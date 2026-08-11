# PhysicalUnits

Physical quantities as Swift types. Unit consistency is checked by the compiler, and a measurement is still just eight bytes at runtime.

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20watchOS%20|%20tvOS%20|%20visionOS-blue.svg)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

English | [日本語](./README.ja.md)

## Features

- **Dimensions are types** — adding a `Length` to a `Duration` does not compile, so a unit mix-up is a build error rather than a wrong number in production.
- **Physics formulas as operators** — `F = m * a`, `E = F * d`, `P = V * I`, `v = d / t`, and the rest of the common relations are written as typed operators, so the result dimension is inferred.
- **SI prefixes for free** — one `BaseUnit` plus `MetricUnit<BaseUnit>` gives every prefixed unit of that dimension without a hand-written case each.
- **Nothing to pay at runtime** — `Measurement` is `@frozen` around a single `Double` held in base units, and the arithmetic is `@inlinable`.
- **Temperature done properly** — absolute readings (`Temperature`) and intervals (`TemperatureDelta`) are separate types, because °C and °F convert with an offset rather than a scale factor.
- **Every Apple platform** — iOS, macOS, watchOS, tvOS, visionOS, with no dependencies beyond Foundation.

## Usage

```swift
import PhysicalUnits

// A battery's runtime is a division across three dimensions.
let battery = Charge(milliampereHours: 5000)
let draw = Current(500, unit: .milliamperes)
let runtime: Duration = battery / draw
print(runtime.hours)             // 10.0

// The result dimension is inferred, and the units need not match going in.
let distance = Length(100, unit: .kilometers)
let elapsed = Duration(2, unit: .hours)
let speed: Speed = distance / elapsed
print(speed.kilometersPerHour)   // 50.0

// let nonsense = distance + elapsed
// ^ does not compile: Length and Duration are different types
```

## Documentation

The API reference and guides are published from the DocC catalog:

- [PhysicalUnits](https://no-problem-dev.github.io/swift-physical-units/documentation/physicalunits/) — full reference
- [Getting Started](https://no-problem-dev.github.io/swift-physical-units/documentation/physicalunits/gettingstarted) — conversions, arithmetic, temperature, collections
- [Architecture](https://no-problem-dev.github.io/swift-physical-units/documentation/physicalunits/architecture) — how the layers fit together, which conversions are exact, and where compile-time checking stops

## Installation

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

## Requirements

- Swift 6.0+
- iOS 17+ / macOS 14+ / watchOS 10+ / tvOS 17+ / visionOS 1+

## Contributing

Bug reports and pull requests are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) for how to
build, test, and release.

## License

MIT License — see [LICENSE](LICENSE) for details.
