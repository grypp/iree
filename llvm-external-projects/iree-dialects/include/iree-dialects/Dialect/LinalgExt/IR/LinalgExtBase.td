// Copyright 2021 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef IREE_DIALECT_LINALGEXT_BASE
#define IREE_DIALECT_LINALGEXT_BASE

include "mlir/IR/OpBase.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/EnumAttr.td"

//===----------------------------------------------------------------------===//
// Dialect definition
//===----------------------------------------------------------------------===//

def IREELinalgExt_Dialect : Dialect {
  let name = "iree_linalg_ext";
  let cppNamespace = "::mlir::iree_compiler::IREE::LinalgExt";
  let description = [{
    The `iree_linalg_ext` dialect is intended to experiment more support for
    non-structured operations, ie, can not be represented in Linalg operations.
  }];
  let hasCanonicalizer = 1;
  let useDefaultAttributePrinterParser = 1;
}

//===----------------------------------------------------------------------===//
// Type definitions
//===----------------------------------------------------------------------===//

class RankedTensorOrMemRefOf<list<Type> allowedTypes> :
  ShapedContainerType<allowedTypes,
      Or<[IsMemRefTypePred, And<[IsTensorTypePred, HasRankPred]>]>,
  "ranked tensor or memref", "::mlir::ShapedType">;

def AnyRankedTensorOrMemRefType : RankedTensorOrMemRefOf<[AnyType]>;

//===---------------------------------------------------------------------===//
// Data layout encoding attributes
//===---------------------------------------------------------------------===//

class IREELinalgExt_Attr<string name, list<Trait> traits = []>
  : AttrDef<IREELinalgExt_Dialect, name, traits>;

// List of pre-defined data layout encoding attributes.
def MATMUL_F32F32F32_LHS
    : I32EnumAttrCase<"MATMUL_F32F32F32_LHS", 0>;
def MATMUL_F32F32F32_RHS
    : I32EnumAttrCase<"MATMUL_F32F32F32_RHS", 1>;
def MATMUL_F32F32F32_RESULT
    : I32EnumAttrCase<"MATMUL_F32F32F32_RESULT", 2>;
def MATMUL_I8I8I32_LHS
    : I32EnumAttrCase<"MATMUL_I8I8I32_LHS", 3>;
def MATMUL_I8I8I32_RHS
    : I32EnumAttrCase<"MATMUL_I8I8I32_RHS", 4>;
def MATMUL_I8I8I32_RESULT
    : I32EnumAttrCase<"MATMUL_I8I8I32_RESULT", 5>;
def MATMUL_F16F16F32_LHS
    : I32EnumAttrCase<"MATMUL_F16F16F32_LHS", 6>;
def MATMUL_F16F16F32_RHS
    : I32EnumAttrCase<"MATMUL_F16F16F32_RHS", 7>;
def MATMUL_F16F16F32_RESULT
    : I32EnumAttrCase<"MATMUL_F16F16F32_RESULT", 8>;
def MATMUL_F16F16F16_LHS
    : I32EnumAttrCase<"MATMUL_F16F16F16_LHS", 9>;
def MATMUL_F16F16F16_RHS
    : I32EnumAttrCase<"MATMUL_F16F16F16_RHS", 10>;
def MATMUL_F16F16F16_RESULT
    : I32EnumAttrCase<"MATMUL_F16F16F16_RESULT", 11>;
def MATMUL_BF16BF16F32_LHS
    : I32EnumAttrCase<"MATMUL_BF16BF16F32_LHS", 12>;
def MATMUL_BF16BF16F32_RHS
    : I32EnumAttrCase<"MATMUL_BF16BF16F32_RHS", 13>;
def MATMUL_BF16BF16F32_RESULT
    : I32EnumAttrCase<"MATMUL_BF16BF16F32_RESULT", 14>;
def MATMUL_BF16BF16BF16_LHS
    : I32EnumAttrCase<"MATMUL_BF16BF16BF16_LHS", 15>;
def MATMUL_BF16BF16BF16_RHS
    : I32EnumAttrCase<"MATMUL_BF16BF16BF16_RHS", 16>;
def MATMUL_BF16BF16BF16_RESULT
    : I32EnumAttrCase<"MATMUL_BF16BF16BF16_RESULT", 17>;

def TensorEncodingEnum
    : I32EnumAttr<"TensorEncoding",
                  "identifier for encoding used for the tensor",[
                    MATMUL_F32F32F32_LHS, MATMUL_F32F32F32_RHS, MATMUL_F32F32F32_RESULT,
                    MATMUL_I8I8I32_LHS, MATMUL_I8I8I32_RHS, MATMUL_I8I8I32_RESULT,
                    MATMUL_F16F16F32_LHS, MATMUL_F16F16F32_RHS, MATMUL_F16F16F32_RESULT,
                    MATMUL_F16F16F16_LHS, MATMUL_F16F16F16_RHS, MATMUL_F16F16F16_RESULT,
                    MATMUL_BF16BF16F32_LHS, MATMUL_BF16BF16F32_RHS, MATMUL_BF16BF16F32_RESULT,
                    MATMUL_BF16BF16BF16_LHS, MATMUL_BF16BF16BF16_RHS, MATMUL_BF16BF16BF16_RESULT,
                  ]> {
  let cppNamespace = "::mlir::iree_compiler::IREE::LinalgExt";
  let genSpecializedAttr = 0;
}

def TensorEncodingAttr :
  EnumAttr<IREELinalgExt_Dialect, TensorEncodingEnum, "encoding"> {
  let summary = [{tensor layout encoding}];
  let description = [{
    This attribute describes the change in the layout for
    a given tensor to execute subsequent operations on
    the tiled layout. The encoding serves as a way to
    represent the change in the way the data is laid out in
    memory without changing the logical rank/extent of
    the tensor itself. When required, the encoding
    can be used to explicitly manifest the layout change
    through operations like pack/unpack.

    Currently the encoding is just an enum that describes
    in an ad-hoc fashions the data layouts we initially care
    about. In fullness of time the encoding attribute can be
    made richer.
  }];

  let assemblyFormat = [{
    `<` `` $value `>`
  }];
}

#endif // IREE_DIALECT_LINALGEXT_BASE
