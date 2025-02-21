; RUN: llc -mtriple=riscv64 -mattr=+xmpe,+f \
; RUN:     | FileCheck %s

declare <16 x i32> @llvm.riscv.mpe.add.v16i32(<16 x i32>, <16 x i32>)
declare <16 x i32> @llvm.riscv.mpe.sub.v16i32(<16 x i32>, <16 x i32>)
declare <16 x i32> @llvm.riscv.mpe.mac.v16i32(<16 x i32>, <16 x i32>)
declare <16 x i32> @llvm.riscv.mpe.add.v16i32.mask(<16 x i32>, <16 x i32>, <16 x i1>)
declare <16 x i32> @llvm.riscv.mpe.sub.v16i32.mask(<16 x i32>, <16 x i32>, <16 x i1>)
declare <16 x i32> @llvm.riscv.mpe.mac.v16i32.mask(<16 x i32>, <16 x i32>, <16 x i1>)

declare <16 x float> @llvm.riscv.mpe.add.v16f32(<16 x float>, <16 x float>)
declare <16 x float> @llvm.riscv.mpe.sub.v16f32(<16 x float>, <16 x float>)
declare <16 x float> @llvm.riscv.mpe.mac.v16f32(<16 x float>, <16 x float>)
declare <16 x float> @llvm.riscv.mpe.add.v16f32.mask(<16 x float>, <16 x float>, <16 x i1>)
declare <16 x float> @llvm.riscv.mpe.sub.v16f32.mask(<16 x float>, <16 x float>, <16 x i1>)
declare <16 x float> @llvm.riscv.mpe.mac.v16f32.mask(<16 x float>, <16 x float>, <16 x i1>)

define <16 x i32> @mpe_add_v16i32(<16 x i32> %lhs, <16 x i32> %rhs) nounwind {
; CHECK-LABEL: mpe_add_v16i32: # @mpe_add_v16i32
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    madd m8, m8, m9
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x i32> @llvm.riscv.mpe.add.v16i32(
        <16 x i32> %lhs,
        <16 x i32> %rhs)
    ret <16 x i32> %0
}

define <16 x i32> @mpe_sub_v16i32(<16 x i32> %lhs, <16 x i32> %rhs) nounwind {
; CHECK-LABEL: mpe_sub_v16i32: # @mpe_sub_v16i32
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    msub m8, m8, m9
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x i32> @llvm.riscv.mpe.sub.v16i32(
        <16 x i32> %lhs,
        <16 x i32> %rhs)
    ret <16 x i32> %0
}

define <16 x i32> @mpe_mac_v16i32(<16 x i32> %lhs, <16 x i32> %rhs) nounwind {
; CHECK-LABEL: mpe_mac_v16i32: # @mpe_mac_v16i32
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mmac m8, m8, m9
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x i32> @llvm.riscv.mpe.mac.v16i32(
        <16 x i32> %lhs,
        <16 x i32> %rhs)
    ret <16 x i32> %0
}

define <16 x float> @mpe_add_v16f32(<16 x float> %lhs, <16 x float> %rhs) nounwind {
; CHECK-LABEL: mpe_add_v16f32: # @mpe_add_v16f32
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    maddf m8, m8, m9
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x float> @llvm.riscv.mpe.add.v16f32(
        <16 x float> %lhs,
        <16 x float> %rhs)
    ret <16 x float> %0
}

define <16 x float> @mpe_sub_v16f32(<16 x float> %lhs, <16 x float> %rhs) nounwind {
; CHECK-LABEL: mpe_sub_v16f32: # @mpe_sub_v16f32
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    msubf m8, m8, m9
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x float> @llvm.riscv.mpe.sub.v16f32(
        <16 x float> %lhs,
        <16 x float> %rhs)
    ret <16 x float> %0
}

