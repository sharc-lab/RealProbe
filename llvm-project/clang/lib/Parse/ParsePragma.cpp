//===--- ParsePragma.cpp - Language specific pragma parsing ---------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
// And has the following additional copyright:
//
// (C) Copyright 2016-2022 Xilinx, Inc.
// All Rights Reserved.
//
//===----------------------------------------------------------------------===//
//
// This file implements the language specific #pragma handlers.
//
//===----------------------------------------------------------------------===//

#include "clang/AST/ASTContext.h"
#include "clang/Basic/PragmaKinds.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Parse/ParseDiagnostic.h"
#include "clang/Parse/Parser.h"
#include "clang/Parse/RAIIObjectsForParser.h"
#include "clang/Sema/LoopHint.h"
#include "clang/Sema/Scope.h"
#include "llvm/ADT/StringSwitch.h"
using namespace clang;

namespace {

struct PragmaAlignHandler : public PragmaHandler {
  explicit PragmaAlignHandler() : PragmaHandler("align") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaGCCVisibilityHandler : public PragmaHandler {
  explicit PragmaGCCVisibilityHandler() : PragmaHandler("visibility") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaOptionsHandler : public PragmaHandler {
  explicit PragmaOptionsHandler() : PragmaHandler("options") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaPackHandler : public PragmaHandler {
  explicit PragmaPackHandler() : PragmaHandler("pack") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaClangSectionHandler : public PragmaHandler {
  explicit PragmaClangSectionHandler(Sema &S)
             : PragmaHandler("section"), Actions(S) {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
private:
  Sema &Actions;
};

struct PragmaMSStructHandler : public PragmaHandler {
  explicit PragmaMSStructHandler() : PragmaHandler("ms_struct") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaUnusedHandler : public PragmaHandler {
  PragmaUnusedHandler() : PragmaHandler("unused") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaWeakHandler : public PragmaHandler {
  explicit PragmaWeakHandler() : PragmaHandler("weak") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaRedefineExtnameHandler : public PragmaHandler {
  explicit PragmaRedefineExtnameHandler() : PragmaHandler("redefine_extname") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaOpenCLExtensionHandler : public PragmaHandler {
  PragmaOpenCLExtensionHandler() : PragmaHandler("EXTENSION") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};


struct PragmaFPContractHandler : public PragmaHandler {
  PragmaFPContractHandler() : PragmaHandler("FP_CONTRACT") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

// Pragma STDC implementations.

/// PragmaSTDC_FENV_ACCESSHandler - "\#pragma STDC FENV_ACCESS ...".
struct PragmaSTDC_FENV_ACCESSHandler : public PragmaHandler {
  PragmaSTDC_FENV_ACCESSHandler() : PragmaHandler("FENV_ACCESS") {}

  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &Tok) override {
    tok::OnOffSwitch OOS;
    if (PP.LexOnOffSwitch(OOS))
     return;
    if (OOS == tok::OOS_ON)
      PP.Diag(Tok, diag::warn_stdc_fenv_access_not_supported);
  }
};

/// PragmaSTDC_CX_LIMITED_RANGEHandler - "\#pragma STDC CX_LIMITED_RANGE ...".
struct PragmaSTDC_CX_LIMITED_RANGEHandler : public PragmaHandler {
  PragmaSTDC_CX_LIMITED_RANGEHandler() : PragmaHandler("CX_LIMITED_RANGE") {}

  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &Tok) override {
    tok::OnOffSwitch OOS;
    PP.LexOnOffSwitch(OOS);
  }
};

/// PragmaSTDC_UnknownHandler - "\#pragma STDC ...".
struct PragmaSTDC_UnknownHandler : public PragmaHandler {
  PragmaSTDC_UnknownHandler() = default;

  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &UnknownTok) override {
    // C99 6.10.6p2, unknown forms are not allowed.
    PP.Diag(UnknownTok, diag::ext_stdc_pragma_ignored);
  }
};

struct PragmaFPHandler : public PragmaHandler {
  PragmaFPHandler() : PragmaHandler("fp") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaNoOpenMPHandler : public PragmaHandler {
  PragmaNoOpenMPHandler() : PragmaHandler("omp") { }
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaOpenMPHandler : public PragmaHandler {
  PragmaOpenMPHandler() : PragmaHandler("omp") { }
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaModelComposerHandler : public PragmaHandler {
  PragmaModelComposerHandler(Sema &Actions)
      : PragmaHandler("XMC"), Actions(Actions) {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;

private:
  Sema &Actions;
};

/// PragmaXlxHLSHandler - "\#pragma HLS ...".
struct PragmaXlxHandler : public PragmaHandler {
  PragmaXlxHandler(StringRef Name) : PragmaHandler(Name), StartKind(tok::annot_pragma_XlxHLS) {}
  PragmaXlxHandler(StringRef Name, tok::TokenKind TokKind) : PragmaHandler(Name), StartKind(TokKind) {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
  tok::TokenKind StartKind;
};

/// PragmaCommentHandler - "\#pragma comment ...".
struct PragmaCommentHandler : public PragmaHandler {
  PragmaCommentHandler(Sema &Actions)
    : PragmaHandler("comment"), Actions(Actions) {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
private:
  Sema &Actions;
};

struct PragmaDetectMismatchHandler : public PragmaHandler {
  PragmaDetectMismatchHandler(Sema &Actions)
    : PragmaHandler("detect_mismatch"), Actions(Actions) {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
private:
  Sema &Actions;
};

struct PragmaMSPointersToMembers : public PragmaHandler {
  explicit PragmaMSPointersToMembers() : PragmaHandler("pointers_to_members") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaMSVtorDisp : public PragmaHandler {
  explicit PragmaMSVtorDisp() : PragmaHandler("vtordisp") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaMSPragma : public PragmaHandler {
  explicit PragmaMSPragma(const char *name) : PragmaHandler(name) {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

/// PragmaOptimizeHandler - "\#pragma clang optimize on/off".
struct PragmaOptimizeHandler : public PragmaHandler {
  PragmaOptimizeHandler(Sema &S)
    : PragmaHandler("optimize"), Actions(S) {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
private:
  Sema &Actions;
};

struct PragmaLoopHintHandler : public PragmaHandler {
  PragmaLoopHintHandler() : PragmaHandler("loop") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaUnrollHintHandler : public PragmaHandler {
  PragmaUnrollHintHandler(const char *name) : PragmaHandler(name) {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaMSRuntimeChecksHandler : public EmptyPragmaHandler {
  PragmaMSRuntimeChecksHandler() : EmptyPragmaHandler("runtime_checks") {}
};

struct PragmaMSIntrinsicHandler : public PragmaHandler {
  PragmaMSIntrinsicHandler() : PragmaHandler("intrinsic") {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;
};

struct PragmaForceCUDAHostDeviceHandler : public PragmaHandler {
  PragmaForceCUDAHostDeviceHandler(Sema &Actions)
      : PragmaHandler("force_cuda_host_device"), Actions(Actions) {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;

private:
  Sema &Actions;
};

/// PragmaAttributeHandler - "\#pragma clang attribute ...".
struct PragmaAttributeHandler : public PragmaHandler {
  PragmaAttributeHandler(AttributeFactory &AttrFactory)
      : PragmaHandler("attribute"), AttributesForPragmaAttribute(AttrFactory) {}
  void HandlePragma(Preprocessor &PP, PragmaIntroducerKind Introducer,
                    Token &FirstToken) override;

  /// A pool of attributes that were parsed in \#pragma clang attribute.
  ParsedAttributes AttributesForPragmaAttribute;
};

}  // end namespace

void Parser::initializePragmaHandlers() {
  AlignHandler.reset(new PragmaAlignHandler());
  PP.AddPragmaHandler(AlignHandler.get());

  GCCVisibilityHandler.reset(new PragmaGCCVisibilityHandler());
  PP.AddPragmaHandler("GCC", GCCVisibilityHandler.get());

  OptionsHandler.reset(new PragmaOptionsHandler());
  PP.AddPragmaHandler(OptionsHandler.get());

  PackHandler.reset(new PragmaPackHandler());
  PP.AddPragmaHandler(PackHandler.get());

  MSStructHandler.reset(new PragmaMSStructHandler());
  PP.AddPragmaHandler(MSStructHandler.get());

  UnusedHandler.reset(new PragmaUnusedHandler());
  PP.AddPragmaHandler(UnusedHandler.get());

  WeakHandler.reset(new PragmaWeakHandler());
  PP.AddPragmaHandler(WeakHandler.get());

  RedefineExtnameHandler.reset(new PragmaRedefineExtnameHandler());
  PP.AddPragmaHandler(RedefineExtnameHandler.get());

  FPContractHandler.reset(new PragmaFPContractHandler());
  PP.AddPragmaHandler("STDC", FPContractHandler.get());

  STDCFENVHandler.reset(new PragmaSTDC_FENV_ACCESSHandler());
  PP.AddPragmaHandler("STDC", STDCFENVHandler.get());

  STDCCXLIMITHandler.reset(new PragmaSTDC_CX_LIMITED_RANGEHandler());
  PP.AddPragmaHandler("STDC", STDCCXLIMITHandler.get());

  STDCUnknownHandler.reset(new PragmaSTDC_UnknownHandler());
  PP.AddPragmaHandler("STDC", STDCUnknownHandler.get());

  PCSectionHandler.reset(new PragmaClangSectionHandler(Actions));
  PP.AddPragmaHandler("clang", PCSectionHandler.get());

  if (getLangOpts().OpenCL) {
    OpenCLExtensionHandler.reset(new PragmaOpenCLExtensionHandler());
    PP.AddPragmaHandler("OPENCL", OpenCLExtensionHandler.get());

    PP.AddPragmaHandler("OPENCL", FPContractHandler.get());
  }
  if (getLangOpts().OpenMP)
    OpenMPHandler.reset(new PragmaOpenMPHandler());
  else
    OpenMPHandler.reset(new PragmaNoOpenMPHandler());
  PP.AddPragmaHandler(OpenMPHandler.get());

  if (getLangOpts().XMCExt) {
    ModelComposerHandler.reset(new PragmaModelComposerHandler(Actions));
    PP.AddPragmaHandler(ModelComposerHandler.get());
  }

  if (getLangOpts().HLSExt) {
    if (!PP.hasPragmaHandler("HLS")) {
      XlxHLSHandler.reset(new PragmaXlxHandler("HLS"));
      PP.AddPragmaHandler(XlxHLSHandler.get());
    }

    if (!PP.hasPragmaHandler("hls")) {
      XlxhlsHandler.reset(new PragmaXlxHandler("hls"));
      PP.AddPragmaHandler(XlxhlsHandler.get());
    }
    
    if (!PP.hasPragmaHandler("HLSDIRECTIVE")) {
      XlxHLSDIRECTIVEHandler.reset(new PragmaXlxHandler("HLSDIRECTIVE", tok::annot_pragma_XlxHLS_directive));
      PP.AddPragmaHandler(XlxHLSDIRECTIVEHandler.get());
    }

    if (!PP.hasPragmaHandler("SLXDIRECTIVE")) { 
      XlxSLXDIRECTIVEHandler.reset(new PragmaXlxHandler("SLXDIRECTIVE", tok::annot_pragma_XlxSLX_directive)); 
      PP.AddPragmaHandler(XlxSLXDIRECTIVEHandler.get());
    }

    if (!PP.hasPragmaHandler("AP")) {
      XlxAPHandler.reset(new PragmaXlxHandler("AP", tok::annot_pragma_XlxHLS_old));
      PP.AddPragmaHandler(XlxAPHandler.get());
    }

    if (!PP.hasPragmaHandler("ap")) {
      XlxapHandler.reset(new PragmaXlxHandler("ap", tok::annot_pragma_XlxHLS_old));
      PP.AddPragmaHandler(XlxapHandler.get());
    }

    if (!PP.hasPragmaHandler("AUTOPILOT")) {
      XlxAUTOPILOTHandler.reset(new PragmaXlxHandler("AUTOPILOT", tok::annot_pragma_XlxHLS_old));
      PP.AddPragmaHandler(XlxAUTOPILOTHandler.get());
    }

    if (!PP.hasPragmaHandler("autopilot")) {
      XlxautopilotHandler.reset(new PragmaXlxHandler("autopilot", tok::annot_pragma_XlxHLS_old));
      PP.AddPragmaHandler(XlxautopilotHandler.get());
    }
  }

  if (getLangOpts().MicrosoftExt || getTargetInfo().getTriple().isPS4()) {
    MSCommentHandler.reset(new PragmaCommentHandler(Actions));
    PP.AddPragmaHandler(MSCommentHandler.get());
  }

  if (getLangOpts().MicrosoftExt) {
    MSDetectMismatchHandler.reset(new PragmaDetectMismatchHandler(Actions));
    PP.AddPragmaHandler(MSDetectMismatchHandler.get());
    MSPointersToMembers.reset(new PragmaMSPointersToMembers());
    PP.AddPragmaHandler(MSPointersToMembers.get());
    MSVtorDisp.reset(new PragmaMSVtorDisp());
    PP.AddPragmaHandler(MSVtorDisp.get());
    MSInitSeg.reset(new PragmaMSPragma("init_seg"));
    PP.AddPragmaHandler(MSInitSeg.get());
    MSDataSeg.reset(new PragmaMSPragma("data_seg"));
    PP.AddPragmaHandler(MSDataSeg.get());
    MSBSSSeg.reset(new PragmaMSPragma("bss_seg"));
    PP.AddPragmaHandler(MSBSSSeg.get());
    MSConstSeg.reset(new PragmaMSPragma("const_seg"));
    PP.AddPragmaHandler(MSConstSeg.get());
    MSCodeSeg.reset(new PragmaMSPragma("code_seg"));
    PP.AddPragmaHandler(MSCodeSeg.get());
    MSSection.reset(new PragmaMSPragma("section"));
    PP.AddPragmaHandler(MSSection.get());
    MSRuntimeChecks.reset(new PragmaMSRuntimeChecksHandler());
    PP.AddPragmaHandler(MSRuntimeChecks.get());
    MSIntrinsic.reset(new PragmaMSIntrinsicHandler());
    PP.AddPragmaHandler(MSIntrinsic.get());
  }

  if (getLangOpts().CUDA) {
    CUDAForceHostDeviceHandler.reset(
        new PragmaForceCUDAHostDeviceHandler(Actions));
    PP.AddPragmaHandler("clang", CUDAForceHostDeviceHandler.get());
  }

  OptimizeHandler.reset(new PragmaOptimizeHandler(Actions));
  PP.AddPragmaHandler("clang", OptimizeHandler.get());

  LoopHintHandler.reset(new PragmaLoopHintHandler());
  PP.AddPragmaHandler("clang", LoopHintHandler.get());

  UnrollHintHandler.reset(new PragmaUnrollHintHandler("unroll"));
  PP.AddPragmaHandler(UnrollHintHandler.get());

  NoUnrollHintHandler.reset(new PragmaUnrollHintHandler("nounroll"));
  PP.AddPragmaHandler(NoUnrollHintHandler.get());

  FPHandler.reset(new PragmaFPHandler());
  PP.AddPragmaHandler("clang", FPHandler.get());

  AttributePragmaHandler.reset(new PragmaAttributeHandler(AttrFactory));
  PP.AddPragmaHandler("clang", AttributePragmaHandler.get());
}

void Parser::resetPragmaHandlers() {
  // Remove the pragma handlers we installed.
  PP.RemovePragmaHandler(AlignHandler.get());
  AlignHandler.reset();
  PP.RemovePragmaHandler("GCC", GCCVisibilityHandler.get());
  GCCVisibilityHandler.reset();
  PP.RemovePragmaHandler(OptionsHandler.get());
  OptionsHandler.reset();
  PP.RemovePragmaHandler(PackHandler.get());
  PackHandler.reset();
  PP.RemovePragmaHandler(MSStructHandler.get());
  MSStructHandler.reset();
  PP.RemovePragmaHandler(UnusedHandler.get());
  UnusedHandler.reset();
  PP.RemovePragmaHandler(WeakHandler.get());
  WeakHandler.reset();
  PP.RemovePragmaHandler(RedefineExtnameHandler.get());
  RedefineExtnameHandler.reset();

  if (getLangOpts().OpenCL) {
    PP.RemovePragmaHandler("OPENCL", OpenCLExtensionHandler.get());
    OpenCLExtensionHandler.reset();
    PP.RemovePragmaHandler("OPENCL", FPContractHandler.get());
  }
  PP.RemovePragmaHandler(OpenMPHandler.get());
  OpenMPHandler.reset();

  if (getLangOpts().XMCExt) {
    PP.RemovePragmaHandler(ModelComposerHandler.get());
    ModelComposerHandler.reset();
  }

  if (getLangOpts().HLSExt) {
    if (XlxHLSHandler) {
      PP.RemovePragmaHandler(XlxHLSHandler.get());
      XlxHLSHandler.reset();
    }
    if (XlxHLSDIRECTIVEHandler) {
      PP.RemovePragmaHandler(XlxHLSDIRECTIVEHandler.get());
      XlxHLSDIRECTIVEHandler.reset();
    }

    if (XlxSLXDIRECTIVEHandler) { 
      PP.RemovePragmaHandler(XlxSLXDIRECTIVEHandler.get());
      XlxSLXDIRECTIVEHandler.reset();
    }

    if (XlxhlsHandler) {
      PP.RemovePragmaHandler(XlxhlsHandler.get());
      XlxhlsHandler.reset();
    }
    if (XlxAPHandler) {
      PP.RemovePragmaHandler(XlxAPHandler.get());
      XlxAPHandler.reset();
    }
    if (XlxapHandler) {
      PP.RemovePragmaHandler(XlxapHandler.get());
      XlxapHandler.reset();
    }
    if (XlxAUTOPILOTHandler) {
      PP.RemovePragmaHandler(XlxAUTOPILOTHandler.get());
      XlxAUTOPILOTHandler.reset();
    }
    if (XlxautopilotHandler) {
      PP.RemovePragmaHandler(XlxautopilotHandler.get());
      XlxautopilotHandler.reset();
    }
  }

  if (getLangOpts().MicrosoftExt || getTargetInfo().getTriple().isPS4()) {
    PP.RemovePragmaHandler(MSCommentHandler.get());
    MSCommentHandler.reset();
  }

  PP.RemovePragmaHandler("clang", PCSectionHandler.get());
  PCSectionHandler.reset();

  if (getLangOpts().MicrosoftExt) {
    PP.RemovePragmaHandler(MSDetectMismatchHandler.get());
    MSDetectMismatchHandler.reset();
    PP.RemovePragmaHandler(MSPointersToMembers.get());
    MSPointersToMembers.reset();
    PP.RemovePragmaHandler(MSVtorDisp.get());
    MSVtorDisp.reset();
    PP.RemovePragmaHandler(MSInitSeg.get());
    MSInitSeg.reset();
    PP.RemovePragmaHandler(MSDataSeg.get());
    MSDataSeg.reset();
    PP.RemovePragmaHandler(MSBSSSeg.get());
    MSBSSSeg.reset();
    PP.RemovePragmaHandler(MSConstSeg.get());
    MSConstSeg.reset();
    PP.RemovePragmaHandler(MSCodeSeg.get());
    MSCodeSeg.reset();
    PP.RemovePragmaHandler(MSSection.get());
    MSSection.reset();
    PP.RemovePragmaHandler(MSRuntimeChecks.get());
    MSRuntimeChecks.reset();
    PP.RemovePragmaHandler(MSIntrinsic.get());
    MSIntrinsic.reset();
  }

  if (getLangOpts().CUDA) {
    PP.RemovePragmaHandler("clang", CUDAForceHostDeviceHandler.get());
    CUDAForceHostDeviceHandler.reset();
  }

  PP.RemovePragmaHandler("STDC", FPContractHandler.get());
  FPContractHandler.reset();

  PP.RemovePragmaHandler("STDC", STDCFENVHandler.get());
  STDCFENVHandler.reset();

  PP.RemovePragmaHandler("STDC", STDCCXLIMITHandler.get());
  STDCCXLIMITHandler.reset();

  PP.RemovePragmaHandler("STDC", STDCUnknownHandler.get());
  STDCUnknownHandler.reset();

  PP.RemovePragmaHandler("clang", OptimizeHandler.get());
  OptimizeHandler.reset();

  PP.RemovePragmaHandler("clang", LoopHintHandler.get());
  LoopHintHandler.reset();

  PP.RemovePragmaHandler(UnrollHintHandler.get());
  UnrollHintHandler.reset();

  PP.RemovePragmaHandler(NoUnrollHintHandler.get());
  NoUnrollHintHandler.reset();

  PP.RemovePragmaHandler("clang", FPHandler.get());
  FPHandler.reset();

  PP.RemovePragmaHandler("clang", AttributePragmaHandler.get());
  AttributePragmaHandler.reset();
}

/// \brief Handle the annotation token produced for #pragma unused(...)
///
/// Each annot_pragma_unused is followed by the argument token so e.g.
/// "#pragma unused(x,y)" becomes:
/// annot_pragma_unused 'x' annot_pragma_unused 'y'
void Parser::HandlePragmaUnused() {
  assert(Tok.is(tok::annot_pragma_unused));
  SourceLocation UnusedLoc = ConsumeAnnotationToken();
  Actions.ActOnPragmaUnused(Tok, getCurScope(), UnusedLoc);
  ConsumeToken(); // The argument token.
}

void Parser::HandlePragmaVisibility() {
  assert(Tok.is(tok::annot_pragma_vis));
  const IdentifierInfo *VisType =
    static_cast<IdentifierInfo *>(Tok.getAnnotationValue());
  SourceLocation VisLoc = ConsumeAnnotationToken();
  Actions.ActOnPragmaVisibility(VisType, VisLoc);
}

namespace {
struct PragmaPackInfo {
  Sema::PragmaMsStackAction Action;
  StringRef SlotLabel;
  Token Alignment;
};
} // end anonymous namespace

void Parser::HandlePragmaPack() {
  assert(Tok.is(tok::annot_pragma_pack));
  PragmaPackInfo *Info =
    static_cast<PragmaPackInfo *>(Tok.getAnnotationValue());
  SourceLocation PragmaLoc = Tok.getLocation();
  ExprResult Alignment;
  if (Info->Alignment.is(tok::numeric_constant)) {
    Alignment = Actions.ActOnNumericConstant(Info->Alignment);
    if (Alignment.isInvalid()) {
      ConsumeAnnotationToken();
      return;
    }
  }
  Actions.ActOnPragmaPack(PragmaLoc, Info->Action, Info->SlotLabel,
                          Alignment.get());
  // Consume the token after processing the pragma to enable pragma-specific
  // #include warnings.
  ConsumeAnnotationToken();
}

void Parser::HandlePragmaMSStruct() {
  assert(Tok.is(tok::annot_pragma_msstruct));
  PragmaMSStructKind Kind = static_cast<PragmaMSStructKind>(
      reinterpret_cast<uintptr_t>(Tok.getAnnotationValue()));
  Actions.ActOnPragmaMSStruct(Kind);
  ConsumeAnnotationToken();
}

void Parser::HandlePragmaAlign() {
  assert(Tok.is(tok::annot_pragma_align));
  Sema::PragmaOptionsAlignKind Kind =
    static_cast<Sema::PragmaOptionsAlignKind>(
    reinterpret_cast<uintptr_t>(Tok.getAnnotationValue()));
  SourceLocation PragmaLoc = ConsumeAnnotationToken();
  Actions.ActOnPragmaOptionsAlign(Kind, PragmaLoc);
}

void Parser::HandlePragmaDump() {
  assert(Tok.is(tok::annot_pragma_dump));
  IdentifierInfo *II =
      reinterpret_cast<IdentifierInfo *>(Tok.getAnnotationValue());
  Actions.ActOnPragmaDump(getCurScope(), Tok.getLocation(), II);
  ConsumeAnnotationToken();
}

void Parser::HandlePragmaWeak() {
  assert(Tok.is(tok::annot_pragma_weak));
  SourceLocation PragmaLoc = ConsumeAnnotationToken();
  Actions.ActOnPragmaWeakID(Tok.getIdentifierInfo(), PragmaLoc,
                            Tok.getLocation());
  ConsumeToken(); // The weak name.
}

void Parser::HandlePragmaWeakAlias() {
  assert(Tok.is(tok::annot_pragma_weakalias));
  SourceLocation PragmaLoc = ConsumeAnnotationToken();
  IdentifierInfo *WeakName = Tok.getIdentifierInfo();
  SourceLocation WeakNameLoc = Tok.getLocation();
  ConsumeToken();
  IdentifierInfo *AliasName = Tok.getIdentifierInfo();
  SourceLocation AliasNameLoc = Tok.getLocation();
  ConsumeToken();
  Actions.ActOnPragmaWeakAlias(WeakName, AliasName, PragmaLoc,
                               WeakNameLoc, AliasNameLoc);

}

void Parser::HandlePragmaRedefineExtname() {
  assert(Tok.is(tok::annot_pragma_redefine_extname));
  SourceLocation RedefLoc = ConsumeAnnotationToken();
  IdentifierInfo *RedefName = Tok.getIdentifierInfo();
  SourceLocation RedefNameLoc = Tok.getLocation();
  ConsumeToken();
  IdentifierInfo *AliasName = Tok.getIdentifierInfo();
  SourceLocation AliasNameLoc = Tok.getLocation();
  ConsumeToken();
  Actions.ActOnPragmaRedefineExtname(RedefName, AliasName, RedefLoc,
                                     RedefNameLoc, AliasNameLoc);
}

void Parser::HandlePragmaFPContract() {
  assert(Tok.is(tok::annot_pragma_fp_contract));
  tok::OnOffSwitch OOS =
    static_cast<tok::OnOffSwitch>(
    reinterpret_cast<uintptr_t>(Tok.getAnnotationValue()));

  LangOptions::FPContractModeKind FPC;
  switch (OOS) {
  case tok::OOS_ON:
    FPC = LangOptions::FPC_On;
    break;
  case tok::OOS_OFF:
    FPC = LangOptions::FPC_Off;
    break;
  case tok::OOS_DEFAULT:
    FPC = getLangOpts().getDefaultFPContractMode();
    break;
  }

  Actions.ActOnPragmaFPContract(FPC);
  ConsumeAnnotationToken();
}

StmtResult Parser::HandlePragmaCaptured()
{
  assert(Tok.is(tok::annot_pragma_captured));
  ConsumeAnnotationToken();

  if (Tok.isNot(tok::l_brace)) {
    PP.Diag(Tok, diag::err_expected) << tok::l_brace;
    return StmtError();
  }

  SourceLocation Loc = Tok.getLocation();

  ParseScope CapturedRegionScope(this, Scope::FnScope | Scope::DeclScope |
                                           Scope::CompoundStmtScope);
  Actions.ActOnCapturedRegionStart(Loc, getCurScope(), CR_Default,
                                   /*NumParams=*/1);

  StmtResult R = ParseCompoundStatement();
  CapturedRegionScope.Exit();

  if (R.isInvalid()) {
    Actions.ActOnCapturedRegionError();
    return StmtError();
  }

  return Actions.ActOnCapturedRegionEnd(R.get());
}

namespace {
  enum OpenCLExtState : char {
    Disable, Enable, Begin, End
  };
  typedef std::pair<const IdentifierInfo *, OpenCLExtState> OpenCLExtData;
}

void Parser::HandlePragmaOpenCLExtension() {
  assert(Tok.is(tok::annot_pragma_opencl_extension));
  OpenCLExtData *Data = static_cast<OpenCLExtData*>(Tok.getAnnotationValue());
  auto State = Data->second;
  auto Ident = Data->first;
  SourceLocation NameLoc = Tok.getLocation();
  ConsumeAnnotationToken();

  auto &Opt = Actions.getOpenCLOptions();
  auto Name = Ident->getName();
  // OpenCL 1.1 9.1: "The all variant sets the behavior for all extensions,
  // overriding all previously issued extension directives, but only if the
  // behavior is set to disable."
  if (Name == "all") {
    if (State == Disable) {
      Opt.disableAll();
      Opt.enableSupportedCore(getLangOpts().OpenCLVersion);
    } else {
      PP.Diag(NameLoc, diag::warn_pragma_expected_predicate) << 1;
    }
  } else if (State == Begin) {
    if (!Opt.isKnown(Name) ||
        !Opt.isSupported(Name, getLangOpts().OpenCLVersion)) {
      Opt.support(Name);
    }
    Actions.setCurrentOpenCLExtension(Name);
  } else if (State == End) {
    if (Name != Actions.getCurrentOpenCLExtension())
      PP.Diag(NameLoc, diag::warn_pragma_begin_end_mismatch);
    Actions.setCurrentOpenCLExtension("");
  } else if (!Opt.isKnown(Name))
    PP.Diag(NameLoc, diag::warn_pragma_unknown_extension) << Ident;
  else if (Opt.isSupportedExtension(Name, getLangOpts().OpenCLVersion))
    Opt.enable(Name, State == Enable);
  else if (Opt.isSupportedCore(Name, getLangOpts().OpenCLVersion))
    PP.Diag(NameLoc, diag::warn_pragma_extension_is_core) << Ident;
  else
    PP.Diag(NameLoc, diag::warn_pragma_unsupported_extension) << Ident;
}

void Parser::HandlePragmaMSPointersToMembers() {
  assert(Tok.is(tok::annot_pragma_ms_pointers_to_members));
  LangOptions::PragmaMSPointersToMembersKind RepresentationMethod =
      static_cast<LangOptions::PragmaMSPointersToMembersKind>(
          reinterpret_cast<uintptr_t>(Tok.getAnnotationValue()));
  SourceLocation PragmaLoc = ConsumeAnnotationToken();
  Actions.ActOnPragmaMSPointersToMembers(RepresentationMethod, PragmaLoc);
}

void Parser::HandlePragmaMSVtorDisp() {
  assert(Tok.is(tok::annot_pragma_ms_vtordisp));
  uintptr_t Value = reinterpret_cast<uintptr_t>(Tok.getAnnotationValue());
  Sema::PragmaMsStackAction Action =
      static_cast<Sema::PragmaMsStackAction>((Value >> 16) & 0xFFFF);
  MSVtorDispAttr::Mode Mode = MSVtorDispAttr::Mode(Value & 0xFFFF);
  SourceLocation PragmaLoc = ConsumeAnnotationToken();
  Actions.ActOnPragmaMSVtorDisp(Action, PragmaLoc, Mode);
}

void Parser::HandlePragmaMSPragma() {
  assert(Tok.is(tok::annot_pragma_ms_pragma));
  // Grab the tokens out of the annotation and enter them into the stream.
  auto TheTokens =
      (std::pair<std::unique_ptr<Token[]>, size_t> *)Tok.getAnnotationValue();
  PP.EnterTokenStream(std::move(TheTokens->first), TheTokens->second, true);
  SourceLocation PragmaLocation = ConsumeAnnotationToken();
  assert(Tok.isAnyIdentifier());
  StringRef PragmaName = Tok.getIdentifierInfo()->getName();
  PP.Lex(Tok); // pragma kind

  // Figure out which #pragma we're dealing with.  The switch has no default
  // because lex shouldn't emit the annotation token for unrecognized pragmas.
  typedef bool (Parser::*PragmaHandler)(StringRef, SourceLocation);
  PragmaHandler Handler = llvm::StringSwitch<PragmaHandler>(PragmaName)
    .Case("data_seg", &Parser::HandlePragmaMSSegment)
    .Case("bss_seg", &Parser::HandlePragmaMSSegment)
    .Case("const_seg", &Parser::HandlePragmaMSSegment)
    .Case("code_seg", &Parser::HandlePragmaMSSegment)
    .Case("section", &Parser::HandlePragmaMSSection)
    .Case("init_seg", &Parser::HandlePragmaMSInitSeg);

  if (!(this->*Handler)(PragmaName, PragmaLocation)) {
    // Pragma handling failed, and has been diagnosed.  Slurp up the tokens
    // until eof (really end of line) to prevent follow-on errors.
    while (Tok.isNot(tok::eof))
      PP.Lex(Tok);
    PP.Lex(Tok);
  }
}

bool Parser::HandlePragmaMSSection(StringRef PragmaName,
                                   SourceLocation PragmaLocation) {
  if (Tok.isNot(tok::l_paren)) {
    PP.Diag(PragmaLocation, diag::warn_pragma_expected_lparen) << PragmaName;
    return false;
  }
  PP.Lex(Tok); // (
  // Parsing code for pragma section
  if (Tok.isNot(tok::string_literal)) {
    PP.Diag(PragmaLocation, diag::warn_pragma_expected_section_name)
        << PragmaName;
    return false;
  }
  ExprResult StringResult = ParseStringLiteralExpression();
  if (StringResult.isInvalid())
    return false; // Already diagnosed.
  StringLiteral *SegmentName = cast<StringLiteral>(StringResult.get());
  if (SegmentName->getCharByteWidth() != 1) {
    PP.Diag(PragmaLocation, diag::warn_pragma_expected_non_wide_string)
        << PragmaName;
    return false;
  }
  int SectionFlags = ASTContext::PSF_Read;
  bool SectionFlagsAreDefault = true;
  while (Tok.is(tok::comma)) {
    PP.Lex(Tok); // ,
    // Ignore "long" and "short".
    // They are undocumented, but widely used, section attributes which appear
    // to do nothing.
    if (Tok.is(tok::kw_long) || Tok.is(tok::kw_short)) {
      PP.Lex(Tok); // long/short
      continue;
    }

    if (!Tok.isAnyIdentifier()) {
      PP.Diag(PragmaLocation, diag::warn_pragma_expected_action_or_r_paren)
          << PragmaName;
      return false;
    }
    ASTContext::PragmaSectionFlag Flag =
      llvm::StringSwitch<ASTContext::PragmaSectionFlag>(
      Tok.getIdentifierInfo()->getName())
      .Case("read", ASTContext::PSF_Read)
      .Case("write", ASTContext::PSF_Write)
      .Case("execute", ASTContext::PSF_Execute)
      .Case("shared", ASTContext::PSF_Invalid)
      .Case("nopage", ASTContext::PSF_Invalid)
      .Case("nocache", ASTContext::PSF_Invalid)
      .Case("discard", ASTContext::PSF_Invalid)
      .Case("remove", ASTContext::PSF_Invalid)
      .Default(ASTContext::PSF_None);
    if (Flag == ASTContext::PSF_None || Flag == ASTContext::PSF_Invalid) {
      PP.Diag(PragmaLocation, Flag == ASTContext::PSF_None
                                  ? diag::warn_pragma_invalid_specific_action
                                  : diag::warn_pragma_unsupported_action)
          << PragmaName << Tok.getIdentifierInfo()->getName();
      return false;
    }
    SectionFlags |= Flag;
    SectionFlagsAreDefault = false;
    PP.Lex(Tok); // Identifier
  }
  // If no section attributes are specified, the section will be marked as
  // read/write.
  if (SectionFlagsAreDefault)
    SectionFlags |= ASTContext::PSF_Write;
  if (Tok.isNot(tok::r_paren)) {
    PP.Diag(PragmaLocation, diag::warn_pragma_expected_rparen) << PragmaName;
    return false;
  }
  PP.Lex(Tok); // )
  if (Tok.isNot(tok::eof)) {
    PP.Diag(PragmaLocation, diag::warn_pragma_extra_tokens_at_eol)
        << PragmaName;
    return false;
  }
  PP.Lex(Tok); // eof
  Actions.ActOnPragmaMSSection(PragmaLocation, SectionFlags, SegmentName);
  return true;
}

bool Parser::HandlePragmaMSSegment(StringRef PragmaName,
                                   SourceLocation PragmaLocation) {
  if (Tok.isNot(tok::l_paren)) {
    PP.Diag(PragmaLocation, diag::warn_pragma_expected_lparen) << PragmaName;
    return false;
  }
  PP.Lex(Tok); // (
  Sema::PragmaMsStackAction Action = Sema::PSK_Reset;
  StringRef SlotLabel;
  if (Tok.isAnyIdentifier()) {
    StringRef PushPop = Tok.getIdentifierInfo()->getName();
    if (PushPop == "push")
      Action = Sema::PSK_Push;
    else if (PushPop == "pop")
      Action = Sema::PSK_Pop;
    else {
      PP.Diag(PragmaLocation,
              diag::warn_pragma_expected_section_push_pop_or_name)
          << PragmaName;
      return false;
    }
    if (Action != Sema::PSK_Reset) {
      PP.Lex(Tok); // push | pop
      if (Tok.is(tok::comma)) {
        PP.Lex(Tok); // ,
        // If we've got a comma, we either need a label or a string.
        if (Tok.isAnyIdentifier()) {
          SlotLabel = Tok.getIdentifierInfo()->getName();
          PP.Lex(Tok); // identifier
          if (Tok.is(tok::comma))
            PP.Lex(Tok);
          else if (Tok.isNot(tok::r_paren)) {
            PP.Diag(PragmaLocation, diag::warn_pragma_expected_punc)
                << PragmaName;
            return false;
          }
        }
      } else if (Tok.isNot(tok::r_paren)) {
        PP.Diag(PragmaLocation, diag::warn_pragma_expected_punc) << PragmaName;
        return false;
      }
    }
  }
  // Grab the string literal for our section name.
  StringLiteral *SegmentName = nullptr;
  if (Tok.isNot(tok::r_paren)) {
    if (Tok.isNot(tok::string_literal)) {
      unsigned DiagID = Action != Sema::PSK_Reset ? !SlotLabel.empty() ?
          diag::warn_pragma_expected_section_name :
          diag::warn_pragma_expected_section_label_or_name :
          diag::warn_pragma_expected_section_push_pop_or_name;
      PP.Diag(PragmaLocation, DiagID) << PragmaName;
      return false;
    }
    ExprResult StringResult = ParseStringLiteralExpression();
    if (StringResult.isInvalid())
      return false; // Already diagnosed.
    SegmentName = cast<StringLiteral>(StringResult.get());
    if (SegmentName->getCharByteWidth() != 1) {
      PP.Diag(PragmaLocation, diag::warn_pragma_expected_non_wide_string)
          << PragmaName;
      return false;
    }
    // Setting section "" has no effect
    if (SegmentName->getLength())
      Action = (Sema::PragmaMsStackAction)(Action | Sema::PSK_Set);
  }
  if (Tok.isNot(tok::r_paren)) {
    PP.Diag(PragmaLocation, diag::warn_pragma_expected_rparen) << PragmaName;
    return false;
  }
  PP.Lex(Tok); // )
  if (Tok.isNot(tok::eof)) {
    PP.Diag(PragmaLocation, diag::warn_pragma_extra_tokens_at_eol)
        << PragmaName;
    return false;
  }
  PP.Lex(Tok); // eof
  Actions.ActOnPragmaMSSeg(PragmaLocation, Action, SlotLabel,
                           SegmentName, PragmaName);
  return true;
}

// #pragma init_seg({ compiler | lib | user | "section-name" [, func-name]} )
bool Parser::HandlePragmaMSInitSeg(StringRef PragmaName,
                                   SourceLocation PragmaLocation) {
  if (getTargetInfo().getTriple().getEnvironment() != llvm::Triple::MSVC) {
    PP.Diag(PragmaLocation, diag::warn_pragma_init_seg_unsupported_target);
    return false;
  }

  if (ExpectAndConsume(tok::l_paren, diag::warn_pragma_expected_lparen,
                       PragmaName))
    return false;

  // Parse either the known section names or the string section name.
  StringLiteral *SegmentName = nullptr;
  if (Tok.isAnyIdentifier()) {
    auto *II = Tok.getIdentifierInfo();
    StringRef Section = llvm::StringSwitch<StringRef>(II->getName())
                            .Case("compiler", "\".CRT$XCC\"")
                            .Case("lib", "\".CRT$XCL\"")
                            .Case("user", "\".CRT$XCU\"")
                            .Default("");

    if (!Section.empty()) {
      // Pretend the user wrote the appropriate string literal here.
      Token Toks[1];
      Toks[0].startToken();
      Toks[0].setKind(tok::string_literal);
      Toks[0].setLocation(Tok.getLocation());
      Toks[0].setLiteralData(Section.data());
      Toks[0].setLength(Section.size());
      SegmentName =
          cast<StringLiteral>(Actions.ActOnStringLiteral(Toks, nullptr).get());
      PP.Lex(Tok);
    }
  } else if (Tok.is(tok::string_literal)) {
    ExprResult StringResult = ParseStringLiteralExpression();
    if (StringResult.isInvalid())
      return false;
    SegmentName = cast<StringLiteral>(StringResult.get());
    if (SegmentName->getCharByteWidth() != 1) {
      PP.Diag(PragmaLocation, diag::warn_pragma_expected_non_wide_string)
          << PragmaName;
      return false;
    }
    // FIXME: Add support for the '[, func-name]' part of the pragma.
  }

  if (!SegmentName) {
    PP.Diag(PragmaLocation, diag::warn_pragma_expected_init_seg) << PragmaName;
    return false;
  }

  if (ExpectAndConsume(tok::r_paren, diag::warn_pragma_expected_rparen,
                       PragmaName) ||
      ExpectAndConsume(tok::eof, diag::warn_pragma_extra_tokens_at_eol,
                       PragmaName))
    return false;

  Actions.ActOnPragmaMSInitSeg(PragmaLocation, SegmentName);
  return true;
}

namespace {
struct PragmaLoopHintInfo {
  Token PragmaName;
  Token Option;
  ArrayRef<Token> Toks;
};
} // end anonymous namespace

static std::string PragmaLoopHintString(Token PragmaName, Token Option) {
  std::string PragmaString;
  if (PragmaName.getIdentifierInfo()->getName() == "loop") {
    PragmaString = "clang loop ";
    PragmaString += Option.getIdentifierInfo()->getName();
  } else {
    assert(PragmaName.getIdentifierInfo()->getName() == "unroll" &&
           "Unexpected pragma name");
    PragmaString = "unroll";
  }
  return PragmaString;
}

bool Parser::HandlePragmaLoopHint(LoopHint &Hint) {
  assert(Tok.is(tok::annot_pragma_loop_hint));
  PragmaLoopHintInfo *Info =
      static_cast<PragmaLoopHintInfo *>(Tok.getAnnotationValue());

  IdentifierInfo *PragmaNameInfo = Info->PragmaName.getIdentifierInfo();
  Hint.PragmaNameLoc = IdentifierLoc::create(
      Actions.Context, Info->PragmaName.getLocation(), PragmaNameInfo);

  // It is possible that the loop hint has no option identifier, such as
  // #pragma unroll(4).
  IdentifierInfo *OptionInfo = Info->Option.is(tok::identifier)
                                   ? Info->Option.getIdentifierInfo()
                                   : nullptr;
  Hint.OptionLoc = IdentifierLoc::create(
      Actions.Context, Info->Option.getLocation(), OptionInfo);

  llvm::ArrayRef<Token> Toks = Info->Toks;

  // Return a valid hint if pragma unroll or nounroll were specified
  // without an argument.
  bool PragmaUnroll = PragmaNameInfo->getName() == "unroll";
  bool PragmaNoUnroll = PragmaNameInfo->getName() == "nounroll";
  if (Toks.empty() && (PragmaUnroll || PragmaNoUnroll)) {
    ConsumeAnnotationToken();
    Hint.Range = Info->PragmaName.getLocation();
    return true;
  }

  // The constant expression is always followed by an eof token, which increases
  // the TokSize by 1.
  assert(!Toks.empty() &&
         "PragmaLoopHintInfo::Toks must contain at least one token.");

  // If no option is specified the argument is assumed to be a constant expr.
  bool OptionUnroll = false;
  bool OptionDistribute = false;
  bool StateOption = false;
  if (OptionInfo) { // Pragma Unroll does not specify an option.
    OptionUnroll = OptionInfo->isStr("unroll");
    OptionDistribute = OptionInfo->isStr("distribute");
    StateOption = llvm::StringSwitch<bool>(OptionInfo->getName())
                      .Case("vectorize", true)
                      .Case("interleave", true)
                      .Default(false) ||
                  OptionUnroll || OptionDistribute;
  }

  bool AssumeSafetyArg = !OptionUnroll && !OptionDistribute;
  // Verify loop hint has an argument.
  if (Toks[0].is(tok::eof)) {
    ConsumeAnnotationToken();
    Diag(Toks[0].getLocation(), diag::err_pragma_loop_missing_argument)
        << /*StateArgument=*/StateOption << /*FullKeyword=*/OptionUnroll
        << /*AssumeSafetyKeyword=*/AssumeSafetyArg;
    return false;
  }

  // Validate the argument.
  if (StateOption) {
    ConsumeAnnotationToken();
    SourceLocation StateLoc = Toks[0].getLocation();
    IdentifierInfo *StateInfo = Toks[0].getIdentifierInfo();

    bool Valid = StateInfo &&
                 llvm::StringSwitch<bool>(StateInfo->getName())
                     .Cases("enable", "disable", true)
                     .Case("full", OptionUnroll)
                     .Case("assume_safety", AssumeSafetyArg)
                     .Default(false);
    if (!Valid) {
      Diag(Toks[0].getLocation(), diag::err_pragma_invalid_keyword)
          << /*FullKeyword=*/OptionUnroll
          << /*AssumeSafetyKeyword=*/AssumeSafetyArg;
      return false;
    }
    if (Toks.size() > 2)
      Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
          << PragmaLoopHintString(Info->PragmaName, Info->Option);
    Hint.StateLoc = IdentifierLoc::create(Actions.Context, StateLoc, StateInfo);
  } else {
    // Enter constant expression including eof terminator into token stream.
    PP.EnterTokenStream(Toks, /*DisableMacroExpansion=*/false);
    ConsumeAnnotationToken();

    ExprResult R = ParseConstantExpression();

    // Tokens following an error in an ill-formed constant expression will
    // remain in the token stream and must be removed.
    if (Tok.isNot(tok::eof)) {
      Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
          << PragmaLoopHintString(Info->PragmaName, Info->Option);
      while (Tok.isNot(tok::eof))
        ConsumeAnyToken();
    }

    ConsumeToken(); // Consume the constant expression eof terminator.

    if (R.isInvalid() ||
        Actions.CheckLoopHintExpr(R.get(), Toks[0].getLocation()))
      return false;

    // Argument is a constant expression with an integer type.
    Hint.ValueExpr = R.get();
  }

  Hint.Range = SourceRange(Info->PragmaName.getLocation(),
                           Info->Toks.back().getLocation());
  return true;
}

namespace {
struct PragmaAttributeInfo {
  enum ActionType { Push, Pop };
  ParsedAttributes &Attributes;
  ActionType Action;
  ArrayRef<Token> Tokens;

  PragmaAttributeInfo(ParsedAttributes &Attributes) : Attributes(Attributes) {}
};

#include "clang/Parse/AttrSubMatchRulesParserStringSwitches.inc"

} // end anonymous namespace

static StringRef getIdentifier(const Token &Tok) {
  if (Tok.is(tok::identifier))
    return Tok.getIdentifierInfo()->getName();
  const char *S = tok::getKeywordSpelling(Tok.getKind());
  if (!S)
    return "";
  return S;
}

static bool isAbstractAttrMatcherRule(attr::SubjectMatchRule Rule) {
  using namespace attr;
  switch (Rule) {
#define ATTR_MATCH_RULE(Value, Spelling, IsAbstract)                           \
  case Value:                                                                  \
    return IsAbstract;
#include "clang/Basic/AttrSubMatchRulesList.inc"
  }
  llvm_unreachable("Invalid attribute subject match rule");
  return false;
}

static void diagnoseExpectedAttributeSubjectSubRule(
    Parser &PRef, attr::SubjectMatchRule PrimaryRule, StringRef PrimaryRuleName,
    SourceLocation SubRuleLoc) {
  auto Diagnostic =
      PRef.Diag(SubRuleLoc,
                diag::err_pragma_attribute_expected_subject_sub_identifier)
      << PrimaryRuleName;
  if (const char *SubRules = validAttributeSubjectMatchSubRules(PrimaryRule))
    Diagnostic << /*SubRulesSupported=*/1 << SubRules;
  else
    Diagnostic << /*SubRulesSupported=*/0;
}

static void diagnoseUnknownAttributeSubjectSubRule(
    Parser &PRef, attr::SubjectMatchRule PrimaryRule, StringRef PrimaryRuleName,
    StringRef SubRuleName, SourceLocation SubRuleLoc) {

  auto Diagnostic =
      PRef.Diag(SubRuleLoc, diag::err_pragma_attribute_unknown_subject_sub_rule)
      << SubRuleName << PrimaryRuleName;
  if (const char *SubRules = validAttributeSubjectMatchSubRules(PrimaryRule))
    Diagnostic << /*SubRulesSupported=*/1 << SubRules;
  else
    Diagnostic << /*SubRulesSupported=*/0;
}

bool Parser::ParsePragmaAttributeSubjectMatchRuleSet(
    attr::ParsedSubjectMatchRuleSet &SubjectMatchRules, SourceLocation &AnyLoc,
    SourceLocation &LastMatchRuleEndLoc) {
  bool IsAny = false;
  BalancedDelimiterTracker AnyParens(*this, tok::l_paren);
  if (getIdentifier(Tok) == "any") {
    AnyLoc = ConsumeToken();
    IsAny = true;
    if (AnyParens.expectAndConsume())
      return true;
  }

  do {
    // Parse the subject matcher rule.
    StringRef Name = getIdentifier(Tok);
    if (Name.empty()) {
      Diag(Tok, diag::err_pragma_attribute_expected_subject_identifier);
      return true;
    }
    std::pair<Optional<attr::SubjectMatchRule>,
              Optional<attr::SubjectMatchRule> (*)(StringRef, bool)>
        Rule = isAttributeSubjectMatchRule(Name);
    if (!Rule.first) {
      Diag(Tok, diag::err_pragma_attribute_unknown_subject_rule) << Name;
      return true;
    }
    attr::SubjectMatchRule PrimaryRule = *Rule.first;
    SourceLocation RuleLoc = ConsumeToken();

    BalancedDelimiterTracker Parens(*this, tok::l_paren);
    if (isAbstractAttrMatcherRule(PrimaryRule)) {
      if (Parens.expectAndConsume())
        return true;
    } else if (Parens.consumeOpen()) {
      if (!SubjectMatchRules
               .insert(
                   std::make_pair(PrimaryRule, SourceRange(RuleLoc, RuleLoc)))
               .second)
        Diag(RuleLoc, diag::err_pragma_attribute_duplicate_subject)
            << Name
            << FixItHint::CreateRemoval(SourceRange(
                   RuleLoc, Tok.is(tok::comma) ? Tok.getLocation() : RuleLoc));
      LastMatchRuleEndLoc = RuleLoc;
      continue;
    }

    // Parse the sub-rules.
    StringRef SubRuleName = getIdentifier(Tok);
    if (SubRuleName.empty()) {
      diagnoseExpectedAttributeSubjectSubRule(*this, PrimaryRule, Name,
                                              Tok.getLocation());
      return true;
    }
    attr::SubjectMatchRule SubRule;
    if (SubRuleName == "unless") {
      SourceLocation SubRuleLoc = ConsumeToken();
      BalancedDelimiterTracker Parens(*this, tok::l_paren);
      if (Parens.expectAndConsume())
        return true;
      SubRuleName = getIdentifier(Tok);
      if (SubRuleName.empty()) {
        diagnoseExpectedAttributeSubjectSubRule(*this, PrimaryRule, Name,
                                                SubRuleLoc);
        return true;
      }
      auto SubRuleOrNone = Rule.second(SubRuleName, /*IsUnless=*/true);
      if (!SubRuleOrNone) {
        std::string SubRuleUnlessName = "unless(" + SubRuleName.str() + ")";
        diagnoseUnknownAttributeSubjectSubRule(*this, PrimaryRule, Name,
                                               SubRuleUnlessName, SubRuleLoc);
        return true;
      }
      SubRule = *SubRuleOrNone;
      ConsumeToken();
      if (Parens.consumeClose())
        return true;
    } else {
      auto SubRuleOrNone = Rule.second(SubRuleName, /*IsUnless=*/false);
      if (!SubRuleOrNone) {
        diagnoseUnknownAttributeSubjectSubRule(*this, PrimaryRule, Name,
                                               SubRuleName, Tok.getLocation());
        return true;
      }
      SubRule = *SubRuleOrNone;
      ConsumeToken();
    }
    SourceLocation RuleEndLoc = Tok.getLocation();
    LastMatchRuleEndLoc = RuleEndLoc;
    if (Parens.consumeClose())
      return true;
    if (!SubjectMatchRules
             .insert(std::make_pair(SubRule, SourceRange(RuleLoc, RuleEndLoc)))
             .second) {
      Diag(RuleLoc, diag::err_pragma_attribute_duplicate_subject)
          << attr::getSubjectMatchRuleSpelling(SubRule)
          << FixItHint::CreateRemoval(SourceRange(
                 RuleLoc, Tok.is(tok::comma) ? Tok.getLocation() : RuleEndLoc));
      continue;
    }
  } while (IsAny && TryConsumeToken(tok::comma));

  if (IsAny)
    if (AnyParens.consumeClose())
      return true;

  return false;
}

namespace {

/// Describes the stage at which attribute subject rule parsing was interruped.
enum class MissingAttributeSubjectRulesRecoveryPoint {
  Comma,
  ApplyTo,
  Equals,
  Any,
  None,
};

MissingAttributeSubjectRulesRecoveryPoint
getAttributeSubjectRulesRecoveryPointForToken(const Token &Tok) {
  if (const auto *II = Tok.getIdentifierInfo()) {
    if (II->isStr("apply_to"))
      return MissingAttributeSubjectRulesRecoveryPoint::ApplyTo;
    if (II->isStr("any"))
      return MissingAttributeSubjectRulesRecoveryPoint::Any;
  }
  if (Tok.is(tok::equal))
    return MissingAttributeSubjectRulesRecoveryPoint::Equals;
  return MissingAttributeSubjectRulesRecoveryPoint::None;
}

/// Creates a diagnostic for the attribute subject rule parsing diagnostic that
/// suggests the possible attribute subject rules in a fix-it together with
/// any other missing tokens.
DiagnosticBuilder createExpectedAttributeSubjectRulesTokenDiagnostic(
    unsigned DiagID, AttributeList &Attribute,
    MissingAttributeSubjectRulesRecoveryPoint Point, Parser &PRef) {
  SourceLocation Loc = PRef.getEndOfPreviousToken();
  if (Loc.isInvalid())
    Loc = PRef.getCurToken().getLocation();
  auto Diagnostic = PRef.Diag(Loc, DiagID);
  std::string FixIt;
  MissingAttributeSubjectRulesRecoveryPoint EndPoint =
      getAttributeSubjectRulesRecoveryPointForToken(PRef.getCurToken());
  if (Point == MissingAttributeSubjectRulesRecoveryPoint::Comma)
    FixIt = ", ";
  if (Point <= MissingAttributeSubjectRulesRecoveryPoint::ApplyTo &&
      EndPoint > MissingAttributeSubjectRulesRecoveryPoint::ApplyTo)
    FixIt += "apply_to";
  if (Point <= MissingAttributeSubjectRulesRecoveryPoint::Equals &&
      EndPoint > MissingAttributeSubjectRulesRecoveryPoint::Equals)
    FixIt += " = ";
  SourceRange FixItRange(Loc);
  if (EndPoint == MissingAttributeSubjectRulesRecoveryPoint::None) {
    // Gather the subject match rules that are supported by the attribute.
    SmallVector<std::pair<attr::SubjectMatchRule, bool>, 4> SubjectMatchRuleSet;
    Attribute.getMatchRules(PRef.getLangOpts(), SubjectMatchRuleSet);
    if (SubjectMatchRuleSet.empty()) {
      // FIXME: We can emit a "fix-it" with a subject list placeholder when
      // placeholders will be supported by the fix-its.
      return Diagnostic;
    }
    FixIt += "any(";
    bool NeedsComma = false;
    for (const auto &I : SubjectMatchRuleSet) {
      // Ensure that the missing rule is reported in the fix-it only when it's
      // supported in the current language mode.
      if (!I.second)
        continue;
      if (NeedsComma)
        FixIt += ", ";
      else
        NeedsComma = true;
      FixIt += attr::getSubjectMatchRuleSpelling(I.first);
    }
    FixIt += ")";
    // Check if we need to remove the range
    PRef.SkipUntil(tok::eof, Parser::StopBeforeMatch);
    FixItRange.setEnd(PRef.getCurToken().getLocation());
  }
  if (FixItRange.getBegin() == FixItRange.getEnd())
    Diagnostic << FixItHint::CreateInsertion(FixItRange.getBegin(), FixIt);
  else
    Diagnostic << FixItHint::CreateReplacement(
        CharSourceRange::getCharRange(FixItRange), FixIt);
  return Diagnostic;
}

} // end anonymous namespace

void Parser::HandlePragmaAttribute() {
  assert(Tok.is(tok::annot_pragma_attribute) &&
         "Expected #pragma attribute annotation token");
  SourceLocation PragmaLoc = Tok.getLocation();
  auto *Info = static_cast<PragmaAttributeInfo *>(Tok.getAnnotationValue());
  if (Info->Action == PragmaAttributeInfo::Pop) {
    ConsumeAnnotationToken();
    Actions.ActOnPragmaAttributePop(PragmaLoc);
    return;
  }
  // Parse the actual attribute with its arguments.
  assert(Info->Action == PragmaAttributeInfo::Push &&
         "Unexpected #pragma attribute command");
  PP.EnterTokenStream(Info->Tokens, /*DisableMacroExpansion=*/false);
  ConsumeAnnotationToken();

  ParsedAttributes &Attrs = Info->Attributes;
  Attrs.clearListOnly();

  auto SkipToEnd = [this]() {
    SkipUntil(tok::eof, StopBeforeMatch);
    ConsumeToken();
  };

  if (Tok.is(tok::l_square) && NextToken().is(tok::l_square)) {
    // Parse the CXX11 style attribute.
    ParseCXX11AttributeSpecifier(Attrs);
  } else if (Tok.is(tok::kw___attribute)) {
    ConsumeToken();
    if (ExpectAndConsume(tok::l_paren, diag::err_expected_lparen_after,
                         "attribute"))
      return SkipToEnd();
    if (ExpectAndConsume(tok::l_paren, diag::err_expected_lparen_after, "("))
      return SkipToEnd();

    if (Tok.isNot(tok::identifier)) {
      Diag(Tok, diag::err_pragma_attribute_expected_attribute_name);
      SkipToEnd();
      return;
    }
    IdentifierInfo *AttrName = Tok.getIdentifierInfo();
    SourceLocation AttrNameLoc = ConsumeToken();

    if (Tok.isNot(tok::l_paren))
      Attrs.addNew(AttrName, AttrNameLoc, nullptr, AttrNameLoc, nullptr, 0,
                   AttributeList::AS_GNU);
    else
      ParseGNUAttributeArgs(AttrName, AttrNameLoc, Attrs, /*EndLoc=*/nullptr,
                            /*ScopeName=*/nullptr,
                            /*ScopeLoc=*/SourceLocation(),
                            AttributeList::AS_GNU,
                            /*Declarator=*/nullptr);

    if (ExpectAndConsume(tok::r_paren))
      return SkipToEnd();
    if (ExpectAndConsume(tok::r_paren))
      return SkipToEnd();
  } else if (Tok.is(tok::kw___declspec)) {
    ParseMicrosoftDeclSpecs(Attrs);
  } else {
    Diag(Tok, diag::err_pragma_attribute_expected_attribute_syntax);
    if (Tok.getIdentifierInfo()) {
      // If we suspect that this is an attribute suggest the use of
      // '__attribute__'.
      if (AttributeList::getKind(Tok.getIdentifierInfo(), /*ScopeName=*/nullptr,
                                 AttributeList::AS_GNU) !=
          AttributeList::UnknownAttribute) {
        SourceLocation InsertStartLoc = Tok.getLocation();
        ConsumeToken();
        if (Tok.is(tok::l_paren)) {
          ConsumeAnyToken();
          SkipUntil(tok::r_paren, StopBeforeMatch);
          if (Tok.isNot(tok::r_paren))
            return SkipToEnd();
        }
        Diag(Tok, diag::note_pragma_attribute_use_attribute_kw)
            << FixItHint::CreateInsertion(InsertStartLoc, "__attribute__((")
            << FixItHint::CreateInsertion(Tok.getEndLoc(), "))");
      }
    }
    SkipToEnd();
    return;
  }

  if (!Attrs.getList() || Attrs.getList()->isInvalid()) {
    SkipToEnd();
    return;
  }

  // Ensure that we don't have more than one attribute.
  if (Attrs.getList()->getNext()) {
    SourceLocation Loc = Attrs.getList()->getNext()->getLoc();
    Diag(Loc, diag::err_pragma_attribute_multiple_attributes);
    SkipToEnd();
    return;
  }

  if (!Attrs.getList()->isSupportedByPragmaAttribute()) {
    Diag(PragmaLoc, diag::err_pragma_attribute_unsupported_attribute)
        << Attrs.getList()->getName();
    SkipToEnd();
    return;
  }
  AttributeList &Attribute = *Attrs.getList();

  // Parse the subject-list.
  if (!TryConsumeToken(tok::comma)) {
    createExpectedAttributeSubjectRulesTokenDiagnostic(
        diag::err_expected, Attribute,
        MissingAttributeSubjectRulesRecoveryPoint::Comma, *this)
        << tok::comma;
    SkipToEnd();
    return;
  }

  if (Tok.isNot(tok::identifier)) {
    createExpectedAttributeSubjectRulesTokenDiagnostic(
        diag::err_pragma_attribute_invalid_subject_set_specifier, Attribute,
        MissingAttributeSubjectRulesRecoveryPoint::ApplyTo, *this);
    SkipToEnd();
    return;
  }
  const IdentifierInfo *II = Tok.getIdentifierInfo();
  if (!II->isStr("apply_to")) {
    createExpectedAttributeSubjectRulesTokenDiagnostic(
        diag::err_pragma_attribute_invalid_subject_set_specifier, Attribute,
        MissingAttributeSubjectRulesRecoveryPoint::ApplyTo, *this);
    SkipToEnd();
    return;
  }
  ConsumeToken();

  if (!TryConsumeToken(tok::equal)) {
    createExpectedAttributeSubjectRulesTokenDiagnostic(
        diag::err_expected, Attribute,
        MissingAttributeSubjectRulesRecoveryPoint::Equals, *this)
        << tok::equal;
    SkipToEnd();
    return;
  }

  attr::ParsedSubjectMatchRuleSet SubjectMatchRules;
  SourceLocation AnyLoc, LastMatchRuleEndLoc;
  if (ParsePragmaAttributeSubjectMatchRuleSet(SubjectMatchRules, AnyLoc,
                                              LastMatchRuleEndLoc)) {
    SkipToEnd();
    return;
  }

  // Tokens following an ill-formed attribute will remain in the token stream
  // and must be removed.
  if (Tok.isNot(tok::eof)) {
    Diag(Tok, diag::err_pragma_attribute_extra_tokens_after_attribute);
    SkipToEnd();
    return;
  }

  // Consume the eof terminator token.
  ConsumeToken();

  Actions.ActOnPragmaAttributePush(Attribute, PragmaLoc,
                                   std::move(SubjectMatchRules));
}

// #pragma GCC visibility comes in two variants:
//   'push' '(' [visibility] ')'
//   'pop'
void PragmaGCCVisibilityHandler::HandlePragma(Preprocessor &PP, 
                                              PragmaIntroducerKind Introducer,
                                              Token &VisTok) {
  SourceLocation VisLoc = VisTok.getLocation();

  Token Tok;
  PP.LexUnexpandedToken(Tok);

  const IdentifierInfo *PushPop = Tok.getIdentifierInfo();

  const IdentifierInfo *VisType;
  if (PushPop && PushPop->isStr("pop")) {
    VisType = nullptr;
  } else if (PushPop && PushPop->isStr("push")) {
    PP.LexUnexpandedToken(Tok);
    if (Tok.isNot(tok::l_paren)) {
      PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_lparen)
        << "visibility";
      return;
    }
    PP.LexUnexpandedToken(Tok);
    VisType = Tok.getIdentifierInfo();
    if (!VisType) {
      PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_identifier)
        << "visibility";
      return;
    }
    PP.LexUnexpandedToken(Tok);
    if (Tok.isNot(tok::r_paren)) {
      PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_rparen)
        << "visibility";
      return;
    }
  } else {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_identifier)
      << "visibility";
    return;
  }
  SourceLocation EndLoc = Tok.getLocation();
  PP.LexUnexpandedToken(Tok);
  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
      << "visibility";
    return;
  }

  auto Toks = llvm::make_unique<Token[]>(1);
  Toks[0].startToken();
  Toks[0].setKind(tok::annot_pragma_vis);
  Toks[0].setLocation(VisLoc);
  Toks[0].setAnnotationEndLoc(EndLoc);
  Toks[0].setAnnotationValue(
                          const_cast<void*>(static_cast<const void*>(VisType)));
  PP.EnterTokenStream(std::move(Toks), 1, /*DisableMacroExpansion=*/true);
}

// #pragma pack(...) comes in the following delicious flavors:
//   pack '(' [integer] ')'
//   pack '(' 'show' ')'
//   pack '(' ('push' | 'pop') [',' identifier] [, integer] ')'
void PragmaPackHandler::HandlePragma(Preprocessor &PP, 
                                     PragmaIntroducerKind Introducer,
                                     Token &PackTok) {
  SourceLocation PackLoc = PackTok.getLocation();

  Token Tok;
  PP.Lex(Tok);
  if (Tok.isNot(tok::l_paren)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_lparen) << "pack";
    return;
  }

  Sema::PragmaMsStackAction Action = Sema::PSK_Reset;
  StringRef SlotLabel;
  Token Alignment;
  Alignment.startToken();
  PP.Lex(Tok);
  if (Tok.is(tok::numeric_constant)) {
    Alignment = Tok;

    PP.Lex(Tok);

    // In MSVC/gcc, #pragma pack(4) sets the alignment without affecting
    // the push/pop stack.
    // In Apple gcc, #pragma pack(4) is equivalent to #pragma pack(push, 4)
    Action =
        PP.getLangOpts().ApplePragmaPack ? Sema::PSK_Push_Set : Sema::PSK_Set;
  } else if (Tok.is(tok::identifier)) {
    const IdentifierInfo *II = Tok.getIdentifierInfo();
    if (II->isStr("show")) {
      Action = Sema::PSK_Show;
      PP.Lex(Tok);
    } else {
      if (II->isStr("push")) {
        Action = Sema::PSK_Push;
      } else if (II->isStr("pop")) {
        Action = Sema::PSK_Pop;
      } else {
        PP.Diag(Tok.getLocation(), diag::warn_pragma_invalid_action) << "pack";
        return;
      }
      PP.Lex(Tok);

      if (Tok.is(tok::comma)) {
        PP.Lex(Tok);

        if (Tok.is(tok::numeric_constant)) {
          Action = (Sema::PragmaMsStackAction)(Action | Sema::PSK_Set);
          Alignment = Tok;

          PP.Lex(Tok);
        } else if (Tok.is(tok::identifier)) {
          SlotLabel = Tok.getIdentifierInfo()->getName();
          PP.Lex(Tok);

          if (Tok.is(tok::comma)) {
            PP.Lex(Tok);

            if (Tok.isNot(tok::numeric_constant)) {
              PP.Diag(Tok.getLocation(), diag::warn_pragma_pack_malformed);
              return;
            }

            Action = (Sema::PragmaMsStackAction)(Action | Sema::PSK_Set);
            Alignment = Tok;

            PP.Lex(Tok);
          }
        } else {
          PP.Diag(Tok.getLocation(), diag::warn_pragma_pack_malformed);
          return;
        }
      }
    }
  } else if (PP.getLangOpts().ApplePragmaPack) {
    // In MSVC/gcc, #pragma pack() resets the alignment without affecting
    // the push/pop stack.
    // In Apple gcc #pragma pack() is equivalent to #pragma pack(pop).
    Action = Sema::PSK_Pop;
  }

  if (Tok.isNot(tok::r_paren)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_rparen) << "pack";
    return;
  }

  SourceLocation RParenLoc = Tok.getLocation();
  PP.Lex(Tok);
  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol) << "pack";
    return;
  }

  PragmaPackInfo *Info =
      PP.getPreprocessorAllocator().Allocate<PragmaPackInfo>(1);
  Info->Action = Action;
  Info->SlotLabel = SlotLabel;
  Info->Alignment = Alignment;

  MutableArrayRef<Token> Toks(PP.getPreprocessorAllocator().Allocate<Token>(1),
                              1);
  Toks[0].startToken();
  Toks[0].setKind(tok::annot_pragma_pack);
  Toks[0].setLocation(PackLoc);
  Toks[0].setAnnotationEndLoc(RParenLoc);
  Toks[0].setAnnotationValue(static_cast<void*>(Info));
  PP.EnterTokenStream(Toks, /*DisableMacroExpansion=*/true);
}

// #pragma ms_struct on
// #pragma ms_struct off
void PragmaMSStructHandler::HandlePragma(Preprocessor &PP, 
                                         PragmaIntroducerKind Introducer,
                                         Token &MSStructTok) {
  PragmaMSStructKind Kind = PMSST_OFF;

  Token Tok;
  PP.Lex(Tok);
  if (Tok.isNot(tok::identifier)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_ms_struct);
    return;
  }
  SourceLocation EndLoc = Tok.getLocation();
  const IdentifierInfo *II = Tok.getIdentifierInfo();
  if (II->isStr("on")) {
    Kind = PMSST_ON;
    PP.Lex(Tok);
  }
  else if (II->isStr("off") || II->isStr("reset"))
    PP.Lex(Tok);
  else {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_ms_struct);
    return;
  }
  
  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
      << "ms_struct";
    return;
  }

  MutableArrayRef<Token> Toks(PP.getPreprocessorAllocator().Allocate<Token>(1),
                              1);
  Toks[0].startToken();
  Toks[0].setKind(tok::annot_pragma_msstruct);
  Toks[0].setLocation(MSStructTok.getLocation());
  Toks[0].setAnnotationEndLoc(EndLoc);
  Toks[0].setAnnotationValue(reinterpret_cast<void*>(
                             static_cast<uintptr_t>(Kind)));
  PP.EnterTokenStream(Toks, /*DisableMacroExpansion=*/true);
}

// #pragma clang section bss="abc" data="" rodata="def" text=""
void PragmaClangSectionHandler::HandlePragma(Preprocessor &PP,
             PragmaIntroducerKind Introducer, Token &FirstToken) {

  Token Tok;
  auto SecKind = Sema::PragmaClangSectionKind::PCSK_Invalid;

  PP.Lex(Tok); // eat 'section'
  while (Tok.isNot(tok::eod)) {
    if (Tok.isNot(tok::identifier)) {
      PP.Diag(Tok.getLocation(), diag::err_pragma_expected_clang_section_name) << "clang section";
      return;
    }

    const IdentifierInfo *SecType = Tok.getIdentifierInfo();
    if (SecType->isStr("bss"))
      SecKind = Sema::PragmaClangSectionKind::PCSK_BSS;
    else if (SecType->isStr("data"))
      SecKind = Sema::PragmaClangSectionKind::PCSK_Data;
    else if (SecType->isStr("rodata"))
      SecKind = Sema::PragmaClangSectionKind::PCSK_Rodata;
    else if (SecType->isStr("text"))
      SecKind = Sema::PragmaClangSectionKind::PCSK_Text;
    else {
      PP.Diag(Tok.getLocation(), diag::err_pragma_expected_clang_section_name) << "clang section";
      return;
    }

    PP.Lex(Tok); // eat ['bss'|'data'|'rodata'|'text']
    if (Tok.isNot(tok::equal)) {
      PP.Diag(Tok.getLocation(), diag::err_pragma_clang_section_expected_equal) << SecKind;
      return;
    }

    std::string SecName;
    if (!PP.LexStringLiteral(Tok, SecName, "pragma clang section", false))
      return;

    Actions.ActOnPragmaClangSection(Tok.getLocation(),
      (SecName.size()? Sema::PragmaClangSectionAction::PCSA_Set :
                       Sema::PragmaClangSectionAction::PCSA_Clear),
       SecKind, SecName);
  }
}

// #pragma 'align' '=' {'native','natural','mac68k','power','reset'}
// #pragma 'options 'align' '=' {'native','natural','mac68k','power','reset'}
static void ParseAlignPragma(Preprocessor &PP, Token &FirstTok,
                             bool IsOptions) {
  Token Tok;

  if (IsOptions) {
    PP.Lex(Tok);
    if (Tok.isNot(tok::identifier) ||
        !Tok.getIdentifierInfo()->isStr("align")) {
      PP.Diag(Tok.getLocation(), diag::warn_pragma_options_expected_align);
      return;
    }
  }

  PP.Lex(Tok);
  if (Tok.isNot(tok::equal)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_align_expected_equal)
      << IsOptions;
    return;
  }

  PP.Lex(Tok);
  if (Tok.isNot(tok::identifier)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_identifier)
      << (IsOptions ? "options" : "align");
    return;
  }

  Sema::PragmaOptionsAlignKind Kind = Sema::POAK_Natural;
  const IdentifierInfo *II = Tok.getIdentifierInfo();
  if (II->isStr("native"))
    Kind = Sema::POAK_Native;
  else if (II->isStr("natural"))
    Kind = Sema::POAK_Natural;
  else if (II->isStr("packed"))
    Kind = Sema::POAK_Packed;
  else if (II->isStr("power"))
    Kind = Sema::POAK_Power;
  else if (II->isStr("mac68k"))
    Kind = Sema::POAK_Mac68k;
  else if (II->isStr("reset"))
    Kind = Sema::POAK_Reset;
  else {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_align_invalid_option)
      << IsOptions;
    return;
  }

  SourceLocation EndLoc = Tok.getLocation();
  PP.Lex(Tok);
  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
      << (IsOptions ? "options" : "align");
    return;
  }

  MutableArrayRef<Token> Toks(PP.getPreprocessorAllocator().Allocate<Token>(1),
                              1);
  Toks[0].startToken();
  Toks[0].setKind(tok::annot_pragma_align);
  Toks[0].setLocation(FirstTok.getLocation());
  Toks[0].setAnnotationEndLoc(EndLoc);
  Toks[0].setAnnotationValue(reinterpret_cast<void*>(
                             static_cast<uintptr_t>(Kind)));
  PP.EnterTokenStream(Toks, /*DisableMacroExpansion=*/true);
}

void PragmaAlignHandler::HandlePragma(Preprocessor &PP, 
                                      PragmaIntroducerKind Introducer,
                                      Token &AlignTok) {
  ParseAlignPragma(PP, AlignTok, /*IsOptions=*/false);
}

void PragmaOptionsHandler::HandlePragma(Preprocessor &PP, 
                                        PragmaIntroducerKind Introducer,
                                        Token &OptionsTok) {
  ParseAlignPragma(PP, OptionsTok, /*IsOptions=*/true);
}

// #pragma unused(identifier)
void PragmaUnusedHandler::HandlePragma(Preprocessor &PP, 
                                       PragmaIntroducerKind Introducer,
                                       Token &UnusedTok) {
  // FIXME: Should we be expanding macros here? My guess is no.
  SourceLocation UnusedLoc = UnusedTok.getLocation();

  // Lex the left '('.
  Token Tok;
  PP.Lex(Tok);
  if (Tok.isNot(tok::l_paren)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_lparen) << "unused";
    return;
  }

  // Lex the declaration reference(s).
  SmallVector<Token, 5> Identifiers;
  SourceLocation RParenLoc;
  bool LexID = true;

  while (true) {
    PP.Lex(Tok);

    if (LexID) {
      if (Tok.is(tok::identifier)) {
        Identifiers.push_back(Tok);
        LexID = false;
        continue;
      }

      // Illegal token!
      PP.Diag(Tok.getLocation(), diag::warn_pragma_unused_expected_var);
      return;
    }

    // We are execting a ')' or a ','.
    if (Tok.is(tok::comma)) {
      LexID = true;
      continue;
    }

    if (Tok.is(tok::r_paren)) {
      RParenLoc = Tok.getLocation();
      break;
    }

    // Illegal token!
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_punc) << "unused";
    return;
  }

  PP.Lex(Tok);
  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol) <<
        "unused";
    return;
  }

  // Verify that we have a location for the right parenthesis.
  assert(RParenLoc.isValid() && "Valid '#pragma unused' must have ')'");
  assert(!Identifiers.empty() && "Valid '#pragma unused' must have arguments");

  // For each identifier token, insert into the token stream a
  // annot_pragma_unused token followed by the identifier token.
  // This allows us to cache a "#pragma unused" that occurs inside an inline
  // C++ member function.

  MutableArrayRef<Token> Toks(
      PP.getPreprocessorAllocator().Allocate<Token>(2 * Identifiers.size()),
      2 * Identifiers.size());
  for (unsigned i=0; i != Identifiers.size(); i++) {
    Token &pragmaUnusedTok = Toks[2*i], &idTok = Toks[2*i+1];
    pragmaUnusedTok.startToken();
    pragmaUnusedTok.setKind(tok::annot_pragma_unused);
    pragmaUnusedTok.setLocation(UnusedLoc);
    idTok = Identifiers[i];
  }
  PP.EnterTokenStream(Toks, /*DisableMacroExpansion=*/true);
}

// #pragma weak identifier
// #pragma weak identifier '=' identifier
void PragmaWeakHandler::HandlePragma(Preprocessor &PP, 
                                     PragmaIntroducerKind Introducer,
                                     Token &WeakTok) {
  SourceLocation WeakLoc = WeakTok.getLocation();

  Token Tok;
  PP.Lex(Tok);
  if (Tok.isNot(tok::identifier)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_identifier) << "weak";
    return;
  }

  Token WeakName = Tok;
  bool HasAlias = false;
  Token AliasName;

  PP.Lex(Tok);
  if (Tok.is(tok::equal)) {
    HasAlias = true;
    PP.Lex(Tok);
    if (Tok.isNot(tok::identifier)) {
      PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_identifier)
          << "weak";
      return;
    }
    AliasName = Tok;
    PP.Lex(Tok);
  }

  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol) << "weak";
    return;
  }

