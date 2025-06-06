//===- Evaluator.cpp - LLVM IR evaluator ----------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
// And has the following additional copyright:
//
// (C) Copyright 2016-2022 Xilinx, Inc.
// Copyright (C) 2023, Advanced Micro Devices, Inc.
// All Rights Reserved.
//
//===----------------------------------------------------------------------===//
//
// Function evaluator for LLVM IR.
//
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/Utils/Evaluator.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/ConstantFolding.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CallSite.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/Operator.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/User.h"
#include "llvm/IR/Value.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include <iterator>

#define DEBUG_TYPE "evaluator"

using namespace llvm;

static inline bool
isSimpleEnoughValueToCommit(Constant *C,
                            SmallPtrSetImpl<Constant *> &SimpleConstants,
                            const DataLayout &DL);

/// Return true if the specified constant can be handled by the code generator.
/// We don't want to generate something like:
///   void *X = &X/42;
/// because the code generator doesn't have a relocation that can handle that.
///
/// This function should be called if C was not found (but just got inserted)
/// in SimpleConstants to avoid having to rescan the same constants all the
/// time.
static bool
isSimpleEnoughValueToCommitHelper(Constant *C,
                                  SmallPtrSetImpl<Constant *> &SimpleConstants,
                                  const DataLayout &DL) {
  // Simple global addresses are supported, do not allow dllimport or
  // thread-local globals.
  if (auto *GV = dyn_cast<GlobalValue>(C))
    return !GV->hasDLLImportStorageClass() && !GV->isThreadLocal();

  // Simple integer, undef, constant aggregate zero, etc are all supported.
  if (C->getNumOperands() == 0 || isa<BlockAddress>(C))
    return true;

  // Aggregate values are safe if all their elements are.
  if (isa<ConstantAggregate>(C)) {
    for (Value *Op : C->operands())
      if (!isSimpleEnoughValueToCommit(cast<Constant>(Op), SimpleConstants, DL))
        return false;
    return true;
  }

  // We don't know exactly what relocations are allowed in constant expressions,
  // so we allow &global+constantoffset, which is safe and uniformly supported
  // across targets.
  ConstantExpr *CE = cast<ConstantExpr>(C);
  switch (CE->getOpcode()) {
  case Instruction::BitCast:
    // Bitcast is fine if the casted value is fine.
    return isSimpleEnoughValueToCommit(CE->getOperand(0), SimpleConstants, DL);

  case Instruction::IntToPtr:
  case Instruction::PtrToInt:
    // int <=> ptr is fine if the int type is the same size as the
    // pointer type.
    if (DL.getTypeSizeInBits(CE->getType()) !=
        DL.getTypeSizeInBits(CE->getOperand(0)->getType()))
      return false;
    return isSimpleEnoughValueToCommit(CE->getOperand(0), SimpleConstants, DL);

  // GEP is fine if it is simple + constant offset.
  case Instruction::GetElementPtr:
    for (unsigned i = 1, e = CE->getNumOperands(); i != e; ++i)
      if (!isa<ConstantInt>(CE->getOperand(i)))
        return false;
    return isSimpleEnoughValueToCommit(CE->getOperand(0), SimpleConstants, DL);

  case Instruction::Add:
    // We allow simple+cst.
    if (!isa<ConstantInt>(CE->getOperand(1)))
      return false;
    return isSimpleEnoughValueToCommit(CE->getOperand(0), SimpleConstants, DL);
  }
  return false;
}

static inline bool
isSimpleEnoughValueToCommit(Constant *C,
                            SmallPtrSetImpl<Constant *> &SimpleConstants,
                            const DataLayout &DL) {
  // If we already checked this constant, we win.
  if (!SimpleConstants.insert(C).second)
    return true;
  // Check the constant.
  return isSimpleEnoughValueToCommitHelper(C, SimpleConstants, DL);
}

