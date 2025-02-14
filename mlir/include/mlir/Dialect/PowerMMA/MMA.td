//===-- MMA.td - MMA dialect operation definitions *- tablegen -*----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the basic operations for the MMA dialect.
//
//===----------------------------------------------------------------------===//

include "mlir/Dialect/LLVMIR/LLVMOpBase.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/BuiltinTypes.td"

//===----------------------------------------------------------------------===//
// MMA dialect declaration
//===----------------------------------------------------------------------===//

// Dialect definition.
def MMA_Dialect : Dialect {
  let name = "mma";
  let cppNamespace = "::mlir::mma";
  let summary = "IBM Power 10 MMA Unit Dialect";
  let description = [{
    This dialect bridges vector and memref dialect to MMA supported operations.
  }];
  let dependentDialects = [
    "::mlir::vector::VectorDialect",
  ];
  let useDefaultTypePrinterParser = 1;
}

//===----------------------------------------------------------------------===//
// MMA Op and IntrOp declaration
//===----------------------------------------------------------------------===//

// Base class for MMA dialect ops that do not correspond to library calls.
class MMA_Op<string mnemonic, list<Trait> traits = []>
    : Op<MMA_Dialect, mnemonic, traits>;

// The "internal" intrinsics are meant for compiler usage.
class MMA_IntrOp<string mnemonic, int numResults, list<Trait> traits = []>
    : LLVM_IntrOpBase<MMA_Dialect, "intr." # mnemonic,
                      "ppc_mma_" # !subst(".", "_", mnemonic),
                      [], [], traits, numResults>;

// The "internal" intrinsics are meant for compiler usage.
class VSX_IntrOp<string mnemonic, int numResults, list<Trait> traits = []>
    : LLVM_IntrOpBase<MMA_Dialect, "intr." # mnemonic,
                      "ppc_vsx_" # !subst(".", "_", mnemonic),
                      [], [], traits, numResults>;

//===----------------------------------------------------------------------===//
// MMA TileType definition
//===----------------------------------------------------------------------===//

/// Base class for MMA types
class MMA_Type<string name, string mnemonicArg, list<Trait> traits = []>
    : TypeDef<MMA_Dialect, name, traits> {
  let mnemonic = mnemonicArg;
}

def MMA_TileTypeElementType : AnyTypeOf<[F32]> {
  let cppFunctionName = "isValidTileTypeElementType";
}

def MMA_TileType : MMA_Type<"Tile", "tile", [ShapedTypeInterface, ValueSemantics]> {
  let summary = "MMA 1D vector to be used by MMA operations.";

  let parameters = (ins
    ArrayRefParameter<"int64_t">:$shape,
    MMA_TileTypeElementType:$elementType
  );

  let builders = [
    TypeBuilderWithInferredContext<
      (ins "ArrayRef<int64_t>":$shape, "Type":$elementType), [{
        return $_get(elementType.getContext(), shape, elementType);
    }]>
  ];

  let extraClassDeclaration = [{
    // Returns if this type is ranked (always true)
    bool hasRank() const { return true; }

    // Clone this tile type with the given shape and element type. If the
    // provided shape is `std::nullopt`, the current shape of the type is used.
    TileType cloneWith(std::optional<ArrayRef<int64_t>> shape, Type elementType) const {
      return get(shape.value_or(getShape()), elementType);
    }
  }];

  let hasCustomAssemblyFormat = 1;
  let skipDefaultBuilders = 1;
}

def IsMMATilePred : And<[
  CPred<[{::llvm::isa<::mlir::mma::TileType>($_self)}]>,
  CPred<[{::llvm::cast<::mlir::mma::TileType>($_self).getRank() == 2}]>]>;

def IsMMAVectorPred : And<[
  CPred<[{::llvm::isa<::mlir::mma::TileType>($_self)}]>,
  CPred<[{::llvm::cast<::mlir::mma::TileType>($_self).getRank() == 1}]>]>;

class MMATileOf<list<Type> allowedTypes>
    : ShapedContainerType<allowedTypes, IsMMATilePred, "tile",
                          "::mlir::mma::TileType">;

class MMAVectorOf<list<Type> allowedTypes>
    : ShapedContainerType<allowedTypes, IsMMAVectorPred, "tile",
                          "::mlir::mma::TileType">;

def AnyMMATile   : MMATileOf<[F32]>;
def AnyMMAVector : MMAVectorOf<[F32]>;
def AnyMMATensor : AnyTypeOf<[AnyMMATile, AnyMMAVector]>;

//===----------------------------------------------------------------------===//
// MMA operation definition
//===----------------------------------------------------------------------===//

