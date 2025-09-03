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

defvar v16i32 = "_Vector<16, int>";
defvar v16f32 = "_Vector<16, float>";

class RISCVMPEBuiltin<string prototype, string features = ""> : TargetBuiltin {
  let Spellings = ["__builtin_riscv_mpe_" # NAME];
  let Prototype = prototype;
  let Features = features;
  let Attributes = [NoThrow, Const];
}

multiclass RISCVMPEBuiltinFormat<string return, list<string> params> {
  defvar mask = "unsigned long long int";
  defvar parmlist = !interleave(params, ",");

  def ""    : RISCVMPEBuiltin<return # "(" # parmlist # ")">;
  def _mask : RISCVMPEBuiltin<return # "(" # parmlist # "," # mask # ")">;
}

//===----------------------------------------------------------------------===/
// ARITHMETIC BUILTINS
//===----------------------------------------------------------------------===//

multiclass RISCVMPEBuiltinAlu2 {
  defm _i32 : RISCVMPEBuiltinFormat<v16i32, [v16i32, v16i32]>;
  defm _f32 : RISCVMPEBuiltinFormat<v16f32, [v16f32, v16f32]>;
}

multiclass RISCVMPEBuiltinAlu3 {
  defm _i32 : RISCVMPEBuiltinFormat<v16i32, [v16i32, v16i32, v16i32]>;
  defm _f32 : RISCVMPEBuiltinFormat<v16f32, [v16f32, v16f32, v16f32]>;
}

let Features = "xmpe" in {
  defm add : RISCVMPEBuiltinAlu2;
  defm sub : RISCVMPEBuiltinAlu2;
  defm mac : RISCVMPEBuiltinAlu3;
} // Features = "xmpe"

//===----------------------------------------------------------------------===//
// MEMORY BUILTINS
//===----------------------------------------------------------------------===//

multiclass RISCVMPEBuiltinLoadBase<list<string> params> {
  defm _i32 : RISCVMPEBuiltinFormat<v16i32, !listconcat(["int const *"], params)>;
  defm _f32 : RISCVMPEBuiltinFormat<v16f32, !listconcat(["float const *"], params)>;
}

multiclass RISCVMPEBuiltinLoad {
  defm ""         : RISCVMPEBuiltinLoadBase<[]>;
  defm _stride    : RISCVMPEBuiltinLoadBase<["size_t"]>;
  defm _rowstride : RISCVMPEBuiltinLoadBase<["size_t"]>;
}

multiclass RISCVMPEBuiltinStoreBase<list<string> params> {
  defm _i32 : RISCVMPEBuiltinFormat<"void", !listconcat([v16i32, "int const *"], params)>;
  defm _f32 : RISCVMPEBuiltinFormat<"void", !listconcat([v16f32, "float const *"], params)>;
}

multiclass RISCVMPEBuiltinStore {
  defm ""         : RISCVMPEBuiltinStoreBase<[]>;
  defm _stride    : RISCVMPEBuiltinStoreBase<["size_t"]>;
  defm _rowstride : RISCVMPEBuiltinStoreBase<["size_t"]>;
}

let Features = "xmpe" in {
  defm load : RISCVMPEBuiltinLoad;
  defm store : RISCVMPEBuiltinStore;
} // Features = "xmpe"

//===----------------------------------------------------------------------===//
// MOVE BUILTINS
//===----------------------------------------------------------------------===//

let Features = "xmpe" in {
  defm move_mm_i32 : RISCVMPEBuiltinFormat<v16i32, [v16i32]>;
  defm move_mm_f32 : RISCVMPEBuiltinFormat<v16f32, [v16f32]>;
  defm move_zm_i32 : RISCVMPEBuiltinFormat<v16i32, [v16i32]>;
  defm move_zm_f32 : RISCVMPEBuiltinFormat<v16f32, [v16f32]>;
  defm move_xm     : RISCVMPEBuiltinFormat<v16i32, ["long int"]>;
  defm move_xz     : RISCVMPEBuiltinFormat<v16i32, ["long int"]>;
  defm move_zx     : RISCVMPEBuiltinFormat<"long int", [v16i32]>;
  defm move_fm     : RISCVMPEBuiltinFormat<v16f32, ["float"]>;
  defm move_fz     : RISCVMPEBuiltinFormat<v16f32, ["float"]>;
  defm move_zf     : RISCVMPEBuiltinFormat<"float", [v16f32]>;
} // Features = "xmpe"
