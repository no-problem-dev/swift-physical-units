# PhysicalUnits

物理量を Swift の型として扱う。単位の整合性はコンパイラが検査し、実行時の測定値は 8 バイトのままにする。

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20watchOS%20|%20tvOS%20|%20visionOS%20%7C%20Linux-blue.svg)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[English](./README.md) | 日本語

## 特徴

- **次元が型** — `Length` と `Duration` を足すコードはコンパイルが通らない。単位の取り違えは本番の誤った数値ではなくビルドエラーになる
- **物理公式が演算子** — `F = m * a`、`E = F * d`、`P = V * I`、`v = d / t` などよく使う関係を型付きの演算子として用意してあるので、結果の次元は推論される
- **SI 接頭辞は自動** — `BaseUnit` 1 つと `MetricUnit<BaseUnit>` で、その次元の接頭辞付き単位が case を手書きせずに揃う
- **実行時のコストを払わない** — `Measurement` は基準単位の `Double` 1 個を包んだ `@frozen` な型で、演算は `@inlinable`
- **温度を正しく分ける** — 絶対温度（`Temperature`）と温度差（`TemperatureDelta`）を別の型にしている。摂氏・華氏は倍率ではなくオフセットで変換するため
- **Apple の全プラットフォーム** — iOS・macOS・watchOS・tvOS・visionOS に対応。Foundation 以外の依存はない

## 使い方

```swift
import PhysicalUnits

// バッテリーの持ち時間は 3 つの次元をまたいだ除算になる
let battery = Charge(milliampereHours: 5000)
let draw = Current(500, unit: .milliamperes)
let runtime: Duration = battery / draw
print(runtime.hours)             // 10.0

// 結果の次元は推論される。入力の単位を揃えておく必要もない
let distance = Length(100, unit: .kilometers)
let elapsed = Duration(2, unit: .hours)
let speed: Speed = distance / elapsed
print(speed.kilometersPerHour)   // 50.0

// let nonsense = distance + elapsed
// ^ コンパイルエラー。Length と Duration は別の型
```

## ドキュメント

API リファレンスとガイドは DocC カタログから公開している。

- [PhysicalUnits](https://no-problem-dev.github.io/swift-physical-units/documentation/physicalunits/) — リファレンス全体
- [Getting Started](https://no-problem-dev.github.io/swift-physical-units/documentation/physicalunits/gettingstarted) — 単位変換・演算・温度・コレクション操作
- [Architecture](https://no-problem-dev.github.io/swift-physical-units/documentation/physicalunits/architecture) — 層の組み立て方、どの変換が厳密でどれが丸めか、コンパイル時検査がどこで止まるか

## インストール

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-physical-units.git", from: "1.0.0")
]

.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "PhysicalUnits", package: "swift-physical-units")
    ]
)
```

## 要件

- Swift 6.0+
- iOS 17+ / macOS 14+ / watchOS 10+ / tvOS 17+ / visionOS 1+
- Linux

## 開発に参加する

不具合の報告も Pull Request も歓迎する。ビルド・テスト・リリースの手順は
[CONTRIBUTING.md](CONTRIBUTING.md) を参照。

## ライセンス

MIT License — 詳細は [LICENSE](LICENSE) を参照。
