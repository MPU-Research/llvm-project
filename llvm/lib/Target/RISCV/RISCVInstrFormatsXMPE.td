//===-- RISCVInstrFormatsXMPE.td - XMPE Instruction Formats --*- tablegen -*-=//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the RISC-V MPE vendor extension instruction formats.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Minor opcodes
//===----------------------------------------------------------------------===//

// Minor opcode (bits {31-29}) in MPE instructions.
class MPEMinorOp<bits<3> val> {
  bits<3> Value = val;
}

def MPEMinorOpSys : MPEMinorOp<0b000>;
def MPEMinorOpMem : MPEMinorOp<0b001>;
def MPEMinorOpMov : MPEMinorOp<0b010>;
def MPEMinorOpAlu : MPEMinorOp<0b011>;

//===----------------------------------------------------------------------===//
// Memory operation encoding
//===----------------------------------------------------------------------===//

// Kind of memory operation (bits {14-13}) in memory instructions.
// Bit 12 that indicates whether it is a load or store is NOT included.
class MPEMemOp<bits<2> val> {
  bits<2> Value = val;
}

def MPEMemContiguous  : MPEMemOp<0b00>; // Mnemonic: m<op>
def MPEMemElemStrided : MPEMemOp<0b01>; // Mnemonic: m<op>ss
def MPEMemRowStrided  : MPEMemOp<0b10>; // Mnemonic: m<op>s
def MPEMemIndexed     : MPEMemOp<0b11>; // Mnemonic: m<op>x

//===----------------------------------------------------------------------===//
// Arithmetic operation encoding
//===----------------------------------------------------------------------===//

// Kind of arithmetic operation (bits {14-12}) in arithmetic instructions.
class MPEAluOp<bits<3> val> {
  bits<3> Value = val;
}

def MPEAluMac : MPEAluOp<0b000>;  // Operation: md += rs1 * rs2
def MPEAluAdd : MPEAluOp<0b001>;  // Operation: md  = rs1 + rs2
def MPEAluSub : MPEAluOp<0b010>;  // Operation: md  = rs1 - rs2

//===----------------------------------------------------------------------===//
// Data type encoding
//===----------------------------------------------------------------------===//

// Data type (bits {27-26}) in arithmetic instructions.
class MPEDataType<bits<2> val> {
  bits<2> Value = val;
}

def MPEIntUnsigned : MPEDataType<0b00>; // i32
def MPEIntSigned   : MPEDataType<0b01>; // u32
def MPEFloat       : MPEDataType<0b10>; // f32

//===----------------------------------------------------------------------===//
// Move operation encoding
//===----------------------------------------------------------------------===//

// Kind of move operation (bits {24-20}) in move instructions.
class MPEMovOp<bits<5> val> {
  bits<5> Value = val;
}

// MPEMovXY where X is the source register class and Y is the destination
// register class. Legend:
// - M = Matrix register
// - Z = Element [0, 0] of matrix register
// - X = Scalar register
// - F = FP Register
def MPEMovMM : MPEMovOp<0b00000>; // MR      -> MR
def MPEMovXM : MPEMovOp<0b00001>; // GPR     -> MR
def MPEMovZX : MPEMovOp<0b00010>; // MR[0,0] -> GPR
def MPEMovXZ : MPEMovOp<0b00011>; // GPR     -> MR[0,0]
def MPEMovZM : MPEMovOp<0b00100>; // MR[0,0] -> MR
def MPEMovFM : MPEMovOp<0b00101>; // FPR     -> MR
def MPEMovZF : MPEMovOp<0b00110>; // MR[0,0] -> FPR
def MPEMovFZ : MPEMovOp<0b00111>; // FPR     -> MR[0,0]

//===----------------------------------------------------------------------===//
// Instruction formats
//===----------------------------------------------------------------------===//

