//===-- llvm/SymbolTableListTraitsImpl.h - Implementation ------*- C++ -*--===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
// And has the following additional copyright:
//
// Copyright (C) 2023, Advanced Micro Devices, Inc.
// All Rights Reserved.
//
//===----------------------------------------------------------------------===//
//
// This file implements the stickier parts of the SymbolTableListTraits class,
// and is explicitly instantiated where needed to avoid defining all this code
// in a widely used header.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_IR_SYMBOLTABLELISTTRAITSIMPL_H
#define LLVM_LIB_IR_SYMBOLTABLELISTTRAITSIMPL_H

#include "llvm/IR/SymbolTableListTraits.h"
#include "llvm/IR/ValueSymbolTable.h"

namespace llvm {

/// Notify basic blocks when an instruction is inserted.
template <typename ParentClass>
inline void invalidateParentIListOrdering(ParentClass *Parent) {}
template <> void invalidateParentIListOrdering(BasicBlock *BB);

/// setSymTabObject - This is called when (f.e.) the parent of a basic block
/// changes.  This requires us to remove all the instruction symtab entries from
/// the current function and reinsert them into the new function.
template <typename ValueSubClass>
template <typename TPtr>
void SymbolTableListTraits<ValueSubClass>::setSymTabObject(TPtr *Dest,
                                                           TPtr Src) {
  // Get the old symtab and value list before doing the assignment.
  ValueSymbolTable *OldST = getSymTab(getListOwner());

  // Do it.
  *Dest = Src;
  
  // Get the new SymTab object.
  ValueSymbolTable *NewST = getSymTab(getListOwner());
  
  // If there is nothing to do, quick exit.
  if (OldST == NewST) return;
  
  // Move all the elements from the old symtab to the new one.
  ListTy &ItemList = getList(getListOwner());
  if (ItemList.empty()) return;
  
  if (OldST) {
    // Remove all entries from the previous symtab.
    for (auto I = ItemList.begin(); I != ItemList.end(); ++I)
      if (I->hasName())
        OldST->removeValueName(I->getValueName());
  }

  if (NewST) {
    // Add all of the items to the new symtab.
    for (auto I = ItemList.begin(); I != ItemList.end(); ++I)
      if (I->hasName())
        NewST->reinsertValue(&*I);
  }
  
}

template <typename ValueSubClass>
void SymbolTableListTraits<ValueSubClass>::addNodeToList(ValueSubClass *V) {
  assert(!V->getParent() && "Value already in a container!!");
  ItemParentClass *Owner = getListOwner();
  V->setParent(Owner);
  invalidateParentIListOrdering(Owner);
  if (V->hasName())
    if (ValueSymbolTable *ST = getSymTab(Owner))
      ST->reinsertValue(V);
}

template <typename ValueSubClass>
void SymbolTableListTraits<ValueSubClass>::removeNodeFromList(
    ValueSubClass *V) {
  V->setParent(nullptr);
  if (V->hasName())
    if (ValueSymbolTable *ST = getSymTab(getListOwner()))
      ST->removeValueName(V->getValueName());
}

template <typename ValueSubClass>
void SymbolTableListTraits<ValueSubClass>::transferNodesFromList(
    SymbolTableListTraits &L2, iterator first, iterator last) {
  // Transfering nodes, even within the same BB, invalidates the ordering. The
  // list that we removed the nodes from still has a valid ordering.
  ItemParentClass *NewIP = getListOwner();
  invalidateParentIListOrdering(NewIP);

  // Nothing else needs to be done if we're reording nodes within the same list.
  ItemParentClass *OldIP = L2.getListOwner();
  if (NewIP == OldIP)
    return;

  // We only have to update symbol table entries if we are transferring the
  // instructions to a different symtab object...
  ValueSymbolTable *NewST = getSymTab(NewIP);
  ValueSymbolTable *OldST = getSymTab(OldIP);
  if (NewST != OldST) {
    for (; first != last; ++first) {
      ValueSubClass &V = *first;
      bool HasName = V.hasName();
      if (OldST && HasName)
        OldST->removeValueName(V.getValueName());
      V.setParent(NewIP);
      if (NewST && HasName)
        NewST->reinsertValue(&V);
    }
  } else {
    // Just transferring between blocks in the same function, simply update the
    // parent fields in the instructions...
    for (; first != last; ++first)
      first->setParent(NewIP);
  }
}

} // End llvm namespace

#endif
