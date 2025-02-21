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
  let Attributes = [NoThrow, Const];
}

//===----------------------------------------------------------------------===//
// ARITHMETIC BUILTINS
//===----------------------------------------------------------------------===//

multiclass RISCVMPEArithBuiltin_M<string dt> {
  defvar Vec = !strconcat("_Vector<16, ", dt, ">");
  defvar Mask = "_Vector<16, bool>";

  def ""    : RISCVMPEBuiltin<Vec # "(" # Vec # "," # Vec # ")">;
  def _mask : RISCVMPEBuiltin<Vec # "(" # Vec # "," # Vec # "," # Mask # ")">;
}

multiclass RISCVMPEArithBuiltin {
  defm _i32 : RISCVMPEArithBuiltin_M<"int">;
  defm _f32 : RISCVMPEArithBuiltin_M<"float">;
}


let Features = "xmpe" in {

defm add : RISCVMPEArithBuiltin;
defm sub : RISCVMPEArithBuiltin;
defm mac : RISCVMPEArithBuiltin;

} // Features = "xmpe"

//===----------------------------------------------------------------------===//
// MEMORY BUILTINS
//===----------------------------------------------------------------------===//

let Features = "xmpe" in {

} // Features = "xmpe"

//===----------------------------------------------------------------------===//
// MOVE BUILTINS
//===----------------------------------------------------------------------===//

let Features = "xmpe" in {

} // Features = "xmpe"
