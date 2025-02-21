; RUN: llc -mtriple=riscv64 -mattr=+xmpe,+f -verify-machineinstrs \
; RUN:     | FileCheck %s

declare <16 x i32> @llvm.riscv.mpe.load.us(i64* %addr)
declare <16 x i32> @llvm.riscv.mpe.load.ss(i64* %addr, i64 %stride)
declare <16 x i32> @llvm.riscv.mpe.load.s(i64* %addr, i64 %stride)
declare <16 x i32> @llvm.riscv.mpe.load.us.mask(i64* %addr, <16 x i1> %mask)
declare <16 x i32> @llvm.riscv.mpe.load.ss.mask(i64* %addr, i64 %stride, <16 x i1> %mask)
declare <16 x i32> @llvm.riscv.mpe.load.s.mask(i64* %addr, i64 %stride, <16 x i1> %mask)

define <16 x i32> @mpe_load_us(i64* %addr) {
; CHECK-LABEL: mpe_load_us
; CHECK:       # %bb.0
; CHECK-NEXT:    ml m8, (a0)
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x i32> @llvm.riscv.mpe.load.us(i64* %addr)
    ret <16 x i32> %0
}

define <16 x i32> @mpe_load_ss(i64* %addr, i64 %stride) {
; CHECK-LABEL: mpe_load_ss
; CHECK:       # %bb.0
; CHECK-NEXT:    mlss m8, (a0), a1
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x i32> @llvm.riscv.mpe.load.ss(i64* %addr, i64 %stride)
    ret <16 x i32> %0
}

define <16 x i32> @mpe_load_s(i64* %addr, i64 %stride) {
; CHECK-LABEL: mpe_load_s
; CHECK:       # %bb.0
; CHECK-NEXT:    mls m8, (a0), a1
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x i32> @llvm.riscv.mpe.load.s(i64* %addr, i64 %stride)
    ret <16 x i32> %0
}

define <16 x i32> @mpe_load_us_mask(i64* %addr, <16 x i1> %mask) {
; CHECK-LABEL: mpe_load_us_mask
; CHECK:       # %bb.0
; CHECK-NEXT:    mmv.mm m0, m8
; CHECK-NEXT:    ml m8, (a0), m0.t
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x i32> @llvm.riscv.mpe.load.us.mask(i64* %addr, <16 x i1> %mask)
    ret <16 x i32> %0
}

define <16 x i32> @mpe_load_ss_mask(i64* %addr, i64 %stride, <16 x i1> %mask) {
; CHECK-LABEL: mpe_load_ss_mask
; CHECK:       # %bb.0
; CHECK-NEXT:    mmv.mm m0, m8
; CHECK-NEXT:    mlss m8, (a0), a1, m0.t
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x i32> @llvm.riscv.mpe.load.ss.mask(i64* %addr, i64 %stride, <16 x i1> %mask)
    ret <16 x i32> %0
}

define <16 x i32> @mpe_load_s_mask(i64* %addr, i64 %stride, <16 x i1> %mask) {
; CHECK-LABEL: mpe_load_s_mask
; CHECK:       # %bb.0
; CHECK-NEXT:    mmv.mm m0, m8
; CHECK-NEXT:    mls m8, (a0), a1, m0.t
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x i32> @llvm.riscv.mpe.load.s.mask(i64* %addr, i64 %stride, <16 x i1> %mask)
    ret <16 x i32> %0

