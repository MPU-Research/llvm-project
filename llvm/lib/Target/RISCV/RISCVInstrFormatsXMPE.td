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

class MPEMinorOp<bits<3> val> {
  bits<3> Value = val;
}

class MPEMemOp<bits<3> val> {
  bits<3> Value = val;
}

class MPEAluOp<bits<3> val> {
  bits<3> Value = val;
}

class MPEMovOp<bits<5> val> {
  bits<5> Value = val;
}

class MPEDataType<bits<2> val> {
  bits<2> Value = val;
}

class MPEInstBase<MPEMinorOp minor, dag outs, dag ins, string opcodestr,
                  string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  let Inst{31-29} = minor.Value;
  let Inst{6-0} = OPC_OP_MATRIX.Value;

  let Uses = [MTYPE, ML, MRL];
}
