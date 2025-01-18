add_mlir_dialect(MPE mpe)
add_mlir_doc(MPE MPE Dialects/ -gen-dialect-doc -dialect=mpe)

set(LLVM_TARGET_DEFINITIONS MPE.td)
mlir_tablegen(MPEConversions.inc -gen-llvmir-conversions)
add_public_tablegen_target(MLIRMPEConversionsIncGen)
