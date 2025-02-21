// RUN: %clang_cc1 -triple riscv64-elf -target-feature +xmpe -O1 -S -o - %s \
// RUN:     | FileCheck %s --check-prefix=ASM
// RUN: %clang_cc1 -triple riscv64-elf -target-feature +xmpe -O1 -emit-llvm -o - %s \
// RUN:     | FileCheck %s --check-prefix=IR

// IR-LABEL: define dso_local <16 x i32> @add_i32
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[TMP0:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.add.i32(<16 x i32> [[TMP1:%.*]], <16 x i32> [[TMP2:%.*]])
// IR-NEXT:    ret <16 x i32> [[TMP0]]
__rvmpe_4x4xi32_t add_i32(__rvmpe_4x4xi32_t a, __rvmpe_4x4xi32_t b) {
  // ASM-LABEL: add_i32:
  // ASM:         madd m8, m8, m9
  // ASM-NEXT:    ret
  return __builtin_riscv_mpe_add_i32(a, b);
}

// IR-LABEL: define dso_local <16 x i32> @sub_i32
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[TMP0:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.sub.i32(<16 x i32> [[TMP1:%.*]], <16 x i32> [[TMP2:%.*]])
// IR-NEXT:    ret <16 x i32> [[TMP0]]
__rvmpe_4x4xi32_t sub_i32(__rvmpe_4x4xi32_t a, __rvmpe_4x4xi32_t b) {
  // ASM-LABEL: sub_i32:
  // ASM:         msub m8, m8, m9
  // ASM-NEXT:    ret
  return __builtin_riscv_mpe_sub_i32(a, b);
}

// IR-LABEL: define dso_local <16 x i32> @mac_i32
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[TMP0:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.mac.i32(<16 x i32> [[TMP1:%.*]], <16 x i32> [[TMP2:%.*]])
// IR-NEXT:    ret <16 x i32> [[TMP0]]
__rvmpe_4x4xi32_t mac_i32(__rvmpe_4x4xi32_t a, __rvmpe_4x4xi32_t b) {
  // ASM-LABEL: mac_i32:
  // ASM:         mmac m8, m8, m9
  // ASM-NEXT:    ret
  return __builtin_riscv_mpe_mac_i32(a, b);
}

// IR-LABEL: define dso_local <16 x float> @add_f32
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[TMP0:%.*]] = tail call <16 x float> @llvm.riscv.mpe.add.f32(<16 x float> [[TMP1:%.*]], <16 x float> [[TMP2:%.*]])
// IR-NEXT:    ret <16 x float> [[TMP0]]
__rvmpe_4x4xf32_t add_f32(__rvmpe_4x4xf32_t a, __rvmpe_4x4xf32_t b) {
  // ASM-LABEL: add_f32:
  // ASM:         maddf m8, m8, m9
  // ASM-NEXT:    ret
  return __builtin_riscv_mpe_add_f32(a, b);
}

// IR-LABEL: define dso_local <16 x float> @sub_f32
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[TMP0:%.*]] = tail call <16 x float> @llvm.riscv.mpe.sub.f32(<16 x float> [[TMP1:%.*]], <16 x float> [[TMP2:%.*]])
// IR-NEXT:    ret <16 x float> [[TMP0]]
__rvmpe_4x4xf32_t sub_f32(__rvmpe_4x4xf32_t a, __rvmpe_4x4xf32_t b) {
  // ASM-LABEL: sub_f32:
  // ASM:         msubf m8, m8, m9
  // ASM-NEXT:    ret
  return __builtin_riscv_mpe_sub_f32(a, b);
}

// IR-LABEL: define dso_local <16 x float> @mac_f32
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[TMP0:%.*]] = tail call <16 x float> @llvm.riscv.mpe.mac.f32(<16 x float> [[TMP1:%.*]], <16 x float> [[TMP2:%.*]])
// IR-NEXT:    ret <16 x float> [[TMP0]]
__rvmpe_4x4xf32_t mac_f32(__rvmpe_4x4xf32_t a, __rvmpe_4x4xf32_t b) {
  // ASM-LABEL: mac_f32:
  // ASM:         mmacf m8, m8, m9
  // ASM-NEXT:    ret
  return __builtin_riscv_mpe_mac_f32(a, b);
}
