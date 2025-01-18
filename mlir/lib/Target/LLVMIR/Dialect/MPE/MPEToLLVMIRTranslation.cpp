//===- MPEToLLVMIRTranslation.cpp - Translate MPE to LLVM IR --------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements a translation between the MPE dialect and LLVM IR.
//
//===----------------------------------------------------------------------===//

#include "mlir/Target/LLVMIR/Dialect/MPE/MPEToLLVMIRTranslation.h"
#include "mlir/Dialect/MPE/MPEDialect.h"
#include "mlir/IR/Operation.h"
#include "mlir/Target/LLVMIR/ModuleTranslation.h"
#include "llvm/IR/IntrinsicsRISCV.h"

using namespace mlir;
using namespace mlir::LLVM;

namespace {
/// Implementation of the dialect interface that converts operations belonging
/// to the MPE dialect to LLVM IR.
class MPEDialectLLVMIRTranslationInterface
    : public LLVMTranslationDialectInterface {
public:
  using LLVMTranslationDialectInterface::LLVMTranslationDialectInterface;

  /// Translates the given operation to LLVM IR using the provided IR builder
  /// and saving the state in `moduleTranslation`.
  LogicalResult
  convertOperation(Operation *op, llvm::IRBuilderBase &builder,
                   LLVM::ModuleTranslation &moduleTranslation) const final {
    Operation &opInst = *op;
#include "mlir/Dialect/MPE/MPEConversions.inc"

    return failure();
  }
};
} // namespace

void mlir::registerMPEDialectTranslation(DialectRegistry &registry) {
  registry.insert<mpe::MPEDialect>();
  registry.addExtension(+[](MLIRContext *ctx, mpe::MPEDialect *dialect) {
    dialect->addInterfaces<MPEDialectLLVMIRTranslationInterface>();
  });
}

void mlir::registerMPEDialectTranslation(MLIRContext &context) {
  DialectRegistry registry;
  registerMPEDialectTranslation(registry);
  context.appendDialectRegistry(registry);
}
