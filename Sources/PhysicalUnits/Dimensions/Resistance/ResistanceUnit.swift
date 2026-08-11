import Foundation

/// A unit of electrical resistance: an SI prefix applied to the ohm.
///
/// Every case is a power of ten away from the ohm, so every conversion here is exact by
/// definition. The factors are `Double`s, and only the non-negative powers of ten are exactly
/// representable: `kilo`, `mega` and `giga` scale exactly, while `milli` multiplies by a
/// rounded factor.
///
/// Five prefixes get a shorthand below. Their spelling is not uniform — `kilohms` elides the
/// doubled o, while `megaohms` and `gigaohms` keep it. ``MetricPrefix`` has fifteen cases
/// in all, from `femto` (10⁻¹⁵) to `peta` (10¹⁵), and any of them can be passed directly:
/// `ResistanceUnit(.micro)`.
///
/// ## Ohm's Law
/// V = I × R. `ElectricityOperators` spells out all three rearrangements as typed operators, so
/// `Voltage / Resistance` gives a `Current` and nothing has to be converted by hand.
///
/// ## Example
/// ```swift
/// let resistor = Resistance(4.7, unit: .kilohms)
/// print(resistor.ohms)  // 4700.0
/// ```
public typealias ResistanceUnit = MetricUnit<Ohm>

// MARK: - Convenience Static Properties

extension ResistanceUnit {
    @inlinable
    public static var ohms: ResistanceUnit {
        ResistanceUnit(.base)
    }

    @inlinable
    public static var milliohms: ResistanceUnit {
        ResistanceUnit(.milli)
    }

    /// Kilohm (kΩ), exactly 1000 Ω.
    ///
    /// Spelled with a single o, unlike `megaohms` and `gigaohms`.
    @inlinable
    public static var kilohms: ResistanceUnit {
        ResistanceUnit(.kilo)
    }

    @inlinable
    public static var megaohms: ResistanceUnit {
        ResistanceUnit(.mega)
    }

    @inlinable
    public static var gigaohms: ResistanceUnit {
        ResistanceUnit(.giga)
    }
}

// MARK: - Resistance Type Alias

/// A resistance, stored internally in ohms.
///
/// Ohmic resistance, taken as constant: nothing here varies with temperature, frequency or
/// applied voltage, and there is no reactance or impedance in the package to combine it with.
/// `resistance(at:)` and `power(at:)` in `ElectricityOperators` carry the squared relations
/// P = I²R and P = V²/R, which the typed operators cannot express.
///
/// ## Example
/// ```swift
/// let resistor = Resistance(220, unit: .ohms)
/// print(resistor.kilohms)  // 0.22
///
/// // Ohm's law
/// let voltage = Voltage(5, unit: .volts)
/// let current: Current = voltage / resistor  // 22.7 mA
/// ```
public typealias Resistance = Measurement<ResistanceUnit>

// MARK: - Resistance Convenience Accessors

extension Resistance {
    @inlinable
    public var ohms: Double {
        value(in: .ohms)
    }

    @inlinable
    public var milliohms: Double {
        value(in: .milliohms)
    }

    @inlinable
    public var kilohms: Double {
        value(in: .kilohms)
    }

    @inlinable
    public var megaohms: Double {
        value(in: .megaohms)
    }

    @inlinable
    public var gigaohms: Double {
        value(in: .gigaohms)
    }
}

// MARK: - Resistance Formatting

extension Resistance {
    /// The value in the largest metric multiple that fits: GΩ from 10⁹ Ω, then MΩ, kΩ, Ω, and mΩ below 1 Ω.
    ///
    /// Always two decimals. There is no smaller unit than mΩ, so a microohm prints as
    /// `0.00 mΩ`, and so does zero.
    public var formatted: String {
        let r = ohms
        if abs(r) >= 1e9 {
            return String(format: "%.2f GΩ", gigaohms)
        } else if abs(r) >= 1e6 {
            return String(format: "%.2f MΩ", megaohms)
        } else if abs(r) >= 1e3 {
            return String(format: "%.2f kΩ", kilohms)
        } else if abs(r) >= 1 {
            return String(format: "%.2f Ω", r)
        } else {
            return String(format: "%.2f mΩ", milliohms)
        }
    }
}

// MARK: - Resistance Common Values

extension Resistance {
    /// 220 Ω, a common series resistor for an LED on a 5 V rail.
    ///
    /// A convention rather than a derived value: the right resistor depends on the supply
    /// voltage, the LED's forward voltage and the current you want through it.
    public static let led220 = Resistance(220, unit: .ohms)

    /// 10 kΩ, the usual pull-up for a slow digital input.
    public static let pullUp10k = Resistance(10, unit: .kilohms)

    /// 4.7 kΩ, the usual pull-up for an I²C bus at standard speed.
    ///
    /// Named for the E24 preferred value 4.7, not for anything computed. The value that
    /// actually works depends on bus capacitance and clock rate.
    public static let pullUp4k7 = Resistance(4.7, unit: .kilohms)
}
