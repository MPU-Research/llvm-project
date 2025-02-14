//===- LegalizeForLLVMExport.cpp - Prepare MMA for LLVM translation -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/LLVMCommon/ConversionTarget.h"
#include "mlir/Conversion/LLVMCommon/Pattern.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/PowerMMA/MMADialect.h"
#include "mlir/Dialect/PowerMMA/Transforms.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"
#include <optional>

using namespace mlir;
using namespace mlir::mma;

#define DEBUG_TYPE "mma"

// ===---------------------------------------------------------------------===//
// HELPER FUNCTIONS
// ===---------------------------------------------------------------------===//

namespace {

/// Convert an `!mma.tile<?x?xT>` into `vector<?xT>` if possible. Only works if
/// the tile type has shape either 4x4 (matrix) of 4 (vector).
std::optional<Type> convertMMATileToVector(TileType type) {
  int64_t rank = type.getRank();
  if (rank != 1 && rank != 2)
    return std::nullopt;
  int64_t numElements = type.getNumElements();
  if (numElements != 4 && numElements != 16)
    return std::nullopt;
  // Return flattened representation
  return VectorType::get({numElements}, type.getElementType());
}

/// Create integer constant with specified value and bit width.
LLVM::ConstantOp createIntConstant(ConversionPatternRewriter &rewriter,
                                   Location loc, int64_t width, int64_t value) {
  MLIRContext *ctx = rewriter.getContext();
  Type type = IntegerType::get(ctx, width);
  IntegerAttr zero = rewriter.getI64IntegerAttr(value);
  return rewriter.create<LLVM::ConstantOp>(loc, type, zero);
}

} // namespace

// ===---------------------------------------------------------------------===//
// CONVERSION PATTERNS
// ===---------------------------------------------------------------------===//

namespace {

/// Lower an `mma.load` to the corresponding intrinsic operation. The MMA tile
/// becomes a flattened vector and the memref uses the default loweing to a
/// struct with five member variables.
///
/// For more details on the MemRef lowering, see
/// https://mlir.llvm.org/docs/TargetLLVMIR/#ranked-memref-types.
///
/// The operation
///
///   %tile = mma.load %memref[%i, %j] : memref<4x4xf32> into !mma.tile<4x4xf32>
///
/// becomes
///
///   %vec = "mma.intr.lxvl"(%ptr, %size) : (!llvm.ptr, i64) -> vector<16xf32>
struct LoadOpConversion : public ConvertOpToLLVMPattern<LoadOp> {
  using ConvertOpToLLVMPattern<LoadOp>::ConvertOpToLLVMPattern;
  using LoadTy = ppc_vsx_lxvl;

  LogicalResult
  matchAndRewrite(LoadOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    LLVM_DEBUG(llvm::dbgs() << "[MMA] Legalizing `LoadOp`\n");

    Type type = typeConverter->convertType(op.getResTileType());
    Location loc = op.getLoc();

    // The pointer where to store tile
    Value ptr =
        getStridedElementPtr(loc, op.getBaseMemRefType(), adaptor.getBase(),
                             adaptor.getIndices(), rewriter);

    // The size of the tile
    Value n = createIntConstant(rewriter, loc, /*width*/ 64,
                                /*value*/ op.getResTileType().getNumElements());

    rewriter.replaceOpWithNewOp<LoadTy>(op, type, ptr, n);
    return success();
  }
};

/// Lower an `mma.store` to the corresponding intrinsic operation. The MMA tile
/// becomes a flattened vector and the memref uses the default loweing to a
/// struct with five member variables.
///
/// For more details on the MemRef lowering, see
/// https://mlir.llvm.org/docs/TargetLLVMIR/#ranked-memref-types.
///
/// The operation
///
///   mma.store %memref[%i, %j], %tile : memref<4x4xf32>, !mma.tile<4x4xf32>
///
/// becomes
///
///   "mma.intr.stxvl"(%vec, %ptr, %size)
///       : (vector<16xf32>, !llvm.ptr, i64) -> ()
struct StoreOpConversion : public ConvertOpToLLVMPattern<StoreOp> {
  using ConvertOpToLLVMPattern<StoreOp>::ConvertOpToLLVMPattern;
  using StoreTy = ppc_vsx_stxvl;

