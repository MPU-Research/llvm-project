// RUN: %clang_cc1 -triple riscv64 -target-feature +xmpe -ast-print %s \
// RUN:    | FileCheck %s

int main() {
    // CHECK: __rvmpe_4x4xi32_t a;
    __rvmpe_4x4xi32_t a;
    // CHECK: __rvmpe_4x4xf32_t b;
    __rvmpe_4x4xf32_t b;
    // CHECK: __rvmpe_mask_t c;
    __rvmpe_mask_t c;
}
