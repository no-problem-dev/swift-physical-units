import Foundation

/// A unit of current: an SI prefix applied to the ampere.
///
/// Every case is a power of ten away from the ampere, so every conversion here is exact by
/// definition. The factors are `Double`s, and only the non-negative powers of ten are exactly
/// representable: `kilo` scales exactly, while `milli`, `micro` and `nano` multiply by a
/// rounded factor.
///
/// Five prefixes get a shorthand below. ``MetricPrefix`` has fifteen cases in all, from `femto`
/// (10⁻¹⁵) to `peta` (10¹⁵), and any of them can be passed directly: `CurrentUnit(.pico)`.
public typealias CurrentUnit = MetricUnit<Ampere>

// MARK: - Convenience Static Properties

extension CurrentUnit {
    @inlinable
    public static var amperes: CurrentUnit {
        CurrentUnit(.base)
    }

    @inlinable
    public static var nanoamperes: CurrentUnit {
        CurrentUnit(.nano)
    }

    @inlinable
    public static var microamperes: CurrentUnit {
        CurrentUnit(.micro)
    }

    @inlinable
    public static var milliamperes: CurrentUnit {
        CurrentUnit(.milli)
    }

    @inlinable
    public static var kiloamperes: CurrentUnit {
        CurrentUnit(.kilo)
    }
}

// MARK: - Current Type Alias

/// A current, stored internally in amperes.
///
/// The SI electrical units are coherent, so the operators that reach this type — Ohm's law and
/// P = V × I in `ElectricityOperators` — apply no conversion factor at all: 1 W = 1 V·A and
/// 1 Ω = 1 V/A are exact by definition.
///
/// ## Example
/// ```swift
/// let led = Current(20, unit: .milliamperes)
/// print(led.amperes)  // 0.02
///
/// let motor = Current(5, unit: .amperes)
/// print(motor.milliamperes)  // 5000.0
/// ```
public typealias Current = Measurement<CurrentUnit>

// MARK: - Current Convenience Accessors

extension Current {
    @inlinable
    public var amperes: Double {
        value(in: .amperes)
    }

    @inlinable
    public var nanoamperes: Double {
        value(in: .nanoamperes)
    }

    @inlinable
    public var microamperes: Double {
        value(in: .microamperes)
    }

    @inlinable
    public var milliamperes: Double {
        value(in: .milliamperes)
    }

    @inlinable
    public var kiloamperes: Double {
        value(in: .kiloamperes)
    }
}

// MARK: - Current Formatting

extension Current {
    /// The value in the largest metric multiple that fits: kA from 1000 A, then A, mA, μA, and nA below 1 μA.
    ///
    /// The number of decimals changes with the unit — two down to mA, one for μA and nA. Zero
    /// prints as `0.0 nA`.
    public var formatted: String {
        let a = amperes
        if abs(a) >= 1e3 {
            return String(format: "%.2f kA", kiloamperes)
        } else if abs(a) >= 1 {
            return String(format: "%.2f A", a)
        } else if abs(milliamperes) >= 1 {
            return String(format: "%.2f mA", milliamperes)
        } else if abs(microamperes) >= 1 {
            return String(format: "%.1f μA", microamperes)
        } else {
            return String(format: "%.1f nA", nanoamperes)
        }
    }
}

// MARK: - Current Special Values

extension Current {
    /// The 500 mA a USB 2.0 downstream port is rated to supply: five 100 mA unit loads.
    ///
    /// A ceiling from the specification, not a measurement of any particular port. A device
    /// that has not finished enumerating is entitled to one unit load, 100 mA.
    public static let usb2Max = Current(500, unit: .milliamperes)

    /// The 900 mA a USB 3.x SuperSpeed downstream port is rated to supply: six 150 mA unit loads.
    public static let usb3Max = Current(900, unit: .milliamperes)

    /// The 5 A ceiling of USB Power Delivery, the most any PD contract negotiates.
    ///
    /// Reaching it needs an electronically marked cable; PD tops out at 3 A over an unmarked
    /// one. This is the current ceiling only — the wattage a charger advertises is this current
    /// against a negotiated voltage, which PD raises well past the 5 V of `Voltage.usb`.
    public static let usbPDMax = Current(5, unit: .amperes)
}
