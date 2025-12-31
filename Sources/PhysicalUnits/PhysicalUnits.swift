// PhysicalUnits - Type-safe physical quantities for Swift
//
// Copyright (c) 2024 no problem LLC
//
// This library provides type-safe representations of physical quantities
// with proper unit handling and SI prefix support.

/// # PhysicalUnits
///
/// 型安全な物理量を Swift で扱うためのライブラリ。
///
/// ## 概要
///
/// PhysicalUnits は、物理量（質量、長さ、時間、エネルギーなど）を
/// 型安全に表現し、単位変換を正確に行うためのフレームワークです。
///
/// ## 設計思想
///
/// 1. **概念の分離**: SI 接頭辞（キロ、ミリ）と基本単位（グラム、メートル）を
///    型として分離し、組み合わせで任意の単位を表現
///
/// 2. **型安全**: 質量と長さなど、異なる次元の値を混同することを
///    コンパイル時に防止
///
/// 3. **パフォーマンス**: `@frozen`, `@inlinable` を活用し、
///    オーバーヘッドを最小化
///
/// ## 基本的な使い方
///
/// ```swift
/// import PhysicalUnits
///
/// // 質量
/// let weight = Mass(70, unit: .kilograms)
/// print(weight.grams)  // 70000.0
///
/// // 長さ
/// let height = Length(175, unit: .centimeters)
/// print(height.meters)  // 1.75
///
/// // 時間
/// let workout = Duration(45, unit: .minutes)
/// print(workout.seconds)  // 2700.0
///
/// // エネルギー
/// let burned = Energy(300, unit: .kilocalories)
/// print(burned.kilojoules)  // 1255.2
/// ```
///
/// ## 演算
///
/// ```swift
/// let mass1 = Mass(1, unit: .kilograms)
/// let mass2 = Mass(500, unit: .grams)
///
/// let total = mass1 + mass2  // 1500g
/// let scaled = mass1 * 2.0   // 2000g
/// let ratio = mass1 / mass2  // 2.0
/// ```
///
/// ## コレクション操作
///
/// ```swift
/// let samples = [Mass(1, unit: .kilograms), Mass(2, unit: .kilograms)]
/// let total = samples.sum()      // 3kg
/// let avg = samples.average()    // 1.5kg
/// ```
///
/// ## 主要な型
///
/// - ``Measurement``: 単位付き測定値のジェネリック型
/// - ``MetricPrefix``: SI 接頭辞（キロ、ミリ、マイクロなど）
/// - ``Unit``: 単位の基底プロトコル
/// - ``BaseUnit``: 基本単位プロトコル
/// - ``MetricUnit``: 接頭辞付き単位
///
/// ## 次元別の型
///
/// - ``Mass`` / ``MassUnit``: 質量
/// - ``Length`` / ``LengthUnit``: 長さ
/// - ``Duration`` / ``TimeUnit``: 時間
/// - ``Energy`` / ``EnergyUnit``: エネルギー

// Re-export all public types
// (Swift automatically exports all public declarations from source files)
