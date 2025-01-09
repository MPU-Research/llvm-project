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

