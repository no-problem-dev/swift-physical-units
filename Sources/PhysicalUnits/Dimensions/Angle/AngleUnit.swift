import Foundation

/// A unit of plane angle, measured against the radian.
///
/// The radian is a dimensionless SI derived unit (rad = m/m), so this is a plain scale over
/// radians rather than a dimension of its own.
///
/// ## Where the type checking stops
/// Because an angle is dimensionless, nothing at the type level keeps an `Angle` apart from a
/// bare number. `sin`, `cos`, `tan` and `Angle / Angle` all hand back a plain `Double`, and
/// `Angle * Double` accepts any `Double` at all — past that point the unit is yours to track.
///
/// ## Conversions
/// - 1 turn = 2π rad = 360° = 400 grad
/// - 1 rad = 180/π° ≈ 57.2958°
/// - 1° = π/180 rad ≈ 0.01745 rad
///
/// These are exact definitions, but π is irrational, so the stored factors are only as good as
/// `Double`. `turnsToRadians` is exactly twice `Double.pi` — doubling is exact in binary —
/// while `degreesToRadians` and `gradiansToRadians` take one further rounding from the division.
/// A degrees → radians → degrees round trip is therefore accurate, not bit-identical.
///
/// ## Example
/// ```swift
/// let rightAngle = Angle(90, unit: .degrees)
/// print(rightAngle.radians)  // 1.5708 (π/2)
///
/// let halfTurn = Angle(.pi, unit: .radians)
/// print(halfTurn.degrees)    // 180.0
/// ```
@frozen
public enum AngleUnit: Unit, Codable, Sendable, Hashable, CaseIterable {
    /// The radian, the dimensionless SI unit of plane angle and the base of this type.
    case radians

    case degrees

    /// The gradian: one hundredth of a right angle, so 400 grad to a full turn.
    case gradians

    /// One full revolution: 2π rad, or 360°.
    case turns

    // MARK: - Constants

    /// Degrees to radians: π/180, an exact definition stored as `Double.pi / 180`.
    public static let degreesToRadians: Double = .pi / 180.0

    /// Gradians to radians: π/200, an exact definition stored as `Double.pi / 200`.
    public static let gradiansToRadians: Double = .pi / 200.0

    /// Turns to radians: 2π, stored as exactly twice `Double.pi` with no extra rounding.
    public static let turnsToRadians: Double = 2.0 * .pi

    // MARK: - Unit Protocol

    /// The factor that converts a value in this unit to radians.
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .radians:
            return 1.0
        case .degrees:
            return Self.degreesToRadians
        case .gradians:
            return Self.gradiansToRadians
        case .turns:
            return Self.turnsToRadians
        }
    }

    /// The symbol: "rad", "°", "grad", "turn".
    public var symbol: String {
        switch self {
        case .radians:
            return "rad"
        case .degrees:
            return "°"
        case .gradians:
            return "grad"
        case .turns:
            return "turn"
        }
    }
}

// MARK: - CustomStringConvertible

extension AngleUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Angle Type Alias

/// A plane angle, stored in radians.
///
/// A type alias for `Measurement<AngleUnit>`. It keeps degrees and radians straight for you,
/// but an angle is dimensionless, so it cannot stop the value being treated as a bare number.
/// Values are never wrapped into a single turn: 540° stays 540°.
///
/// ## Example
/// ```swift
/// let angle = Angle(45, unit: .degrees)
/// print(angle.radians)  // 0.7854 (π/4)
///
/// let rotation = Angle(1.5, unit: .turns)
/// print(rotation.degrees)  // 540.0
/// ```
public typealias Angle = Measurement<AngleUnit>

// MARK: - Angle Convenience Accessors

extension Angle {
    @inlinable
    public var radians: Double {
        value(in: .radians)
    }

    @inlinable
    public var degrees: Double {
        value(in: .degrees)
    }

    @inlinable
    public var gradians: Double {
        value(in: .gradians)
    }

    @inlinable
    public var turns: Double {
        value(in: .turns)
    }
}

// MARK: - Angle Formatting

extension Angle {
    /// The angle in degrees to two decimals, with the degree sign.
    ///
    /// Nothing is wrapped into a single turn, so 1.5 turns prints as "540.00°".
    public var formattedDegrees: String {
        String(format: "%.2f°", degrees)
    }

    /// The angle in radians to four decimals, followed by "rad".
    public var formattedRadians: String {
        String(format: "%.4f rad", radians)
    }
}

// MARK: - Angle Special Values

extension Angle {
    /// A right angle: 90°, or π/2 rad.
    public static let rightAngle = Angle(90, unit: .degrees)

    /// A straight angle: 180°, or π rad.
    public static let straightAngle = Angle(180, unit: .degrees)

    /// A full turn: 360°, or 2π rad. Nothing wraps, so this does not compare equal to `zero`.
    public static let fullAngle = Angle(360, unit: .degrees)

    public static let zero = Angle(0, unit: .radians)
}

// MARK: - Trigonometric Functions

extension Angle {
    /// The sine of the angle, taken in radians whichever unit the value was built with.
    @inlinable
    public var sin: Double {
        Foundation.sin(radians)
    }

    /// The cosine of the angle, taken in radians whichever unit the value was built with.
    @inlinable
    public var cos: Double {
        Foundation.cos(radians)
    }

    /// The tangent of the angle, taken in radians whichever unit the value was built with.
    ///
    /// - Warning: Nothing guards the poles at ±90°. `Double` cannot hold π/2 exactly, so a right
    ///   angle returns about 1.63e16 instead of infinity or an error. Test the angle, not the
    ///   result, if you need to reject those.
    @inlinable
    public var tan: Double {
        Foundation.tan(radians)
    }
}
