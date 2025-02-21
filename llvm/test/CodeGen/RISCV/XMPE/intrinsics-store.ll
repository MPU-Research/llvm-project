; RUN: llc -mtriple=riscv64 -mattr=+xmpe,+f -verify-machineinstrs \
; RUN:     | FileCheck %s

declare void @llvm.riscv.mpe.store.us(<16 x i32> %m, i64* %addr)
declare void @llvm.riscv.mpe.store.ss(<16 x i32> %m, i64* %addr, i64 %stride)
declare void @llvm.riscv.mpe.store.s(<16 x i32> %m, i64* %addr, i64 %stride)
declare void @llvm.riscv.mpe.store.us.mask(<16 x i32> %m, i64* %addr, <16 x i1> %mask)
declare void @llvm.riscv.mpe.store.ss.mask(<16 x i32> %m, i64* %addr, i64 %stride, <16 x i1> %mask)
declare void @llvm.riscv.mpe.store.s.mask(<16 x i32> %m, i64* %addr, i64 %stride, <16 x i1> %mask)

define void @mpe_store_us(<16 x i32> %m, i64* %addr) {
; CHECK-LABEL: mpe_store_us:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ms m8, (a0)
; CHECK-NEXT:    ret
entry:
    call void @llvm.riscv.mpe.store.us(<16 x i32> %m, i64* %addr)
    ret void
}

define void @mpe_store_ss(<16 x i32> %m, i64* %addr, i64 %stride) {
; CHECK-LABEL: mpe_store_ss:
; CHECK:       # %bb.0:
; CHECK-NEXT:    msss m8, (a0), a1
; CHECK-NEXT:    ret
entry:
    call void @llvm.riscv.mpe.store.ss(<16 x i32> %m, i64* %addr, i64 %stride)
    ret void
}

define void @mpe_store_s(<16 x i32> %m, i64* %addr, i64 %stride) {
; CHECK-LABEL: mpe_store_s:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mss m8, (a0), a1
; CHECK-NEXT:    ret
entry:
    call void @llvm.riscv.mpe.store.s(<16 x i32> %m, i64* %addr, i64 %stride)
    ret void
}

define void @mpe_store_us_mask(<16 x i32> %m, i64* %addr, <16 x i1> %mask) {
; CHECK-LABEL: mpe_store_us_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mmv.mm m0, m9
; CHECK-NEXT:    ms m8, (a0), m0.t
; CHECK-NEXT:    ret
entry:
    call void @llvm.riscv.mpe.store.us.mask(<16 x i32> %m, i64* %addr, <16 x i1> %mask)
    ret void
}

define void @mpe_store_ss_mask(<16 x i32> %m, i64* %addr, i64 %stride, <16 x i1> %mask) {
; CHECK-LABEL: mpe_store_ss_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mmv.mm m0, m9
; CHECK-NEXT:    msss m8, (a0), a1, m0.t
; CHECK-NEXT:    ret
entry:
    call void @llvm.riscv.mpe.store.ss.mask(<16 x i32> %m, i64* %addr, i64 %stride, <16 x i1> %mask)
    ret void
}

define void @mpe_store_s_mask(<16 x i32> %m, i64* %addr, i64 %stride, <16 x i1> %mask) {
; CHECK-LABEL: mpe_store_s_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mmv.mm m0, m9
; CHECK-NEXT:    mss m8, (a0), a1, m0.t
; CHECK-NEXT:    ret
entry:
    call void @llvm.riscv.mpe.store.s.mask(<16 x i32> %m, i64* %addr, i64 %stride, <16 x i1> %mask)
    ret void
}
