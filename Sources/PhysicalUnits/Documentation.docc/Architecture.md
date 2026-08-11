# Architecture

How the library is put together, which conversions are exact, and where the compiler stops helping.

## Overview

There are four layers, and each one exists to keep the layer above it small.

| Layer | Type | Job |
|---|---|---|
| Unit | ``Unit`` | A scale factor to the dimension's base unit, plus a symbol |
| Base unit | ``BaseUnit`` | The unprefixed anchor of a dimension: `Meter`, `Gram`, `Second` |
| Prefixed unit | ``MetricUnit`` | `MetricPrefix` × `BaseUnit`, so one type covers every SI prefix |
| Quantity | ``Measurement`` | A `Double` in base units, tagged with the unit type it belongs to |

A dimension is then just a pair of type aliases:

```swift
public typealias LengthUnit = MetricUnit<Meter>
public typealias Length = Measurement<LengthUnit>
```

Because ``Measurement`` is generic over the *unit* type, `Length` and `Mass` are different
types. That is the whole safety mechanism — there is no runtime dimension tag to compare.

## One number, in one base unit

``Measurement`` stores a single `Double`, always converted to the dimension's base unit at
initialisation. Reading it back divides by the target unit's coefficient.

```swift
let mass = Mass(1, unit: .kilograms)   // stored as 1000 (grams)
mass.value(in: .grams)                 // 1000.0
```

Two consequences fall out of that:

- The struct is `@frozen` and eight bytes wide, with `@inlinable` arithmetic, so a measurement
  costs what a bare `Double` costs. There is no boxing and no unit object to allocate.
- Arithmetic between two values of the same dimension never converts. `Mass(1, unit: .kilograms)
  + Mass(500, unit: .grams)` adds `1000 + 500` directly.

**The base units are not all SI.** Mass is anchored on the **gram**, not the kilogram, and
volume on the **litre**, not the cubic metre. That choice keeps `MetricUnit` usable — a prefix
applied to "kilogram" would give "kilokilogram" — but it means any formula that mixes mass into
an SI-derived quantity has to carry a factor of 1000. The operators in `Formulas/` do that for
you; hand-rolled arithmetic on `Measurement.value(in:)` does not.

## Prefixes are a type parameter, not fifteen enum cases

``MetricPrefix`` covers `femto` (1e-15) through `peta` (1e15), fifteen steps including the
unprefixed `base`. Composing it with a ``BaseUnit`` gives every prefixed unit of a dimension
from one declaration:

```swift
public struct Meter: BaseUnit {
    public static let symbol = "m"
    public init() {}
}

public typealias LengthUnit = MetricUnit<Meter>

MetricUnit<Meter>(.centi)   // cm
MetricUnit<Meter>(.kilo)    // km
```

Eight dimensions are built this way: length, mass, volume, current, voltage, resistance,
charge, and frequency.

## Dimensions with irregular units get their own enum

Prefix composition only works when every unit of a dimension is a power of ten away from the
base. Time is not — minutes and hours are sexagesimal — and neither are acres, pounds-force, or
kilocalories. Those dimensions declare an explicit `enum` of cases instead: ``TimeUnit``,
``AreaUnit``, ``ForceUnit``, ``EnergyUnit``, ``PowerUnit``, ``PressureUnit``, ``SpeedUnit``,
``AccelerationUnit``, ``AngleUnit``, ``AngularSpeedUnit``, ``TemperatureUnit``.

`Newton`, `Watt`, `Pascal`, and `Second` still exist as ``BaseUnit`` types, but the `Force` /
`Power` / `Pressure` / `Duration` aliases do not use them — those dimensions need the irregular
cases. Writing `MetricUnit<Newton>(.kilo)` compiles, and gives a `Measurement<MetricUnit<Newton>>`
that is a *different type* from `Force`, with none of the mechanics operators available on it.

One consequence of the split is that the metric-prefix dimensions carry **only** metric units.
`Length`, `Mass`, and `Volume` have no inches, pounds, or gallons; the non-metric units in the
library live in the enum dimensions — acres in ``AreaUnit``, pounds-force in ``ForceUnit``,
miles per hour and knots in ``SpeedUnit``, calories in ``EnergyUnit``, psi and torr in
``PressureUnit``.

## Temperature is not a scale

``Unit`` gives a single multiplicative `coefficientToBase`, which cannot express the offset that
Celsius and Fahrenheit need. So temperature is split in two:

- ``Temperature`` — an absolute reading. Converting applies the offset: 37 °C is 310.15 K.
- ``TemperatureDelta`` — a difference. Converting applies only the scale: a 1 °C rise is a 1 K
  rise, and a 1 °F rise is 5/9 K.

`TemperatureUnit.coefficientToBase` is therefore the **interval** factor. Reading it as an
absolute conversion factor gives an answer that is wrong by 273.15. The two types keep the
distinction honest in ordinary code; the raw coefficient does not. Because `TemperatureUnit`
conforms to ``Unit``, `Measurement<TemperatureUnit>(20, unit: .celsius)` also compiles — and
stores 20, not 293.15. Reach for ``Temperature``, never the generic container.

## Formulas are hand-written operators

`Formulas/` declares one operator per physical relation — `Speed = Length / Duration`,
`Force = Mass * Acceleration`, `Power = Voltage * Current`, `Duration = Charge / Current`, and
so on. There is no general dimensional algebra: nothing computes that `kg·m/s²` is a newton.

