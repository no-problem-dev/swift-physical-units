import Foundation

/// A unit of acceleration, convertible to and from metres per second squared.
///
/// The base unit is m/s², the rate at which speed changes (a = Δv / Δt).
///
/// ## Conversions
/// - 1 g = 9.80665 m/s², exact. Standard gravity is a defined constant, so it does not vary
///   with latitude or altitude the way locally measured gravity does.
/// - 1 Gal = 0.01 m/s² = 1 cm/s², exact by definition of the CGS system. Used in geodesy and
///   seismology.
/// - 1 mGal = 10⁻⁵ m/s², exact.
///
/// ## Example
/// ```swift
/// let gravity = Acceleration(1, unit: .standardGravity)
/// print(gravity.metersPerSecondSquared)  // 9.80665
///
/// let car = Acceleration(3, unit: .metersPerSecondSquared)
/// print(car.standardGravity)  // 0.306
/// ```
@frozen
public enum AccelerationUnit: Unit, Codable, Sendable, Hashable {
    /// Metre per second squared (m/s²), the base unit every other case converts against.
    case metersPerSecondSquared

    /// Standard gravity (g), exactly 9.80665 m/s².
    case standardGravity

    /// Gal, the CGS unit used in seismology and gravimetry: exactly 0.01 m/s² = 1 cm/s².
    case gal

    /// Milligal (mGal), exactly 10⁻⁵ m/s².
    case milligal

    // MARK: - Constants

    /// Standard gravity g₀ in m/s², exactly 9.80665 by definition.
    ///
    /// A conventional value fixed by agreement, not a measurement of gravity anywhere in
    /// particular. `ForceUnit.standardGravity` holds an independent copy of the same number.
    public static let standardGravityValue: Double = 9.80665

    /// Gal in m/s², exactly 0.01 by definition.
    public static let galToMsSquared: Double = 0.01

    // MARK: - Unit Protocol

    /// The multiplier that turns a value in this unit into m/s².
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .metersPerSecondSquared:
            return 1.0
        case .standardGravity:
            return Self.standardGravityValue
        case .gal:
            return Self.galToMsSquared
        case .milligal:
            return Self.galToMsSquared * 1e-3
        }
    }

    public var symbol: String {
        switch self {
        case .metersPerSecondSquared:
            return "m/s²"
        case .standardGravity:
            return "g"
        case .gal:
            return "Gal"
        case .milligal:
            return "mGal"
        }
    }
}

// MARK: - CustomStringConvertible

extension AccelerationUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Acceleration Type Alias

/// An acceleration, stored internally in m/s².
///
/// ## Example
/// ```swift
/// let freefall = Acceleration(1, unit: .standardGravity)
/// print(freefall.metersPerSecondSquared)  // 9.80665
///
/// let braking = Acceleration(-5, unit: .metersPerSecondSquared)
/// print(braking.standardGravity)  // -0.51
/// ```
public typealias Acceleration = Measurement<AccelerationUnit>

// MARK: - Acceleration Convenience Accessors

extension Acceleration {
    @inlinable
    public var metersPerSecondSquared: Double {
        value(in: .metersPerSecondSquared)
    }

    @inlinable
    public var standardGravity: Double {
        value(in: .standardGravity)
    }

    @inlinable
    public var gal: Double {
        value(in: .gal)
    }

    @inlinable
    public var milligal: Double {
        value(in: .milligal)
    }
}

// MARK: - Acceleration Formatting

extension Acceleration {
    /// The value as g from 1 g upward, as m/s² down to 0.01 m/s², and as mGal below that.
    ///
    /// The Gal branch below never runs: `abs(gal) >= 1` is the same condition as
    /// `abs(metersPerSecondSquared) >= 0.01`, which the preceding branch has already taken.
    /// This property therefore never prints `Gal`.
    public var formatted: String {
        let ms2 = metersPerSecondSquared
        if abs(ms2) >= AccelerationUnit.standardGravityValue {
            return String(format: "%.2f g", standardGravity)
        } else if abs(ms2) >= 0.01 {
            return String(format: "%.3f m/s²", ms2)
        } else if abs(gal) >= 1 {
            return String(format: "%.2f Gal", gal)
        } else {
            return String(format: "%.1f mGal", milligal)
        }
    }
}

// MARK: - Acceleration Special Values

extension Acceleration {
    /// Standard gravity at sea level: 1 g, exactly 9.80665 m/s².
    public static let gravity = Acceleration(1, unit: .standardGravity)

    /// Mean surface gravity of the Moon, 1.62 m/s² — a rounded measured value, not a defined one.
    public static let moonGravity = Acceleration(1.62, unit: .metersPerSecondSquared)

    /// Mean surface gravity of Mars, 3.72 m/s² — a rounded measured value, not a defined one.
    public static let marsGravity = Acceleration(3.72, unit: .metersPerSecondSquared)

    /// Zero acceleration. Shadows the `AdditiveArithmetic` zero for this dimension with the same value.
    public static let zero = Acceleration(0, unit: .metersPerSecondSquared)
}
