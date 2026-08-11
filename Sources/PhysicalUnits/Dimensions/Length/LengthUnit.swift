import Foundation

/// A unit of length: an SI prefix applied to the meter.
///
/// Every case is a power of ten away from the meter, so every conversion in this dimension is
/// exact by definition — 1 km = 1000 m, 1 cm = 0.01 m. There are no imperial units here: no
/// inches, feet, yards or miles, and so none of the rounding they would bring.
///
/// The factors are `Double`s, though, and only the non-negative powers of ten are exactly
/// representable. `kilo` scales exactly; `centi`, `milli`, `micro` and `nano` multiply by a
/// rounded factor, which can leave the low bits off a converted value.
///
/// Seven prefixes get a shorthand below. ``MetricPrefix`` has fifteen cases in all, from
/// `femto` (10⁻¹⁵) to `peta` (10¹⁵), and any of them can be passed directly:
/// `LengthUnit(.hecto)`.
public typealias LengthUnit = MetricUnit<Meter>

// MARK: - Convenience Static Properties

extension LengthUnit {
    @inlinable
    public static var meters: LengthUnit {
        LengthUnit(.base)
    }

    @inlinable
    public static var centimeters: LengthUnit {
        LengthUnit(.centi)
    }

    @inlinable
    public static var millimeters: LengthUnit {
        LengthUnit(.milli)
    }

    @inlinable
    public static var kilometers: LengthUnit {
        LengthUnit(.kilo)
    }

    @inlinable
    public static var micrometers: LengthUnit {
        LengthUnit(.micro)
    }

    @inlinable
    public static var nanometers: LengthUnit {
        LengthUnit(.nano)
    }

    /// Decimeter (dm), exactly 0.1 m.
    ///
    /// `Length` has no matching accessor, so read a value back with `value(in: .decimeters)`.
    @inlinable
    public static var decimeters: LengthUnit {
        LengthUnit(.deci)
    }
}

// MARK: - Length Type Alias

/// A length, stored internally in meters.
///
/// This is the length that the mechanics and kinematics operators consume and produce, so
/// `Energy / Force` comes back as meters and `Speed × Duration` as a distance in meters,
/// whatever unit the operands were written in.
///
/// ## Example
/// ```swift
/// let height = Length(175, unit: .centimeters)
/// print(height.meters)  // 1.75
///
/// let distance = Length(5, unit: .kilometers)
/// print(distance.meters)  // 5000.0
/// ```
public typealias Length = Measurement<LengthUnit>

// MARK: - Length Convenience Accessors

extension Length {
    @inlinable
    public var meters: Double {
        value(in: .meters)
    }

    @inlinable
    public var centimeters: Double {
        value(in: .centimeters)
    }

    @inlinable
    public var millimeters: Double {
        value(in: .millimeters)
    }

    @inlinable
    public var kilometers: Double {
        value(in: .kilometers)
    }

    @inlinable
    public var micrometers: Double {
        value(in: .micrometers)
    }

    @inlinable
    public var nanometers: Double {
        value(in: .nanometers)
    }
}

// MARK: - Length CustomStringConvertible

extension Length {
    /// The value in the largest metric multiple that fits: km from 1000 m, then m, cm, mm, and μm below 1 mm.
    ///
    /// Always two decimals. Decimeters and nanometers are never chosen, so anything smaller
    /// than a millimeter prints as a fraction of a micrometer and zero prints as `0.00 μm`.
    public var formatted: String {
        let m = meters
        if abs(m) >= 1000 {
            return String(format: "%.2f km", kilometers)
        } else if abs(m) >= 1 {
            return String(format: "%.2f m", m)
        } else if abs(centimeters) >= 1 {
            return String(format: "%.2f cm", centimeters)
        } else if abs(millimeters) >= 1 {
            return String(format: "%.2f mm", millimeters)
        } else {
            return String(format: "%.2f μm", micrometers)
        }
    }
}
