import Foundation

/// A unit of force, convertible to and from newtons.
///
/// The base unit is the newton (N): 1 N = 1 kg⋅m⋅s⁻², the force that accelerates a 1 kg mass
/// at 1 m/s². The newton is kilogram-based, while this library's mass base unit is the gram —
/// see `Force` for how the two are bridged.
///
/// ## Conversions
/// - 1 kN = 1000 N, exact.
/// - 1 kgf = 9.80665 N, exact. The kilogram-force is one kilogram under standard gravity, and
///   g₀ = 9.80665 m/s² is a defined value rather than a measurement.
/// - 1 lbf = 4.4482216152605 N, exact. It is 0.45359237 kg (the exact international pound)
///   times g₀, and the constant here keeps every digit of that product.
/// - 1 dyn = 10⁻⁵ N, exact by definition of the CGS system.
///
/// ## Example
/// ```swift
/// let weight = Force(70, unit: .kilogramsForce)
/// print(weight.newtons)  // 686.47
///
/// let thrust = Force(100, unit: .kilonewtons)
/// print(thrust.newtons)  // 100000.0
/// ```
@frozen
public enum ForceUnit: Unit, Codable, Sendable, Hashable, CaseIterable {
    /// Newton (N), the base unit every other case converts against.
    case newtons

    /// Millinewton (mN), exactly 10⁻³ N.
    case millinewtons

    /// Kilonewton (kN), exactly 10³ N.
    case kilonewtons

    /// Meganewton (MN), exactly 10⁶ N.
    case meganewtons

    /// Kilogram-force (kgf), exactly 9.80665 N: the weight of 1 kg under standard gravity.
    case kilogramsForce

    /// Pound-force (lbf), exactly 4.4482216152605 N: the weight of one international pound
    /// under standard gravity.
    case poundsForce

    /// Dyne (dyn), the CGS unit of force: exactly 10⁻⁵ N.
    case dynes

    // MARK: - Constants

    /// Standard gravity g₀ in m/s², exactly 9.80665 by definition.
    ///
    /// This is the conventional value, not a local measurement, so it does not vary with
    /// latitude or altitude. `AccelerationUnit.standardGravityValue` holds an independent copy
    /// of the same number.
    public static let standardGravity: Double = 9.80665

    /// Pound-force in newtons: exactly 0.45359237 × 9.80665, written to full precision.
    public static let lbfToNewtons: Double = 4.4482216152605

    /// Dyne in newtons, exactly 10⁻⁵ by definition.
    public static let dyneToNewtons: Double = 1e-5

    // MARK: - Unit Protocol

    /// The multiplier that turns a value in this unit into newtons.
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .newtons:
            return 1.0
        case .millinewtons:
            return 1e-3
        case .kilonewtons:
            return 1e3
        case .meganewtons:
            return 1e6
        case .kilogramsForce:
            return Self.standardGravity
        case .poundsForce:
            return Self.lbfToNewtons
        case .dynes:
            return Self.dyneToNewtons
        }
    }

    public var symbol: String {
        switch self {
        case .newtons:
            return "N"
        case .millinewtons:
            return "mN"
        case .kilonewtons:
            return "kN"
        case .meganewtons:
            return "MN"
        case .kilogramsForce:
            return "kgf"
        case .poundsForce:
            return "lbf"
        case .dynes:
            return "dyn"
        }
    }
}

// MARK: - CustomStringConvertible

extension ForceUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Force Type Alias

/// A force, stored internally in newtons.
///
/// - Important: Force here is kilogram-based (kg⋅m⋅s⁻²) while `Mass` is gram-based. The typed
///   `Mass` × `Acceleration` and `Force` / `Mass` operators apply the ×1000 / ÷1000 bridge for
///   you. Arithmetic that leaves those operators and works on plain `Double` values does not,
///   and comes out a factor of 1000 wrong.
///
/// ## Example
/// ```swift
/// let push = Force(50, unit: .newtons)
/// print(push.kilogramsForce)  // 5.10
///
/// let engineThrust = Force(500, unit: .kilonewtons)
/// print(engineThrust.meganewtons)  // 0.5
/// ```
public typealias Force = Measurement<ForceUnit>

// MARK: - Force Convenience Accessors

extension Force {
    @inlinable
    public var newtons: Double {
        value(in: .newtons)
    }

    @inlinable
    public var millinewtons: Double {
        value(in: .millinewtons)
    }

    @inlinable
    public var kilonewtons: Double {
        value(in: .kilonewtons)
    }

    @inlinable
    public var meganewtons: Double {
        value(in: .meganewtons)
    }

    @inlinable
    public var kilogramsForce: Double {
        value(in: .kilogramsForce)
    }

    @inlinable
    public var poundsForce: Double {
        value(in: .poundsForce)
    }

    @inlinable
    public var dynes: Double {
        value(in: .dynes)
    }
}

// MARK: - Force Formatting

extension Force {
    /// The value in the largest metric multiple that fits: MN from 10⁶ N, then kN, N, and mN below 1 N.
    ///
    /// Always two decimals. kgf, lbf and dyn are never chosen, so a force entered in those
    /// units comes back out in metric ones. Zero prints as `0.00 mN`.
    public var formatted: String {
        let n = newtons
        if abs(n) >= 1e6 {
            return String(format: "%.2f MN", meganewtons)
        } else if abs(n) >= 1e3 {
            return String(format: "%.2f kN", kilonewtons)
        } else if abs(n) >= 1 {
            return String(format: "%.2f N", n)
        } else {
            return String(format: "%.2f mN", millinewtons)
        }
    }
}