The practical effect is that supported relations are exact and inferred, and unsupported ones
are a compile error rather than a wrong number. If you need a relation that is not there, add
the operator rather than dropping to `Double`.

## Which conversions are exact

"Exact" here means the literal in the code is the full defined value, so the only error is
`Double` rounding.

| Exact by definition | Value in the code |
|---|---|
| Minute, hour, day | 60 s, 3600 s, 86400 s |
| Are, hectare, acre | 100 m², 10000 m², 4046.8564224 m² |
| Standard gravity, kilogram-force | 9.80665 m/s², 9.80665 N |
| Pound-force, dyne | 4.4482216152605 N, 1e-5 N |
| Metric horsepower | 735.49875 W |
| Standard atmosphere, bar | 101325 Pa, 1e5 Pa |
| Thermochemical calorie | 4.184 J |
| Mile per hour, knot | 1609.344/3600 m/s, 1852/3600 m/s |
| Speed of light | 299792458 m/s |
| Celsius offset, Fahrenheit offset and scale | 273.15, 459.67, 9/5 |
| Ampere-hour, milliampere-hour | 3600 C, 3.6 C |
| Elementary charge | 1.602176634e-19 C |

Two of those deserve a second look. `SpeedUnit` stores mile-per-hour and knot as unevaluated
ratios rather than truncated decimals, precisely because neither has a terminating decimal
expansion. And the calorie here is the **thermochemical** calorie; the international calorie
(4.1868 J) and the 15 °C calorie (4.1855 J) are different numbers, and food labelling does not
always say which it means.

Three factors in the library are **rounded**, and their symbol documentation says so:

| Rounded | In the code | Exact value |
|---|---|---|
| Torr | 133.32236842 Pa | 101325/760, non-terminating |
| Pound per square inch | 6894.757293168 Pa | 6894.757293168361… |
| Imperial horsepower | 745.69987158 W | 745.6998715822702 |

Two caveats that no amount of precision fixes:

- **π-based conversions** — degrees, revolutions, and RPM are exact as definitions, and the code
  computes them from `Double.pi` rather than a truncated literal. But π is only representable to
  `Double` precision, so a round trip through radians does not return the original decimal bit
  for bit.
- **The day is the SI day.** It is exactly 86400 seconds and knows nothing about leap seconds or
  daylight saving. For calendar arithmetic, use `Foundation.Calendar`.

Conversions that are conventional rather than defined — millimetres of mercury, the acceleration
due to gravity on Mars, the speed of sound in air — say so in their own symbol documentation.
Check the case's doc comment before treating a factor as authoritative.

## Where compile-time checking stops

The type system catches dimension mix-ups. It does not catch these:

- **Scalars are untyped.** `Measurement * Double` and `Measurement / Double` return the same
  dimension whatever the scalar meant, and `Measurement / Measurement` returns a bare `Double`.
  Once a value is a `Double`, nothing tracks what it was.
- **`Codable` carries no unit.** ``Measurement`` encodes only its base-unit magnitude under a
  single key. A `Mass` payload decodes into a `Length` without complaint, because the two encode
  to the same shape. If you persist measurements across a schema change, tag the dimension
  yourself.
- **`description` prints no symbol.** It formats the base-unit magnitude and says
  `(base units)`. Format through `value(in:)` and the unit's `symbol` when a human will read it.
- **Angles are dimensionless.** ``AngleUnit`` is a scale over radians; nothing stops a bare
  `Double` from standing in for an angle at an API boundary.
- **A few accessors return `Double` on purpose.** `Charge.ampereHours`, `Frequency.angularSpeed`,
  and their neighbours hand back plain numbers because the target has no case in that dimension's
  unit enum. Each says so; the type system does not.
- **Offsets are not dimensions.** `Measurement<TemperatureUnit>` type-checks and quietly treats a
  Celsius reading as if it were kelvin.
- **`Double` is `Double`.** Accumulating many small quantities loses precision the same way it
  does anywhere else, and the base-unit representation decides where. A femtometre added to a
  kilometre is lost regardless of the units you wrote.

## Dimension coverage

### Base dimensions

| Dimension | Quantity type | Base unit |
|---|---|---|
| Length | ``Length`` | metre (m) |
| Mass | ``Mass`` | gram (g) |
| Time | ``Duration`` | second (s) |
| Temperature | ``Temperature`` | kelvin (K) |
| Electric current | ``Current`` | ampere (A) |
| Angle | ``Angle`` | radian (rad) |

### Derived dimensions

| Dimension | Quantity type | Base unit | Relation |
|---|---|---|---|
| Speed | ``Speed`` | m/s | v = d/t |
| Acceleration | ``Acceleration`` | m/s² | a = v/t |
| Force | ``Force`` | N | F = ma |
| Energy | ``Energy`` | J | E = Fd |
| Power | ``Power`` | W | P = E/t |
| Pressure | ``Pressure`` | Pa | P = F/A |
| Voltage | ``Voltage`` | V | V = IR |
| Resistance | ``Resistance`` | Ω | R = V/I |
| Charge | ``Charge`` | C | Q = It |
| Frequency | ``Frequency`` | Hz | f = 1/T |
| Angular speed | ``AngularSpeed`` | rad/s | ω = θ/t |
| Area | ``Area`` | m² | A = l·w |
| Volume | ``Volume`` | L | V = l·w·h |
