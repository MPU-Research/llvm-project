// RUN: %clang_cc1 -triple riscv64-elf -target-feature +xmpe -O1 -emit-llvm -o - %s \
// RUN:     | FileCheck %s --check-prefix=IR

#include <riscv_matrix.h>

// IR:      define dso_local void @move_mm_i32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:   [[B:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.move.mm.v16i32.v16i32(<16 x i32> [[A]])
// IR-NEXT:   store <16 x i32> [[B]]
// IR-NEXT:   ret void
__matrixi move_mm_i32(__matrixi a) {
  return __rvmpe_move_mm_i32(a);
}

// IR:      define dso_local void @move_zm_i32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:   [[B:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.move.zm.v16i32.v16i32(<16 x i32> [[A]])
// IR-NEXT:   store <16 x i32> [[B]]
// IR-NEXT:   ret void
__matrixi move_zm_i32(__matrixi a) {
  return __rvmpe_move_zm_i32(a);
}

// IR:      define dso_local void @move_mm_f32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:   [[B:%.*]] = tail call <16 x float> @llvm.riscv.mpe.move.mm.v16f32.v16f32(<16 x float> [[A]])
// IR-NEXT:   store <16 x float> [[B]]
// IR-NEXT:   ret void
__matrixf move_mm_f32(__matrixf a) {
  return __rvmpe_move_mm_f32(a);
}

// IR:      define dso_local void @move_zm_f32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:   [[B:%.*]] = tail call <16 x float> @llvm.riscv.mpe.move.zm.v16f32.v16f32(<16 x float> [[A]])
// IR-NEXT:   store <16 x float> [[B]]
// IR-NEXT:   ret void
__matrixf move_zm_f32(__matrixf a) {
  return __rvmpe_move_zm_f32(a);
}

// IR:      define dso_local void @move_xm
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = sext i32 %value to i64
// IR-NEXT:   [[B:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.move.xm(i64 [[A]])
// IR-NEXT:   store <16 x i32> %0
// IR-NEXT:   ret void
__matrixi move_xm(int value) {
  return __rvmpe_move_xm(value);
}

// IR:      define dso_local void @move_xz
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = sext i32 %value to i64
// IR-NEXT:   [[B:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.move.xz(i64 [[A]])
// IR-NEXT:   store <16 x i32> %0
// IR-NEXT:   ret void
__matrixi move_xz(int value) {
  return __rvmpe_move_xz(value);
}

// IR:      define dso_local signext i32 @move_zx
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:   [[B:%.*]] = tail call i64 @llvm.riscv.mpe.move.zx(<16 x i32> [[A]])
// IR-NEXT:   [[C:%.*]] = trunc i64 [[B]] to i32
// IR-NEXT:   ret i32 [[C]]
int move_zx(__matrixi a) {
  return __rvmpe_move_zx(a);
}

// IR:      define dso_local void @move_fm
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[B:%.*]] = tail call <16 x float> @llvm.riscv.mpe.move.fm(float %value)
// IR-NEXT:   store <16 x float> %0
// IR-NEXT:   ret void
__matrixf move_fm(float value) {
  return __rvmpe_move_fm(value);
}

// IR:      define dso_local void @move_fz
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[B:%.*]] = tail call <16 x float> @llvm.riscv.mpe.move.fz(float %value)
// IR-NEXT:   store <16 x float> %0
// IR-NEXT:   ret void
__matrixf move_fz(float value) {
  return __rvmpe_move_fz(value);
}

// IR:      define dso_local float @move_zf
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:   [[B:%.*]] = tail call float @llvm.riscv.mpe.move.zf(<16 x float> [[A]])
// IR-NEXT:   ret float [[B]]
float move_zf(__matrixf a) {
  return __rvmpe_move_zf(a);
}
