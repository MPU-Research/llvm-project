add_mlir_translation_library(MLIRMPEToLLVMIRTranslation
  MPEToLLVMIRTranslation.cpp

  DEPENDS
  MLIRMPEConversionsIncGen

  LINK_COMPONENTS
  Core

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRMPEDialect
  MLIRLLVMDialect
  MLIRSupport
  MLIRTargetLLVMIRExport
)
