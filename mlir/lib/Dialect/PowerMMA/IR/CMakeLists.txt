add_mlir_dialect_library(MLIRMMADialect
  MMADialect.cpp
  
  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/MMA
  
  DEPENDS
  MLIRMMAIncGen
  
  LINK_LIBS PUBLIC
  MLIRIR
  MLIRLLVMDialect
  MLIRSideEffectInterfaces
)
