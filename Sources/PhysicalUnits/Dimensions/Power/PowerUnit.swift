import Foundation

/// A unit of power, mechanical or electrical, convertible to and from watts.
///
/// The base unit is the watt (W): 1 W = 1 J/s = 1 kg⋅m²⋅s⁻³.
///
/// ## Conversions
/// - 1 kW = 1000 W, exact.
/// - 1 metric hp = 735.49875 W, exact. It is 75 kgf⋅m/s, that is 75 × 9.80665 W, and the
///   constant here keeps every digit.
/// - 1 mechanical (imperial) hp = 745.69987158227022 W exactly, but this library stores
///   `745.69987158`. Imperial-horsepower conversions are therefore rounded, truncated after
///   the eleventh significant digit (about 3 parts in 10¹²).
///
/// ## Example
/// ```swift
/// let motor = Power(5, unit: .kilowatts)
/// print(motor.horsepower)  // 6.80
///
/// let bulb = Power(100, unit: .watts)
/// print(bulb.kilowatts)    // 0.1
/// ```
@frozen
public enum PowerUnit: Unit, Codable, Sendable, Hashable, CaseIterable {
    /// Watt (W), the base unit every other case converts against.
    case watts

    /// Milliwatt (mW), exactly 10⁻³ W.
    case milliwatts

    /// Kilowatt (kW), exactly 10³ W.
    case kilowatts

    /// Megawatt (MW), exactly 10⁶ W.
    case megawatts

    /// Gigawatt (GW), exactly 10⁹ W.
    case gigawatts

    /// Metric horsepower, exactly 735.49875 W (75 kgf⋅m/s).
    ///
    /// This is what the plain `hp` symbol and the `Power.horsepower` accessor both mean.
    case horsepower

    /// Mechanical (imperial) horsepower, 550 ft⋅lbf/s, carried at reduced precision.
    ///
    /// Stored as 745.69987158 W rather than the exact 745.69987158227022 W. Read a value in
    /// this unit with `value(in: .horsepowerImperial)`; there is no dedicated accessor.
    case horsepowerImperial

    // MARK: - Constants

    /// Metric horsepower in watts: exactly 75 × 9.80665.
    public static let metricHpToWatts: Double = 735.49875

    /// Mechanical horsepower in watts, rounded rather than exact.
    ///
    /// 550 ft⋅lbf/s comes to exactly 745.69987158227022 W; the digits past `745.69987158` are
    /// dropped here, so conversions through this constant carry a relative error of roughly
    /// 3 × 10⁻¹².
    public static let imperialHpToWatts: Double = 745.69987158

    // MARK: - Unit Protocol

    /// The multiplier that turns a value in this unit into watts.
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .watts:
            return 1.0
        case .milliwatts:
            return 1e-3
        case .kilowatts:
            return 1e3
        case .megawatts:
            return 1e6
        case .gigawatts:
            return 1e9
        case .horsepower:
            return Self.metricHpToWatts
        case .horsepowerImperial:
            return Self.imperialHpToWatts
        }
    }

    public var symbol: String {
        switch self {
        case .watts:
            return "W"
        case .milliwatts:
            return "mW"
        case .kilowatts:
            return "kW"
        case .megawatts:
            return "MW"
        case .gigawatts:
            return "GW"
        case .horsepower:
            return "hp"
        case .horsepowerImperial:
            return "hp(I)"
        }
    }
}

// MARK: - CustomStringConvertible

extension PowerUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Power Type Alias

/// An amount of power, stored internally in watts.
///
/// ## Example
/// ```swift
/// let engine = Power(150, unit: .horsepower)
/// print(engine.kilowatts)  // 110.32
///
/// let plant = Power(1.21, unit: .gigawatts)
/// print(plant.megawatts)   // 1210.0
/// ```
public typealias Power = Measurement<PowerUnit>

// MARK: - Power Convenience Accessors

extension Power {
    @inlinable
    public var watts: Double {
        value(in: .watts)
    }

    @inlinable
    public var milliwatts: Double {
        value(in: .milliwatts)
    }

    @inlinable
    public var kilowatts: Double {
        value(in: .kilowatts)
    }

    @inlinable
    public var megawatts: Double {
        value(in: .megawatts)
    }

    @inlinable
    public var gigawatts: Double {
        value(in: .gigawatts)
    }

    /// The value in metric horsepower, not imperial.
    ///
    /// There is no matching accessor for the imperial unit; use
    /// `value(in: .horsepowerImperial)` for that one.
    @inlinable
    public var horsepower: Double {
        value(in: .horsepower)
    }
}

// MARK: - Power Formatting

extension Power {
    /// The value in the largest metric multiple that fits: GW from 10⁹ W, then MW, kW, W, and mW below 1 W.
    ///
    /// W prints with one decimal, every other unit with two. Horsepower is never chosen, so a
    /// value entered in hp comes back out in watts.
    public var formatted: String {
        let w = watts
        if abs(w) >= 1e9 {
            return String(format: "%.2f GW", gigawatts)
        } else if abs(w) >= 1e6 {
            return String(format: "%.2f MW", megawatts)
        } else if abs(w) >= 1e3 {
            return String(format: "%.2f kW", kilowatts)
        } else if abs(w) >= 1 {
            return String(format: "%.1f W", w)
        } else {
            return String(format: "%.2f mW", milliwatts)
        }
    }
}
