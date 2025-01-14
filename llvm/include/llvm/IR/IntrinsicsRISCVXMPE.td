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

  // TODO: Add correct types and properties
  class RISCVMPEMemUnitStride
      : DefaultAttrsIntrinsic<
          [llvm_i64_ty],
          [llvm_i64_ty],
          []>;

  def int_riscv_mpe_load : RISCVMPEMemUnitStride;
  def int_riscv_mpe_store : RISCVMPEMemUnitStride;
  
} // TargetPrefix = "riscv"