// unit-stride load: <load> md, (rs1), m0.t
class MPEBaseInstMLU<string opcodestr, string argstr, dag outs, dag ins> 
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> md;
  bits<5> rs1;
  bit mrm;

  let Inst{31-29} = MPEMinorOpMem.Value;
  let Inst{28-26} = 0;
  let Inst{25} = mrm;
  let Inst{24-20} = 0;
  let Inst{19-15} = rs1;
  let Inst{14-13} = MPEMemContiguous.Value;
  let Inst{12} = 0;
  let Inst{11-7} = md;
  let Inst{6-0} = OPC_OP_MATRIX.Value;

  //let Uses = [MTYPE, ML];
}

// strided load: <load> md, (rs1), rs2, m0.t
class MPEBaseInstMLS<string opcodestr, string argstr, MPEMemOp mmop, dag outs, dag ins> 
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> md;
  bits<5> rs1;
  bits<5> rs2;
  bit mrm;

  let Inst{31-29} = MPEMinorOpMem.Value;
  let Inst{28-26} = 0;
  let Inst{25} = mrm;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-13} = mmop.Value;
  let Inst{12} = 0;
  let Inst{11-7} = md;
  let Inst{6-0} = OPC_OP_MATRIX.Value;

  //let Uses = [MTYPE, ML];
}

// unit-stride store: <store> ms, (rs1), m0.t
class MPEBaseInstMSU<string opcodestr, string argstr, dag outs, dag ins> 
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> md;
  bits<5> rs1;
  bit mrm;

  let Inst{31-29} = MPEMinorOpMem.Value;
  let Inst{28-26} = 0;
  let Inst{25} = mrm;
  let Inst{24-20} = 0;
  let Inst{19-15} = rs1;
  let Inst{14-13} = MPEMemContiguous.Value;
  let Inst{12} = 1;
  let Inst{11-7} = md;
  let Inst{6-0} = OPC_OP_MATRIX.Value;

  //let Uses = [MTYPE, ML];
}

// strided store: <store> md, (rs1), rs2, m0.t
class MPEBaseInstMSS<string opcodestr, string argstr, MPEMemOp mmop, dag outs, dag ins> 
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> md;
  bits<5> rs1;
  bits<5> rs2;
  bit mrm;

  let Inst{31-29} = MPEMinorOpMem.Value;
  let Inst{28-26} = 0;
  let Inst{25} = mrm;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-13} = mmop.Value;
  let Inst{12} = 1;
  let Inst{11-7} = md;
  let Inst{6-0} = OPC_OP_MATRIX.Value;

  //let Uses = [MTYPE, ML];
}

// alu instruction: <op> md, ms1, ms2, m0.t
class MPEBaseInstAlu<string opcodestr, string argstr, MPEAluOp maop, MPEDataType dt, dag outs, dag ins>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> md;
  bits<5> ms1;
  bits<5> ms2;
  bit mrm;

  let Inst{31-29} = MPEMinorOpAlu.Value;
  let Inst{28} = 0;
  let Inst{27-26} = dt.Value;
  let Inst{25} = mrm;
  let Inst{24-20} = ms2;
  let Inst{19-15} = ms1;
  let Inst{14-12} = maop.Value;
  let Inst{11-7} = md;
  let Inst{6-0} = OPC_OP_MATRIX.Value;

  //let Uses = [MTYPE, ML];
}

// mov instruction: <mov> md, ms1, m0.t
class MPEBaseInstMov<string opcodestr, string argstr, MPEMovOp mmov, dag outs, dag ins>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rd;
  bits<5> rs1;
  bit mrm;

  let Inst{31-29} = MPEMinorOpMov.Value;
  let Inst{28-26} = 0;
  let Inst{25} = mrm;
  let Inst{24-20} = mmov.Value;
  let Inst{19-15} = rs1;
  let Inst{14-12} = 0;
  let Inst{11-7} = rd;
  let Inst{6-0} = OPC_OP_MATRIX.Value;

  //let Uses = [MTYPE, ML];
}