  if (HasAlias) {
    MutableArrayRef<Token> Toks(
        PP.getPreprocessorAllocator().Allocate<Token>(3), 3);
    Token &pragmaUnusedTok = Toks[0];
    pragmaUnusedTok.startToken();
    pragmaUnusedTok.setKind(tok::annot_pragma_weakalias);
    pragmaUnusedTok.setLocation(WeakLoc);
    pragmaUnusedTok.setAnnotationEndLoc(AliasName.getLocation());
    Toks[1] = WeakName;
    Toks[2] = AliasName;
    PP.EnterTokenStream(Toks, /*DisableMacroExpansion=*/true);
  } else {
    MutableArrayRef<Token> Toks(
        PP.getPreprocessorAllocator().Allocate<Token>(2), 2);
    Token &pragmaUnusedTok = Toks[0];
    pragmaUnusedTok.startToken();
    pragmaUnusedTok.setKind(tok::annot_pragma_weak);
    pragmaUnusedTok.setLocation(WeakLoc);
    pragmaUnusedTok.setAnnotationEndLoc(WeakLoc);
    Toks[1] = WeakName;
    PP.EnterTokenStream(Toks, /*DisableMacroExpansion=*/true);
  }
}

// #pragma redefine_extname identifier identifier
void PragmaRedefineExtnameHandler::HandlePragma(Preprocessor &PP, 
                                               PragmaIntroducerKind Introducer,
                                                Token &RedefToken) {
  SourceLocation RedefLoc = RedefToken.getLocation();

  Token Tok;
  PP.Lex(Tok);
  if (Tok.isNot(tok::identifier)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_identifier) <<
      "redefine_extname";
    return;
  }

  Token RedefName = Tok;
  PP.Lex(Tok);

  if (Tok.isNot(tok::identifier)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_identifier)
        << "redefine_extname";
    return;
  }

  Token AliasName = Tok;
  PP.Lex(Tok);

  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol) <<
      "redefine_extname";
    return;
  }

  MutableArrayRef<Token> Toks(PP.getPreprocessorAllocator().Allocate<Token>(3),
                              3);
  Token &pragmaRedefTok = Toks[0];
  pragmaRedefTok.startToken();
  pragmaRedefTok.setKind(tok::annot_pragma_redefine_extname);
  pragmaRedefTok.setLocation(RedefLoc);
  pragmaRedefTok.setAnnotationEndLoc(AliasName.getLocation());
  Toks[1] = RedefName;
  Toks[2] = AliasName;
  PP.EnterTokenStream(Toks, /*DisableMacroExpansion=*/true);
}


