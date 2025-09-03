//===- IntrinsicsRISCVXMPE.td - MPE intrinsics -------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the MPE vendor intrinsics for RISC-V.
//
//===----------------------------------------------------------------------===//

/// Type used to represent a mask
defvar MaskType = llvm_i64_ty;

let TargetPrefix = "riscv" in {

//===----------------------------------------------------------------------===//
// Arithmetic operations
//===----------------------------------------------------------------------===//

//===-- Add/Sub -----------------------------------------------------------===//

class RISCVMPEIntrinsicAlu2Unmasked<LLVMType type>
    : DefaultAttrsIntrinsic<[type], [type, type], [IntrNoMem]>;

class RISCVMPEIntrinsicAlu2Masked<LLVMType type>
    : DefaultAttrsIntrinsic<[type], [type, type, MaskType], [IntrNoMem]>;

multiclass RISCVMPEIntrinsicAlu2<LLVMType type> {
  def "int_riscv_mpe_" # NAME           : RISCVMPEIntrinsicAlu2Unmasked<type>;
  def "int_riscv_mpe_" # NAME # "_mask" : RISCVMPEIntrinsicAlu2Masked<type>;
}

multiclass RISCVMPEIntrinsicAlu2_I_F {
  defm _i32 : RISCVMPEIntrinsicAlu2<llvm_v16i32_ty>;
  defm _f32 : RISCVMPEIntrinsicAlu2<llvm_v16f32_ty>;
}

defm add : RISCVMPEIntrinsicAlu2_I_F;
defm sub : RISCVMPEIntrinsicAlu2_I_F;

//===-- Mac ---------------------------------------------------------------===//

class RISCVMPEIntrinsicAlu3Unmasked<LLVMType type>
    : DefaultAttrsIntrinsic<[type], [type, type, type], [IntrNoMem]>;

class RISCVMPEIntrinsicAlu3Masked<LLVMType type>
    : DefaultAttrsIntrinsic<[type], [type, type, type, MaskType], [IntrNoMem]>;

multiclass RISCVMPEIntrinsicAlu3<LLVMType type> {
  def "int_riscv_mpe_" # NAME           : RISCVMPEIntrinsicAlu3Unmasked<type>;
  def "int_riscv_mpe_" # NAME # "_mask" : RISCVMPEIntrinsicAlu3Masked<type>;
}

multiclass RISCVMPEIntrinsicAlu3_I_F {
  defm _i32 : RISCVMPEIntrinsicAlu3<llvm_v16i32_ty>;
  defm _f32 : RISCVMPEIntrinsicAlu3<llvm_v16f32_ty>;
}

defm mac : RISCVMPEIntrinsicAlu3_I_F;

//===----------------------------------------------------------------------===//
// Memory operations
//===----------------------------------------------------------------------===//

multiclass RISCVMPEIntrinsicLoadNoStride {
  def ""
      : DefaultAttrsIntrinsic<[llvm_anyvector_ty],
                              [llvm_ptr_ty],
                              [IntrReadMem]>;
  def _mask
      : DefaultAttrsIntrinsic<[llvm_anyvector_ty],
                              [llvm_ptr_ty, MaskType],
                              [IntrReadMem]>;
}

multiclass RISCVMPEIntrinsicLoadStride {
  def "" 
      : DefaultAttrsIntrinsic<[llvm_anyvector_ty],
                              [llvm_ptr_ty, llvm_i64_ty],
                              [IntrReadMem, IntrArgMemOnly]>;
  def _mask
      : DefaultAttrsIntrinsic<[llvm_anyvector_ty],
                              [llvm_ptr_ty, llvm_i64_ty, MaskType],
                              [IntrReadMem, IntrArgMemOnly]>;
}

multiclass RISCVMPELoad {
  defm "int_riscv_mpe_" # NAME # "_us" : RISCVMPEIntrinsicLoadNoStride;
  defm "int_riscv_mpe_" # NAME # "_ss" : RISCVMPEIntrinsicLoadStride;
  defm "int_riscv_mpe_" # NAME # "_s"  : RISCVMPEIntrinsicLoadStride;
}

// @llvm.riscv.mpe.load.<kind>()
defm load : RISCVMPELoad;

multiclass RISCVMPEIntrinsicStoreNoStride {
  def ""
      : DefaultAttrsIntrinsic<[],
                              [llvm_anyvector_ty, llvm_ptr_ty],
                              [IntrWriteMem, IntrArgMemOnly]>;
  def _mask
      : DefaultAttrsIntrinsic<[],
                              [llvm_anyvector_ty, llvm_ptr_ty, MaskType],
                              [IntrWriteMem, IntrArgMemOnly]>;
}

multiclass RISCVMPEIntrinsicStoreStride {
  def ""
      : DefaultAttrsIntrinsic<[],
                              [llvm_anyvector_ty, llvm_ptr_ty, llvm_i64_ty],
                              [IntrWriteMem, IntrArgMemOnly]>;
  def _mask
      : DefaultAttrsIntrinsic<[],
                              [llvm_anyvector_ty, llvm_ptr_ty, llvm_i64_ty, MaskType],
                              [IntrWriteMem, IntrArgMemOnly]>;
}

multiclass RISCVMPEStore {
  defm "int_riscv_mpe_" # NAME # "_us" : RISCVMPEIntrinsicStoreNoStride;
  defm "int_riscv_mpe_" # NAME # "_ss" : RISCVMPEIntrinsicStoreStride;
  defm "int_riscv_mpe_" # NAME # "_s"  : RISCVMPEIntrinsicStoreStride;
}

// @llvm.riscv.mpe.store.<kind>()
defm store : RISCVMPEStore;

//===----------------------------------------------------------------------===//
// Move operations
//===----------------------------------------------------------------------===//

multiclass RISCVMPEIntrinsicMoveMM {
  def ""
      : DefaultAttrsIntrinsic<[llvm_anyvector_ty],
                              [llvm_anyvector_ty],
                              [IntrNoMem]>;
  def _mask
      : DefaultAttrsIntrinsic<[llvm_anyvector_ty],
                              [llvm_anyvector_ty, MaskType],
                              [IntrNoMem]>;
}

multiclass RISCVMPEIntrinsicMoveXM {
  def ""
      : DefaultAttrsIntrinsic<[llvm_v16i32_ty],
                              [llvm_i64_ty],
                              [IntrNoMem]>;
  def _mask
      : DefaultAttrsIntrinsic<[llvm_v16i32_ty],
                              [llvm_i64_ty, MaskType],
                              [IntrNoMem]>;
}

multiclass RISCVMPEIntrinsicMoveMX {
  def ""
      : DefaultAttrsIntrinsic<[llvm_i64_ty],
                              [llvm_v16i32_ty],
                              [IntrNoMem]>;
  def _mask
      : DefaultAttrsIntrinsic<[llvm_i64_ty],
                              [llvm_v16i32_ty, MaskType],
                              [IntrNoMem]>;
}

multiclass RISCVMPEIntrinsicMoveFM {
  def ""
      : DefaultAttrsIntrinsic<[llvm_v16f32_ty],
                              [llvm_float_ty],
                              [IntrNoMem]>;
  def _mask
      : DefaultAttrsIntrinsic<[llvm_v16f32_ty],
                              [llvm_float_ty, MaskType],
                              [IntrNoMem]>;
}

multiclass RISCVMPEIntrinsicMoveMF {
  def ""
      : DefaultAttrsIntrinsic<[llvm_float_ty],
                              [llvm_v16f32_ty],
                              [IntrNoMem]>;
  def _mask
      : DefaultAttrsIntrinsic<[llvm_float_ty],
                              [llvm_v16f32_ty, MaskType],
                              [IntrNoMem]>;
}

defm int_riscv_mpe_move_mm : RISCVMPEIntrinsicMoveMM;
defm int_riscv_mpe_move_zm : RISCVMPEIntrinsicMoveMM;
defm int_riscv_mpe_move_xm : RISCVMPEIntrinsicMoveXM;
defm int_riscv_mpe_move_xz : RISCVMPEIntrinsicMoveXM;
defm int_riscv_mpe_move_zx : RISCVMPEIntrinsicMoveMX;
defm int_riscv_mpe_move_fm : RISCVMPEIntrinsicMoveFM;
defm int_riscv_mpe_move_fz : RISCVMPEIntrinsicMoveFM;
defm int_riscv_mpe_move_zf : RISCVMPEIntrinsicMoveMF;

} // TargetPrefix = "riscv"
