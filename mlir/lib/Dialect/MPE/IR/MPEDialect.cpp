//===- MPEDialect.cpp - MLIR MPE ops implementation -----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the MPE dialect and its operations.
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/MPE/MPEDialect.h"
#include "mlir/Dialect/LLVMIR/LLVMTypes.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/IR/TypeUtilities.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;

// ===-----------------------------------------------------------------------===
// INCLUDE OPS AND TYPES
// ===-----------------------------------------------------------------------===

#include "mlir/Dialect/MPE/MPEDialect.cpp.inc"

#define GET_OP_CLASSES
#include "mlir/Dialect/MPE/MPE.cpp.inc"

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/MPE/MPETypes.cpp.inc"

// ===-----------------------------------------------------------------------===
// DIALECT INITIALIZATION
// ===-----------------------------------------------------------------------===

void mlir::mpe::MPEDialect::initialize() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "mlir/Dialect/MPE/MPETypes.cpp.inc"
      >();

  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/MPE/MPE.cpp.inc"
      >();
}

// ===-----------------------------------------------------------------------===
// HELPER FUNCTIONS
// ===-----------------------------------------------------------------------===

namespace {} // namespace

// ===-----------------------------------------------------------------------===
// VERIFICATION
// ===-----------------------------------------------------------------------===

LogicalResult mpe::ZeroOp::verify() {
  // TODO
  return success();
}

LogicalResult mpe::LoadOp::verify() {
  // TODO
  return success();
}

LogicalResult mpe::StoreOp::verify() {
  // TODO
  return success();
}

LogicalResult mpe::MultiplyOp::verify() {
  // TODO
  return success();
}

// ===-----------------------------------------------------------------------===
// PARSING & PRINTING
// ===-----------------------------------------------------------------------===

Type mpe::TileType::parse(AsmParser &parser) {
  if (parser.parseLess())
    return nullptr;

  SmallVector<int64_t, 2> shape;
  if (parser.parseDimensionList(shape, false, true))
    return nullptr;

  Type elementType;
  if (parser.parseType(elementType))
    return nullptr;

  if (parser.parseGreater())
    return nullptr;

  return TileType::get(shape, elementType);
}

void mpe::TileType::print(AsmPrinter &os) const {
  os << '<';
  os.printDimensionList(getShape());
  os << 'x';
  os.printType(getElementType());
  os << '>';
}
