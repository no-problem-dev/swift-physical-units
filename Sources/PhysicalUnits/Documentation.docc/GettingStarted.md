# Getting Started with PhysicalUnits

Create measurements, convert between units, and let the compiler check your formulas.

## Installation

Add the package to `Package.swift`:

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

## Creating and converting measurements

Every quantity is created with a unit and read back through whichever unit you ask for. There is
no separate conversion call.

```swift
import PhysicalUnits

let body = Mass(70, unit: .kilograms)
print(body.grams)        // 70000.0
print(body.milligrams)   // 70000000.0

let height = Length(175, unit: .centimeters)
print(height.meters)     // 1.75
print(height.kilometers) // 0.00175

let lap = Duration(90, unit: .seconds)
print(lap.minutes)       // 1.5
print(lap.milliseconds)  // 90000.0

// Calories here are thermochemical calories: 1 cal = 4.184 J exactly.
let meal = Energy(500, unit: .kilocalories)
print(meal.kilojoules)   // 2092.0
```

## Arithmetic within a dimension

Values of the same dimension add, subtract, and scale. The input units need not match — every
measurement is stored in its dimension's base unit, so no conversion happens in between.

```swift
let a = Mass(1, unit: .kilograms)
let b = Mass(500, unit: .grams)

let total = a + b       // 1500 g
let doubled = a * 2.0   // 2000 g
let ratio = a / b       // 2.0, a dimensionless Double
```

Dividing two measurements of the same dimension gives a bare `Double`. That is the one place
where the dimension is deliberately discarded.

## Formulas across dimensions

Physical relations are typed operators, so annotating the result is enough to pick the right
one:

```swift
// Kinematics: distance = speed × time
let speed = Speed(60, unit: .kilometersPerHour)
let duration = Duration(2, unit: .hours)
let distance: Length = speed * duration
print(distance.kilometers)   // 120.0

// …and back the other way
let d2 = Length(100, unit: .kilometers)
let t2 = Duration(2, unit: .hours)
let v2: Speed = d2 / t2
print(v2.kilometersPerHour)  // 50.0

// Electricity: P = V × I
let voltage = Voltage(100, unit: .volts)
let current = Current(5, unit: .amperes)
let power: Power = voltage * current
print(power.watts)           // 500.0

// Ohm's law: V = I × R
let r = Resistance(20, unit: .ohms)
let v3: Voltage = current * r
print(v3.volts)              // 100.0
```

A combination nobody wrote an operator for does not compile. That is deliberate: see
<doc:Architecture> for why there is no general dimensional algebra.

## Temperature

Celsius and Fahrenheit convert to kelvin with an offset, not a scale factor, so an absolute
reading and a difference cannot be the same type. ``Temperature`` is the reading;
``TemperatureDelta`` is the difference. Adding two readings is meaningless and does not compile;
adding a delta to a reading does.

```swift
let body = Temperature(37, unit: .celsius)
print(body.kelvin)      // 310.15
print(body.fahrenheit)  // 98.6

let fever = body + TemperatureDelta(1.5, unit: .celsius)
print(fever.celsius)    // 38.5

// Subtracting two readings yields the difference between them.
let rise: TemperatureDelta = fever - body
print(rise.celsius)     // 1.5
print(rise.fahrenheit)  // 2.7  — a 1.5 K interval, not 34.7 °F
```

That last line is the reason for the split: a 1.5 °C *rise* is 2.7 °F, while a 1.5 °C *reading*
is 34.7 °F.

## Working with collections

```swift
let samples = [
    Mass(60, unit: .kilograms),
    Mass(70, unit: .kilograms),
    Mass(80, unit: .kilograms)
]

let total = samples.sum()        // 210 kg
let average = samples.average()  // 70 kg, Optional — nil when empty
let spread = samples.range()     // 20 kg, Optional
let heaviest = samples.maximum() // 80 kg, Optional
```

`sum()` returns zero for an empty sequence, since zero is meaningful for every dimension.
Everything that has no answer for an empty collection returns an optional instead.
