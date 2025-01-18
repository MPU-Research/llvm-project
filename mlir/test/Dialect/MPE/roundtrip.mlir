// RUN: mlir-opt -verify-diagnostics %s | mlir-opt | FileCheck %s

// CHECK-LABEL: test_foo
// CHECK: mpe.intr.foo
func.func @test_foo(%arg0 : i64) {
    %0 = mpe.foo %arg0 : i64
    return
}