/// Return true if this constant is simple enough for us to understand.  In
/// particular, if it is a cast to anything other than from one pointer type to
/// another pointer type, we punt.  We basically just support direct accesses to
/// globals and GEP's of globals.  This should be kept up to date with
/// CommitValueTo.
static bool isSimpleEnoughPointerToCommit(Constant *C) {
  if (GlobalVariable *GV = dyn_cast<GlobalVariable>(C))
    // Do not allow weak/*_odr/linkonce linkage or external globals.
    return GV->hasUniqueInitializer();

  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(C)) {
    // Handle a constantexpr gep.
    if (CE->getOpcode() == Instruction::GetElementPtr &&
        isa<GlobalVariable>(CE->getOperand(0)) &&
        cast<GEPOperator>(CE)->isInBounds()) {
      GlobalVariable *GV = cast<GlobalVariable>(CE->getOperand(0));
      // Do not allow weak/*_odr/linkonce/dllimport/dllexport linkage or
      // external globals.
      if (!GV->hasUniqueInitializer())
        return false;

      // The first index must be zero.
      ConstantInt *CI = dyn_cast<ConstantInt>(*std::next(CE->op_begin()));
      if (!CI || !CI->isZero()) return false;

      // The remaining indices must be compile-time known integers within the
      // notional bounds of the corresponding static array types.
      if (!CE->isGEPWithNoNotionalOverIndexing())
        return false;

      return ConstantFoldLoadThroughGEPConstantExpr(GV->getInitializer(), CE);

    // A constantexpr bitcast from a pointer to another pointer is a no-op,
    // and we know how to evaluate it by moving the bitcast from the pointer
    // operand to the value operand.
    } else if (CE->getOpcode() == Instruction::BitCast &&
               isa<GlobalVariable>(CE->getOperand(0))) {
      // Do not allow weak/*_odr/linkonce/dllimport/dllexport linkage or
      // external globals.
      return cast<GlobalVariable>(CE->getOperand(0))->hasUniqueInitializer();
    }
  }

  return false;
}

static bool canLosslesslyBitCast(Type *T1, Type *T2, const DataLayout &DL) {
  if (T1->canLosslesslyBitCastTo(T2))
    return true;

  if (!T1->isSingleValueType() || !T2->isSingleValueType())
    return false;
  
  return DL.getTypeSizeInBits(T1) == DL.getTypeSizeInBits(T2);
}

static Constant *ConvertTo(Constant *C, Type *TargetTy) {
  if (C->getType() == TargetTy)
    return C;
  return ConstantExpr::getBitCast(C, TargetTy);
}

static Constant *getGEPFromBitCastForStruct(Constant *P, const DataLayout &DL,
                                            const TargetLibraryInfo *TLI) {
  Type *TargetTy = P->getType()->getPointerElementType();
  if (auto *CE = dyn_cast<ConstantExpr>(P)) {
    if (CE->getOpcode() == Instruction::BitCast) {
      P = CE->getOperand(0);
      Type *NewTy = cast<PointerType>(P->getType())->getElementType();

      bool BuildGEP = false;
      while (!canLosslesslyBitCast(TargetTy, NewTy, DL)) {
        if (StructType *STy = dyn_cast<StructType>(NewTy)) {
          NewTy = STy->getTypeAtIndex(0U);

          IntegerType *IdxTy = IntegerType::get(NewTy->getContext(), 32);
          Constant *IdxZero = ConstantInt::get(IdxTy, 0, false);
          Constant * const IdxList[] = {IdxZero, IdxZero};

          P = ConstantExpr::getGetElementPtr(nullptr, P, IdxList);
          if (auto *FoldedPtr = ConstantFoldConstant(P, DL, TLI))
            P = FoldedPtr;
          BuildGEP = true;
        } else {
          return nullptr;
        }
      }
      assert(canLosslesslyBitCast(
                 TargetTy, P->getType()->getPointerElementType(), DL) &&
             "Bad bitcast");
      if (BuildGEP)
        return P;
    }
  }
  return nullptr;
}

