import Foundation

/// A unit of angular speed, measured against radians per second.
///
/// Angular speed is the rate of change of angle: ω = θ/t = 2πf. The base unit is rad/s.
///
/// ## Conversions
/// - 1 rad/s is the base unit
/// - 1 °/s = π/180 rad/s
/// - 1 rpm = 2π/60 rad/s ≈ 0.10472 rad/s
/// - 1 rps = 2π rad/s, which as a rotational frequency is 1 Hz
///
/// The 60 and the 180 are exact, but every factor carries π, so the stored values are exact
/// definitions rounded to `Double`. `rpsToRadPerSec` is exactly twice `Double.pi`, while
/// `rpmToRadPerSec` and `degreesToRadians` take one further rounding from the division.
///
/// ## Where the type checking stops
/// The radian is dimensionless, so rad/s and a bare s⁻¹ are the same dimension. The type keeps
/// angular speed apart from `Frequency`, but the factor of 2π between them is a convention this
/// package applies for you, not something the compiler can verify — and `speed / radius` returns
/// rad/s on that same convention.
///
/// ## Example
/// ```swift
/// let motor = AngularSpeed(3000, unit: .rpm)
/// print(motor.radiansPerSecond)  // 314.159...
/// ```
@frozen
public enum AngularSpeedUnit: Unit, Codable, Sendable, Hashable {
    /// Radians per second, the base of this type.
    case radiansPerSecond

    case degreesPerSecond

    /// Revolutions per minute: 2π/60 rad/s, or 6°/s.
    case revolutionsPerMinute

    /// Revolutions per second: 2π rad/s. This is the rotational frequency f in hertz, not ω.
    case revolutionsPerSecond

    // MARK: - Constants

    /// Degrees per second to radians per second: π/180, an exact definition rounded to `Double`.
    public static let degreesToRadians: Double = .pi / 180.0

    /// Revolutions per minute to radians per second: 2π/60, an exact definition rounded to `Double`.
    public static let rpmToRadPerSec: Double = 2.0 * .pi / 60.0

    /// Revolutions per second to radians per second: 2π, exactly twice `Double.pi`.
    public static let rpsToRadPerSec: Double = 2.0 * .pi

    // MARK: - Unit Protocol

    /// The factor that converts a value in this unit to radians per second.
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .radiansPerSecond:
            return 1.0
        case .degreesPerSecond:
            return Self.degreesToRadians
        case .revolutionsPerMinute:
            return Self.rpmToRadPerSec
        case .revolutionsPerSecond:
            return Self.rpsToRadPerSec
        }
    }

    /// The symbol: "rad/s", "°/s", "rpm", "rps".
    public var symbol: String {
        switch self {
        case .radiansPerSecond:
            return "rad/s"
        case .degreesPerSecond:
            return "°/s"
        case .revolutionsPerMinute:
            return "rpm"
        case .revolutionsPerSecond:
            return "rps"
        }
    }
}

// MARK: - CustomStringConvertible

extension AngularSpeedUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - AngularSpeed Type Alias

/// An angular speed, stored in radians per second.
///
/// A type alias for `Measurement<AngularSpeedUnit>`. Dividing an `Angle` by a `Duration` gives
/// one of these; multiplying it by a radius gives a `Speed`.
///
/// ## Example
/// ```swift
/// let fan = AngularSpeed(1200, unit: .rpm)
/// print(fan.radiansPerSecond)  // 125.66...
///
/// // Angular speed from an angle and a duration
/// let angle = Angle(360, unit: .degrees)
/// let time = Duration(1, unit: .seconds)
/// let speed: AngularSpeed = angle / time  // 2π rad/s
/// ```
public typealias AngularSpeed = Measurement<AngularSpeedUnit>

// MARK: - AngularSpeed Convenience Accessors

extension AngularSpeed {
    @inlinable
    public var radiansPerSecond: Double {
        value(in: .radiansPerSecond)
    }

    @inlinable
    public var degreesPerSecond: Double {
        value(in: .degreesPerSecond)
    }

    @inlinable
    public var rpm: Double {
        value(in: .revolutionsPerMinute)
    }

    @inlinable
    public var rps: Double {
        value(in: .revolutionsPerSecond)
    }

    /// The rotational frequency in hertz, the same number as `rps`.
    ///
    /// This is f, not ω: 2π rad/s reads 1.0 here. Multiply by 2π to get back to rad/s.
    @inlinable
    public var hertz: Double {
        rps
    }
}

// MARK: - AngularSpeed Formatting

extension AngularSpeed {
    /// A string in rpm from 1 rpm up, otherwise in rad/s.
    ///
    /// rpm prints with one decimal, rad/s with three. The cut is at 1 rpm ≈ 0.105 rad/s, so
    /// anything slower reads in rad/s.
    public var formatted: String {
        let rpmVal = rpm
        if abs(rpmVal) >= 1 {
            return String(format: "%.1f rpm", rpmVal)
        } else {
            return String(format: "%.3f rad/s", radiansPerSecond)
        }
    }
}

// MARK: - AngularSpeed Common Values

extension AngularSpeed {
    /// Earth's rotation rate, about 7.2921159e-5 rad/s.
    ///
    /// A rounded measured value, not a definition. It is the sidereal rate — one turn per
    /// sidereal day of roughly 86,164 s, not per the 86,400 s solar day.
    public static let earthRotation = AngularSpeed(7.2921159e-5, unit: .radiansPerSecond)

    /// A clock's second hand: exactly 1 rpm, or 6°/s.
    public static let clockSecondHand = AngularSpeed(1, unit: .revolutionsPerMinute)

    /// A clock's minute hand: 1/60 rpm, one turn an hour.
    ///
    /// 1/60 has no exact binary form, so the stored value is the nearest `Double`.
    public static let clockMinuteHand = AngularSpeed(1.0 / 60.0, unit: .revolutionsPerMinute)
}
