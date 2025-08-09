/*===---- riscv_matrix.h - RISC-V MPE builtins -----------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#ifndef __RISCV_MATRIX_H
#define __RISCV_MATRIX_H

#if !defined(__riscv) || (__riscv_xlen != 64)
#error "This header is only meant to be used on RISCV64 architecture"
#endif

#define __DEFAULT_FN_ATTRS __attribute__((__always_inline__, __nodebug__))

//===----------------------------------------------------------------------===//
// TYPES
//===----------------------------------------------------------------------===//

typedef float __matrixf __attribute__((__vector_size__(64)));
typedef long long __matrixi __attribute__((__vector_size__(64)));

typedef unsigned long long int __mask;

//===----------------------------------------------------------------------===//
// ARITHMETIC BUILTINS
//===----------------------------------------------------------------------===//

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_add_i32(__matrixi a,
                                                           __matrixi b) {
  return __builtin_riscv_mpe_add_i32(a, b);
}

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_sub_i32(__matrixi a,
                                                           __matrixi b) {
  return __builtin_riscv_mpe_sub_i32(a, b);
}

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_mac_i32(__matrixi a,
                                                           __matrixi b,
                                                           __matrixi c) {
  return __builtin_riscv_mpe_mac_i32(a, b, c);
}

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_add_i32_mask(__matrixi a,
                                                                __matrixi b,
                                                                __mask mask) {
  return __builtin_riscv_mpe_add_i32_mask(a, b, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_sub_i32_mask(__matrixi a,
                                                                __matrixi b,
                                                                __mask mask) {
  return __builtin_riscv_mpe_sub_i32_mask(a, b, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_mac_i32_mask(__matrixi a,
                                                                __matrixi b,
                                                                __matrixi c,
                                                                __mask mask) {
  return __builtin_riscv_mpe_mac_i32_mask(a, b, c, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixf __rvmpe_add_f32(__matrixf a,
                                                           __matrixf b) {
  return __builtin_riscv_mpe_add_f32(a, b);
}

static inline __DEFAULT_FN_ATTRS __matrixf __rvmpe_sub_f32(__matrixf a,
                                                           __matrixf b) {
  return __builtin_riscv_mpe_sub_f32(a, b);
}

static inline __DEFAULT_FN_ATTRS __matrixf __rvmpe_mac_f32(__matrixf a,
                                                           __matrixf b,
                                                           __matrixf c) {
  return __builtin_riscv_mpe_mac_f32(a, b, c);
}

static inline __DEFAULT_FN_ATTRS __matrixf __rvmpe_add_f32_mask(__matrixf a,
                                                                __matrixf b,
                                                                __mask mask) {
  return __builtin_riscv_mpe_add_f32_mask(a, b, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixf __rvmpe_sub_f32_mask(__matrixf a,
                                                                __matrixf b,
                                                                __mask mask) {
  return __builtin_riscv_mpe_sub_f32_mask(a, b, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixf __rvmpe_mac_f32_mask(__matrixf a,
                                                                __matrixf b,
                                                                __matrixf c,
                                                                __mask mask) {
  return __builtin_riscv_mpe_mac_f32_mask(a, b, c, mask);
}

//===----------------------------------------------------------------------===//
// MEMORY BUILTINS
//===----------------------------------------------------------------------===//

//===-- LOAD/i32 ----------------------------------------------------------===//

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_load_i32(int const *ptr) {
  return __builtin_riscv_mpe_load_i32(ptr);
}

static inline __DEFAULT_FN_ATTRS __matrixi
__rvmpe_load_stride_i32(int const *ptr, long stride) {
  return __builtin_riscv_mpe_load_stride_i32(ptr, stride);
}

static inline __DEFAULT_FN_ATTRS __matrixi
__rvmpe_load_rowstride_i32(int const *ptr, long stride) {
  return __builtin_riscv_mpe_load_rowstride_i32(ptr, stride);
}

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_load_i32_mask(int const *ptr,
                                                                 long mask) {
  return __builtin_riscv_mpe_load_i32_mask(ptr, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixi
__rvmpe_load_stride_i32_mask(int const *ptr, long stride, __mask mask) {
  return __builtin_riscv_mpe_load_stride_i32_mask(ptr, stride, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixi
__rvmpe_load_rowstride_i32_mask(int const *ptr, long stride, __mask mask) {
  return __builtin_riscv_mpe_load_rowstride_i32_mask(ptr, stride, mask);
}

//===-- LOAD/f32 ----------------------------------------------------------===//

static inline __DEFAULT_FN_ATTRS __matrixf __rvmpe_load_f32(float const *ptr) {
  return __builtin_riscv_mpe_load_f32(ptr);
}

static inline __DEFAULT_FN_ATTRS __matrixf
__rvmpe_load_stride_f32(float const *ptr, long stride) {
  return __builtin_riscv_mpe_load_stride_f32(ptr, stride);
}

static inline __DEFAULT_FN_ATTRS __matrixf
__rvmpe_load_rowstride_f32(float const *ptr, long stride) {
  return __builtin_riscv_mpe_load_rowstride_f32(ptr, stride);
}

static inline __DEFAULT_FN_ATTRS __matrixf
__rvmpe_load_f32_mask(float const *ptr, __mask mask) {
  return __builtin_riscv_mpe_load_f32_mask(ptr, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixf
__rvmpe_load_stride_f32_mask(float const *ptr, long stride, __mask mask) {
  return __builtin_riscv_mpe_load_stride_f32_mask(ptr, stride, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixf
__rvmpe_load_rowstride_f32_mask(float const *ptr, long stride, __mask mask) {
  return __builtin_riscv_mpe_load_rowstride_f32_mask(ptr, stride, mask);
}

//===-- STORE/i32 ---------------------------------------------------------===//

static inline __DEFAULT_FN_ATTRS void __rvmpe_store_i32(__matrixi matrix,
                                                        int *ptr) {
  __builtin_riscv_mpe_store_i32(matrix, ptr);
}

static inline __DEFAULT_FN_ATTRS void
__rvmpe_store_stride_i32(__matrixi matrix, int *ptr, long stride) {
  __builtin_riscv_mpe_store_stride_i32(matrix, ptr, stride);
}

static inline __DEFAULT_FN_ATTRS void
__rvmpe_store_rowstride_i32(__matrixi matrix, int *ptr, long stride) {
  __builtin_riscv_mpe_store_rowstride_i32(matrix, ptr, stride);
}

static inline __DEFAULT_FN_ATTRS void
__rvmpe_store_i32_mask(__matrixi matrix, int *ptr, __mask mask) {
  __builtin_riscv_mpe_store_i32_mask(matrix, ptr, mask);
}

static inline __DEFAULT_FN_ATTRS void
__rvmpe_store_stride_i32_mask(__matrixi matrix, int *ptr, long stride,
                              __mask mask) {
  __builtin_riscv_mpe_store_stride_i32_mask(matrix, ptr, stride, mask);
}

static inline __DEFAULT_FN_ATTRS void
__rvmpe_store_rowstride_i32_mask(__matrixi matrix, int *ptr, long stride,
                                 __mask mask) {
  __builtin_riscv_mpe_store_rowstride_i32_mask(matrix, ptr, stride, mask);
}

//===-- STORE/f32 ---------------------------------------------------------===//

static inline __DEFAULT_FN_ATTRS void __rvmpe_store_f32(__matrixf matrix,
                                                        float *ptr) {
  __builtin_riscv_mpe_store_f32(matrix, ptr);
}

static inline __DEFAULT_FN_ATTRS void
__rvmpe_store_stride_f32(__matrixf matrix, float *ptr, long stride) {
  __builtin_riscv_mpe_store_stride_f32(matrix, ptr, stride);
}

static inline __DEFAULT_FN_ATTRS void
__rvmpe_store_rowstride_f32(__matrixf matrix, float *ptr, long stride) {
  __builtin_riscv_mpe_store_rowstride_f32(matrix, ptr, stride);
}

static inline __DEFAULT_FN_ATTRS void
__rvmpe_store_f32_mask(__matrixf matrix, float *ptr, __mask mask) {
  __builtin_riscv_mpe_store_f32_mask(matrix, ptr, mask);
}

static inline __DEFAULT_FN_ATTRS void
__rvmpe_store_stride_f32_mask(__matrixf matrix, float *ptr, long stride,
                              __mask mask) {
  __builtin_riscv_mpe_store_stride_f32_mask(matrix, ptr, stride, mask);
}

static inline __DEFAULT_FN_ATTRS void
__rvmpe_store_rowstride_f32_mask(__matrixf matrix, float *ptr, long stride,
                                 __mask mask) {
  __builtin_riscv_mpe_store_rowstride_f32_mask(matrix, ptr, stride, mask);
}

//===----------------------------------------------------------------------===//
// MOVE BUILTINS
//===----------------------------------------------------------------------===//

//===-- Matrix <=> Matrix -------------------------------------------------===//

static inline __DEFAULT_FN_ATTRS __matrixi
__rvmpe_move_mm_i32(__matrixi matrix) {
  return __builtin_riscv_mpe_move_mm_i32(matrix);
}

static inline __DEFAULT_FN_ATTRS __matrixi
__rvmpe_move_mm_i32_mask(__matrixi matrix, __mask mask) {
  return __builtin_riscv_mpe_move_mm_i32_mask(matrix, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixi
__rvmpe_move_zm_i32(__matrixi matrix) {
  return __builtin_riscv_mpe_move_zm_i32(matrix);
}

static inline __DEFAULT_FN_ATTRS __matrixi
__rvmpe_move_zm_i32_mask(__matrixi matrix, __mask mask) {
  return __builtin_riscv_mpe_move_zm_i32_mask(matrix, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixf
__rvmpe_move_mm_f32(__matrixf matrix) {
  return __builtin_riscv_mpe_move_mm_f32(matrix);
}

static inline __DEFAULT_FN_ATTRS __matrixf
__rvmpe_move_mm_f32_mask(__matrixf matrix, __mask mask) {
  return __builtin_riscv_mpe_move_mm_f32_mask(matrix, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixf
__rvmpe_move_zm_f32(__matrixf matrix) {
  return __builtin_riscv_mpe_move_zm_f32(matrix);
}

static inline __DEFAULT_FN_ATTRS __matrixf
__rvmpe_move_zm_f32_mask(__matrixf matrix, __mask mask) {
  return __builtin_riscv_mpe_move_zm_f32_mask(matrix, mask);
}

//===-- Matrix <=> Integer ------------------------------------------------===//

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_move_xm(int value) {
  return __builtin_riscv_mpe_move_xm(value);
}

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_move_xm_mask(int value,
                                                                __mask mask) {
  return __builtin_riscv_mpe_move_xm_mask(value, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_zero() {
  return __builtin_riscv_mpe_move_xm(0);
}

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_move_xz(int value) {
  return __builtin_riscv_mpe_move_xz(value);
}

static inline __DEFAULT_FN_ATTRS __matrixi __rvmpe_move_xz_mask(int value,
                                                                __mask mask) {
  return __builtin_riscv_mpe_move_xz_mask(value, mask);
}

static inline __DEFAULT_FN_ATTRS int __rvmpe_move_zx(__matrixi matrix) {
  return __builtin_riscv_mpe_move_zx(matrix);
}

static inline __DEFAULT_FN_ATTRS int __rvmpe_move_zx_mask(__matrixi matrix,
                                                          __mask mask) {
  return __builtin_riscv_mpe_move_zx_mask(matrix, mask);
}

//===-- Matrix <=> Float --------------------------------------------------===//

static inline __DEFAULT_FN_ATTRS __matrixf __rvmpe_move_fm(float value) {
  return __builtin_riscv_mpe_move_fm(value);
}

static inline __DEFAULT_FN_ATTRS __matrixf __rvmpe_move_fm_mask(float value,
                                                                __mask mask) {
  return __builtin_riscv_mpe_move_fm_mask(value, mask);
}

static inline __DEFAULT_FN_ATTRS __matrixf __rvmpe_move_fz(float value) {
  return __builtin_riscv_mpe_move_fz(value);
}

static inline __DEFAULT_FN_ATTRS __matrixf __rvmpe_move_fz_mask(float value,
                                                                __mask mask) {
  return __builtin_riscv_mpe_move_fz_mask(value, mask);
}

static inline __DEFAULT_FN_ATTRS float __rvmpe_move_zf(__matrixf matrix) {
  return __builtin_riscv_mpe_move_zf(matrix);
}

static inline __DEFAULT_FN_ATTRS float __rvmpe_move_zf_mask(__matrixf matrix,
                                                            __mask mask) {
  return __builtin_riscv_mpe_move_zf_mask(matrix, mask);
}

#endif /* __RISCV_MATRIX_H */
