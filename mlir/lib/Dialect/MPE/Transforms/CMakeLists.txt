add_mlir_dialect_library(MLIRMPETransforms
  LegalizeForLLVMExport.cpp

  DEPENDS
  MLIRMPEConversionsIncGen

  LINK_LIBS PUBLIC
  MLIRMPEDialect
  MLIRIR
  MLIRLLVMCommonConversion
  MLIRLLVMDialect
)
