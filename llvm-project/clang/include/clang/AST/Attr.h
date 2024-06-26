//===--- Attr.h - Classes for representing attributes ----------*- C++ -*-===//
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
//  This file defines the Attr interface and subclasses.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CLANG_AST_ATTR_H
#define LLVM_CLANG_AST_ATTR_H

#include "clang/AST/AttrIterator.h"
#include "clang/AST/Decl.h"
#include "clang/AST/Expr.h"
#include "clang/AST/Type.h"
#include "clang/Basic/AttrKinds.h"
#include "clang/Basic/LLVM.h"
#include "clang/Basic/OpenMPKinds.h"
#include "clang/Basic/Sanitizers.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/VersionTuple.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <cassert>

namespace clang {
  class ASTContext;
  class IdentifierInfo;
  class ObjCInterfaceDecl;
  class Expr;
  class QualType;
  class FunctionDecl;
  class TypeSourceInfo;

/// Attr - This represents one attribute.
class Attr {
private:
  SourceRange Range;
  unsigned AttrKind : 16;


protected:
  /// An index into the spelling list of an
  /// attribute defined in Attr.td file.
  unsigned SpellingListIndex : 4;
  unsigned Inherited : 1;
  unsigned IsPackExpansion : 1;
  unsigned Implicit : 1;
  // FIXME: These are properties of the attribute kind, not state for this
  // instance of the attribute.
  unsigned IsLateParsed : 1;
  unsigned InheritEvenIfAlreadyPresent : 1;

  // HLS specifial staff
  IdentifierInfo* pragmaContext; 
  Expr* HLSIfCond; 

  void *operator new(size_t bytes) noexcept {
    llvm_unreachable("Attrs cannot be allocated with regular 'new'.");
  }
  void operator delete(void *data) noexcept {
    llvm_unreachable("Attrs cannot be released with regular 'delete'.");
  }

public:
  // Forward so that the regular new and delete do not hide global ones.
  void *operator new(size_t Bytes, ASTContext &C,
                     size_t Alignment = 8) noexcept {
    return ::operator new(Bytes, C, Alignment);
  }
  void operator delete(void *Ptr, ASTContext &C, size_t Alignment) noexcept {
    return ::operator delete(Ptr, C, Alignment);
  }

protected:
  Attr(attr::Kind AK, SourceRange R, unsigned SpellingListIndex,
       bool IsLateParsed)
    : Range(R), AttrKind(AK), SpellingListIndex(SpellingListIndex),
      Inherited(false), IsPackExpansion(false), Implicit(false),
      IsLateParsed(IsLateParsed), InheritEvenIfAlreadyPresent(false), pragmaContext(nullptr), HLSIfCond(nullptr) {}

public:

  attr::Kind getKind() const {
    return static_cast<attr::Kind>(AttrKind);
  }
  
  unsigned getSpellingListIndex() const { return SpellingListIndex; }
  const char *getSpelling() const;

  SourceLocation getLocation() const { return Range.getBegin(); }
  SourceRange getRange() const { return Range; }
  void setRange(SourceRange R) { Range = R; }

  bool isInherited() const { return Inherited; }

  /// \brief Returns true if the attribute has been implicitly created instead
  /// of explicitly written by the user.
  bool isImplicit() const { return Implicit; }
  void setImplicit(bool I) { Implicit = I; }

  void setPackExpansion(bool PE) { IsPackExpansion = PE; }
  bool isPackExpansion() const { return IsPackExpansion; }

  // Clone this attribute.
  Attr *clone(ASTContext &C) const;

  IdentifierInfo *getPragmaContext() const { 
    return pragmaContext; 
  }

  void setPragmaContext(IdentifierInfo *pragmaContext) { 
    this->pragmaContext = pragmaContext; 
  }

  Expr* getHLSIfCond() const{ 
    return HLSIfCond; 
  }

  void setHLSIfCond( Expr* cond) { 
    HLSIfCond = cond; 
  }


