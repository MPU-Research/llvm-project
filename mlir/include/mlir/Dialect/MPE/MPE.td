//===-- MPE.td - MPE dialect operation definitions *- tablegen -*----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the basic operations for the MPE dialect.
//
// The Matrix Processing Engine (MPE) is a RISC-V processor that implements
// instructions for operating on matrices. This MLIR dialects serves to link
// high-level linear algebra operations to low-level LLVM IR intrinsics.
//
//===----------------------------------------------------------------------===//

#ifndef MPE
#define MPE

include "mlir/Dialect/LLVMIR/LLVMOpBase.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/BuiltinTypes.td"

//===----------------------------------------------------------------------===//
// MPE dialect definition
//===----------------------------------------------------------------------===//

def MPE_Dialect : Dialect {
  let name = "mpe";
  let cppNamespace = "::mlir::mpe";
  let dependentDialects = [
    "vector::VectorDialect",
  ];
  let useDefaultTypePrinterParser = 1;
}

//===----------------------------------------------------------------------===//
// MPE Op and IntrOp definitions
//===----------------------------------------------------------------------===//

class MPE_Op<string mnemonic, list<Trait> traits = []>
    : Op<MPE_Dialect, mnemonic, traits>;

class MPE_IntrOp<string mnemonic, int numResults,
                 list<int> overloadedResults = [],
                 list<int> overloadedOperands = [],
                 list<Trait> traits = []>
  : LLVM_IntrOpBase<MPE_Dialect, "intr." # mnemonic,
                  "riscv_mpe_" # !subst(".", "_", mnemonic),
                  overloadedResults, overloadedOperands, traits, numResults>;

//===----------------------------------------------------------------------===//
// MPE Tile Type definition.
//===----------------------------------------------------------------------===//

class MPE_Type<string name, string typeMnemonic, list<Trait> traits = []>
    : TypeDef<MPE_Dialect, name, traits> {
  let mnemonic = typeMnemonic;
}

def MPE_TileTypeElementType : AnyTypeOf<[F32]> {
  let cppFunctionName = "isValidTileTypeElementType";
}

def MPE_TileType : MPE_Type<"Tile", "tile", [ShapedTypeInterface, ValueSemantics]> {
  let summary = "MPE 2D tile to be used by MPE operations.";

  let parameters = (ins
    ArrayRefParameter<"int64_t">:$shape,
    MPE_TileTypeElementType:$elementType
  );

  let builders = [
    TypeBuilderWithInferredContext<(ins
      "ArrayRef<int64_t>":$shape, "Type":$elementType), [{
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

def IsMPETilePred : And<[
    CPred<[{::llvm::isa<::mlir::mpe::TileType>($_self)}]>,
    CPred<[{::llvm::cast<::mlir::mpe::TileType>($_self).getRank() == 2}]>]>;

class MPETileOf<list<Type> allowedTypes>
    : ShapedContainerType<allowedTypes, IsMPETilePred, "tile",
                          "::mlir::mpe::TileType">;

def AnyMPETile : MPETileOf<[F32]>;
def MPETileF32 : MPETileOf<[F32]>;

//===----------------------------------------------------------------------===//
// MPE Op definitions (user facing)
//===----------------------------------------------------------------------===//

def LoadOp : MPE_Op<"load", [Pure]> {
  let summary = "Load a tile from memory";

  let arguments = (ins
    Arg<AnyMemRef, "load base", [MemRead]>:$base,
    Variadic<Index>:$indices
  );

  let results = (outs AnyMPETile:$res);

  let extraClassDeclaration = [{
    TileType getResTileType() {
      return ::mlir::cast<TileType>(getRes().getType());
    }

    MemRefType getBaseMemRefType() {
      return ::mlir::cast<MemRefType>(getBase().getType());
    }
  }];

  let assemblyFormat = "$base `[` $indices `]` attr-dict `:` type($base) `into` type($res)";
  let hasVerifier = 1;
}

def StoreOp : MPE_Op<"store", [Pure]> {
  let summary = "Store a tile in memory";

  let arguments = (ins
    Arg<AnyMemRef, "store base", [MemWrite]>:$base,
    Variadic<Index>:$indices,
    AnyMPETile:$tile
  );

  let extraClassDeclaration = [{
    TileType getTileType() {
      return ::mlir::cast<TileType>(getTile().getType());
    }
    MemRefType getBaseMemRefType() {
      return ::mlir::cast<MemRefType>(getBase().getType());
    }
  }];

  let assemblyFormat = "$base `[` $indices `]` `,` $tile attr-dict `:` type($base) `,` type($tile)";
  let hasVerifier = 1;
}

def ZeroOp : MPE_Op<"zero", [Pure]> {
  let summary = "Initializes a tile with all zeros";
  let results = (outs AnyMPETile:$res);

  let extraClassDeclaration = [{
    TileType getResTileType() {
      return ::mlir::cast<TileType>(getRes().getType());
    }
  }];

  let assemblyFormat = "attr-dict `:` type($res)";
  let hasVerifier = 1;
}

def MultiplyOp : MPE_Op<"multiply", [Pure, AllTypesMatch<["lhs", "rhs", "acc", "res"]>]> {
  let summary = "Multiply two tiles and accumulate";

  let arguments = (ins AnyMPETile:$lhs, AnyMPETile:$rhs, AnyMPETile:$acc);
  let results = (outs AnyMPETile:$res);

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

  let assemblyFormat = "$lhs `,` $rhs `,` $acc attr-dict `:` type($res)";
  let hasVerifier = 1;
}

//===----------------------------------------------------------------------===//
// MPE IntrOp definitions (LLVM compiler facing)
//===----------------------------------------------------------------------===//

def LLVM_riscv_mpe_add_f32 : MPE_IntrOp<"add.f32", 1>,
  Arguments<(ins LLVM_Type, LLVM_Type)>;

def LLVM_riscv_mpe_sub_f32 : MPE_IntrOp<"sub.f32", 1>,
  Arguments<(ins LLVM_Type, LLVM_Type)>;

def LLVM_riscv_mpe_mac_f32 : MPE_IntrOp<"mac.f32", 1>,
  Arguments<(ins LLVM_Type, LLVM_Type)>;

def LLVM_riscv_mpe_load_us : MPE_IntrOp<"load.us", 1, [0]>,
  Arguments<(ins LLVM_AnyPointer)>;

def LLVM_riscv_mpe_store_us : MPE_IntrOp<"store.us", 0, [], [0]>,
  Arguments<(ins LLVM_Type, LLVM_AnyPointer)>;

def LLVM_riscv_mpe_move_xm : MPE_IntrOp<"move.xm", 1, [0], [0]>,
  Arguments<(ins AnyInteger)>;

#endif // MPE