void
PragmaFPContractHandler::HandlePragma(Preprocessor &PP, 
                                      PragmaIntroducerKind Introducer,
                                      Token &Tok) {
  tok::OnOffSwitch OOS;
  if (PP.LexOnOffSwitch(OOS))
    return;

  MutableArrayRef<Token> Toks(PP.getPreprocessorAllocator().Allocate<Token>(1),
                              1);
  Toks[0].startToken();
  Toks[0].setKind(tok::annot_pragma_fp_contract);
  Toks[0].setLocation(Tok.getLocation());
  Toks[0].setAnnotationEndLoc(Tok.getLocation());
  Toks[0].setAnnotationValue(reinterpret_cast<void*>(
                             static_cast<uintptr_t>(OOS)));
  PP.EnterTokenStream(Toks, /*DisableMacroExpansion=*/true);
}

void 
PragmaOpenCLExtensionHandler::HandlePragma(Preprocessor &PP, 
                                           PragmaIntroducerKind Introducer,
                                           Token &Tok) {
  PP.LexUnexpandedToken(Tok);
  if (Tok.isNot(tok::identifier)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_identifier) <<
      "OPENCL";
    return;
  }
  IdentifierInfo *Ext = Tok.getIdentifierInfo();
  SourceLocation NameLoc = Tok.getLocation();

  PP.Lex(Tok);
  if (Tok.isNot(tok::colon)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_colon) << Ext;
    return;
  }

  PP.Lex(Tok);
  if (Tok.isNot(tok::identifier)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_predicate) << 0;
    return;
  }
  IdentifierInfo *Pred = Tok.getIdentifierInfo();

  OpenCLExtState State;
  if (Pred->isStr("enable")) {
    State = Enable;
  } else if (Pred->isStr("disable")) {
    State = Disable;
  } else if (Pred->isStr("begin"))
    State = Begin;
  else if (Pred->isStr("end"))
    State = End;
  else {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_predicate)
      << Ext->isStr("all");
    return;
  }
  SourceLocation StateLoc = Tok.getLocation();

  PP.Lex(Tok);
  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol) <<
      "OPENCL EXTENSION";
    return;
  }

  auto Info = PP.getPreprocessorAllocator().Allocate<OpenCLExtData>(1);
  Info->first = Ext;
  Info->second = State;
  MutableArrayRef<Token> Toks(PP.getPreprocessorAllocator().Allocate<Token>(1),
                              1);
  Toks[0].startToken();
  Toks[0].setKind(tok::annot_pragma_opencl_extension);
  Toks[0].setLocation(NameLoc);
  Toks[0].setAnnotationValue(static_cast<void*>(Info));
  Toks[0].setAnnotationEndLoc(StateLoc);
  PP.EnterTokenStream(Toks, /*DisableMacroExpansion=*/true);

  if (PP.getPPCallbacks())
    PP.getPPCallbacks()->PragmaOpenCLExtension(NameLoc, Ext, 
                                               StateLoc, State);
}

