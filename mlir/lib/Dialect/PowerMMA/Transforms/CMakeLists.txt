add_mlir_dialect_library(MLIRMMATransforms
  LegalizeForLLVMExport.cpp

  DEPENDS
  MLIRMMAConversionsIncGen

  LINK_LIBS PUBLIC
  MLIRMMADialect
  MLIRIR
  MLIRLLVMCommonConversion
  MLIRLLVMDialect
)
