import Foundation

/// An SI prefix, stored as the factor it multiplies the base unit by.
///
/// The raw value *is* the factor, so reading ``factor`` is a load rather than a `switch`.
///
/// The fifteen cases run from 10¹⁵ (``peta``) down to 10⁻¹⁵ (``femto``): every power of ten
/// between 10³ and 10⁻³, then every third power out to each end. There is no case for exa,
/// atto, or anything further out, and none for the binary prefixes such as kibi and mebi.
///
/// Scaling multiplies a `Double` by the factor, so it is exact only where the factor itself
/// is exact. Every power of ten from 10⁰ up to about 10²² is exactly representable, so
/// ``base`` and all seven positive prefixes scale exactly. The negative ones, ``deci``
/// through ``femto``, are stored as the nearest `Double` and can leave low bits off.
///
/// ```swift
/// let kilo = MetricPrefix.kilo
/// print(kilo.factor)   // 1000.0
/// print(kilo.symbol)   // "k"
/// ```
@frozen
public enum MetricPrefix: Double, Sendable, Hashable, Codable, CaseIterable {
    case peta  = 1e15

    case tera  = 1e12

    case giga  = 1e9

    case mega  = 1e6

    case kilo  = 1e3

    case hecto = 1e2

    case deca  = 1e1

    /// The unprefixed unit, a factor of 1.
    case base  = 1

    case deci  = 1e-1

    case centi = 1e-2

    case milli = 1e-3

    case micro = 1e-6

    case nano  = 1e-9

    case pico  = 1e-12

    case femto = 1e-15

    // MARK: - Properties

    /// The multiplier this prefix applies to the base unit.
    ///
    /// It is the raw value, so unlike ``symbol`` and ``name`` it costs no branching.
    @inlinable
    public var factor: Double { rawValue }

    /// The prefix symbol, or an empty string for ``base``.
    ///
    /// Micro is the Greek small letter mu (U+03BC), not the micro sign (U+00B5), which
    /// matters when comparing symbols byte for byte.
    public var symbol: String {
        switch self {
        case .peta:  return "P"
        case .tera:  return "T"
        case .giga:  return "G"
        case .mega:  return "M"
        case .kilo:  return "k"
        case .hecto: return "h"
        case .deca:  return "da"
        case .base:  return ""
        case .deci:  return "d"
        case .centi: return "c"
        case .milli: return "m"
        case .micro: return "μ"
        case .nano:  return "n"
        case .pico:  return "p"
        case .femto: return "f"
        }
    }

    /// The spelled-out prefix name, or an empty string for ``base``.
    public var name: String {
        switch self {
        case .peta:  return "peta"
        case .tera:  return "tera"
        case .giga:  return "giga"
        case .mega:  return "mega"
        case .kilo:  return "kilo"
        case .hecto: return "hecto"
        case .deca:  return "deca"
        case .base:  return ""
        case .deci:  return "deci"
        case .centi: return "centi"
        case .milli: return "milli"
        case .micro: return "micro"
        case .nano:  return "nano"
        case .pico:  return "pico"
        case .femto: return "femto"
        }
    }

    /// The base-ten exponent of ``factor``: `3` for kilo, `-3` for milli.
    ///
    /// Unlike ``factor`` this is an exact integer, so it is the safe thing to do arithmetic
    /// on when combining prefixes.
    public var exponent: Int {
        switch self {
        case .peta:  return 15
        case .tera:  return 12
        case .giga:  return 9
        case .mega:  return 6
        case .kilo:  return 3
        case .hecto: return 2
        case .deca:  return 1
        case .base:  return 0
        case .deci:  return -1
        case .centi: return -2
        case .milli: return -3
        case .micro: return -6
        case .nano:  return -9
        case .pico:  return -12
        case .femto: return -15
        }
    }
}

// MARK: - CustomStringConvertible

extension MetricPrefix: CustomStringConvertible {
    /// The prefix name, or the literal text `(base)` for ``base``, whose name is empty.
    public var description: String {
        name.isEmpty ? "(base)" : name
    }
}
