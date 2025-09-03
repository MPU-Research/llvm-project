// RUN: %clang_cc1 -triple riscv64-elf -target-feature +xmpe -O1 -emit-llvm -o - %s \
// RUN:     | FileCheck %s --check-prefix=IR

#include <riscv_matrix.h>

// IR:       define dso_local void @add_i32
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:    [[B:%.*]] = load <16 x i32>, ptr %1
// IR-NEXT:    [[C:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.add.i32(<16 x i32> [[A]], <16 x i32> [[B]])
// IR-NEXT:    store <16 x i32> [[C]]
// IR-NEXT:    ret void
__matrixi add_i32(__matrixi a, __matrixi b) {
  return __rvmpe_add_i32(a, b);
}

// IR:       define dso_local void @sub_i32
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:    [[B:%.*]] = load <16 x i32>, ptr %1
// IR-NEXT:    [[C:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.sub.i32(<16 x i32> [[A]], <16 x i32> [[B]])
// IR-NEXT:    store <16 x i32> [[C]]
// IR-NEXT:    ret void
__matrixi sub_i32(__matrixi a, __matrixi b) {
  return __rvmpe_sub_i32(a, b);
}

// IR:       define dso_local void @mac_i32
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:    [[B:%.*]] = load <16 x i32>, ptr %1
// IR-NEXT:    [[C:%.*]] = load <16 x i32>, ptr %2
// IR-NEXT:    [[D:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.mac.i32(<16 x i32> [[A]], <16 x i32> [[B]], <16 x i32> [[C]])
// IR-NEXT:    store <16 x i32> [[D]]
// IR-NEXT:    ret void
__matrixi mac_i32(__matrixi a, __matrixi b, __matrixi c) {
  return __rvmpe_mac_i32(a, b, c);
}

// IR:       define dso_local void @add_f32
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:    [[B:%.*]] = load <16 x float>, ptr %1
// IR-NEXT:    [[C:%.*]] = tail call <16 x float> @llvm.riscv.mpe.add.f32(<16 x float> [[A]], <16 x float> [[B]])
// IR-NEXT:    store <16 x float> [[C]]
// IR-NEXT:    ret void
__matrixf add_f32(__matrixf a, __matrixf b) {
  return __rvmpe_add_f32(a, b);
}

// IR:       define dso_local void @sub_f32
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:    [[B:%.*]] = load <16 x float>, ptr %1
// IR-NEXT:    [[C:%.*]] = tail call <16 x float> @llvm.riscv.mpe.sub.f32(<16 x float> [[A]], <16 x float> [[B]])
// IR-NEXT:    store <16 x float> [[C]]
// IR-NEXT:    ret void
__matrixf sub_f32(__matrixf a, __matrixf b) {
  return __rvmpe_sub_f32(a, b);
}

// IR:       define dso_local void @mac_f32
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:    [[B:%.*]] = load <16 x float>, ptr %1
// IR-NEXT:    [[C:%.*]] = load <16 x float>, ptr %2
// IR-NEXT:    [[D:%.*]] = tail call <16 x float> @llvm.riscv.mpe.mac.f32(<16 x float> [[A]], <16 x float> [[B]], <16 x float> [[C]])
// IR-NEXT:    store <16 x float> [[D]]
// IR-NEXT:    ret void
__matrixf mac_f32(__matrixf a, __matrixf b, __matrixf c) {
  return __rvmpe_mac_f32(a, b, c);
}

// IR:       define dso_local void @add_i32_mask
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:    [[B:%.*]] = load <16 x i32>, ptr %1
// IR-NEXT:    [[C:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.add.i32.mask(<16 x i32> [[A]], <16 x i32> [[B]], i64 %m)
// IR-NEXT:    store <16 x i32> [[C]]
// IR-NEXT:    ret void
__matrixi add_i32_mask(__matrixi a, __matrixi b, __mask m) {
  return __rvmpe_add_i32_mask(a, b, m);
}

// IR:       define dso_local void @sub_i32_mask
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:    [[B:%.*]] = load <16 x i32>, ptr %1
// IR-NEXT:    [[C:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.sub.i32.mask(<16 x i32> [[A]], <16 x i32> [[B]], i64 %m)
// IR-NEXT:    store <16 x i32> [[C]]
// IR-NEXT:    ret void
__matrixi sub_i32_mask(__matrixi a, __matrixi b, __mask m) {
  return __rvmpe_sub_i32_mask(a, b, m);
}

// IR:       define dso_local void @mac_i32_mask
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:    [[B:%.*]] = load <16 x i32>, ptr %1
// IR-NEXT:    [[C:%.*]] = load <16 x i32>, ptr %2
// IR-NEXT:    [[D:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.mac.i32.mask(<16 x i32> [[A]], <16 x i32> [[B]], <16 x i32> [[C]], i64 %m)
// IR-NEXT:    store <16 x i32> [[D]]
// IR-NEXT:    ret void
__matrixi mac_i32_mask(__matrixi a, __matrixi b, __matrixi c, __mask m) {
  return __rvmpe_mac_i32_mask(a, b, c, m);
}

// IR:       define dso_local void @add_f32_mask
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:    [[B:%.*]] = load <16 x float>, ptr %1
// IR-NEXT:    [[C:%.*]] = tail call <16 x float> @llvm.riscv.mpe.add.f32.mask(<16 x float> [[A]], <16 x float> [[B]], i64 %m)
// IR-NEXT:    store <16 x float> [[C]]
// IR-NEXT:    ret void
__matrixi add_f32_mask(__matrixi a, __matrixi b, __mask m) {
  return __rvmpe_add_f32_mask(a, b, m);
}

// IR:       define dso_local void @sub_f32_mask
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:    [[B:%.*]] = load <16 x float>, ptr %1
// IR-NEXT:    [[C:%.*]] = tail call <16 x float> @llvm.riscv.mpe.sub.f32.mask(<16 x float> [[A]], <16 x float> [[B]], i64 %m)
// IR-NEXT:    store <16 x float> [[C]]
// IR-NEXT:    ret void
__matrixi sub_f32_mask(__matrixi a, __matrixi b, __mask m) {
  return __rvmpe_sub_f32_mask(a, b, m);
}

// IR:       define dso_local void @mac_f32_mask
// IR-NEXT:  [[ENTRY:.*:]]
// IR-NEXT:    [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:    [[B:%.*]] = load <16 x float>, ptr %1
// IR-NEXT:    [[C:%.*]] = load <16 x float>, ptr %2
// IR-NEXT:    [[D:%.*]] = tail call <16 x float> @llvm.riscv.mpe.mac.f32.mask(<16 x float> [[A]], <16 x float> [[B]], <16 x float> [[C]], i64 %m)
// IR-NEXT:    store <16 x float> [[D]]
// IR-NEXT:    ret void
__matrixi mac_f32_mask(__matrixi a, __matrixi b, __matrixi c, __mask m) {
  return __rvmpe_mac_f32_mask(a, b, c, m);
}