/// \brief Handle '#pragma omp ...' when OpenMP is disabled.
///
void
PragmaNoOpenMPHandler::HandlePragma(Preprocessor &PP,
                                    PragmaIntroducerKind Introducer,
                                    Token &FirstTok) {
  if (!PP.getDiagnostics().isIgnored(diag::warn_pragma_omp_ignored,
                                     FirstTok.getLocation())) {
    PP.Diag(FirstTok, diag::warn_pragma_omp_ignored);
    PP.getDiagnostics().setSeverity(diag::warn_pragma_omp_ignored,
                                    diag::Severity::Ignored, SourceLocation());
  }
  PP.DiscardUntilEndOfDirective();
}

/// \brief Handle '#pragma omp ...' when OpenMP is enabled.
///
void
PragmaOpenMPHandler::HandlePragma(Preprocessor &PP,
                                  PragmaIntroducerKind Introducer,
                                  Token &FirstTok) {
  SmallVector<Token, 16> Pragma;
  Token Tok;
  Tok.startToken();
  Tok.setKind(tok::annot_pragma_openmp);
  Tok.setLocation(FirstTok.getLocation());

  while (Tok.isNot(tok::eod)) {
    Pragma.push_back(Tok);
    PP.Lex(Tok);
  }
  SourceLocation EodLoc = Tok.getLocation();
  Tok.startToken();
  Tok.setKind(tok::annot_pragma_openmp_end);
  Tok.setLocation(EodLoc);
  Pragma.push_back(Tok);

  auto Toks = llvm::make_unique<Token[]>(Pragma.size());
  std::copy(Pragma.begin(), Pragma.end(), Toks.get());
  PP.EnterTokenStream(std::move(Toks), Pragma.size(),
                      /*DisableMacroExpansion=*/false);
}

