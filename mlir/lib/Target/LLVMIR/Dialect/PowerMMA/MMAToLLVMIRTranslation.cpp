//===- MMAToLLVMIRTranslation.cpp - Translate MMA to LLVM IR --------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements a translation between the MMA dialect and LLVM IR.
//
//===----------------------------------------------------------------------===//

#include "mlir/Target/LLVMIR/Dialect/PowerMMA/MMAToLLVMIRTranslation.h"
#include "mlir/Dialect/PowerMMA/MMADialect.h"
#include "mlir/IR/Operation.h"
#include "mlir/Target/LLVMIR/ModuleTranslation.h"
#include "llvm/IR/IntrinsicsPowerPC.h"

using namespace mlir;
using namespace mlir::LLVM;

namespace {

class MMADialectLLVMIRTranslationInterface
    : public LLVMTranslationDialectInterface {
public:
  using LLVMTranslationDialectInterface::LLVMTranslationDialectInterface;

  LogicalResult
  convertOperation(Operation *op, llvm::IRBuilderBase &builder,
                   LLVM::ModuleTranslation &moduleTranslation) const final {
    Operation &opInst = *op;
#include "mlir/Dialect/PowerMMA/MMAConversions.inc"

    return failure();
  }
};

} // namespace

void mlir::registerMMADialectTranslation(DialectRegistry &registry) {
  registry.insert<mma::MMADialect>();
  registry.addExtension(+[](MLIRContext *ctx, mma::MMADialect *dialect) {
    dialect->addInterfaces<MMADialectLLVMIRTranslationInterface>();
  });
}

void mlir::registerMMADialectTranslation(MLIRContext &context) {
  DialectRegistry registry;
  registerMMADialectTranslation(registry);
  context.appendDialectRegistry(registry);
}
