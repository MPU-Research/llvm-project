//==- BuiltinsRISCVXMPE.td - RISC-V MPE Builtin database ---*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the MPE-specific builtin function database.  Users of
// this file must define the BUILTIN macro to make use of this information.
//
//===----------------------------------------------------------------------===//

class RISCVMPEBuiltin<string prototype, string features = ""> : TargetBuiltin {
  let Spellings = ["__builtin_riscv_mpe_" # NAME];
  let Prototype = prototype;
  let Features = features;
}

// TODO: Add correct prototypes
let Features = "xmpe", Attributes = [NoThrow, Const] in {
  def load   : RISCVMPEBuiltin<"int64_t(int64_t)">;
  def store  : RISCVMPEBuiltin<"int64_t(int64_t)">;
} // Features = "xmpe", Attributes = [NoThrow, Const]
