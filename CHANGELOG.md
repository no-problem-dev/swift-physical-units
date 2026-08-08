# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [未リリース]

なし

## [1.0.0] - 2025-12-31

### Added
- Initial release of PhysicalUnits
- Core `Measurement<Unit>` generic type with type-safe unit conversions
- `MetricUnit<BaseUnit>` for SI prefix support (nano to tera)
- Dimension types:
  - **Mechanics**: Length, Mass, Duration, Speed, Acceleration, Force, Energy, Power
  - **Electricity**: Voltage, Current, Resistance, Charge
  - **Rotation**: Angle, AngularSpeed, Frequency
  - **Other**: Temperature, Pressure, Area, Volume
- Physics formula operators:
  - Kinematics: v = d/t, d = v*t, t = d/v, a = (v-v0)/t
  - Mechanics: F = ma, E = Fd, P = E/t, E = Pt
  - Electricity: P = VI, V = IR (Ohm's law), Q = It
  - Rotation: omega = theta/t, v = omega*r, f <-> omega conversions
- Comprehensive test suite with 361 tests
- DocC documentation support

[1.0.0]: https://github.com/no-problem-dev/swift-physical-units/releases/tag/v1.0.0

<!-- Auto-generated on 2025-12-31T06:05:29Z by release workflow -->