  bool isLateParsed() const { return IsLateParsed; }

  // Pretty print this attribute.
  void printPretty(raw_ostream &OS, const PrintingPolicy &Policy) const;
};

class StmtAttr : public Attr {
protected:
  StmtAttr(attr::Kind AK, SourceRange R, unsigned SpellingListIndex,
                  bool IsLateParsed)
      : Attr(AK, R, SpellingListIndex, IsLateParsed) {}

public:
  static bool classof(const Attr *A) {
    return A->getKind() >= attr::FirstStmtAttr &&
           A->getKind() <= attr::LastStmtAttr;
  }
};

class InheritableAttr : public Attr {
protected:
  InheritableAttr(attr::Kind AK, SourceRange R, unsigned SpellingListIndex,
                  bool IsLateParsed, bool InheritEvenIfAlreadyPresent)
      : Attr(AK, R, SpellingListIndex, IsLateParsed) {
    this->InheritEvenIfAlreadyPresent = InheritEvenIfAlreadyPresent;
  }

public:
  void setInherited(bool I) { Inherited = I; }

  /// Should this attribute be inherited from a prior declaration even if it's
  /// explicitly provided in the current declaration?
  bool shouldInheritEvenIfAlreadyPresent() const {
    return InheritEvenIfAlreadyPresent;
  }

  // Implement isa/cast/dyncast/etc.
  static bool classof(const Attr *A) {
    return A->getKind() >= attr::FirstInheritableAttr &&
           A->getKind() <= attr::LastInheritableAttr;
  }
};

class InheritableParamAttr : public InheritableAttr {
protected:
  InheritableParamAttr(attr::Kind AK, SourceRange R, unsigned SpellingListIndex,
                       bool IsLateParsed, bool InheritEvenIfAlreadyPresent)
      : InheritableAttr(AK, R, SpellingListIndex, IsLateParsed,
                        InheritEvenIfAlreadyPresent) {}

public:
  // Implement isa/cast/dyncast/etc.
  static bool classof(const Attr *A) {
    return A->getKind() >= attr::FirstInheritableParamAttr &&
           A->getKind() <= attr::LastInheritableParamAttr;
  }
};

/// A parameter attribute which changes the argument-passing ABI rule
/// for the parameter.
class ParameterABIAttr : public InheritableParamAttr {
protected:
  ParameterABIAttr(attr::Kind AK, SourceRange R,
                   unsigned SpellingListIndex, bool IsLateParsed,
                   bool InheritEvenIfAlreadyPresent)
    : InheritableParamAttr(AK, R, SpellingListIndex, IsLateParsed,
                           InheritEvenIfAlreadyPresent) {}

public:
  ParameterABI getABI() const {
    switch (getKind()) {
    case attr::SwiftContext:
      return ParameterABI::SwiftContext;
    case attr::SwiftErrorResult:
      return ParameterABI::SwiftErrorResult;
    case attr::SwiftIndirectResult:
      return ParameterABI::SwiftIndirectResult;
    default:
      llvm_unreachable("bad parameter ABI attribute kind");
    }
  }

  static bool classof(const Attr *A) {
    return A->getKind() >= attr::FirstParameterABIAttr &&
           A->getKind() <= attr::LastParameterABIAttr;
   }
};

#include "clang/AST/Attrs.inc"

inline const DiagnosticBuilder &operator<<(const DiagnosticBuilder &DB,
                                           const Attr *At) {
  DB.AddTaggedVal(reinterpret_cast<intptr_t>(At),
                  DiagnosticsEngine::ak_attr);
  return DB;
}

inline const PartialDiagnostic &operator<<(const PartialDiagnostic &PD,
                                           const Attr *At) {
  PD.AddTaggedVal(reinterpret_cast<intptr_t>(At),
                  DiagnosticsEngine::ak_attr);
  return PD;
}
}  // end namespace clang

#endif
