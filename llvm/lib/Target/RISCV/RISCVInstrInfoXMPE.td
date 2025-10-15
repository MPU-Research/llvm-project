//===-- RISCVInstrInfoXMPE.td - 'XMPE' instructions --------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the RISC-V instructions from the vendor extension 'MPE'
// Matrix Processing Engine, version 0.1.
//
//===----------------------------------------------------------------------===//

include "RISCVInstrFormatsXMPE.td"

//===----------------------------------------------------------------------===//
// Mask operand class
//===----------------------------------------------------------------------===//

def MMaskAsmOperand : AsmOperandClass {
  let Name = "RVMPEMaskRegOpOperand";
  let RenderMethod = "addRegOperands";
  let PredicateMethod = "isM0Reg";
  let ParserMethod = "parseMaskReg";
  let IsOptional = 1;
  let DefaultMethod = "defaultMaskRegOp";
  let DiagnosticType = "InvalidMPEMaskRegister";
}

def MMaskOp : RegisterOperand<MMM0> {
  let ParserMatchClass = MMaskAsmOperand;
  let PrintMethod = "printMMaskReg";
  let EncoderMethod = "getMMaskReg";
  let DecoderMethod = "decodeMMaskReg";
}

//===----------------------------------------------------------------------===//
// Memory instructions
//===----------------------------------------------------------------------===//

class MPEInstMLU<string opcodestr>
    : MPEBaseInstMLU<opcodestr, "$md, $rs1$mrm",
                     (outs MR:$md),
                     (ins GPRMemZeroOffset:$rs1, MMaskOp:$mrm)>;

class MPEInstMLS<string opcodestr, MPEMemOp mmop>
    : MPEBaseInstMLS<opcodestr, "$md, $rs1, $rs2$mrm", mmop,
                     (outs MR:$md),
                     (ins GPRMemZeroOffset:$rs1, GPR:$rs2, MMaskOp:$mrm)>;

multiclass MPEInstLoad<string opcodestr> {
  def U  : MPEInstMLU<opcodestr>;
  def SS : MPEInstMLS<opcodestr # "ss", MPEMemElemStrided>;
  def S  : MPEInstMLS<opcodestr # "s",  MPEMemRowStrided>;
  // def X  : MPEInstMLX<opcodestr # "x">;
}

let Predicates = [HasVendorXMPE] in {
  let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in {
    defm ML : MPEInstLoad<"ml">;
  }
}

class MPEInstMSU<string opcodestr>
    : MPEBaseInstMSU<opcodestr, "$md, $rs1$mrm",
                     (outs),
                     (ins MR:$md, GPRMemZeroOffset:$rs1, MMaskOp:$mrm)>;

class MPEInstMSS<string opcodestr, MPEMemOp mmop>
    : MPEBaseInstMSS<opcodestr, "$md, $rs1, $rs2$mrm", mmop,
                     (outs),
                     (ins MR:$md, GPRMemZeroOffset:$rs1, GPR:$rs2, MMaskOp:$mrm)>;

multiclass MPEInstStore<string opcodestr> {
  def U  : MPEInstMSU<opcodestr>;
  def SS : MPEInstMSS<opcodestr # "ss", MPEMemElemStrided>;
  def S  : MPEInstMSS<opcodestr # "s",  MPEMemRowStrided>;
  // def X  : MPEInstMSX<opcodestr # "x">;
}

let Predicates = [HasVendorXMPE] in {
  let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in {
    defm MS : MPEInstStore<"ms">;
  }
}

//===----------------------------------------------------------------------===//
// Arithmetic instructions
//===----------------------------------------------------------------------===//

class MPEInstAlu<string opcodestr, MPEAluOp maop, MPEDataType dt>
    : MPEBaseInstAlu<opcodestr, "$md, $ms1, $ms2$mrm", maop, dt,
                     (outs MR:$md),
                     (ins MR:$ms1, MR:$ms2, MMaskOp:$mrm)>;

multiclass MPEInstAlu_S_U_F<string opcodestr, MPEAluOp maop> {
  def "" : MPEInstAlu<opcodestr,       maop, MPEIntSigned>;
  def U  : MPEInstAlu<opcodestr # "u", maop, MPEIntUnsigned>;
  def F  : MPEInstAlu<opcodestr # "f", maop, MPEFloat>;
}

class MPEInstAluWb<string opcodestr, MPEAluOp maop, MPEDataType dt>
    : MPEBaseInstAlu<opcodestr, "$md, $ms1, $ms2$mrm", maop, dt,
                     (outs MR:$md_wb),
                     (ins MR:$md, MR:$ms1, MR:$ms2, MMaskOp:$mrm)> {
  let Constraints = "$md = $md_wb";
}

multiclass MPEInstAluWb_S_U_F<string opcodestr, MPEAluOp maop> {
  def "" : MPEInstAluWb<opcodestr,       maop, MPEIntSigned>;
  def U  : MPEInstAluWb<opcodestr # "u", maop, MPEIntUnsigned>;
  def F  : MPEInstAluWb<opcodestr # "f", maop, MPEFloat>;
}

let Predicates = [HasVendorXMPE] in {
  let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
    defm MADD : MPEInstAlu_S_U_F<"madd", MPEAluAdd>;
    defm MSUB : MPEInstAlu_S_U_F<"msub", MPEAluSub>;
    defm MMAC : MPEInstAluWb_S_U_F<"mmac", MPEAluMac>;
  }
}

//===----------------------------------------------------------------------===//
// Move instructions
//===----------------------------------------------------------------------===//

class MPEInstMov<string opcodestr, MPEMovOp mmov, RegisterClass src, RegisterClass dst>
    : MPEBaseInstMov<opcodestr, "$rd, $rs1$mrm", mmov,
                     (outs dst:$rd),
                     (ins src:$rs1, MMaskOp:$mrm)>;

multiclass MPEInstMov_SFVM<string opcodestr> {
  def MM : MPEInstMov<opcodestr # ".mm", MPEMovMM, MR,    MR>;
  def XM : MPEInstMov<opcodestr # ".xm", MPEMovXM, GPR,   MR>;
  def ZX : MPEInstMov<opcodestr # ".zx", MPEMovZX, MR,    GPR>;
  def ZM : MPEInstMov<opcodestr # ".zm", MPEMovZM, MR,    MR>;
  def FM : MPEInstMov<opcodestr # ".fm", MPEMovFM, FPR32, MR>;
  def ZF : MPEInstMov<opcodestr # ".zf", MPEMovZF, MR,    FPR32>;
  def FZ : MPEInstMov<opcodestr # ".fz", MPEMovFZ, FPR32, MR>;
}

let Predicates = [HasVendorXMPE] in {
  let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
    defm MMV_ : MPEInstMov_SFVM<"mmv">;
  }
  def : InstAlias<"mzero $md$mrm", (MMV_XM MR:$md, X0, MMaskOp:$mrm)>;
  def : InstAlias<"mz $md$mrm",    (MMV_XM MR:$md, X0, MMaskOp:$mrm)>;
}

//===----------------------------------------------------------------------===//
// System instructions
//===----------------------------------------------------------------------===//

class MPEInstSys<string opcodestr, MPESysOp msys>
    : MPEBaseInstSys<opcodestr, "$rd, $rs1, $rs2", msys,
                     (outs GPR:$rd),
                     (ins GPR:$rs1, GPR:$rs2)>;

let Predicates = [HasVendorXMPE] in {
  let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
    def MSET : MPEInstSys<"mset", MPESysSet>;
  }
}
