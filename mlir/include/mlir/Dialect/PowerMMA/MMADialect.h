//===- MMADialect.h - MLIR Dialect for MMA ----------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the Target dialect for MMA in MLIR.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_MMA_MMADIALECT_H
#define MLIR_DIALECT_MMA_MMADIALECT_H

#include "mlir/Bytecode/BytecodeOpInterface.h"
#include "mlir/Dialect/LLVMIR/LLVMTypes.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/IR/Types.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"

#include "mlir/Dialect/PowerMMA/MMADialect.h.inc"

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/PowerMMA/MMATypes.h.inc"

#define GET_OP_CLASSES
#include "mlir/Dialect/PowerMMA/MMA.h.inc"

#define MAX_ROWS 4
#define BITS_PER_ROW 128

#endif // MLIR_DIALECT_MMA_MMADIALECT_H
