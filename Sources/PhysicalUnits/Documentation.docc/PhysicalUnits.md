# ``PhysicalUnits``

Physical quantities as Swift types, with unit consistency checked by the compiler.

## Overview

A quantity in this library carries its dimension in its type. `Mass` and `Length` are distinct
types, so adding one to the other is a build error rather than a number that is quietly wrong by
a factor of a thousand. Conversion happens on the way in and on the way out; in between, a
measurement is a single `Double` held in the dimension's base unit.

```swift
import PhysicalUnits

// Convert by asking for the unit you want.
let weight = Mass(70, unit: .kilograms)
print(weight.grams)                 // 70000.0

let height = Length(175, unit: .centimeters)
print(height.meters)                // 1.75

// Cross-dimension formulas are typed operators, so the result dimension is inferred.
let voltage = Voltage(100, unit: .volts)
let current = Current(5, unit: .amperes)
let power: Power = voltage * current
print(power.watts)                  // 500.0

// Absolute temperatures and temperature differences are separate types,
// because Celsius and Fahrenheit convert with an offset.
let body = Temperature(37, unit: .celsius)
let fever = body + TemperatureDelta(1.5, unit: .celsius)
print(fever.fahrenheit)             // 101.3
```

Read <doc:Architecture> for how the layers fit together, which conversion factors are exact, and
the cases the compiler cannot catch for you.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:Architecture>

### Core protocols and shared types

- ``Unit``
- ``BaseUnit``
- ``MetricPrefix``
- ``MetricUnit``
- ``Measurement``

### Mechanics and motion

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

### Electricity

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

### Geometry and the rest

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

### Base units

- ``Meter``
- ``Gram``
- ``Second``
- ``Liter``
- ``Ampere``
- ``Volt``
- ``Ohm``
- ``Coulomb``
- ``Hertz``
- ``Newton``
- ``Watt``
- ``Pascal``
