English | [日本語](./README.ja.md)

# PhysicalUnits

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20watchOS%20|%20tvOS%20|%20visionOS-blue.svg)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A Swift library for type-safe physical units. Unit consistency is verified at compile time with minimal runtime overhead.

## Features

- **Type-safe unit conversion**: Compile-time validation of conversions between different units
- **Physics formula operators**: Natural syntax for formulas like `F = m * a`, `E = F * d`, `P = V * I`
- **SI prefix support**: Automatic nano-to-tera coverage via the `MetricUnit<BaseUnit>` pattern
- **High performance**: Optimized with `@frozen` and `@inlinable`
- **Multi-platform**: iOS, macOS, watchOS, tvOS, visionOS

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-physical-units.git", from: "1.0.0")
]
```

## Usage

### Basic Unit Conversion

```swift
import PhysicalUnits

// Length
let distance = Length(100, unit: .meters)
print(distance.kilometers)  // 0.1

// Mass
let mass = Mass(1, unit: .kilograms)
print(mass.grams)  // 1000.0

// Time
let time = Duration(1, unit: .hours)
print(time.seconds)  // 3600.0
```

### Physics Formula Calculations

```swift
// Speed = Distance / Time
let distance = Length(100, unit: .kilometers)
let time = Duration(2, unit: .hours)
let speed: Speed = distance / time
print(speed.kilometersPerHour)  // 50.0

// Force = Mass × Acceleration
let mass = Mass(10, unit: .kilograms)
let acceleration = Acceleration(9.8, unit: .metersPerSecondSquared)
let force: Force = mass * acceleration
print(force.newtons)  // 98.0

// Power = Voltage × Current
let voltage = Voltage(100, unit: .volts)
let current = Current(5, unit: .amperes)
let power: Power = voltage * current
print(power.watts)  // 500.0
```

### Ohm's Law

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

### Rotational Motion

```swift
// Angular speed
let angle = Angle(360, unit: .degrees)
let time = Duration(1, unit: .seconds)
let angularSpeed: AngularSpeed = angle / time
print(angularSpeed.rpm)  // 60.0

// Linear speed = angular speed × radius
let radius = Length(0.5, unit: .meters)
let linearSpeed: Speed = angularSpeed * radius
print(linearSpeed.metersPerSecond)  // 3.14...
```

### Battery Capacity

```swift
// Charge
let battery = Charge(milliampereHours: 5000)
print(battery.ampereHours)  // 5.0
print(battery.coulombs)  // 18000.0

// Discharge time
let current = Current(500, unit: .milliamperes)
let dischargeTime: Duration = battery / current
print(dischargeTime.hours)  // 10.0
```

## Supported Dimensions

### Base Dimensions
| Dimension | Type | Base Unit |
|-----------|------|-----------|
| Length | `Length` | Meter (m) |
| Mass | `Mass` | Gram (g) |
| Time | `Duration` | Second (s) |
| Temperature | `Temperature` | Kelvin (K) |
| Electric current | `Current` | Ampere (A) |
| Angle | `Angle` | Radian (rad) |

### Derived Dimensions
| Dimension | Type | Base Unit | Formula |
|-----------|------|-----------|---------|
| Speed | `Speed` | m/s | v = d/t |
| Acceleration | `Acceleration` | m/s² | a = v/t |
| Force | `Force` | N (kg·m/s²) | F = ma |
| Energy | `Energy` | J (N·m) | E = Fd |
| Power | `Power` | W (J/s) | P = E/t |
| Voltage | `Voltage` | V | V = IR |
| Resistance | `Resistance` | Ω | R = V/I |
| Charge | `Charge` | C (A·s) | Q = It |
| Angular speed | `AngularSpeed` | rad/s | ω = θ/t |
| Frequency | `Frequency` | Hz | f = 1/T |
| Area | `Area` | m² | A = l × w |
| Volume | `Volume` | m³ | V = l × w × h |
| Pressure | `Pressure` | Pa | P = F/A |

## Architecture

```
PhysicalUnits/
├── Core/
│   ├── Measurement.swift      # Generic measurement type
│   ├── Unit.swift             # Unit protocol
│   └── MetricUnit.swift       # SI prefix support
├── Dimensions/
│   ├── Length/                # Length
│   ├── Mass/                  # Mass
│   ├── Time/                  # Time
│   ├── Speed/                 # Speed
│   ├── Acceleration/          # Acceleration
│   ├── Force/                 # Force
│   ├── Energy/                # Energy
│   ├── Power/                 # Power
│   ├── Voltage/               # Voltage
│   ├── Current/               # Current
│   ├── Resistance/            # Resistance
│   ├── Charge/                # Charge
│   ├── Angle/                 # Angle
│   ├── AngularSpeed/          # Angular speed
│   ├── Frequency/             # Frequency
│   └── ...
└── Formulas/
    ├── KinematicsOperators.swift   # Kinematics
    ├── MechanicsOperators.swift    # Mechanics
    ├── ElectricityOperators.swift  # Electricity
    └── FrequencyOperators.swift    # Frequency & angular speed
```

## License

MIT License — see [LICENSE](LICENSE) for details.
