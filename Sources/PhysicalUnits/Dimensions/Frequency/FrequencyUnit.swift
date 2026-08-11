import Foundation

/// A unit of frequency: an SI prefix applied to the hertz.
///
/// Every case is a power of ten away from the hertz, so every conversion here is exact by
/// definition. The factors are `Double`s, and only the non-negative powers of ten are exactly
/// representable: `kilo` through `tera` scale exactly, while `milli` multiplies by a rounded
/// factor.
///
/// Six prefixes get a shorthand below. ``MetricPrefix`` has fifteen cases in all, from `femto`
/// (10⁻¹⁵) to `peta` (10¹⁵), and any of them can be passed directly: `FrequencyUnit(.peta)`.
public typealias FrequencyUnit = MetricUnit<Hertz>

// MARK: - Convenience Static Properties

extension FrequencyUnit {
    @inlinable
    public static var hertz: FrequencyUnit {
        FrequencyUnit(.base)
    }

    @inlinable
    public static var millihertz: FrequencyUnit {
        FrequencyUnit(.milli)
    }

    @inlinable
    public static var kilohertz: FrequencyUnit {
        FrequencyUnit(.kilo)
    }

    @inlinable
    public static var megahertz: FrequencyUnit {
        FrequencyUnit(.mega)
    }

    @inlinable
    public static var gigahertz: FrequencyUnit {
        FrequencyUnit(.giga)
    }

    @inlinable
    public static var terahertz: FrequencyUnit {
        FrequencyUnit(.tera)
    }
}

// MARK: - Frequency Type Alias

/// A frequency, stored internally in hertz.
///
/// `FrequencyOperators` connects this to `Duration` by reciprocal (`asPeriod`, `asFrequency`)
/// and to `Angle` and `AngularSpeed` through 2π rad per cycle. None of those conversions
/// applies a rounded literal; the only loss is `Double`'s π.
///
/// ## Example
/// ```swift
/// let radio = Frequency(88.1, unit: .megahertz)
/// print(radio.kilohertz)  // 88100.0
///
/// let cpu = Frequency(3.5, unit: .gigahertz)
/// print(cpu.megahertz)    // 3500.0
/// ```
public typealias Frequency = Measurement<FrequencyUnit>

// MARK: - Frequency Convenience Accessors

extension Frequency {
    @inlinable
    public var hertz: Double {
        value(in: .hertz)
    }

    @inlinable
    public var millihertz: Double {
        value(in: .millihertz)
    }

    @inlinable
    public var kilohertz: Double {
        value(in: .kilohertz)
    }

    @inlinable
    public var megahertz: Double {
        value(in: .megahertz)
    }

    @inlinable
    public var gigahertz: Double {
        value(in: .gigahertz)
    }

    @inlinable
    public var terahertz: Double {
        value(in: .terahertz)
    }

    /// The length of one cycle in seconds, as a plain number.
    ///
    /// Returning `Double` drops the dimension, so nothing downstream catches a period used
    /// where something else was meant. `asPeriod` in `FrequencyOperators` computes the same
    /// reciprocal and hands back a typed `Duration`; prefer it.
    ///
    /// A zero frequency yields infinity rather than trapping, since this is `Double` division.
    @inlinable
    public var period: Double {
        1.0 / hertz
    }
}

// MARK: - Frequency Formatting

extension Frequency {
    /// The value in the largest metric multiple that fits: THz from 10¹² Hz, then GHz, MHz, kHz, Hz, and mHz below 1 Hz.
    ///
    /// Two decimals down to Hz, three for mHz. Zero prints as `0.000 mHz`.
    public var formatted: String {
        let hz = hertz
        if abs(hz) >= 1e12 {
            return String(format: "%.2f THz", terahertz)
        } else if abs(hz) >= 1e9 {
            return String(format: "%.2f GHz", gigahertz)
        } else if abs(hz) >= 1e6 {
            return String(format: "%.2f MHz", megahertz)
        } else if abs(hz) >= 1e3 {
            return String(format: "%.2f kHz", kilohertz)
        } else if abs(hz) >= 1 {
            return String(format: "%.2f Hz", hz)
        } else {
            return String(format: "%.3f mHz", millihertz)
        }
    }
}
