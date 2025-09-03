// RUN: %clang_cc1 -triple riscv64-elf -target-feature +xmpe -O1 -emit-llvm -o - %s \
// RUN:     | FileCheck %s --check-prefix=IR

#include <riscv_matrix.h>

// IR:      define dso_local void @load_i32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[V0:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.load.us.v16i32(ptr %ptr)
// IR-NEXT:   store <16 x i32> [[V0]]
// IR-NEXT:   ret void
__matrixi load_i32(int const *ptr) {
  return __rvmpe_load_i32(ptr);
}

// IR:      define dso_local void @load_stride_i32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[V0:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.load.ss.v16i32(ptr %ptr, i64 %stride)
// IR-NEXT:   store <16 x i32> [[V0]]
// IR-NEXT:   ret void
__matrixi load_stride_i32(int const *ptr, long stride) {
  return __rvmpe_load_stride_i32(ptr, stride);
}

// IR:      define dso_local void @load_rowstride_i32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[V0:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.load.s.v16i32(ptr %ptr, i64 %stride)
// IR-NEXT:   store <16 x i32> [[V0]]
// IR-NEXT:   ret void
__matrixi load_rowstride_i32(int const *ptr, long stride) {
  return __rvmpe_load_rowstride_i32(ptr, stride);
}

// IR:      define dso_local void @load_i32_mask
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[V0:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.load.us.mask.v16i32(ptr %ptr, i64 %m)
// IR-NEXT:   store <16 x i32> [[V0]]
// IR-NEXT:   ret void
__matrixi load_i32_mask(int const *ptr, __mask m) {
  return __rvmpe_load_i32_mask(ptr, m);
}

// IR:      define dso_local void @load_stride_i32_mask
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[V0:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.load.ss.mask.v16i32(ptr %ptr, i64 %stride, i64 %m)
// IR-NEXT:   store <16 x i32> [[V0]]
// IR-NEXT:   ret void
__matrixi load_stride_i32_mask(int const *ptr, long stride, __mask m) {
  return __rvmpe_load_stride_i32_mask(ptr, stride, m);
}

// IR:      define dso_local void @load_rowstride_i32_mask
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[V0:%.*]] = tail call <16 x i32> @llvm.riscv.mpe.load.s.mask.v16i32(ptr %ptr, i64 %stride, i64 %m)
// IR-NEXT:   store <16 x i32> [[V0]]
// IR-NEXT:   ret void
__matrixi load_rowstride_i32_mask(int const *ptr, long stride, __mask m) {
  return __rvmpe_load_rowstride_i32_mask(ptr, stride, m);
}

// IR:      define dso_local void @load_f32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[V0:%.*]] = tail call <16 x float> @llvm.riscv.mpe.load.us.v16f32(ptr %ptr)
// IR-NEXT:   store <16 x float> [[V0]]
// IR-NEXT:   ret void
__matrixf load_f32(float const *ptr) {
  return __rvmpe_load_f32(ptr);
}

// IR:      define dso_local void @load_stride_f32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[V0:%.*]] = tail call <16 x float> @llvm.riscv.mpe.load.ss.v16f32(ptr %ptr, i64 %stride)
// IR-NEXT:   store <16 x float> [[V0]]
// IR-NEXT:   ret void
__matrixf load_stride_f32(float const *ptr, long stride) {
  return __rvmpe_load_stride_f32(ptr, stride);
}

// IR:      define dso_local void @load_rowstride_f32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[V0:%.*]] = tail call <16 x float> @llvm.riscv.mpe.load.s.v16f32(ptr %ptr, i64 %stride)
// IR-NEXT:   store <16 x float> [[V0]]
// IR-NEXT:   ret void
__matrixf load_rowstride_f32(float const *ptr, long stride) {
  return __rvmpe_load_rowstride_f32(ptr, stride);
}

// IR:      define dso_local void @load_f32_mask
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[V0:%.*]] = tail call <16 x float> @llvm.riscv.mpe.load.us.mask.v16f32(ptr %ptr, i64 %m)
// IR-NEXT:   store <16 x float> [[V0]]
// IR-NEXT:   ret void
__matrixf load_f32_mask(float const *ptr, __mask m) {
  return __rvmpe_load_f32_mask(ptr, m);
}

// IR:      define dso_local void @load_stride_f32_mask
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[V0:%.*]] = tail call <16 x float> @llvm.riscv.mpe.load.ss.mask.v16f32(ptr %ptr, i64 %stride, i64 %m)
// IR-NEXT:   store <16 x float> [[V0]]
// IR-NEXT:   ret void
__matrixf load_stride_f32_mask(float const *ptr, long stride, __mask m) {
  return __rvmpe_load_stride_f32_mask(ptr, stride, m);
}

// IR:      define dso_local void @load_rowstride_f32_mask
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[V0:%.*]] = tail call <16 x float> @llvm.riscv.mpe.load.s.mask.v16f32(ptr %ptr, i64 %stride, i64 %m)
// IR-NEXT:   store <16 x float> [[V0]]
// IR-NEXT:   ret void
__matrixf load_rowstride_f32_mask(float const *ptr, long stride, __mask m) {
  return __rvmpe_load_rowstride_f32_mask(ptr, stride, m);
}
