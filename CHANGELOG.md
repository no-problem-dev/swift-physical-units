# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
