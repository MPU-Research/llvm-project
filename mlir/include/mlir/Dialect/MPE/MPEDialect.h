//===- MPEDialect.h - MLIR Dialect for MPE ----------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the Target dialect for MPE in MLIR.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_MPE_MPEDIALECT_H
#define MLIR_DIALECT_MPE_MPEDIALECT_H

#include "mlir/IR/Dialect.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

#include "mlir/Dialect/MPE/MPEDialect.h.inc"

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/MPE/MPETypes.h.inc"

#define GET_OP_CLASSES
#include "mlir/Dialect/MPE/MPE.h.inc"

#endif // MLIR_DIALECT_MPE_MPEDIALECT_H
