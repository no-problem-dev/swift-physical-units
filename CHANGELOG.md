# Changelog

## [Unreleased]

`Duration.formattedHMS` now returns `String?`. It returned a malformed string for a
negative duration — -90 s came out as "-1:-30", and -3600 s lost its hour entirely and
read "0:00" — because the sign was applied to each field instead of once to the whole.
It also trapped on a duration that was not finite, which is what a division by a zero
speed produces, and on any duration too large for `Int` seconds. The sign is now written
once in front, every finite duration formats however large, and a NaN or an infinity
returns `nil` instead of crashing.

`Acceleration.formatted` reaches its `Gal` branch. The branch tested `abs(gal) >= 1`,
which is the same condition as the `m/s²` branch above it, so no input ever got there and
the property never printed `Gal`. The ladder now gives each unit a band of its own: g from
1 g, m/s² from 1 m/s², Gal from 1 Gal, mGal below that.

Every unit type is `CaseIterable`, so conversions and formatting can be asserted over the
whole of each dimension rather than over selected examples.

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-07-19

### Changed
- Documentation comments and DocC rewritten in Japanese, and the README unified as a Japanese
  and English pair. The module documentation was expanded to cover every dimension and every
  operator, and DocC articles were added.
- CI workflows synced to the standard SSOT template (tests + release-on-tag; the old
  auto-release is gone). DocC is built on macos-26 / Xcode 26 (Swift 6.2) and deployed to
  GitHub Pages via `actions/deploy-pages`.

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

[1.0.1]: https://github.com/no-problem-dev/swift-physical-units/compare/v1.0.0...1.0.1
[1.0.0]: https://github.com/no-problem-dev/swift-physical-units/releases/tag/v1.0.0