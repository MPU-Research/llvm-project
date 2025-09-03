// RUN: %clang_cc1 -triple riscv64-elf -target-feature +xmpe -O1 -emit-llvm -o - %s \
// RUN:     | FileCheck %s --check-prefix=IR

#include <riscv_matrix.h>

// IR:      define dso_local void @store_i32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:   tail call void @llvm.riscv.mpe.store.us.v16i32(<16 x i32> [[A]], ptr %ptr)
// IR-NEXT:   ret void
void store_i32(__matrixi a, int *ptr) {
  __rvmpe_store_i32(a, ptr);
}

// IR:      define dso_local void @store_stride_i32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:   tail call void @llvm.riscv.mpe.store.ss.v16i32(<16 x i32> [[A]], ptr %ptr, i64 %stride)
// IR-NEXT:   ret void
void store_stride_i32(__matrixi a, int *ptr, long stride) {
  __rvmpe_store_stride_i32(a, ptr, stride);
}

// IR:      define dso_local void @store_rowstride_i32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:   tail call void @llvm.riscv.mpe.store.s.v16i32(<16 x i32> [[A]], ptr %ptr, i64 %stride)
// IR-NEXT:   ret void
void store_rowstride_i32(__matrixi a, int *ptr, long stride) {
  __rvmpe_store_rowstride_i32(a, ptr, stride);
}

// IR:      define dso_local void @store_i32_mask
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:   tail call void @llvm.riscv.mpe.store.us.mask.v16i32(<16 x i32> [[A]], ptr %ptr, i64 %m)
// IR-NEXT:   ret void
void store_i32_mask(__matrixi a, int *ptr, __mask m) {
  __rvmpe_store_i32_mask(a, ptr, m);
}

// IR:      define dso_local void @store_stride_i32_mask
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:   tail call void @llvm.riscv.mpe.store.ss.mask.v16i32(<16 x i32> [[A]], ptr %ptr, i64 %stride, i64 %m)
// IR-NEXT:   ret void
void store_stride_i32_mask(__matrixi a, int *ptr, long stride, __mask m) {
  __rvmpe_store_stride_i32_mask(a, ptr, stride, m);
}

// IR:      define dso_local void @store_rowstride_i32_mask
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x i32>, ptr %0
// IR-NEXT:   tail call void @llvm.riscv.mpe.store.s.mask.v16i32(<16 x i32> [[A]], ptr %ptr, i64 %stride, i64 %m)
// IR-NEXT:   ret void
void store_rowstride_i32_mask(__matrixi a, int *ptr, long stride, __mask m) {
  __rvmpe_store_rowstride_i32_mask(a, ptr, stride, m);
}

// IR:      define dso_local void @store_f32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:   tail call void @llvm.riscv.mpe.store.us.v16f32(<16 x float> [[A]], ptr %ptr)
// IR-NEXT:   ret void
void store_f32(__matrixf a, float *ptr) {
  __rvmpe_store_f32(a, ptr);
}

// IR:      define dso_local void @store_stride_f32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:   tail call void @llvm.riscv.mpe.store.ss.v16f32(<16 x float> [[A]], ptr %ptr, i64 %stride)
// IR-NEXT:   ret void
void store_stride_f32(__matrixf a, float *ptr, long stride) {
  __rvmpe_store_stride_f32(a, ptr, stride);
}

// IR:      define dso_local void @store_rowstride_f32
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:   tail call void @llvm.riscv.mpe.store.s.v16f32(<16 x float> [[A]], ptr %ptr, i64 %stride)
// IR-NEXT:   ret void
void store_rowstride_f32(__matrixf a, float *ptr, long stride) {
  __rvmpe_store_rowstride_f32(a, ptr, stride);
}

// IR:      define dso_local void @store_f32_mask
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:   tail call void @llvm.riscv.mpe.store.us.mask.v16f32(<16 x float> [[A]], ptr %ptr, i64 %m)
// IR-NEXT:   ret void
void store_f32_mask(__matrixf a, float *ptr, __mask m) {
  __rvmpe_store_f32_mask(a, ptr, m);
}

// IR:      define dso_local void @store_stride_f32_mask
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:   tail call void @llvm.riscv.mpe.store.ss.mask.v16f32(<16 x float> [[A]], ptr %ptr, i64 %stride, i64 %m)
// IR-NEXT:   ret void
void store_stride_f32_mask(__matrixf a, float *ptr, long stride, __mask m) {
  __rvmpe_store_stride_f32_mask(a, ptr, stride, m);
}

// IR:      define dso_local void @store_rowstride_f32_mask
// IR-NEXT: [[ENTRY:.*:]]
// IR-NEXT:   [[A:%.*]] = load <16 x float>, ptr %0
// IR-NEXT:   tail call void @llvm.riscv.mpe.store.s.mask.v16f32(<16 x float> [[A]], ptr %ptr, i64 %stride, i64 %m)
// IR-NEXT:   ret void
void store_rowstride_f32_mask(__matrixf a, float *ptr, long stride, __mask m) {
  __rvmpe_store_rowstride_f32_mask(a, ptr, stride, m);
}
