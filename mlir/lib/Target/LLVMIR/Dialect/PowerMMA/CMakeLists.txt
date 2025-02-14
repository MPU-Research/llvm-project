add_mlir_translation_library(MLIRMMAToLLVMIRTranslation
  MMAToLLVMIRTranslation.cpp

  DEPENDS
  MLIRMMAConversionsIncGen

  LINK_COMPONENTS
  Core

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRMMADialect
  MLIRLLVMDialect
  MLIRSupport
  MLIRTargetLLVMIRExport
)
