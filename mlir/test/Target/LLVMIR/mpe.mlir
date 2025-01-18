// RUN: mlir-translate --mlir-to-llvmir %s | FileCheck %s

// CHECK-LABEL: define void @target(ptr %0)
// CHECK: %[[c:.*]] = call x86_amx @llvm.riscv.mpe.foo(i16 16, i16 16)
// CHECK: call void @llvm.x86.tilestored64.internal(i16 16, i16 16, ptr %0, i64 32, x86_amx %[[c]]
llvm.func @target(%arg0 : i64) {
  %0 = "mpe.intr.foo"(%arg0) : (i64) -> (i64)
  llvm.return
}