def LoadOp : MMA_Op<"load", [Pure]> {
  let summary = "Load value into MMA accumulator";
  let description = [{
    LoadOp

    ```mlir
    %0 = mma.load %base[%i, %j] : memref<?x?xf16> into vector <4x4xf32>
    ```
  }];

  let arguments = (ins
    Arg<AnyMemRef, "load base", [MemRead]>:$base,
    Variadic<Index>:$indices
  );

  let results = (outs AnyMMATensor:$res);

  let extraClassDeclaration = [{
    MemRefType getBaseMemRefType() {
      return ::mlir::cast<MemRefType>(getBase().getType());
    }

    TileType getResTileType() {
      return ::mlir::cast<TileType>(getRes().getType());
    }
  }];

  let assemblyFormat = "$base `[` $indices `]` attr-dict `:` type($base) `into` type($res)";
  let hasVerifier = 1;
}

def StoreOp : MMA_Op<"store", [Pure]> {
  let summary = "Stores value from MMA accumulator";
  let description = [{
    StoreOp

    ```mlir
    mma.store %base[%i, %j], %0 : memref<?x?xi32> `,` vector<4x4xi32>
    ```
  }];

  let arguments = (ins
    Arg<AnyMemRef, "store base", [MemWrite]>:$base,
    Variadic<Index>:$indices,
    AnyMMATensor:$val
  );

  let extraClassDeclaration = [{
    MemRefType getBaseMemRefType() {
      return ::mlir::cast<MemRefType>(getBase().getType());
    }

    TileType getValTileType() {
      return ::mlir::cast<TileType>(getVal().getType());
    }
  }];

  let assemblyFormat = "$base `[` $indices `]` `,` $val attr-dict `:` type($base) `,` type($val)";
  let hasVerifier = 1;
}

def ZeroOp : MMA_Op<"zero", [Pure]> {
  let summary = "Initializes an accumulator with all zeros";
  let description = [{
    ZeroOp

    ```mlir
    %0 = mma.zero : vector<4x4xf32>
    ```
  }];

  let arguments = (ins);
  let results = (outs AnyMMATile:$res);

  let extraClassDeclaration = [{
    TileType getResTileType() {
      return ::mlir::cast<TileType>(getRes().getType());
    }
  }];

  let assemblyFormat = "attr-dict `:` type($res)";
  let hasVerifier = 1;
}

def OuterProductFOp : MMA_Op<"outer", [
    Pure, AllTypesMatch<["acc", "res"]>, AllTypesMatch<["lhs", "rhs"]>]> {
  let summary = "Performs the outer product between LHS and RHS and add to the accumulator";
  let description = [{
    OuterProductFHOp

    ```mlir
    %0 = mma.outer %a, %b, %c : vector<4xf32>, vector<4xf32>, vector<4x4xf32>
    ```
  }];

  let arguments = (ins
    AnyMMAVector:$lhs,
    AnyMMAVector:$rhs,
    AnyMMATile:$acc
  );

  let results = (outs AnyMMATile:$res);

  let extraClassDeclaration = [{
    TileType getLhsTileType() {
      return ::mlir::cast<TileType>(getLhs().getType());
    }

    TileType getRhsTileType() {
      return ::mlir::cast<TileType>(getRhs().getType());
    }

    TileType getAccTileType() {
      return ::mlir::cast<TileType>(getAcc().getType());
    }

    TileType getResTileType() {
      return ::mlir::cast<TileType>(getRes().getType());
    }
  }];

  let assemblyFormat = "$lhs `,` $rhs `,` $acc attr-dict `:` type($lhs) `->` type($acc)";
  let hasVerifier = 1;
}

//===----------------------------------------------------------------------===//
// MMA intrinsic operation definition
//===----------------------------------------------------------------------===//

// Load VSX Vector
def LLVM_ppc_vsx_lxvl : VSX_IntrOp<"lxvl", 1>,
    Arguments<(ins LLVM_AnyPointer, AnyInteger)>;

// Store VSX Vector
def LLVM_ppc_vsx_stxvl : VSX_IntrOp<"stxvl", 0>,
    Arguments<(ins LLVM_Type, LLVM_AnyPointer, AnyInteger)>;

// VSX Set Accumulator to Zero
def LLVM_ppc_mma_xxsetaccz : MMA_IntrOp<"xxsetaccz", 1>,
    Arguments<(ins)>;

// VSX Move From Accumulator
def LLVM_ppc_mma_xxmfacc : MMA_IntrOp<"xxmfacc", 1>,
    Arguments<(ins LLVM_Type)>;

// VSX move to accumulator
def LLVM_ppc_mma_xxmtacc : MMA_IntrOp<"xxmtacc", 1>,
    Arguments<(ins LLVM_Type)>;

// VSX Vector 32-bit Floating-Point GER (rank-1)
def LLVM_ppc_mma_xvf32gerpp : MMA_IntrOp<"xvf32gerpp", 1>,
    Arguments<(ins LLVM_Type, LLVM_Type, LLVM_Type)>;
