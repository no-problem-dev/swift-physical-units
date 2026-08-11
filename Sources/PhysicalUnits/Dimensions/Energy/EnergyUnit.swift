import Foundation

/// An energy unit: joules or calories, each with an SI prefix.
///
/// Joules are the base. Calories are kept as their own case rather than folded into a joule
/// count so that a value entered as kcal reads back as kcal.
///
/// ## The two families
/// - **Joule (J)**: SI derived unit. 1 J = 1 kg⋅m²/s²
/// - **Calorie (cal)**: historical unit. 1 cal = 4.184 J exactly — the thermochemical calorie
///
/// Nutrition and fitness figures are quoted in kilocalories while physics and engineering use
/// joules, so both families are carried in one type.
///
/// ## Example
/// ```swift
/// let burned = Energy(300, unit: .kilocalories)
/// print(burned.kilojoules)  // 1255.2
///
/// let work = Energy(1000, unit: .joules)
/// print(work.calories)      // 239.006...
/// ```
@frozen
public enum EnergyUnit: Unit, Codable, Sendable, Hashable {
    /// Joules with an SI prefix.
    case joules(MetricPrefix)

    /// Calories with an SI prefix.
    ///
    /// The thermochemical calorie, 1 cal = 4.184 J exactly — not the International Steam Table
    /// calorie (4.1868 J exactly) and not the 15 °C calorie (about 4.1855 J). A figure taken
    /// from a source on one of those definitions is off by roughly 0.07%.
    case calories(MetricPrefix)

    // MARK: - Constants

    /// Joules per calorie, exactly 4.184 by the definition of the thermochemical calorie.
    ///
    /// Several calories are in circulation — International Steam Table (exactly 4.1868 J),
    /// 15 °C (about 4.1855 J) — and this package uses the thermochemical one everywhere, so
    /// values imported from another convention need converting before they are stored.
    public static let joulesPerCalorie: Double = 4.184

    // MARK: - Unit Protocol

    /// Joules per one of this unit: the prefix factor alone, times 4.184 for the calorie cases.
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .joules(let prefix):
            return prefix.factor
        case .calories(let prefix):
            return prefix.factor * Self.joulesPerCalorie
        }
    }

    public var symbol: String {
        switch self {
        case .joules(let prefix):
            return prefix.symbol + "J"
        case .calories(let prefix):
            return prefix.symbol + "cal"
        }
    }
}

// MARK: - Convenience Static Properties

extension EnergyUnit {
    // MARK: Joules

    @inlinable
    public static var joules: EnergyUnit {
        .joules(.base)
    }

    @inlinable
    public static var kilojoules: EnergyUnit {
        .joules(.kilo)
    }

    @inlinable
    public static var megajoules: EnergyUnit {
        .joules(.mega)
    }

    @inlinable
    public static var millijoules: EnergyUnit {
        .joules(.milli)
    }

    // MARK: Calories

    @inlinable
    public static var calories: EnergyUnit {
        .calories(.base)
    }

    /// Kilocalories (kcal), the unit food labels and fitness trackers call "calories".
    ///
    /// 1 kcal = 1000 cal = 4184 J exactly. Also written "large calorie" or "food calorie".
    @inlinable
    public static var kilocalories: EnergyUnit {
        .calories(.kilo)
    }

    @inlinable
    public static var megacalories: EnergyUnit {
        .calories(.mega)
    }
}

// MARK: - CustomStringConvertible

extension EnergyUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - CaseIterable

extension EnergyUnit: CaseIterable {
    /// Every energy unit: a prefixed joule and a prefixed calorie for each ``MetricPrefix``.
    ///
    /// Both cases carry a prefix, so the compiler cannot synthesize this. The list is written
    /// out instead, which is what lets a test assert over the whole type.
    public static var allCases: [EnergyUnit] {
        MetricPrefix.allCases.flatMap { [EnergyUnit.joules($0), EnergyUnit.calories($0)] }
    }
}

// MARK: - Energy Type Alias

/// An energy value, stored in joules whichever unit it was written in.
///
/// ## Example
/// ```swift
/// // Energy burned during exercise
/// let burned = Energy(350, unit: .kilocalories)
/// print(burned.kilojoules)  // 1464.4
///
/// // Mechanical work
/// let work = Energy(500, unit: .joules)
/// print(work.calories)      // 119.5...
/// ```
public typealias Energy = Measurement<EnergyUnit>

// MARK: - Energy Convenience Accessors

extension Energy {
    // MARK: Joules

    @inlinable
    public var joules: Double {
        value(in: .joules)
    }

    @inlinable
    public var kilojoules: Double {
        value(in: .kilojoules)
    }

    @inlinable
    public var megajoules: Double {
        value(in: .megajoules)
    }

    // MARK: Calories

    @inlinable
    public var calories: Double {
        value(in: .calories)
    }

    @inlinable
    public var kilocalories: Double {
        value(in: .kilocalories)
    }
}

// MARK: - Energy Formatting

extension Energy {
    /// The value on the calorie scale, choosing Mcal, kcal, or cal by magnitude.
    ///
    /// Switches to Mcal at 1000 kcal and down to cal below 1 kcal, always to one decimal place.
    /// This is the form to use for nutrition and fitness figures.
    public var formattedCalories: String {
        let kcal = kilocalories
        if abs(kcal) >= 1000 {
            return String(format: "%.1f Mcal", kcal / 1000)
        } else if abs(kcal) >= 1 {
            return String(format: "%.1f kcal", kcal)
        } else {
            return String(format: "%.1f cal", calories)
        }
    }

    /// The value on the joule scale, choosing MJ, kJ, or J by magnitude.
    ///
    /// Switches at 1 MJ and 1 kJ, always to two decimal places. This is the form to use for
    /// physics and engineering figures.
    public var formattedJoules: String {
        let j = joules
        if abs(j) >= 1_000_000 {
            return String(format: "%.2f MJ", megajoules)
        } else if abs(j) >= 1000 {
            return String(format: "%.2f kJ", kilojoules)
        } else {
            return String(format: "%.2f J", j)
        }
    }

    /// The default rendering, which is the calorie form rather than the joule form.
    public var formatted: String {
        formattedCalories
    }
}
