# PhysicalUnits

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20watchOS%20|%20tvOS%20|%20visionOS-blue.svg)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Swift で物理単位を型安全に扱うためのライブラリです。コンパイル時に単位の整合性を検証し、実行時のオーバーヘッドを最小限に抑えます。

## 特徴

- **型安全な単位変換**: 異なる単位間の変換をコンパイル時に検証
- **物理公式の演算子**: `F = m * a`、`E = F * d`、`P = V * I` などの物理公式を自然な構文で記述
- **SI プレフィックス対応**: `MetricUnit<BaseUnit>` パターンにより nano から tera まで自動対応
- **高パフォーマンス**: `@frozen`、`@inlinable` を活用した最適化
- **マルチプラットフォーム**: iOS、macOS、watchOS、tvOS、visionOS 対応

## インストール

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-physical-units.git", from: "1.0.0")
]
```

## 使い方

### 基本的な単位変換

```swift
import PhysicalUnits

// 長さ
let distance = Length(100, unit: .meters)
print(distance.kilometers)  // 0.1

// 質量
let mass = Mass(1, unit: .kilograms)
print(mass.grams)  // 1000.0

// 時間
let time = Duration(1, unit: .hours)
print(time.seconds)  // 3600.0
```

### 物理公式の計算

```swift
// 速度 = 距離 / 時間
let distance = Length(100, unit: .kilometers)
let time = Duration(2, unit: .hours)
let speed: Speed = distance / time
print(speed.kilometersPerHour)  // 50.0

// 力 = 質量 × 加速度
let mass = Mass(10, unit: .kilograms)
let acceleration = Acceleration(9.8, unit: .metersPerSecondSquared)
let force: Force = mass * acceleration
print(force.newtons)  // 98.0

// 電力 = 電圧 × 電流
let voltage = Voltage(100, unit: .volts)
let current = Current(5, unit: .amperes)
let power: Power = voltage * current
print(power.watts)  // 500.0
```

### オームの法則

```swift
// V = IR
let current = Current(2, unit: .amperes)
let resistance = Resistance(50, unit: .ohms)
let voltage: Voltage = current * resistance
print(voltage.volts)  // 100.0

// I = V/R
let current2: Current = voltage / resistance
print(current2.amperes)  // 2.0
```

### 回転運動

```swift
// 角速度
let angle = Angle(360, unit: .degrees)
let time = Duration(1, unit: .seconds)
let angularSpeed: AngularSpeed = angle / time
print(angularSpeed.rpm)  // 60.0

// 線速度 = 角速度 × 半径
let radius = Length(0.5, unit: .meters)
let linearSpeed: Speed = angularSpeed * radius
print(linearSpeed.metersPerSecond)  // 3.14...
```

### バッテリー容量

```swift
// 電荷量
let battery = Charge(milliampereHours: 5000)
print(battery.ampereHours)  // 5.0
print(battery.coulombs)  // 18000.0

// 放電時間の計算
let current = Current(500, unit: .milliamperes)
let dischargeTime: Duration = battery / current
print(dischargeTime.hours)  // 10.0
```

## 対応する次元

### 基本次元
| 次元 | 型 | 基準単位 |
|------|-----|---------|
| 長さ | `Length` | メートル (m) |
| 質量 | `Mass` | グラム (g) |
| 時間 | `Duration` | 秒 (s) |
| 温度 | `Temperature` | ケルビン (K) |
| 電流 | `Current` | アンペア (A) |
| 角度 | `Angle` | ラジアン (rad) |

### 派生次元
| 次元 | 型 | 基準単位 | 公式 |
|------|-----|---------|-----|
| 速度 | `Speed` | m/s | v = d/t |
| 加速度 | `Acceleration` | m/s² | a = v/t |
| 力 | `Force` | N (kg·m/s²) | F = ma |
| エネルギー | `Energy` | J (N·m) | E = Fd |
| 電力 | `Power` | W (J/s) | P = E/t |
| 電圧 | `Voltage` | V | V = IR |
| 抵抗 | `Resistance` | Ω | R = V/I |
| 電荷 | `Charge` | C (A·s) | Q = It |
| 角速度 | `AngularSpeed` | rad/s | ω = θ/t |
| 周波数 | `Frequency` | Hz | f = 1/T |
| 面積 | `Area` | m² | A = l × w |
| 体積 | `Volume` | m³ | V = l × w × h |
| 圧力 | `Pressure` | Pa | P = F/A |

## アーキテクチャ

```
PhysicalUnits/
├── Core/
│   ├── Measurement.swift      # ジェネリックな測定値型
│   ├── Unit.swift             # Unit プロトコル
│   └── MetricUnit.swift       # SI プレフィックス対応
├── Dimensions/
│   ├── Length/                # 長さ
│   ├── Mass/                  # 質量
│   ├── Duration/              # 時間
│   ├── Speed/                 # 速度
│   ├── Acceleration/          # 加速度
│   ├── Force/                 # 力
│   ├── Energy/                # エネルギー
│   ├── Power/                 # 電力
│   ├── Voltage/               # 電圧
│   ├── Current/               # 電流
│   ├── Resistance/            # 抵抗
│   ├── Charge/                # 電荷
│   ├── Angle/                 # 角度
│   ├── AngularSpeed/          # 角速度
│   ├── Frequency/             # 周波数
│   └── ...
└── Formulas/
    ├── KinematicsOperators.swift   # 運動学
    ├── MechanicsOperators.swift    # 力学
    ├── ElectricityOperators.swift  # 電気
    └── FrequencyOperators.swift    # 周波数・角速度
```

## ライセンス

MIT License - 詳細は [LICENSE](LICENSE) を参照してください。