define <16 x float> @mpe_mac_v16f32(<16 x float> %lhs, <16 x float> %rhs) nounwind {
; CHECK-LABEL: mpe_mac_v16f32: # @mpe_mac_v16f32
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mmacf m8, m8, m9
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x float> @llvm.riscv.mpe.mac.v16f32(
        <16 x float> %lhs,
        <16 x float> %rhs)
    ret <16 x float> %0
}

define <16 x i32> @mpe_add_v16i32_mask(<16 x i32> %lhs, <16 x i32> %rhs, <16 x i1> %mask) nounwind {
; CHECK-LABEL: mpe_add_v16i32_mask: # @mpe_add_v16i32_mask
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mmv.mm m0, m10
; CHECK-NEXT:    madd m8, m8, m9, m0.t
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x i32> @llvm.riscv.mpe.add.v16i32.mask(
        <16 x i32> %lhs,
        <16 x i32> %rhs,
        <16 x  i1> %mask)
    ret <16 x i32> %0
}

define <16 x i32> @mpe_sub_v16i32_mask(<16 x i32> %lhs, <16 x i32> %rhs, <16 x i1> %mask) nounwind {
; CHECK-LABEL: mpe_sub_v16i32_mask: # @mpe_sub_v16i32_mask
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mmv.mm m0, m10
; CHECK-NEXT:    msub m8, m8, m9, m0.t
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x i32> @llvm.riscv.mpe.sub.v16i32.mask(
        <16 x i32> %lhs,
        <16 x i32> %rhs,
        <16 x i1> %mask)
    ret <16 x i32> %0
}

define <16 x i32> @mpe_mac_v16i32_mask(<16 x i32> %lhs, <16 x i32> %rhs, <16 x i1> %mask) nounwind {
; CHECK-LABEL: mpe_mac_v16i32_mask: # @mpe_mac_v16i32_mask
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mmv.mm m0, m10
; CHECK-NEXT:    mmac m8, m8, m9, m0.t
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x i32> @llvm.riscv.mpe.mac.v16i32.mask(
        <16 x i32> %lhs,
        <16 x i32> %rhs,
        <16 x i1> %mask)
    ret <16 x i32> %0
}

define <16 x float> @mpe_add_v16f32_mask(<16 x float> %lhs, <16 x float> %rhs, <16 x i1> %mask) nounwind {
; CHECK-LABEL: mpe_add_v16f32_mask: # @mpe_add_v16f32_mask
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mmv.mm m0, m10
; CHECK-NEXT:    maddf m8, m8, m9, m0.t
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x float> @llvm.riscv.mpe.add.v16f32.mask(
        <16 x float> %lhs,
        <16 x float> %rhs,
        <16 x  i1> %mask)
    ret <16 x float> %0
}

define <16 x float> @mpe_sub_v16f32_mask(<16 x float> %lhs, <16 x float> %rhs, <16 x i1> %mask) nounwind {
; CHECK-LABEL: mpe_sub_v16f32_mask: # @mpe_sub_v16f32_mask
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mmv.mm m0, m10
; CHECK-NEXT:    msubf m8, m8, m9, m0.t
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x float> @llvm.riscv.mpe.sub.v16f32.mask(
        <16 x float> %lhs,
        <16 x float> %rhs,
        <16 x i1> %mask)
    ret <16 x float> %0
}

define <16 x float> @mpe_mac_v16f32_mask(<16 x float> %lhs, <16 x float> %rhs, <16 x i1> %mask) nounwind {
; CHECK-LABEL: mpe_mac_v16f32_mask: # @mpe_mac_v16f32_mask
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mmv.mm m0, m10
; CHECK-NEXT:    mmacf m8, m8, m9, m0.t
; CHECK-NEXT:    ret
entry:
    %0 = call <16 x float> @llvm.riscv.mpe.mac.v16f32.mask(
        <16 x float> %lhs,
        <16 x float> %rhs,
        <16 x i1> %mask)
    ret <16 x float> %0
}