  LogicalResult
  matchAndRewrite(StoreOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    LLVM_DEBUG(llvm::dbgs() << "[MMA] Legalizing `StoreOp`\n");

    Location loc = op.getLoc();
    Value val = adaptor.getVal();
    Value c16 = createIntConstant(rewriter, loc, /*width*/ 64, /*value*/ 16);
    Value ptr =
        getStridedElementPtr(loc, op.getBaseMemRefType(), adaptor.getBase(),
                             adaptor.getIndices(), rewriter);

    rewriter.replaceOpWithNewOp<StoreTy>(op, TypeRange(), val, ptr, c16);
    return success();
  }
};

/// Lower an `mma.zero` to the corresponding intrinsic operation. The resulting
/// MMA tile becomes a flattened vector.
///
/// The operation
///
///   %tile = mma.zero : !mma.tile<4x4xf32>
///
/// becomes
///
///   %vec = "mma.intr.xxsetaccz"() : () -> (vec<16xf32>)
struct ZeroOpConversion : public ConvertOpToLLVMPattern<ZeroOp> {
  using ConvertOpToLLVMPattern<ZeroOp>::ConvertOpToLLVMPattern;
  using ZeroTy = ppc_mma_xxsetaccz;

  LogicalResult
  matchAndRewrite(ZeroOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    LLVM_DEBUG(llvm::dbgs() << "[MMA] Legalizing `ZeroOp`\n");

    Type type = typeConverter->convertType(op.getResTileType());

    rewriter.replaceOpWithNewOp<ZeroTy>(op, type);
    return success();
  }
};

/// Lower an `mma.outer` to the corresponding intrinsic operation. The MMA tiles
/// become flattened vectors.
///
/// The operation
///
///   %tile = mma.outer %0, %1, %2 : !mma.tile<4xf32> -> !mma.tile<4x4xf32>
///
/// becomes
///
///   %vec = "mma.intr.xvf32gerpp"(%v2, %v0, %v1)
///        : (vector<16xf32>, vector<4xf32>, vector<4xf32>) -> vector<16xf32>
struct OuterProductFOpConversion
    : public ConvertOpToLLVMPattern<OuterProductFOp> {
  using ConvertOpToLLVMPattern<OuterProductFOp>::ConvertOpToLLVMPattern;
  using OuterTy = ppc_mma_xvf32gerpp;

  LogicalResult
  matchAndRewrite(OuterProductFOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    LLVM_DEBUG(llvm::dbgs() << "[MMA] Legalizing `OuterProductFOp`\n");

    Type type = typeConverter->convertType(op.getResTileType());
    Value lhs = adaptor.getLhs();
    Value rhs = adaptor.getRhs();
    Value acc = adaptor.getAcc();

    rewriter.replaceOpWithNewOp<OuterTy>(op, type, acc, lhs, rhs);
    return success();
  }
};

} // namespace

// ===---------------------------------------------------------------------===//
// PUBLIC API
// ===---------------------------------------------------------------------===//

void mlir::populateMMALegalizeForLLVMExportPatterns(
    LLVMTypeConverter &converter, RewritePatternSet &patterns) {
  LLVM_DEBUG(llvm::dbgs() << "[MMA] Populating legalization patterns\n");

  patterns.add<LoadOpConversion>(converter);
  patterns.add<StoreOpConversion>(converter);
  patterns.add<ZeroOpConversion>(converter);
  patterns.add<OuterProductFOpConversion>(converter);

  converter.addConversion(convertMMATileToVector);
}

void mlir::configureMMALegalizeForExportTarget(LLVMConversionTarget &target) {
  LLVM_DEBUG(llvm::dbgs() << "[MMA] Configuring conversion target\n");

  target.addIllegalOp<LoadOp, StoreOp, ZeroOp, OuterProductFOp>();
  target.addLegalOp<ppc_vsx_lxvl, ppc_vsx_stxvl, ppc_mma_xxsetaccz,
                    ppc_mma_xxmtacc, ppc_mma_xxmfacc, ppc_mma_xvf32gerpp>();
}