/// Return the value that would be computed by a load from P after the stores
/// reflected by 'memory' have been performed.  If we can't decide, return null.
Constant *Evaluator::ComputeLoadResult(Constant *P) {
  Type *TargetTy = P->getType()->getPointerElementType();
  if (auto *CE = dyn_cast<ConstantExpr>(P)) { 
    if (CE->getOpcode() == Instruction::BitCast) {
      if (!CE->getOperand(0)->getType()->isPointerTy())
        return nullptr;
      Type *SrcTy = CE->getOperand(0)->getType()->getPointerElementType();
      if (Constant *GEP = getGEPFromBitCastForStruct(P, DL, TLI)) {
        P = GEP;
      } else { 
        if (SrcTy->isSingleValueType() && TargetTy->isSingleValueType()) {
          Constant *Val = ComputeLoadResult(CE->getOperand(0));
          if (Val) {
            uint64_t SrcSize = DL.getTypeSizeInBits(SrcTy);
            uint64_t TargetSize = DL.getTypeSizeInBits(TargetTy);
            if (SrcSize == TargetSize) {
              return ConstantExpr::getBitCast(Val, TargetTy);
            } else if (SrcSize > TargetSize) {
              if (!SrcTy->isIntegerTy()) {
                Val = 
                    ConstantExpr::getBitCast(
                        Val, IntegerType::get(SrcTy->getContext(), SrcSize));
              } 
              Val = 
                  ConstantExpr::getTrunc(
                      Val, IntegerType::get(SrcTy->getContext(), TargetSize));
              return ConstantExpr::getBitCast(Val, TargetTy);
            }
          }
        }
        return nullptr;
      }
    }
  }

  // If this memory location has been recently stored, use the stored value: it
  // is the most up-to-date.
  DenseMap<Constant*, Constant*>::const_iterator I = MutatedMemory.find(P);
  if (I != MutatedMemory.end()) return ConvertTo(I->second, TargetTy);

  bool isAllocTmp = false;
  GlobalVariable* basePtr = nullptr;

  if (auto *CE = dyn_cast<ConstantExpr>(P)) { 
    if ((CE->getOpcode() == Instruction::GetElementPtr ||
         CE->getOpcode() == Instruction::BitCast))
      basePtr = dyn_cast<GlobalVariable>(CE->getOperand(0));
  } else {
    basePtr = dyn_cast<GlobalVariable>(P);
  }

  if (!basePtr)
    return nullptr;

  isAllocTmp = AllocaTmps.count(basePtr);
  Type *ElemTy = P->getType()->getPointerElementType();
  LLVMContext &Context = P->getContext();

  // Get value from previous store
  if (isAllocTmp || !AssumeGlobalUnchanged) {
    // If we are loading a structure, try to load each fileds and combine them
    // into the structure value.
    if (StructType *STTy = dyn_cast<StructType>(ElemTy)) {

      std::vector<Constant *> Values;
      for (unsigned i = 0, e = STTy->getNumElements(); i < e; i++) {
        std::vector<Constant *> IdxList = 
            {ConstantInt::get(Type::getInt32Ty(Context), 0),
             ConstantInt::get(Type::getInt32Ty(Context), i)};
        Constant *SubPtr = 
            ConstantExpr::getInBoundsGetElementPtr(nullptr, P, IdxList);
        if (auto *FoldPtr = ConstantFoldConstant(SubPtr, DL, TLI))
          SubPtr = FoldPtr;

        Constant *SubValue = ComputeLoadResult(SubPtr);
        // If Fail to load any filed, return null
        if (!SubValue)
          return nullptr;

        Values.push_back(SubValue);
      }
  
      return ConstantStruct::get(STTy, Values);
    } 

    // Don't expect to load other aggregate type, like array. 
    if (!ElemTy->isSingleValueType()) 
      return nullptr;
  }

  // Access it.
  if (GlobalVariable *GV = dyn_cast<GlobalVariable>(P)) {
    if (GV->hasDefinitiveInitializer()) {
      Constant *InitC = GV->getInitializer();
      if (!InitC)
        return nullptr;

      if (GV->isConstant() || AssumeGlobalUnchanged)
        return ConvertTo(InitC, TargetTy);

      if (isa<UndefValue>(InitC) && GV != ValueWithUnknownInit)
        return ConvertTo(InitC, TargetTy);
    }
    return nullptr;
  }

  // Handle a constantexpr getelementptr.
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(P)) {
    if (CE->getOpcode() == Instruction::GetElementPtr &&
        isa<GlobalVariable>(CE->getOperand(0))) {
      GlobalVariable *GV = cast<GlobalVariable>(CE->getOperand(0));
      if (GV->hasDefinitiveInitializer()) {
        Constant *InitC =
            ConstantFoldLoadThroughGEPConstantExpr(GV->getInitializer(), CE);
        if (!InitC)
          return nullptr;

        if (GV->isConstant() || AssumeGlobalUnchanged)
          return ConvertTo(InitC, TargetTy);

        if (isa<UndefValue>(InitC) && GV != ValueWithUnknownInit)
          return ConvertTo(InitC, TargetTy);
      }
    }
  }

  return nullptr;  // don't know how to evaluate.
}

