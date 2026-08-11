import Foundation

/// A unit of volume: an SI prefix applied to the liter.
///
/// The base unit is the **liter**, not the SI cubic meter, because a prefix cannot sensibly
/// attach to a cubed unit. 1 L = 0.001 m³ exactly, so no accuracy is given up: 1 kL is exactly
/// 1 m³, which is all `Volume.cubicMeters` is.
///
/// Every case is a power of ten away from the liter, so every conversion here is exact by
/// definition. There are no US or imperial units — the US gallon (exactly 3.785411784 L), the
/// imperial gallon (exactly 4.54609 L) and the fluid ounces derived from them are absent, and
/// so is the ambiguity between the two systems' same-named units.
///
/// The factors are `Double`s, and only the non-negative powers of ten are exactly
/// representable: `kilo` scales exactly, while `deci`, `centi`, `milli` and `micro` multiply by
/// a rounded factor.
///
/// Six prefixes get a shorthand below. ``MetricPrefix`` has fifteen cases in all, from `femto`
/// (10⁻¹⁵) to `peta` (10¹⁵), and any of them can be passed directly: `VolumeUnit(.hecto)`.
public typealias VolumeUnit = MetricUnit<Liter>

// MARK: - Convenience Static Properties

extension VolumeUnit {
    @inlinable
    public static var liters: VolumeUnit {
        VolumeUnit(.base)
    }

    @inlinable
    public static var milliliters: VolumeUnit {
        VolumeUnit(.milli)
    }

    /// Microliter (μL), exactly 10⁻⁶ L, which is also the cubic millimeter.
    ///
    /// `Volume` has no matching accessor, so read a value back with `value(in: .microliters)`.
    @inlinable
    public static var microliters: VolumeUnit {
        VolumeUnit(.micro)
    }

    @inlinable
    public static var centiliters: VolumeUnit {
        VolumeUnit(.centi)
    }

    @inlinable
    public static var deciliters: VolumeUnit {
        VolumeUnit(.deci)
    }

    /// Kiloliter (kL), exactly 1000 L, which is exactly one cubic meter.
    @inlinable
    public static var kiloliters: VolumeUnit {
        VolumeUnit(.kilo)
    }
}

// MARK: - Volume Type Alias

/// A volume, stored internally in liters.
///
/// No operator produces or consumes a `Volume`: nothing multiplies an `Area` by a `Length` to
/// reach one, and nothing divides a `Mass` by one to reach a density. This dimension only
/// converts and formats.
///
/// ## Example
/// ```swift
/// let water = Volume(500, unit: .milliliters)
/// print(water.liters)  // 0.5
///
/// let tank = Volume(100, unit: .liters)
/// print(tank.milliliters)  // 100000.0
/// ```
public typealias Volume = Measurement<VolumeUnit>

// MARK: - Volume Convenience Accessors

extension Volume {
    @inlinable
    public var liters: Double {
        value(in: .liters)
    }

    @inlinable
    public var milliliters: Double {
        value(in: .milliliters)
    }

    @inlinable
    public var centiliters: Double {
        value(in: .centiliters)
    }

    @inlinable
    public var deciliters: Double {
        value(in: .deciliters)
    }

    @inlinable
    public var kiloliters: Double {
        value(in: .kiloliters)
    }

    /// The value in cubic meters.
    ///
    /// Returns ``kiloliters`` unchanged, because 1 kL is exactly 1 m³. No arithmetic beyond the
    /// kiloliter conversion happens, so this costs nothing extra in accuracy.
    @inlinable
    public var cubicMeters: Double {
        kiloliters
    }
}

// MARK: - Volume Formatting

extension Volume {
    /// The value in the largest metric multiple that fits: kL from 1000 L, then L, mL, and μL below 1 mL.
    ///
    /// The number of decimals changes with the unit — two for kL and L, one for mL and μL.
    /// Centiliters and deciliters are never chosen, so 0.5 L prints as `0.50 L` rather than as
    /// `5 dL`, and zero prints as `0.0 μL`.
    public var formatted: String {
        let l = liters
        if abs(l) >= 1000 {
            return String(format: "%.2f kL", kiloliters)
        } else if abs(l) >= 1 {
            return String(format: "%.2f L", l)
        } else if abs(milliliters) >= 1 {
            return String(format: "%.1f mL", milliliters)
        } else {
            return String(format: "%.1f μL", value(in: .microliters))
        }
    }
}
