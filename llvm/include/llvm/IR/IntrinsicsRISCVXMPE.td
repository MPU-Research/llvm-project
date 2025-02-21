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

let TargetPrefix = "riscv" in {

//===----------------------------------------------------------------------===//
// Arithmetic operations
//===----------------------------------------------------------------------===//

// Binary operation with result type equals its inputs type
class RISCVMPEIntrinsicBinopUnmasked<LLVMType type>
    : DefaultAttrsIntrinsic<[type],
                            [type, type],
                            [IntrNoMem]>;

class RISCVMPEIntrinsicBinopMasked<LLVMType type>
    : DefaultAttrsIntrinsic<[type],
                            [type, type, llvm_v16i1_ty],
                            [IntrNoMem]>;

multiclass RISCVMPEIntrinsicBinop<LLVMType type> {
  def "int_riscv_mpe_" # NAME           : RISCVMPEIntrinsicBinopUnmasked<type>;
  def "int_riscv_mpe_" # NAME # "_mask" : RISCVMPEIntrinsicBinopMasked<type>;
}

// Define variations of a binary operation for vectors of signed and
// floating-point elements, each element being 32-bit wide.
multiclass RISCVMPEInstrinsicBinop_S_F {
  defm _i32 : RISCVMPEIntrinsicBinop<llvm_v16i32_ty>;
  defm _f32 : RISCVMPEIntrinsicBinop<llvm_v16f32_ty>;
}

// @llvm.riscv.mpe.<op>.<dt>()
// @llvm.riscv.mpe.<op>.<dt>.mask()
defm mac : RISCVMPEInstrinsicBinop_S_F;
defm add : RISCVMPEInstrinsicBinop_S_F;
defm sub : RISCVMPEInstrinsicBinop_S_F;

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
                              [llvm_ptr_ty, llvm_v16i1_ty],
                              [IntrReadMem]>;
}

multiclass RISCVMPEIntrinsicLoadStride {
  def "" 
      : DefaultAttrsIntrinsic<[llvm_anyvector_ty],
                              [llvm_ptr_ty, llvm_anyint_ty],
                              [IntrReadMem, IntrArgMemOnly]>;
  def _mask
      : DefaultAttrsIntrinsic<[llvm_anyvector_ty],
                              [llvm_ptr_ty, llvm_anyint_ty, llvm_v16i1_ty],
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
                              [llvm_anyvector_ty, llvm_ptr_ty, llvm_v16i1_ty],
                              [IntrWriteMem, IntrArgMemOnly]>;
}

multiclass RISCVMPEIntrinsicStoreStride {
  def ""
      : DefaultAttrsIntrinsic<[],
                              [llvm_anyvector_ty, llvm_ptr_ty, llvm_anyint_ty],
                              [IntrWriteMem, IntrArgMemOnly]>;
  def _mask
      : DefaultAttrsIntrinsic<[],
                              [llvm_anyvector_ty, llvm_ptr_ty, llvm_anyint_ty, llvm_v16i1_ty],
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
                              [llvm_anyvector_ty, llvm_anyvector_ty],
                              [IntrNoMem]>;
}

multiclass RISCVMPEIntrinsicMoveXM {
  def ""
      : DefaultAttrsIntrinsic<[llvm_anyvector_ty],
                              [llvm_anyint_ty],
                              [IntrNoMem]>;
  def _mask
      : DefaultAttrsIntrinsic<[llvm_anyvector_ty],
                              [llvm_anyint_ty, llvm_anyvector_ty],
                              [IntrNoMem]>;
}

multiclass RISCVMPEIntrinsicMoveMX {
  def ""
      : DefaultAttrsIntrinsic<[llvm_anyint_ty],
                              [llvm_anyvector_ty],
                              [IntrNoMem]>;
  def _mask
      : DefaultAttrsIntrinsic<[llvm_anyint_ty],
                              [llvm_anyvector_ty, llvm_anyvector_ty],
                              [IntrNoMem]>;
}

multiclass RISCVMPEIntrinsicMoveFM {
  def ""
      : DefaultAttrsIntrinsic<[llvm_anyvector_ty],
                              [llvm_anyfloat_ty],
                              [IntrNoMem]>;
  def _mask
      : DefaultAttrsIntrinsic<[llvm_anyvector_ty],
                              [llvm_anyfloat_ty, llvm_anyvector_ty],
                              [IntrNoMem]>;
}

multiclass RISCVMPEIntrinsicMoveMF {
  def ""
      : DefaultAttrsIntrinsic<[llvm_anyfloat_ty],
                              [llvm_anyvector_ty],
                              [IntrNoMem]>;
  def _mask
      : DefaultAttrsIntrinsic<[llvm_anyfloat_ty],
                              [llvm_anyvector_ty, llvm_anyvector_ty],
                              [IntrNoMem]>;
}

defm int_riscv_mpe_move_mm : RISCVMPEIntrinsicMoveMM;
defm int_riscv_mpe_move_xm : RISCVMPEIntrinsicMoveXM;
defm int_riscv_mpe_move_zx : RISCVMPEIntrinsicMoveMX;
defm int_riscv_mpe_move_zm : RISCVMPEIntrinsicMoveMM;
defm int_riscv_mpe_move_fm : RISCVMPEIntrinsicMoveFM;
defm int_riscv_mpe_move_zf : RISCVMPEIntrinsicMoveMF;
defm int_riscv_mpe_move_fz : RISCVMPEIntrinsicMoveFM;

} // TargetPrefix = "riscv"