// Save the value to MutatedMemory.
// If the value has aggregate type, also save each element.
bool Evaluator::saveMutatedMemory(Constant *Ptr, Constant *Val) {
  MutatedMemory[Ptr] = Val;
  LLVMContext &Context = Ptr->getContext();

  // Don't support vector of pointers
  if (Ptr->getType()->isVectorTy())
    return false;
  
  Type *PointeeTy = Ptr->getType()->getPointerElementType();

  if (PointeeTy->isStructTy() || PointeeTy->isArrayTy()) {
    unsigned NumElements = 
        PointeeTy->isStructTy() ? PointeeTy->getStructNumElements()
                                : PointeeTy->getArrayNumElements();
    for (unsigned i = 0; i < NumElements; i++) {
      std::vector<Constant *> IdxList = 
          {ConstantInt::get(Type::getInt32Ty(Context), 0),
           ConstantInt::get(Type::getInt32Ty(Context), i)};
      Constant *SubPtr =
          ConstantExpr::getInBoundsGetElementPtr(nullptr, Ptr, IdxList);

      if (auto *FoldPtr = ConstantFoldConstant(SubPtr, DL, TLI))
        SubPtr = FoldPtr;

      Constant *SubValue = Val->getAggregateElement(i);

      if (!SubValue)
        return false;

      // Save the element value to MutatedMemory
      if (!saveMutatedMemory(SubPtr, SubValue))
        return false;
    }

    return true;
  }

  return PointeeTy->isSingleValueType();
}


