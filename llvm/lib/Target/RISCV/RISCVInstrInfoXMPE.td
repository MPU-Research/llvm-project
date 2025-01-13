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
// Minor opcodes
//===----------------------------------------------------------------------===//

def MPEMinorOpSys : MPEMinorOp<0b000>;
def MPEMinorOpMem : MPEMinorOp<0b001>;
def MPEMinorOpMov : MPEMinorOp<0b010>;
def MPEMinorOpAlu : MPEMinorOp<0b011>;

//===----------------------------------------------------------------------===//
// Memory operation encoding
//===----------------------------------------------------------------------===//

def MPEMemLoadContiguous  : MPEMemOp<0b000>;
def MPEMemStoreContiguous : MPEMemOp<0b001>;

//===----------------------------------------------------------------------===//
// Arithmetic operation encoding
//===----------------------------------------------------------------------===//

def MPEAluMac : MPEAluOp<0b000>;
def MPEAluAdd : MPEAluOp<0b001>;
def MPEAluSub : MPEAluOp<0b010>;

//===----------------------------------------------------------------------===//
// Move operation encoding
//===----------------------------------------------------------------------===//

def MPEMovMM : MPEMovOp<0b00000>;
def MPEMovXM : MPEMovOp<0b00001>;
def MPEMovZX : MPEMovOp<0b00010>;
def MPEMovXZ : MPEMovOp<0b00011>;
def MPEMovZM : MPEMovOp<0b00100>;
def MPEMovFM : MPEMovOp<0b00101>;
def MPEMovZF : MPEMovOp<0b00110>;
def MPEMovFZ : MPEMovOp<0b00111>;

//===----------------------------------------------------------------------===//
// Data type encoding
//===----------------------------------------------------------------------===//

def MPEIntUnsigned : MPEDataType<0b00>;
def MPEIntSigned   : MPEDataType<0b01>;
def MPEFloat       : MPEDataType<0b10>;

//===----------------------------------------------------------------------===//
// Instruction formats
//===----------------------------------------------------------------------===//

//===-- MEMORY INSTRUCTIONS -----------------------------------------------===//

class MPEInstMemBase<string opcodestr, string argstr, MPEMemOp mmop, dag outs,
                     dag ins>
    : MPEInstBase<MPEMinorOpMem, outs, ins, opcodestr, argstr> {
  bits<5> md;
  bits<5> rs1;

  let Inst{28-26} = 0;
  let Inst{25} = 1;
  let Inst{24-20} = 0;
  let Inst{19-15} = rs1;
  let Inst{14-12} = mmop.Value;
  let Inst{11-7} = md;
}

class MPEInstMem<string opcodestr, MPEMemOp mmop>
    : MPEInstMemBase<opcodestr, "$md, $rs1", mmop,
                     (outs MR:$md),
                     (ins GPRMemZeroOffset:$rs1)>;

let Predicates = [HasVendorXMPE] in {
let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in {
  def MLD : MPEInstMem<"ml", MPEMemLoadContiguous>;
} // hasSideEffects = 0, mayLoad = 1, mayStore = 0
} // Predicates = [HasVendorXMPE]

let Predicates = [HasVendorXMPE] in {
let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in {
  def MST : MPEInstMem<"ms", MPEMemStoreContiguous>;
} // hasSideEffects = 0, mayLoad = 0, mayStore = 1
} // Predicates = [HasVendorXMPE]

//===-- ARITHMETIC INSTRUCTIONS -------------------------------------------===//

class MPEInstAluBase<string opcodestr, string argstr, dag outs, dag ins,
                     MPEAluOp maop, MPEDataType dt>
    : MPEInstBase<MPEMinorOpAlu, outs, ins, opcodestr, argstr> {
  bits<5> md;
  bits<5> ms1;
  bits<5> ms2;

  let Inst{28} = 0;
  let Inst{27-26} = dt.Value;
  let Inst{25} = 1;
  let Inst{24-20} = ms2;
  let Inst{19-15} = ms1;
  let Inst{14-12} = maop.Value;
  let Inst{11-7} = md;
}

class MPEInstAlu<string opcodestr, MPEAluOp maop, MPEDataType dt>
    : MPEInstAluBase<opcodestr, "$md, $ms1, $ms2", (outs MR:$md),
                     (ins MR:$ms1, MR:$ms2), maop, dt>;

multiclass MPEInstAlu_SUF<string opcodestr, MPEAluOp maop> {
  def   : MPEInstAlu<opcodestr, maop, MPEIntSigned>;
  def U : MPEInstAlu<opcodestr # "u", maop, MPEIntUnsigned>;
  def F : MPEInstAlu<opcodestr # "f", maop, MPEFloat>;
}

let Predicates = [HasVendorXMPE] in {
let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
  defm MADD : MPEInstAlu_SUF<"madd", MPEAluAdd>;
  defm MSUB : MPEInstAlu_SUF<"msub", MPEAluSub>;
  defm MMAC : MPEInstAlu_SUF<"mmac", MPEAluMac>;
} // hasSideEffects = 0, mayLoad = 0, mayStore = 0
} // Predicates = [HasVendorXMPE]
