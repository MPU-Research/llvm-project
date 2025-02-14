add_mlir_dialect(MMA mma)
add_mlir_doc(MMA MMA Dialects/ -gen-dialect-doc -dialect=mma)

set(LLVM_TARGET_DEFINITIONS MMA.td)
mlir_tablegen(MMAConversions.inc -gen-llvmir-conversions)
add_public_tablegen_target(MLIRMMAConversionsIncGen)