/// Evaluate all instructions in block BB, returning true if successful, false
/// if we can't evaluate it.  NewBB returns the next BB that control flows into,
/// or null upon return.
bool Evaluator::EvaluateBlock(BasicBlock::iterator CurInst,
                              BasicBlock *&NextBB) {
  // This is the main evaluation loop.
  while (true) {
    Constant *InstResult = nullptr;

    DEBUG(dbgs() << "Evaluating Instruction: " << *CurInst << "\n");

    if (StoreInst *SI = dyn_cast<StoreInst>(CurInst)) {
      if (!SI->isSimple()) {
        DEBUG(dbgs() << "Store is not simple! Can not evaluate.\n");
        return false;  // no volatile/atomic accesses.
      }
      Constant *Ptr = getVal(SI->getOperand(1));
      if (auto *FoldedPtr = ConstantFoldConstant(Ptr, DL, TLI)) {
        DEBUG(dbgs() << "Folding constant ptr expression: " << *Ptr);
        Ptr = FoldedPtr;
        DEBUG(dbgs() << "; To: " << *Ptr << "\n");
      }
      if (!isSimpleEnoughPointerToCommit(Ptr)) {
        // If this is too complex for us to commit, reject it.
        DEBUG(dbgs() << "Pointer is too complex for us to evaluate store.");
        return false;
      }

      Constant *Val = getVal(SI->getOperand(0));

      // If this might be too difficult for the backend to handle (e.g. the addr
      // of one global variable divided by another) then we can't commit it.
      if (!isSimpleEnoughValueToCommit(Val, SimpleConstants, DL)) {
        DEBUG(dbgs() << "Store value is too complex to evaluate store. " << *Val
              << "\n");
        return false;
      }

      if (ConstantExpr *CE = dyn_cast<ConstantExpr>(Ptr)) {
        if (CE->getOpcode() == Instruction::BitCast) {
          DEBUG(dbgs() << "Attempting to resolve bitcast on constant ptr.\n");
          // If we're evaluating a store through a bitcast, then we need
          // to pull the bitcast off the pointer type and push it onto the
          // stored value.
          Ptr = CE->getOperand(0);

          Type *NewTy = cast<PointerType>(Ptr->getType())->getElementType();

          // In order to push the bitcast onto the stored value, a bitcast
          // from NewTy to Val's type must be legal.  If it's not, we can try
          // introspecting NewTy to find a legal conversion.
          while (!canLosslesslyBitCast(Val->getType(), NewTy, DL)) {
            // If NewTy is a struct, we can convert the pointer to the struct
            // into a pointer to its first member.
            // FIXME: This could be extended to support arrays as well.
            if (StructType *STy = dyn_cast<StructType>(NewTy)) {
              NewTy = STy->getTypeAtIndex(0U);

              IntegerType *IdxTy = IntegerType::get(NewTy->getContext(), 32);
              Constant *IdxZero = ConstantInt::get(IdxTy, 0, false);
              Constant * const IdxList[] = {IdxZero, IdxZero};

              Ptr = ConstantExpr::getGetElementPtr(nullptr, Ptr, IdxList);
              if (auto *FoldedPtr = ConstantFoldConstant(Ptr, DL, TLI))
                Ptr = FoldedPtr;

            // If we can't improve the situation by introspecting NewTy,
            // we have to give up.
            } else {
              DEBUG(dbgs() << "Failed to bitcast constant ptr, can not "
                    "evaluate.\n");
              return false;
            }
          }

          // If we found compatible types, go ahead and push the bitcast
          // onto the stored value.
          Val = ConstantExpr::getBitCast(Val, NewTy);

          DEBUG(dbgs() << "Evaluated bitcast: " << *Val << "\n");
        }
      }

      // If this is a store of structure, save values of each field
      if (!saveMutatedMemory(Ptr, Val))
        return false;

    } else if (BinaryOperator *BO = dyn_cast<BinaryOperator>(CurInst)) {
      InstResult = ConstantExpr::get(BO->getOpcode(),
                                     getVal(BO->getOperand(0)),
                                     getVal(BO->getOperand(1)));
      DEBUG(dbgs() << "Found a BinaryOperator! Simplifying: " << *InstResult
            << "\n");
      auto Op = BO->getOpcode();
      if ((Op == Instruction::Shl || Op == Instruction::AShr || 
           Op == Instruction::LShr) && isa<UndefValue>(InstResult)) 
        InstResult = ConstantInt::get(InstResult->getType(), 0);
           
    } else if (CmpInst *CI = dyn_cast<CmpInst>(CurInst)) {
      InstResult = ConstantExpr::getCompare(CI->getPredicate(),
                                            getVal(CI->getOperand(0)),
                                            getVal(CI->getOperand(1)));
      DEBUG(dbgs() << "Found a CmpInst! Simplifying: " << *InstResult
            << "\n");
    } else if (CastInst *CI = dyn_cast<CastInst>(CurInst)) {
      InstResult = ConstantExpr::getCast(CI->getOpcode(),
                                         getVal(CI->getOperand(0)),
                                         CI->getType());
      DEBUG(dbgs() << "Found a Cast! Simplifying: " << *InstResult
            << "\n");
    } else if (SelectInst *SI = dyn_cast<SelectInst>(CurInst)) {
      InstResult = ConstantExpr::getSelect(getVal(SI->getOperand(0)),
                                           getVal(SI->getOperand(1)),
                                           getVal(SI->getOperand(2)));
      DEBUG(dbgs() << "Found a Select! Simplifying: " << *InstResult
            << "\n");
    } else if (auto *EVI = dyn_cast<ExtractValueInst>(CurInst)) {
      InstResult = ConstantExpr::getExtractValue(
          getVal(EVI->getAggregateOperand()), EVI->getIndices());
      DEBUG(dbgs() << "Found an ExtractValueInst! Simplifying: " << *InstResult
                   << "\n");
    } else if (auto *IVI = dyn_cast<InsertValueInst>(CurInst)) {
      InstResult = ConstantExpr::getInsertValue(
          getVal(IVI->getAggregateOperand()),
          getVal(IVI->getInsertedValueOperand()), IVI->getIndices());
      DEBUG(dbgs() << "Found an InsertValueInst! Simplifying: " << *InstResult
                   << "\n");
    } else if (GetElementPtrInst *GEP = dyn_cast<GetElementPtrInst>(CurInst)) {
      Constant *P = getVal(GEP->getOperand(0));
      SmallVector<Constant*, 8> GEPOps;
      for (User::op_iterator i = GEP->op_begin() + 1, e = GEP->op_end();
           i != e; ++i)
        GEPOps.push_back(getVal(*i));
      InstResult =
          ConstantExpr::getGetElementPtr(GEP->getSourceElementType(), P, GEPOps,
                                         cast<GEPOperator>(GEP)->isInBounds());
      DEBUG(dbgs() << "Found a GEP! Simplifying: " << *InstResult
            << "\n");
    } else if (LoadInst *LI = dyn_cast<LoadInst>(CurInst)) {
      if (!LI->isSimple()) {
        DEBUG(dbgs() << "Found a Load! Not a simple load, can not evaluate.\n");
        return false;  // no volatile/atomic accesses.
      }

      Constant *Ptr = getVal(LI->getOperand(0));
      if (auto *FoldedPtr = ConstantFoldConstant(Ptr, DL, TLI)) {
        Ptr = FoldedPtr;
        DEBUG(dbgs() << "Found a constant pointer expression, constant "
              "folding: " << *Ptr << "\n");
      }
      InstResult = ComputeLoadResult(Ptr);
      if (!InstResult) {
        DEBUG(dbgs() << "Failed to compute load result. Can not evaluate load."
              "\n");
        return false; // Could not evaluate load.
      }

      DEBUG(dbgs() << "Evaluated load: " << *InstResult << "\n");
    } else if (AllocaInst *AI = dyn_cast<AllocaInst>(CurInst)) {
      if (AI->isArrayAllocation()) {
        DEBUG(dbgs() << "Found an array alloca. Can not evaluate.\n");
        return false;  // Cannot handle array allocs.
      }
      Type *Ty = AI->getAllocatedType();
      auto tmp = new GlobalVariable( Ty, false, GlobalValue::InternalLinkage, UndefValue::get(Ty), AI->getName());
      InstResult = tmp;
      AllocaTmps.insert(tmp);
      DEBUG(dbgs() << "Found an alloca. Result: " << *InstResult << "\n");
    } else if (isa<CallInst>(CurInst) || isa<InvokeInst>(CurInst)) {
      CallSite CS(&*CurInst);

      // Debug info can safely be ignored here.
      if (isa<DbgInfoIntrinsic>(CS.getInstruction())) {
        DEBUG(dbgs() << "Ignoring debug info.\n");
        ++CurInst;
        continue;
      }

      // Cannot handle inline asm.
      if (isa<InlineAsm>(CS.getCalledValue())) {
        DEBUG(dbgs() << "Found inline asm, can not evaluate.\n");
        return false;
      }

      if (IntrinsicInst *II = dyn_cast<IntrinsicInst>(CS.getInstruction())) {
        if (MemSetInst *MSI = dyn_cast<MemSetInst>(II)) {
          if (MSI->isVolatile()) {
            DEBUG(dbgs() << "Can not optimize a volatile memset " <<
                  "intrinsic.\n");
            return false;
          }
          Constant *Ptr = getVal(MSI->getDest());
          Constant *Val = getVal(MSI->getValue());
          Constant *DestVal = ComputeLoadResult(getVal(Ptr));
          if (Val->isNullValue() && DestVal && DestVal->isNullValue()) {
            // This memset is a no-op.
            DEBUG(dbgs() << "Ignoring no-op memset.\n");
            ++CurInst;
            continue;
          }
        }

        if (II->getIntrinsicID() == Intrinsic::lifetime_start ||
            II->getIntrinsicID() == Intrinsic::lifetime_end) {
          DEBUG(dbgs() << "Ignoring lifetime intrinsic.\n");
          ++CurInst;
          continue;
        }

        if (II->getIntrinsicID() == Intrinsic::invariant_start) {
          // We don't insert an entry into Values, as it doesn't have a
          // meaningful return value.
          if (!II->use_empty()) {
            DEBUG(dbgs() << "Found unused invariant_start. Can't evaluate.\n");
            return false;
          }
          ConstantInt *Size = cast<ConstantInt>(II->getArgOperand(0));
          Value *PtrArg = getVal(II->getArgOperand(1));
          Value *Ptr = PtrArg->stripPointerCasts();
          if (GlobalVariable *GV = dyn_cast<GlobalVariable>(Ptr)) {
            Type *ElemTy = GV->getValueType();
            if (!Size->isMinusOne() &&
                Size->getValue().getLimitedValue() >=
                    DL.getTypeStoreSize(ElemTy)) {
              Invariants.insert(GV);
              DEBUG(dbgs() << "Found a global var that is an invariant: " << *GV
                    << "\n");
            } else {
              DEBUG(dbgs() << "Found a global var, but can not treat it as an "
                    "invariant.\n");
            }
          }
          // Continue even if we do nothing.
          ++CurInst;
          continue;
        } else if (II->getIntrinsicID() == Intrinsic::assume) {
          DEBUG(dbgs() << "Skipping assume intrinsic.\n");
          ++CurInst;
          continue;
        } else if (II->getIntrinsicID() == Intrinsic::sideeffect) {
          DEBUG(dbgs() << "Skipping sideeffect intrinsic.\n");
          ++CurInst;
          continue;
        } else if (II->getIntrinsicID() == Intrinsic::directive_scope_entry ||
                   II->getIntrinsicID() == Intrinsic::directive_scope_exit) {
          DEBUG(dbgs() << "Skipping scope entry/exit intrinsic.\n");
          ++CurInst;
          continue;
        } else if (II->getIntrinsicID() == Intrinsic::ssa_copy) {
          DEBUG(dbgs() << "Propagate the source of ssa_copy intrinsic.\n");
          setVal(&*CurInst, getVal(II->getReturnedArgOperand()));
          ++CurInst;
          continue;
        } else if (II->getIntrinsicID() == Intrinsic::fpga_ssa_keep) {
          DEBUG(dbgs() << "Propagate the source of fpga_ssa_keep intrinsic.\n");
          setVal(&*CurInst, getVal(II->getArgOperand(0)));
          ++CurInst;
          continue;
        } else if (II->getIntrinsicID() == Intrinsic::fpga_type_annotate) {
          DEBUG(dbgs() << "Skipping fpga type annotate intrinsic.\n");
          ++CurInst;
          continue;
        } else if (II->getIntrinsicID() == Intrinsic::fpga_fence) {
          DEBUG(dbgs() << "Skipping fpga fence intrinsic.\n");
          ++CurInst;
          continue;
        } else if (II->getIntrinsicID() == Intrinsic::fpga_any) {
          DEBUG(dbgs() << "Replacing fpga any intrinsic with 0.\n");
          setVal(&*CurInst, ConstantInt::get(II->getType(), 0));
          ++CurInst;
          continue;
        } else if (!II->mayHaveSideEffects()) {
          if (!CurInst->use_empty()) {
            SmallVector<Constant*, 8> Formals;
            for (User::op_iterator i = CS.arg_begin(), e = CS.arg_end(); 
                 i != e; ++i)
              Formals.push_back(getVal(*i));

            if (Constant *C = ConstantFoldCall(CS, CS.getCalledFunction(), 
                                               Formals, TLI)) {
              DEBUG(dbgs() << "Evaluate part select intrinsic.\n");
              setVal(&*CurInst, C);
            } else
              return false;
          }
          ++CurInst;
          continue;
        }

        DEBUG(dbgs() << "Unknown intrinsic. Can not evaluate.\n");
        return false;
      }

      // Resolve function pointers.
      Function *Callee = dyn_cast<Function>(getVal(CS.getCalledValue()));
      if (!Callee || Callee->isInterposable()) {
        DEBUG(dbgs() << "Can not resolve function pointer.\n");
        return false;  // Cannot resolve.
      }

      SmallVector<Constant*, 8> Formals;
      for (User::op_iterator i = CS.arg_begin(), e = CS.arg_end(); i != e; ++i)
        Formals.push_back(getVal(*i));

      if (Callee->isDeclaration()) {
        // If this is a function we can constant fold, do it.
        if (Constant *C = ConstantFoldCall(CS, Callee, Formals, TLI)) {
          InstResult = C;
          DEBUG(dbgs() << "Constant folded function call. Result: " <<
                *InstResult << "\n");
        } else {
          DEBUG(dbgs() << "Can not constant fold function call.\n");
          return false;
        }
      } else {
        if (Callee->getFunctionType()->isVarArg()) {
          DEBUG(dbgs() << "Can not constant fold vararg function call.\n");
          return false;
        }

        Constant *RetVal = nullptr;
        // Execute the call, if successful, use the return value.
        ValueStack.emplace_back();
        if (!EvaluateFunction(Callee, RetVal, Formals)) {
          DEBUG(dbgs() << "Failed to evaluate function.\n");
          return false;
        }
        ValueStack.pop_back();
        InstResult = RetVal;

        if (InstResult) {
          DEBUG(dbgs() << "Successfully evaluated "<< Callee->getName() << " Result: "
                       << *InstResult << "\n\n");
        } else {
          DEBUG(dbgs() << "Successfully evaluated " << Callee->getName() << " Result: 0\n\n");
        }
      }
    } else if (isa<TerminatorInst>(CurInst)) {
      DEBUG(dbgs() << "Found a terminator instruction.\n");

      if (BranchInst *BI = dyn_cast<BranchInst>(CurInst)) {
        if (BI->isUnconditional()) {
          NextBB = BI->getSuccessor(0);
        } else {
          ConstantInt *Cond =
            dyn_cast<ConstantInt>(getVal(BI->getCondition()));
          if (!Cond) return false;  // Cannot determine.

          NextBB = BI->getSuccessor(!Cond->getZExtValue());
        }
      } else if (SwitchInst *SI = dyn_cast<SwitchInst>(CurInst)) {
        ConstantInt *Val =
          dyn_cast<ConstantInt>(getVal(SI->getCondition()));
        if (!Val) return false;  // Cannot determine.
        NextBB = SI->findCaseValue(Val)->getCaseSuccessor();
      } else if (IndirectBrInst *IBI = dyn_cast<IndirectBrInst>(CurInst)) {
        Value *Val = getVal(IBI->getAddress())->stripPointerCasts();
        if (BlockAddress *BA = dyn_cast<BlockAddress>(Val))
          NextBB = BA->getBasicBlock();
        else
          return false;  // Cannot determine.
      } else if (isa<ReturnInst>(CurInst)) {
        NextBB = nullptr;
      } else {
        // invoke, unwind, resume, unreachable.
        DEBUG(dbgs() << "Can not handle terminator.");
        return false;  // Cannot handle this terminator.
      }

      // We succeeded at evaluating this block!
      DEBUG(dbgs() << "Successfully evaluated block.\n");
      return true;
    } else {
      // Did not know how to evaluate this!
      DEBUG(dbgs() << "Failed to evaluate block due to unhandled instruction."
            "\n");
      return false;
    }

    if (!CurInst->use_empty()) {
      if (auto *FoldedInstResult = ConstantFoldConstant(InstResult, DL, TLI))
        InstResult = FoldedInstResult;

      setVal(&*CurInst, InstResult);
    }

    // If we just processed an invoke, we finished evaluating the block.
    if (InvokeInst *II = dyn_cast<InvokeInst>(CurInst)) {
      NextBB = II->getNormalDest();
      DEBUG(dbgs() << "Found an invoke instruction. Finished Block.\n\n");
      return true;
    }

    // Advance program counter.
    ++CurInst;
  }
}

