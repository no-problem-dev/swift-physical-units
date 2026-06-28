# Getting Started with PhysicalUnits

型安全な単位演算をすぐに使い始めるためのガイド。

## Installation

Package.swift に依存を追加します。

```swift
dependencies: [
    .package(
        url: "https://github.com/no-problem-dev/swift-physical-units.git",
        from: "1.0.0"
    )
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "PhysicalUnits", package: "swift-physical-units")
        ]
    )
]
```

## Basic Usage

### 測定値の作成と単位変換

```swift
import PhysicalUnits

// 質量: キログラムで作成し、グラムで取得
let body = Mass(70, unit: .kilograms)
print(body.grams)       // 70000.0
print(body.milligrams)  // 70000000.0

// 長さ: センチメートルで作成し、メートルで取得
let height = Length(175, unit: .centimeters)
print(height.meters)    // 1.75
print(height.kilometers)// 0.00175

// 時間: 分で作成し、秒で取得
let lap = Duration(90, unit: .seconds)
print(lap.minutes)      // 1.5
print(lap.milliseconds) // 90000.0

// エネルギー: キロカロリーで作成し、キロジュールで取得
let meal = Energy(500, unit: .kilocalories)
print(meal.kilojoules)  // 2092.0
```

### 型安全な演算

同じ次元の値同士で加減算・スカラー倍が使えます。

```swift
let a = Mass(1, unit: .kilograms)
let b = Mass(500, unit: .grams)

let total = a + b       // 1500 g (内部表現はすべて基準単位)
let doubled = a * 2.0   // 2000 g
let ratio = a / b       // 2.0 (Double)
```

### 物理演算子（次元をまたいだ演算）

```swift
// 運動学: 距離 = 速度 × 時間
let speed    = Speed(60, unit: .kilometersPerHour)
let duration = Duration(2, unit: .hours)
let distance: Length = speed * duration
print(distance.kilometers)  // 120.0

// 速度 = 距離 ÷ 時間
let d2  = Length(100, unit: .kilometers)
let t2  = Duration(2, unit: .hours)
let v2: Speed = d2 / t2
print(v2.kilometersPerHour)  // 50.0

// 電気: P = V × I
let voltage  = Voltage(100, unit: .volts)
let current  = Current(5, unit: .amperes)
let power: Power = voltage * current
print(power.watts)           // 500.0

// オームの法則: V = I × R
let r = Resistance(20, unit: .ohms)
let v3: Voltage = current * r
print(v3.volts)              // 100.0
```

### 温度（オフセット変換）

温度は加算ではなくオフセット型 `TemperatureDelta` を使います。

```swift
let body = Temperature(37, unit: .celsius)
print(body.kelvin)       // 310.15
print(body.fahrenheit)   // 98.6

let fever = body + TemperatureDelta(1.5, unit: .celsius)
print(fever.celsius)     // 38.5
```

### コレクション操作

```swift
let samples = [
    Mass(60, unit: .kilograms),
    Mass(70, unit: .kilograms),
    Mass(80, unit: .kilograms)
]

let total   = samples.sum()      // 210 kg
let average = samples.average()  // 70 kg (Optional)
let range   = samples.range()    // 20 kg
```