/// \brief Handle '#pragma pointers_to_members'
// The grammar for this pragma is as follows:
//
// <inheritance model> ::= ('single' | 'multiple' | 'virtual') '_inheritance'
//
// #pragma pointers_to_members '(' 'best_case' ')'
// #pragma pointers_to_members '(' 'full_generality' [',' inheritance-model] ')'
// #pragma pointers_to_members '(' inheritance-model ')'
void PragmaMSPointersToMembers::HandlePragma(Preprocessor &PP,
                                             PragmaIntroducerKind Introducer,
                                             Token &Tok) {
  SourceLocation PointersToMembersLoc = Tok.getLocation();
  PP.Lex(Tok);
  if (Tok.isNot(tok::l_paren)) {
    PP.Diag(PointersToMembersLoc, diag::warn_pragma_expected_lparen)
      << "pointers_to_members";
    return;
  }
  PP.Lex(Tok);
  const IdentifierInfo *Arg = Tok.getIdentifierInfo();
  if (!Arg) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_identifier)
      << "pointers_to_members";
    return;
  }
  PP.Lex(Tok);

  LangOptions::PragmaMSPointersToMembersKind RepresentationMethod;
  if (Arg->isStr("best_case")) {
    RepresentationMethod = LangOptions::PPTMK_BestCase;
  } else {
    if (Arg->isStr("full_generality")) {
      if (Tok.is(tok::comma)) {
        PP.Lex(Tok);

        Arg = Tok.getIdentifierInfo();
        if (!Arg) {
          PP.Diag(Tok.getLocation(),
                  diag::err_pragma_pointers_to_members_unknown_kind)
              << Tok.getKind() << /*OnlyInheritanceModels*/ 0;
          return;
        }
        PP.Lex(Tok);
      } else if (Tok.is(tok::r_paren)) {
        // #pragma pointers_to_members(full_generality) implicitly specifies
        // virtual_inheritance.
        Arg = nullptr;
        RepresentationMethod = LangOptions::PPTMK_FullGeneralityVirtualInheritance;
      } else {
        PP.Diag(Tok.getLocation(), diag::err_expected_punc)
            << "full_generality";
        return;
      }
    }

    if (Arg) {
      if (Arg->isStr("single_inheritance")) {
        RepresentationMethod =
            LangOptions::PPTMK_FullGeneralitySingleInheritance;
      } else if (Arg->isStr("multiple_inheritance")) {
        RepresentationMethod =
            LangOptions::PPTMK_FullGeneralityMultipleInheritance;
      } else if (Arg->isStr("virtual_inheritance")) {
        RepresentationMethod =
            LangOptions::PPTMK_FullGeneralityVirtualInheritance;
      } else {
        PP.Diag(Tok.getLocation(),
                diag::err_pragma_pointers_to_members_unknown_kind)
            << Arg << /*HasPointerDeclaration*/ 1;
        return;
      }
    }
  }

  if (Tok.isNot(tok::r_paren)) {
    PP.Diag(Tok.getLocation(), diag::err_expected_rparen_after)
        << (Arg ? Arg->getName() : "full_generality");
    return;
  }

  SourceLocation EndLoc = Tok.getLocation();
  PP.Lex(Tok);
  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
      << "pointers_to_members";
    return;
  }

  Token AnnotTok;
  AnnotTok.startToken();
  AnnotTok.setKind(tok::annot_pragma_ms_pointers_to_members);
  AnnotTok.setLocation(PointersToMembersLoc);
  AnnotTok.setAnnotationEndLoc(EndLoc);
  AnnotTok.setAnnotationValue(
      reinterpret_cast<void *>(static_cast<uintptr_t>(RepresentationMethod)));
  PP.EnterToken(AnnotTok);
}