/// Evaluate a call to function F, returning true if successful, false if we
/// can't evaluate it.  ActualArgs contains the formal arguments for the
/// function.
bool Evaluator::EvaluateFunction(Function *F, Constant *&RetVal,
                                 const SmallVectorImpl<Constant*> &ActualArgs) {
  // Check to see if this function is already executing (recursion).  If so,
  // bail out.  TODO: we might want to accept limited recursion.
  // XILINX HLS: allow recursive call with recursive depth <= 100
  if (count(CallStack, F) > 100)
    return false;

  CallStack.push_back(F);

  // Initialize arguments to the incoming values specified.
  unsigned ArgNo = 0;
  for (Function::arg_iterator AI = F->arg_begin(), E = F->arg_end(); AI != E;
       ++AI, ++ArgNo)
    setVal(&*AI, ActualArgs[ArgNo]);

  // ExecutedBlocks - We only handle non-looping, non-recursive code.  As such,
  // we can only evaluate any one basic block at most once.  This set keeps
  // track of what we have executed so we can detect recursive cases etc.
  SmallPtrSet<BasicBlock*, 32> ExecutedBlocks;

  // CurBB - The current basic block we're evaluating.
  BasicBlock *CurBB = &F->front();

  BasicBlock::iterator CurInst = CurBB->begin();

  while (true) {
    BasicBlock *NextBB = nullptr; // Initialized to avoid compiler warnings.
    DEBUG(dbgs() << "Trying to evaluate BB: " << *CurBB << "\n");

    if (!EvaluateBlock(CurInst, NextBB)) 
      return false;

    if (!NextBB) {
      // Successfully running until there's no next block means that we found
      // the return.  Fill it the return value and pop the call stack.
      ReturnInst *RI = cast<ReturnInst>(CurBB->getTerminator());
      if (RI->getNumOperands())
        RetVal = getVal(RI->getOperand(0));
      CallStack.pop_back();
      return true;
    }
    // Okay, we succeeded in evaluating this control flow.  See if we have
    // executed the new block before.  If so, we have a looping function,
    // which we cannot evaluate in reasonable time.
#if 0
    if (!ExecutedBlocks.insert(NextBB).second)
      return false;  // looped!
#endif
    // Okay, we have never been in this block before.  Check to see if there
    // are any PHI nodes.  If so, evaluate them with information about where
    // we came from.
    PHINode *PN = nullptr;
    for (CurInst = NextBB->begin();
         (PN = dyn_cast<PHINode>(CurInst)); ++CurInst)
      setVal(PN, getVal(PN->getIncomingValueForBlock(CurBB)));

    // Advance to the next block.
    CurBB = NextBB;
  }
}
