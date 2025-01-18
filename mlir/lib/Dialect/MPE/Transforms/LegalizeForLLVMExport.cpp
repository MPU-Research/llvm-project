//===- LegalizeForLLVMExport.cpp - Prepare MPE for LLVM translation -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/LLVMCommon/ConversionTarget.h"
#include "mlir/Conversion/LLVMCommon/Pattern.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/MPE/MPEDialect.h"
#include "mlir/Dialect/MPE/Transforms.h"
#include "mlir/Support/LLVM.h"
#include <optional>

using namespace mlir;
using namespace mlir::mpe;

#define DEBUG_TYPE "mpe"

//===----------------------------------------------------------------------===//
// HELPER FUNCTIONS
//===----------------------------------------------------------------------===//

namespace {

/// Convert an `!mpe.tile<4x4xT>` to `vector<16xT>` if possible.
std::optional<Type> convertMPETileToVector(TileType type) {
  if (type.getRank() != 2)
    return std::nullopt;
  int64_t numElements;
  if ((numElements = type.getNumElements()) != 16)
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

//===----------------------------------------------------------------------===//
// CONVERSION PATTERNS
//===----------------------------------------------------------------------===//

namespace {

/// Lower an `mpe.load` to the corresponding intrinsic operation. The MPE tile
/// becomes a flattened vector and the memref uses the default lowering to a
/// struct with five member variables.
///
/// For more details on the MemRef lowering, see
/// https://mlir.llvm.org/docs/TargetLLVMIR/#ranked-memref-types.
///
/// The original operation
///
///   %tile = mpe.load %memref[%i, %j] : memref<4x4xf32> into !mpe.tile<4x4xf32>
///
/// becomes
///
///   %vec = "mpe.intr.load.us"(%ptr) : (!llvm.ptr) -> vector<16xf32>
struct LoadOpConversion : public ConvertOpToLLVMPattern<LoadOp> {
  using ConvertOpToLLVMPattern<LoadOp>::ConvertOpToLLVMPattern;
  using LoadTy = riscv_mpe_load_us;

  LogicalResult
  matchAndRewrite(LoadOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    LLVM_DEBUG(llvm::dbgs() << "[MPE] Legalizing `LoadOp`\n");

    Type type = typeConverter->convertType(op.getResTileType());
    Location loc = op.getLoc();
    Value ptr =
        getStridedElementPtr(loc, op.getBaseMemRefType(), adaptor.getBase(),
                             adaptor.getIndices(), rewriter);
    rewriter.replaceOpWithNewOp<LoadTy>(op, type, ptr);
    return success();
  }
};

/// Lower an `mpe.store` to the corresponding intrinsic operation. The MPE tile
/// becomes a flattened vector and the memref uses the default lowering to a
/// struct with five member variables.
///
/// For more details on the MemRef lowering, see
/// https://mlir.llvm.org/docs/TargetLLVMIR/#ranked-memref-types.
///
/// The original operation
///
///   mpe.store %memref[%i, %j], %tile : memref<4x4xf32>, !mpe.tile<4x4xf32>
///
/// becomes
///
///   "mpe.intr.store.us"(%ptr, %vec) : (!llvm.ptr, vector<16xf32>) -> ()
struct StoreOpConversion : public ConvertOpToLLVMPattern<StoreOp> {
  using ConvertOpToLLVMPattern<StoreOp>::ConvertOpToLLVMPattern;
  using StoreTy = riscv_mpe_store_us;

  LogicalResult
  matchAndRewrite(StoreOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    LLVM_DEBUG(llvm::dbgs() << "[MPE] Legalizing `StoreOp`\n");

    Location loc = op.getLoc();
    Value tile = adaptor.getTile();
    Value ptr =
        getStridedElementPtr(loc, op.getBaseMemRefType(), adaptor.getBase(),
                             adaptor.getIndices(), rewriter);

    rewriter.replaceOpWithNewOp<StoreTy>(op, TypeRange(), tile, ptr);
    return success();
  }
};

/// Lower an `mpe.zero` to the corresponding intrinsic operation. The MPE tile
/// becomes a flattened vector.
///
/// The original operation
///
///  %tile = mpe.zero : !mpe.tile<4x4xf32>
///
/// becomes
///
///   %cst = llvm.mlir.constant(0 : i32) : i64
///   %vec = "mpe.intr.move.xm"(%cst) : (i64) -> vector<16xf32>
struct ZeroOpConversion : public ConvertOpToLLVMPattern<ZeroOp> {
  using ConvertOpToLLVMPattern<ZeroOp>::ConvertOpToLLVMPattern;
  using MoveXMTy = riscv_mpe_move_xm;

  LogicalResult
  matchAndRewrite(ZeroOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    LLVM_DEBUG(llvm::dbgs() << "[MPE] Legalizing `ZeroOp`\n");

    Type type = typeConverter->convertType(op.getResTileType());
    Location loc = op.getLoc();
    Value zero = createIntConstant(rewriter, loc, /*width*/ 64, /*value*/ 0);

    rewriter.replaceOpWithNewOp<MoveXMTy>(op, type, zero);
    return success();
  }
};

/// Lower an `mpe.multiply` to the corresponding intrinsic. The MPE tiles become
/// flattened vectors.
///
/// The original operation
///
///   %tile = mpe.multiply %0, %1, %2 : !mpe.tile<4x4xf32>
///
/// becomes
///
///   %vec = "mpe.intr.mac.f32"(%v0, %v1, %v2)
///        : (vector<16xf32>, vector<16xf32>, vector<16xf32>) -> vector<16xf32>
struct MultiplyOpConversion : public ConvertOpToLLVMPattern<MultiplyOp> {
  using ConvertOpToLLVMPattern<MultiplyOp>::ConvertOpToLLVMPattern;
  using MacTy = mpe::riscv_mpe_mac_f32;

  LogicalResult
  matchAndRewrite(MultiplyOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    LLVM_DEBUG(llvm::dbgs() << "[MPE] Legalizing `MultiplyOp`\n");

    Type type = typeConverter->convertType(op.getType());
    Value lhs = adaptor.getLhs();
    Value rhs = adaptor.getRhs();
    // Value acc = adaptor.getAcc();

    rewriter.replaceOpWithNewOp<MacTy>(op, type, lhs, rhs);
    return success();
  }
};

} // namespace

//===----------------------------------------------------------------------===//
// PUBLIC API
//===----------------------------------------------------------------------===//

void mlir::populateMPELegalizeForLLVMExportPatterns(
    LLVMTypeConverter &converter, RewritePatternSet &patterns) {
  LLVM_DEBUG(llvm::dbgs() << "[MPE] Populating legalization patterns\n");

  patterns.add<LoadOpConversion>(converter);
  patterns.add<StoreOpConversion>(converter);
  patterns.add<ZeroOpConversion>(converter);
  patterns.add<MultiplyOpConversion>(converter);

  converter.addConversion(convertMPETileToVector);
}

void mlir::configureMPELegalizeForLLVMExportTarget(
    LLVMConversionTarget &target) {
  LLVM_DEBUG(llvm::dbgs() << "[MPE] Configuring conversion target\n");

  target.addIllegalOp<MultiplyOp, LoadOp, StoreOp, ZeroOp>();
  target.addLegalOp<riscv_mpe_load_us, riscv_mpe_store_us, riscv_mpe_move_xm,
                    riscv_mpe_mac_f32>();
}