/// \brief Handle '#pragma vtordisp'
// The grammar for this pragma is as follows:
//
// <vtordisp-mode> ::= ('off' | 'on' | '0' | '1' | '2' )
//
// #pragma vtordisp '(' ['push' ','] vtordisp-mode ')'
// #pragma vtordisp '(' 'pop' ')'
// #pragma vtordisp '(' ')'
void PragmaMSVtorDisp::HandlePragma(Preprocessor &PP,
                                    PragmaIntroducerKind Introducer,
                                    Token &Tok) {
  SourceLocation VtorDispLoc = Tok.getLocation();
  PP.Lex(Tok);
  if (Tok.isNot(tok::l_paren)) {
    PP.Diag(VtorDispLoc, diag::warn_pragma_expected_lparen) << "vtordisp";
    return;
  }
  PP.Lex(Tok);

  Sema::PragmaMsStackAction Action = Sema::PSK_Set;
  const IdentifierInfo *II = Tok.getIdentifierInfo();
  if (II) {
    if (II->isStr("push")) {
      // #pragma vtordisp(push, mode)
      PP.Lex(Tok);
      if (Tok.isNot(tok::comma)) {
        PP.Diag(VtorDispLoc, diag::warn_pragma_expected_punc) << "vtordisp";
        return;
      }
      PP.Lex(Tok);
      Action = Sema::PSK_Push_Set;
      // not push, could be on/off
    } else if (II->isStr("pop")) {
      // #pragma vtordisp(pop)
      PP.Lex(Tok);
      Action = Sema::PSK_Pop;
    }
    // not push or pop, could be on/off
  } else {
    if (Tok.is(tok::r_paren)) {
      // #pragma vtordisp()
      Action = Sema::PSK_Reset;
    }
  }


  uint64_t Value = 0;
  if (Action & Sema::PSK_Push || Action & Sema::PSK_Set) {
    const IdentifierInfo *II = Tok.getIdentifierInfo();
    if (II && II->isStr("off")) {
      PP.Lex(Tok);
      Value = 0;
    } else if (II && II->isStr("on")) {
      PP.Lex(Tok);
      Value = 1;
    } else if (Tok.is(tok::numeric_constant) &&
               PP.parseSimpleIntegerLiteral(Tok, Value)) {
      if (Value > 2) {
        PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_integer)
            << 0 << 2 << "vtordisp";
        return;
      }
    } else {
      PP.Diag(Tok.getLocation(), diag::warn_pragma_invalid_action)
          << "vtordisp";
      return;
    }
  }

  // Finish the pragma: ')' $
  if (Tok.isNot(tok::r_paren)) {
    PP.Diag(VtorDispLoc, diag::warn_pragma_expected_rparen) << "vtordisp";
    return;
  }
  SourceLocation EndLoc = Tok.getLocation();
  PP.Lex(Tok);
  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
        << "vtordisp";
    return;
  }

  // Enter the annotation.
  Token AnnotTok;
  AnnotTok.startToken();
  AnnotTok.setKind(tok::annot_pragma_ms_vtordisp);
  AnnotTok.setLocation(VtorDispLoc);
  AnnotTok.setAnnotationEndLoc(EndLoc);
  AnnotTok.setAnnotationValue(reinterpret_cast<void *>(
      static_cast<uintptr_t>((Action << 16) | (Value & 0xFFFF))));
  PP.EnterToken(AnnotTok);
}

