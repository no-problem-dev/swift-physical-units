# ``PhysicalUnits``

型安全な物理量を Swift で扱うためのライブラリ。

## Overview

PhysicalUnits は、物理量（質量・長さ・時間・エネルギーなど）を型安全に表現し、単位変換を正確に行うフレームワーク。

異なる次元の値（例: `Mass` と `Length`）を誤って加算しようとするとコンパイルエラーになるため、実行時エラーを型レベルで排除できる。

```swift
import PhysicalUnits

// 単位変換
let weight = Mass(70, unit: .kilograms)
print(weight.grams)        // 70000.0

let height = Length(175, unit: .centimeters)
print(height.meters)       // 1.75

// 物理演算子（次元をまたいだ演算）
let speed = Speed(60, unit: .kilometersPerHour)
let time  = Duration(2, unit: .hours)
let dist: Length = speed * time   // 120 km

// 電気回路
let v: Voltage  = Voltage(100, unit: .volts)
let i: Current  = Current(5,   unit: .amperes)
let p: Power    = v * i          // 500 W (P = V × I)
```

## Topics

### 基本

- <doc:GettingStarted>

### コアプロトコルと共通型

- ``Unit``
- ``BaseUnit``
- ``MetricPrefix``
- ``MetricUnit``
- ``Measurement``

### 力学・運動

- ``Mass``
- ``MassUnit``
- ``Length``
- ``LengthUnit``
- ``Duration``
- ``TimeUnit``
- ``Speed``
- ``SpeedUnit``
- ``Acceleration``
- ``AccelerationUnit``
- ``Force``
- ``ForceUnit``
- ``Energy``
- ``EnergyUnit``
- ``Power``
- ``PowerUnit``
- ``Pressure``
- ``PressureUnit``

### 電気

- ``Current``
- ``CurrentUnit``
- ``Voltage``
- ``VoltageUnit``
- ``Resistance``
- ``ResistanceUnit``
- ``Charge``
- ``ChargeUnit``
- ``Frequency``
- ``FrequencyUnit``

### 幾何・その他

- ``Area``
- ``AreaUnit``
- ``Volume``
- ``VolumeUnit``
- ``Angle``
- ``AngleUnit``
- ``AngularSpeed``
- ``AngularSpeedUnit``
- ``Temperature``
- ``TemperatureDelta``
- ``TemperatureUnit``