/// \brief Handle all MS pragmas.  Simply forwards the tokens after inserting
/// an annotation token.
void PragmaMSPragma::HandlePragma(Preprocessor &PP,
                                  PragmaIntroducerKind Introducer,
                                  Token &Tok) {
  Token EoF, AnnotTok;
  EoF.startToken();
  EoF.setKind(tok::eof);
  AnnotTok.startToken();
  AnnotTok.setKind(tok::annot_pragma_ms_pragma);
  AnnotTok.setLocation(Tok.getLocation());
  AnnotTok.setAnnotationEndLoc(Tok.getLocation());
  SmallVector<Token, 8> TokenVector;
  // Suck up all of the tokens before the eod.
  for (; Tok.isNot(tok::eod); PP.Lex(Tok)) {
    TokenVector.push_back(Tok);
    AnnotTok.setAnnotationEndLoc(Tok.getLocation());
  }
  // Add a sentinal EoF token to the end of the list.
  TokenVector.push_back(EoF);
  // We must allocate this array with new because EnterTokenStream is going to
  // delete it later.
  auto TokenArray = llvm::make_unique<Token[]>(TokenVector.size());
  std::copy(TokenVector.begin(), TokenVector.end(), TokenArray.get());
  auto Value = new (PP.getPreprocessorAllocator())
      std::pair<std::unique_ptr<Token[]>, size_t>(std::move(TokenArray),
                                                  TokenVector.size());
  AnnotTok.setAnnotationValue(Value);
  PP.EnterToken(AnnotTok);
}

/// \brief Handle the Microsoft \#pragma detect_mismatch extension.
///
/// The syntax is:
/// \code
///   #pragma detect_mismatch("name", "value")
/// \endcode
/// Where 'name' and 'value' are quoted strings.  The values are embedded in
/// the object file and passed along to the linker.  If the linker detects a
/// mismatch in the object file's values for the given name, a LNK2038 error
/// is emitted.  See MSDN for more details.
void PragmaDetectMismatchHandler::HandlePragma(Preprocessor &PP,
                                               PragmaIntroducerKind Introducer,
                                               Token &Tok) {
  SourceLocation DetectMismatchLoc = Tok.getLocation();
  PP.Lex(Tok);
  if (Tok.isNot(tok::l_paren)) {
    PP.Diag(DetectMismatchLoc, diag::err_expected) << tok::l_paren;
    return;
  }

  // Read the name to embed, which must be a string literal.
  std::string NameString;
  if (!PP.LexStringLiteral(Tok, NameString,
                           "pragma detect_mismatch",
                           /*MacroExpansion=*/true))
    return;

  // Read the comma followed by a second string literal.
  std::string ValueString;
  if (Tok.isNot(tok::comma)) {
    PP.Diag(Tok.getLocation(), diag::err_pragma_detect_mismatch_malformed);
    return;
  }

  if (!PP.LexStringLiteral(Tok, ValueString, "pragma detect_mismatch",
                           /*MacroExpansion=*/true))
    return;

  if (Tok.isNot(tok::r_paren)) {
    PP.Diag(Tok.getLocation(), diag::err_expected) << tok::r_paren;
    return;
  }
  PP.Lex(Tok);  // Eat the r_paren.

  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::err_pragma_detect_mismatch_malformed);
    return;
  }

  // If the pragma is lexically sound, notify any interested PPCallbacks.
  if (PP.getPPCallbacks())
    PP.getPPCallbacks()->PragmaDetectMismatch(DetectMismatchLoc, NameString,
                                              ValueString);

  Actions.ActOnPragmaDetectMismatch(DetectMismatchLoc, NameString, ValueString);
}

/// \brief Handle the microsoft \#pragma comment extension.
///
/// The syntax is:
/// \code
///   #pragma comment(linker, "foo")
/// \endcode
/// 'linker' is one of five identifiers: compiler, exestr, lib, linker, user.
/// "foo" is a string, which is fully macro expanded, and permits string
/// concatenation, embedded escape characters etc.  See MSDN for more details.
void PragmaCommentHandler::HandlePragma(Preprocessor &PP,
                                        PragmaIntroducerKind Introducer,
                                        Token &Tok) {
  SourceLocation CommentLoc = Tok.getLocation();
  PP.Lex(Tok);
  if (Tok.isNot(tok::l_paren)) {
    PP.Diag(CommentLoc, diag::err_pragma_comment_malformed);
    return;
  }

  // Read the identifier.
  PP.Lex(Tok);
  if (Tok.isNot(tok::identifier)) {
    PP.Diag(CommentLoc, diag::err_pragma_comment_malformed);
    return;
  }

  // Verify that this is one of the 5 whitelisted options.
  IdentifierInfo *II = Tok.getIdentifierInfo();
  PragmaMSCommentKind Kind =
    llvm::StringSwitch<PragmaMSCommentKind>(II->getName())
    .Case("linker",   PCK_Linker)
    .Case("lib",      PCK_Lib)
    .Case("compiler", PCK_Compiler)
    .Case("exestr",   PCK_ExeStr)
    .Case("user",     PCK_User)
    .Default(PCK_Unknown);
  if (Kind == PCK_Unknown) {
    PP.Diag(Tok.getLocation(), diag::err_pragma_comment_unknown_kind);
    return;
  }

  // On PS4, issue a warning about any pragma comments other than
  // #pragma comment lib.
  if (PP.getTargetInfo().getTriple().isPS4() && Kind != PCK_Lib) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_comment_ignored)
      << II->getName();
    return;
  }

  // Read the optional string if present.
  PP.Lex(Tok);
  std::string ArgumentString;
  if (Tok.is(tok::comma) && !PP.LexStringLiteral(Tok, ArgumentString,
                                                 "pragma comment",
                                                 /*MacroExpansion=*/true))
    return;

  // FIXME: warn that 'exestr' is deprecated.
  // FIXME: If the kind is "compiler" warn if the string is present (it is
  // ignored).
  // The MSDN docs say that "lib" and "linker" require a string and have a short
  // whitelist of linker options they support, but in practice MSVC doesn't
  // issue a diagnostic.  Therefore neither does clang.

  if (Tok.isNot(tok::r_paren)) {
    PP.Diag(Tok.getLocation(), diag::err_pragma_comment_malformed);
    return;
  }
  PP.Lex(Tok);  // eat the r_paren.

  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::err_pragma_comment_malformed);
    return;
  }

  // If the pragma is lexically sound, notify any interested PPCallbacks.
  if (PP.getPPCallbacks())
    PP.getPPCallbacks()->PragmaComment(CommentLoc, II, ArgumentString);

  Actions.ActOnPragmaMSComment(CommentLoc, Kind, ArgumentString);
}

// #pragma clang optimize off
// #pragma clang optimize on
void PragmaOptimizeHandler::HandlePragma(Preprocessor &PP, 
                                        PragmaIntroducerKind Introducer,
                                        Token &FirstToken) {
  Token Tok;
  PP.Lex(Tok);
  if (Tok.is(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::err_pragma_missing_argument)
        << "clang optimize" << /*Expected=*/true << "'on' or 'off'";
    return;
  }
  if (Tok.isNot(tok::identifier)) {
    PP.Diag(Tok.getLocation(), diag::err_pragma_optimize_invalid_argument)
      << PP.getSpelling(Tok);
    return;
  }
  const IdentifierInfo *II = Tok.getIdentifierInfo();
  // The only accepted values are 'on' or 'off'.
  bool IsOn = false;
  if (II->isStr("on")) {
    IsOn = true;
  } else if (!II->isStr("off")) {
    PP.Diag(Tok.getLocation(), diag::err_pragma_optimize_invalid_argument)
      << PP.getSpelling(Tok);
    return;
  }
  PP.Lex(Tok);
  
  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::err_pragma_optimize_extra_argument)
      << PP.getSpelling(Tok);
    return;
  }

  Actions.ActOnPragmaOptimize(IsOn, FirstToken.getLocation());
}

namespace {
/// Used as the annotation value for tok::annot_pragma_fp.
struct TokFPAnnotValue {
  enum FlagKinds { Contract };
  enum FlagValues { On, Off, Fast };

  FlagKinds FlagKind;
  FlagValues FlagValue;
};
} // end anonymous namespace

void PragmaFPHandler::HandlePragma(Preprocessor &PP,
                                   PragmaIntroducerKind Introducer,
                                   Token &Tok) {
  // fp
  Token PragmaName = Tok;
  SmallVector<Token, 1> TokenList;

  PP.Lex(Tok);
  if (Tok.isNot(tok::identifier)) {
    PP.Diag(Tok.getLocation(), diag::err_pragma_fp_invalid_option)
        << /*MissingOption=*/true << "";
    return;
  }

  while (Tok.is(tok::identifier)) {
    IdentifierInfo *OptionInfo = Tok.getIdentifierInfo();

    auto FlagKind =
        llvm::StringSwitch<llvm::Optional<TokFPAnnotValue::FlagKinds>>(
            OptionInfo->getName())
            .Case("contract", TokFPAnnotValue::Contract)
            .Default(None);
    if (!FlagKind) {
      PP.Diag(Tok.getLocation(), diag::err_pragma_fp_invalid_option)
          << /*MissingOption=*/false << OptionInfo;
      return;
    }
    PP.Lex(Tok);

    // Read '('
    if (Tok.isNot(tok::l_paren)) {
      PP.Diag(Tok.getLocation(), diag::err_expected) << tok::l_paren;
      return;
    }
    PP.Lex(Tok);

    if (Tok.isNot(tok::identifier)) {
      PP.Diag(Tok.getLocation(), diag::err_pragma_fp_invalid_argument)
          << PP.getSpelling(Tok) << OptionInfo->getName();
      return;
    }
    const IdentifierInfo *II = Tok.getIdentifierInfo();

    auto FlagValue =
        llvm::StringSwitch<llvm::Optional<TokFPAnnotValue::FlagValues>>(
            II->getName())
            .Case("on", TokFPAnnotValue::On)
            .Case("off", TokFPAnnotValue::Off)
            .Case("fast", TokFPAnnotValue::Fast)
            .Default(llvm::None);

    if (!FlagValue) {
      PP.Diag(Tok.getLocation(), diag::err_pragma_fp_invalid_argument)
          << PP.getSpelling(Tok) << OptionInfo->getName();
      return;
    }
    PP.Lex(Tok);

    // Read ')'
    if (Tok.isNot(tok::r_paren)) {
      PP.Diag(Tok.getLocation(), diag::err_expected) << tok::r_paren;
      return;
    }
    PP.Lex(Tok);

    auto *AnnotValue = new (PP.getPreprocessorAllocator())
        TokFPAnnotValue{*FlagKind, *FlagValue};
    // Generate the loop hint token.
    Token FPTok;
    FPTok.startToken();
    FPTok.setKind(tok::annot_pragma_fp);
    FPTok.setLocation(PragmaName.getLocation());
    FPTok.setAnnotationEndLoc(PragmaName.getLocation());
    FPTok.setAnnotationValue(reinterpret_cast<void *>(AnnotValue));
    TokenList.push_back(FPTok);
  }

  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
        << "clang fp";
    return;
  }

  auto TokenArray = llvm::make_unique<Token[]>(TokenList.size());
  std::copy(TokenList.begin(), TokenList.end(), TokenArray.get());

  PP.EnterTokenStream(std::move(TokenArray), TokenList.size(),
                      /*DisableMacroExpansion=*/false);
}

void Parser::HandlePragmaFP() {
  assert(Tok.is(tok::annot_pragma_fp));
  auto *AnnotValue =
      reinterpret_cast<TokFPAnnotValue *>(Tok.getAnnotationValue());

  LangOptions::FPContractModeKind FPC;
  switch (AnnotValue->FlagValue) {
  case TokFPAnnotValue::On:
    FPC = LangOptions::FPC_On;
    break;
  case TokFPAnnotValue::Fast:
    FPC = LangOptions::FPC_Fast;
    break;
  case TokFPAnnotValue::Off:
    FPC = LangOptions::FPC_Off;
    break;
  }

  Actions.ActOnPragmaFPContract(FPC);
  ConsumeAnnotationToken();
}

/// \brief Parses loop or unroll pragma hint value and fills in Info.
static bool ParseLoopHintValue(Preprocessor &PP, Token &Tok, Token PragmaName,
                               Token Option, bool ValueInParens,
                               PragmaLoopHintInfo &Info) {
  SmallVector<Token, 1> ValueList;
  int OpenParens = ValueInParens ? 1 : 0;
  // Read constant expression.
  while (Tok.isNot(tok::eod)) {
    if (Tok.is(tok::l_paren))
      OpenParens++;
    else if (Tok.is(tok::r_paren)) {
      OpenParens--;
      if (OpenParens == 0 && ValueInParens)
        break;
    }

    ValueList.push_back(Tok);
    PP.Lex(Tok);
  }

  if (ValueInParens) {
    // Read ')'
    if (Tok.isNot(tok::r_paren)) {
      PP.Diag(Tok.getLocation(), diag::err_expected) << tok::r_paren;
      return true;
    }
    PP.Lex(Tok);
  }

  Token EOFTok;
  EOFTok.startToken();
  EOFTok.setKind(tok::eof);
  EOFTok.setLocation(Tok.getLocation());
  ValueList.push_back(EOFTok); // Terminates expression for parsing.

  Info.Toks = llvm::makeArrayRef(ValueList).copy(PP.getPreprocessorAllocator());

  Info.PragmaName = PragmaName;
  Info.Option = Option;
  return false;
}

/// \brief Handle the \#pragma clang loop directive.
///  #pragma clang 'loop' loop-hints
///
///  loop-hints:
///    loop-hint loop-hints[opt]
///
///  loop-hint:
///    'vectorize' '(' loop-hint-keyword ')'
///    'interleave' '(' loop-hint-keyword ')'
///    'unroll' '(' unroll-hint-keyword ')'
///    'vectorize_width' '(' loop-hint-value ')'
///    'interleave_count' '(' loop-hint-value ')'
///    'unroll_count' '(' loop-hint-value ')'
///
///  loop-hint-keyword:
///    'enable'
///    'disable'
///    'assume_safety'
///
///  unroll-hint-keyword:
///    'enable'
///    'disable'
///    'full'
///
///  loop-hint-value:
///    constant-expression
///
/// Specifying vectorize(enable) or vectorize_width(_value_) instructs llvm to
/// try vectorizing the instructions of the loop it precedes. Specifying
/// interleave(enable) or interleave_count(_value_) instructs llvm to try
/// interleaving multiple iterations of the loop it precedes. The width of the
/// vector instructions is specified by vectorize_width() and the number of
/// interleaved loop iterations is specified by interleave_count(). Specifying a
/// value of 1 effectively disables vectorization/interleaving, even if it is
/// possible and profitable, and 0 is invalid. The loop vectorizer currently
/// only works on inner loops.
///
/// The unroll and unroll_count directives control the concatenation
/// unroller. Specifying unroll(enable) instructs llvm to unroll the loop
/// completely if the trip count is known at compile time and unroll partially
/// if the trip count is not known.  Specifying unroll(full) is similar to
/// unroll(enable) but will unroll the loop only if the trip count is known at
/// compile time.  Specifying unroll(disable) disables unrolling for the
/// loop. Specifying unroll_count(_value_) instructs llvm to try to unroll the
/// loop the number of times indicated by the value.
void PragmaLoopHintHandler::HandlePragma(Preprocessor &PP,
                                         PragmaIntroducerKind Introducer,
                                         Token &Tok) {
  // Incoming token is "loop" from "#pragma clang loop".
  Token PragmaName = Tok;
  SmallVector<Token, 1> TokenList;

  // Lex the optimization option and verify it is an identifier.
  PP.Lex(Tok);
  if (Tok.isNot(tok::identifier)) {
    PP.Diag(Tok.getLocation(), diag::err_pragma_loop_invalid_option)
        << /*MissingOption=*/true << "";
    return;
  }

  while (Tok.is(tok::identifier)) {
    Token Option = Tok;
    IdentifierInfo *OptionInfo = Tok.getIdentifierInfo();

    bool OptionValid = llvm::StringSwitch<bool>(OptionInfo->getName())
                           .Case("vectorize", true)
                           .Case("interleave", true)
                           .Case("unroll", true)
                           .Case("distribute", true)
                           .Case("vectorize_width", true)
                           .Case("interleave_count", true)
                           .Case("unroll_count", true)
                           .Default(false);
    if (!OptionValid) {
      PP.Diag(Tok.getLocation(), diag::err_pragma_loop_invalid_option)
          << /*MissingOption=*/false << OptionInfo;
      return;
    }
    PP.Lex(Tok);

    // Read '('
    if (Tok.isNot(tok::l_paren)) {
      PP.Diag(Tok.getLocation(), diag::err_expected) << tok::l_paren;
      return;
    }
    PP.Lex(Tok);

    auto *Info = new (PP.getPreprocessorAllocator()) PragmaLoopHintInfo;
    if (ParseLoopHintValue(PP, Tok, PragmaName, Option, /*ValueInParens=*/true,
                           *Info))
      return;

    // Generate the loop hint token.
    Token LoopHintTok;
    LoopHintTok.startToken();
    LoopHintTok.setKind(tok::annot_pragma_loop_hint);
    LoopHintTok.setLocation(PragmaName.getLocation());
    LoopHintTok.setAnnotationEndLoc(PragmaName.getLocation());
    LoopHintTok.setAnnotationValue(static_cast<void *>(Info));
    TokenList.push_back(LoopHintTok);
  }

  if (Tok.isNot(tok::eod)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
        << "clang loop";
    return;
  }

  auto TokenArray = llvm::make_unique<Token[]>(TokenList.size());
  std::copy(TokenList.begin(), TokenList.end(), TokenArray.get());

  PP.EnterTokenStream(std::move(TokenArray), TokenList.size(),
                      /*DisableMacroExpansion=*/false);
}

/// \brief Handle the loop unroll optimization pragmas.
///  #pragma unroll
///  #pragma unroll unroll-hint-value
///  #pragma unroll '(' unroll-hint-value ')'
///  #pragma nounroll
///
///  unroll-hint-value:
///    constant-expression
///
/// Loop unrolling hints can be specified with '#pragma unroll' or
/// '#pragma nounroll'. '#pragma unroll' can take a numeric argument optionally
/// contained in parentheses. With no argument the directive instructs llvm to
/// try to unroll the loop completely. A positive integer argument can be
/// specified to indicate the number of times the loop should be unrolled.  To
/// maximize compatibility with other compilers the unroll count argument can be
/// specified with or without parentheses.  Specifying, '#pragma nounroll'
/// disables unrolling of the loop.
void PragmaUnrollHintHandler::HandlePragma(Preprocessor &PP,
                                           PragmaIntroducerKind Introducer,
                                           Token &Tok) {
  // Incoming token is "unroll" for "#pragma unroll", or "nounroll" for
  // "#pragma nounroll".
  Token PragmaName = Tok;
  PP.Lex(Tok);
  auto *Info = new (PP.getPreprocessorAllocator()) PragmaLoopHintInfo;
  if (Tok.is(tok::eod)) {
    // nounroll or unroll pragma without an argument.
    Info->PragmaName = PragmaName;
    Info->Option.startToken();
  } else if (PragmaName.getIdentifierInfo()->getName() == "nounroll") {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
        << "nounroll";
    return;
  } else {
    // Unroll pragma with an argument: "#pragma unroll N" or
    // "#pragma unroll(N)".
    // Read '(' if it exists.
    bool ValueInParens = Tok.is(tok::l_paren);
    if (ValueInParens)
      PP.Lex(Tok);

    Token Option;
    Option.startToken();
    if (ParseLoopHintValue(PP, Tok, PragmaName, Option, ValueInParens, *Info))
      return;

    // In CUDA, the argument to '#pragma unroll' should not be contained in
    // parentheses.
    if (PP.getLangOpts().CUDA && ValueInParens)
      PP.Diag(Info->Toks[0].getLocation(),
              diag::warn_pragma_unroll_cuda_value_in_parens);

    if (Tok.isNot(tok::eod)) {
      PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
          << "unroll";
      return;
    }
  }

  // Generate the hint token.
  auto TokenArray = llvm::make_unique<Token[]>(1);
  TokenArray[0].startToken();
  TokenArray[0].setKind(tok::annot_pragma_loop_hint);
  TokenArray[0].setLocation(PragmaName.getLocation());
  TokenArray[0].setAnnotationEndLoc(PragmaName.getLocation());
  TokenArray[0].setAnnotationValue(static_cast<void *>(Info));
  PP.EnterTokenStream(std::move(TokenArray), 1,
                      /*DisableMacroExpansion=*/false);
}

/// \brief Handle the Microsoft \#pragma intrinsic extension.
///
/// The syntax is:
/// \code
///  #pragma intrinsic(memset)
///  #pragma intrinsic(strlen, memcpy)
/// \endcode
///
/// Pragma intrisic tells the compiler to use a builtin version of the
/// function. Clang does it anyway, so the pragma doesn't really do anything.
/// Anyway, we emit a warning if the function specified in \#pragma intrinsic
/// isn't an intrinsic in clang and suggest to include intrin.h.
void PragmaMSIntrinsicHandler::HandlePragma(Preprocessor &PP,
                                            PragmaIntroducerKind Introducer,
                                            Token &Tok) {
  PP.Lex(Tok);

  if (Tok.isNot(tok::l_paren)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_lparen)
        << "intrinsic";
    return;
  }
  PP.Lex(Tok);

  bool SuggestIntrinH = !PP.isMacroDefined("__INTRIN_H");

  while (Tok.is(tok::identifier)) {
    IdentifierInfo *II = Tok.getIdentifierInfo();
    if (!II->getBuiltinID())
      PP.Diag(Tok.getLocation(), diag::warn_pragma_intrinsic_builtin)
          << II << SuggestIntrinH;

    PP.Lex(Tok);
    if (Tok.isNot(tok::comma))
      break;
    PP.Lex(Tok);
  }

  if (Tok.isNot(tok::r_paren)) {
    PP.Diag(Tok.getLocation(), diag::warn_pragma_expected_rparen)
        << "intrinsic";
    return;
  }
  PP.Lex(Tok);

  if (Tok.isNot(tok::eod))
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
        << "intrinsic";
}
void PragmaForceCUDAHostDeviceHandler::HandlePragma(
    Preprocessor &PP, PragmaIntroducerKind Introducer, Token &Tok) {
  Token FirstTok = Tok;

  PP.Lex(Tok);
  IdentifierInfo *Info = Tok.getIdentifierInfo();
  if (!Info || (!Info->isStr("begin") && !Info->isStr("end"))) {
    PP.Diag(FirstTok.getLocation(),
            diag::warn_pragma_force_cuda_host_device_bad_arg);
    return;
  }

  if (Info->isStr("begin"))
    Actions.PushForceCUDAHostDevice();
  else if (!Actions.PopForceCUDAHostDevice())
    PP.Diag(FirstTok.getLocation(),
            diag::err_pragma_cannot_end_force_cuda_host_device);

  PP.Lex(Tok);
  if (!Tok.is(tok::eod))
    PP.Diag(FirstTok.getLocation(),
            diag::warn_pragma_force_cuda_host_device_bad_arg);
}

/// \brief Handle the #pragma clang attribute directive.
///
/// The syntax is:
/// \code
///  #pragma clang attribute push(attribute, subject-set)
///  #pragma clang attribute pop
/// \endcode
///
/// The subject-set clause defines the set of declarations which receive the
/// attribute. Its exact syntax is described in the LanguageExtensions document
/// in Clang's documentation.
///
/// This directive instructs the compiler to begin/finish applying the specified
/// attribute to the set of attribute-specific declarations in the active range
/// of the pragma.
void PragmaAttributeHandler::HandlePragma(Preprocessor &PP,
                                          PragmaIntroducerKind Introducer,
                                          Token &FirstToken) {
  Token Tok;
  PP.Lex(Tok);
  auto *Info = new (PP.getPreprocessorAllocator())
      PragmaAttributeInfo(AttributesForPragmaAttribute);

  // Parse the 'push' or 'pop'.
  if (Tok.isNot(tok::identifier)) {
    PP.Diag(Tok.getLocation(), diag::err_pragma_attribute_expected_push_pop);
    return;
  }
  const auto *II = Tok.getIdentifierInfo();
  if (II->isStr("push"))
    Info->Action = PragmaAttributeInfo::Push;
  else if (II->isStr("pop"))
    Info->Action = PragmaAttributeInfo::Pop;
  else {
    PP.Diag(Tok.getLocation(), diag::err_pragma_attribute_invalid_argument)
        << PP.getSpelling(Tok);
    return;
  }
  PP.Lex(Tok);

  // Parse the actual attribute.
  if (Info->Action == PragmaAttributeInfo::Push) {
    if (Tok.isNot(tok::l_paren)) {
      PP.Diag(Tok.getLocation(), diag::err_expected) << tok::l_paren;
      return;
    }
    PP.Lex(Tok);

    // Lex the attribute tokens.
    SmallVector<Token, 16> AttributeTokens;
    int OpenParens = 1;
    while (Tok.isNot(tok::eod)) {
      if (Tok.is(tok::l_paren))
        OpenParens++;
      else if (Tok.is(tok::r_paren)) {
        OpenParens--;
        if (OpenParens == 0)
          break;
      }

      AttributeTokens.push_back(Tok);
      PP.Lex(Tok);
    }

    if (AttributeTokens.empty()) {
      PP.Diag(Tok.getLocation(), diag::err_pragma_attribute_expected_attribute);
      return;
    }
    if (Tok.isNot(tok::r_paren)) {
      PP.Diag(Tok.getLocation(), diag::err_expected) << tok::r_paren;
      return;
    }
    SourceLocation EndLoc = Tok.getLocation();
    PP.Lex(Tok);

    // Terminate the attribute for parsing.
    Token EOFTok;
    EOFTok.startToken();
    EOFTok.setKind(tok::eof);
    EOFTok.setLocation(EndLoc);
    AttributeTokens.push_back(EOFTok);

    Info->Tokens =
        llvm::makeArrayRef(AttributeTokens).copy(PP.getPreprocessorAllocator());
  }

  if (Tok.isNot(tok::eod))
    PP.Diag(Tok.getLocation(), diag::warn_pragma_extra_tokens_at_eol)
        << "clang attribute";

  // Generate the annotated pragma token.
  auto TokenArray = llvm::make_unique<Token[]>(1);
  TokenArray[0].startToken();
  TokenArray[0].setKind(tok::annot_pragma_attribute);
  TokenArray[0].setLocation(FirstToken.getLocation());
  TokenArray[0].setAnnotationEndLoc(FirstToken.getLocation());
  TokenArray[0].setAnnotationValue(static_cast<void *>(Info));
  PP.EnterTokenStream(std::move(TokenArray), 1,
                      /*DisableMacroExpansion=*/false);
}

/// \brief Handle Model Composer pragmas.
///  #pragma XMC [INPORT | OUTPORT] name [, name]*
void PragmaModelComposerHandler::HandlePragma(Preprocessor &PP,
                                              PragmaIntroducerKind Introducer,
                                              Token &Tok) {
  PP.Lex(Tok);
  if (Tok.getIdentifierInfo()->isStr("INPORT") ||
      Tok.getIdentifierInfo()->isStr("OUTPORT") ||
      Tok.getIdentifierInfo()->isStr("INPUT") ||
      Tok.getIdentifierInfo()->isStr("OUTPUT")) {
    std::string direction = Tok.getIdentifierInfo()->getName().str();
    PP.Lex(Tok);
    while (Tok.isNot(tok::eod)) {
      if (Tok.isNot(tok::identifier)) {
        // PP.Diag(Tok.getLocation(), diag::warn_xmc_expected) << "name [,
        // name]*";
        return;
      }
      std::string param_name = Tok.getIdentifierInfo()->getName().str();
      Actions.XMC_portDirection[param_name] = direction;
      PP.Lex(Tok);
      if (Tok.is(tok::comma)) {
        PP.Lex(Tok);
      }
    }
  }
}

/// \brief Handle '#pragma HLS|AP|AUTOPILOT ...' when HLSExt is enabled.
///
//
void PragmaXlxHandler::HandlePragma(Preprocessor &PP,
                                    PragmaIntroducerKind Introducer,
                                    Token &FirstTok) {
  SmallVector<Token, 16> Pragma;
  Token Tok;
  Tok.startToken();
  Tok.setKind(StartKind);
  Tok.setLocation(FirstTok.getLocation());
  Tok.setAnnotationValue(FirstTok.getIdentifierInfo()); 

  while (Tok.isNot(tok::eod)) {
    Pragma.push_back(Tok);
    PP.Lex(Tok);
  }

  SourceLocation EodLoc = Tok.getLocation();
  Tok.startToken();
  Tok.setKind(tok::annot_pragma_XlxHLS_end);
  Tok.setLocation(EodLoc);
  Pragma.push_back(Tok);

  auto Toks = llvm::make_unique<Token[]>(Pragma.size());
  std::copy(Pragma.begin(), Pragma.end(), Toks.get());
  PP.EnterTokenStream(std::move(Toks), Pragma.size(),
                      /*DisableMacroExpansion=*/true);
}
