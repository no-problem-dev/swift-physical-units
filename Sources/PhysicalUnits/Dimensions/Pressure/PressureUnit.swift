import Foundation

/// A pressure unit, with the pascal as the base.
///
/// 1 Pa = 1 N/m² = 1 kg⋅m⁻¹⋅s⁻²
///
/// ## Which conversions are exact
/// - 1 hPa = 100 Pa and 1 mbar = 100 Pa — exact, by the SI prefixes
/// - 1 bar = 100,000 Pa — exact, that is the definition of the bar
/// - 1 atm = 101,325 Pa — exact, that is the definition of the standard atmosphere
/// - 1 Torr = 101325/760 Pa ≈ 133.322368 Pa — an exact ratio, stored rounded
/// - 1 psi ≈ 6,894.757293 Pa — derived from exactly defined units, but the quotient does not
///   terminate, so the stored factor is rounded
///
/// ## Example
/// ```swift
/// let tire = Pressure(2.5, unit: .bars)
/// print(tire.kilopascals)  // 250.0
///
/// let weather = Pressure(1013.25, unit: .hectopascals)
/// print(weather.atmospheres)  // 1.0
/// ```
@frozen
public enum PressureUnit: Unit, Codable, Sendable, Hashable, CaseIterable {
    /// Pascals (Pa), the SI derived unit and the base every value is stored in.
    case pascals

    /// Hectopascals (hPa), the unit weather reports use for atmospheric pressure.
    case hectopascals

    case kilopascals

    case megapascals

    /// Bars, defined as exactly 100,000 Pa.
    case bars

    /// Millibars (mbar), numerically identical to hectopascals.
    case millibars

    /// Standard atmospheres (atm), defined as exactly 101,325 Pa.
    case atmospheres

    /// Torr, defined as exactly 1/760 of a standard atmosphere.
    ///
    /// Commonly written "mmHg", but the two are not the same unit: the conventional millimetre
    /// of mercury is 133.322387415 Pa (mercury at 13,595.1 kg/m³ under standard gravity), about
    /// 1.4 parts in 10⁷ larger than the torr. That gap is far below clinical or meteorological
    /// resolution, so a blood-pressure or barometer reading in mmHg can be passed here.
    case torr

    /// Pounds-force per square inch (psi).
    ///
    /// Built from exactly defined quantities — 1 lbf = 0.45359237 kg × 9.80665 m/s², 1 in =
    /// 25.4 mm — whose quotient is not a terminating decimal, so the factor is rounded.
    case psi

    // MARK: - Constants

    /// Pascals per bar, exactly 100,000 by the definition of the bar.
    public static let barToPascals: Double = 1e5

    /// Pascals in one standard atmosphere, exactly 101,325 by definition.
    public static let atmospherePascals: Double = 101_325.0

    /// Pascals per torr, rounded from the exact ratio 101325/760.
    ///
    /// The exact value runs 133.32236842105263…; this literal keeps 11 significant digits, so
    /// conversions carry a relative error near 1e-10 — negligible next to the difference between
    /// the torr and the millimetre of mercury it is usually standing in for.
    public static let torrToPascals: Double = 133.32236842

    /// Pascals per psi, rounded from a quotient that does not terminate.
    ///
    /// 1 lbf ÷ 1 in² = 4.4482216152605 N ÷ 0.00064516 m² = 6894.75729316836… Pa. Both operands
    /// are exact by definition, but the result is not, so this literal keeps 13 significant
    /// digits.
    public static let psiToPascals: Double = 6894.757293168

    // MARK: - Unit Protocol

    /// Pascals per one of this unit.
    ///
    /// Exact for the SI multiples, the bar, and the atmosphere; rounded for torr and psi, whose
    /// constants document how far.
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .pascals:
            return 1.0
        case .hectopascals:
            return 1e2
        case .kilopascals:
            return 1e3
        case .megapascals:
            return 1e6
        case .bars:
            return Self.barToPascals
        case .millibars:
            return 1e2  // 1 mbar = 1 hPa = 100 Pa
        case .atmospheres:
            return Self.atmospherePascals
        case .torr:
            return Self.torrToPascals
        case .psi:
            return Self.psiToPascals
        }
    }

    public var symbol: String {
        switch self {
        case .pascals:
            return "Pa"
        case .hectopascals:
            return "hPa"
        case .kilopascals:
            return "kPa"
        case .megapascals:
            return "MPa"
        case .bars:
            return "bar"
        case .millibars:
            return "mbar"
        case .atmospheres:
            return "atm"
        case .torr:
            return "Torr"
        case .psi:
            return "psi"
        }
    }
}

// MARK: - CustomStringConvertible

extension PressureUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Pressure Type Alias

/// A pressure value, stored in pascals whichever unit it was written in.
///
/// ## Example
/// ```swift
/// let blood = Pressure(120, unit: .torr)
/// print(blood.kilopascals)  // ≈15.9987
///
/// let vacuum = Pressure(0.001, unit: .pascals)
/// print(vacuum.torr)        // ≈7.5006e-06
/// ```
public typealias Pressure = Measurement<PressureUnit>

// MARK: - Pressure Convenience Accessors

extension Pressure {
    @inlinable
    public var pascals: Double {
        value(in: .pascals)
    }

    @inlinable
    public var hectopascals: Double {
        value(in: .hectopascals)
    }

    @inlinable
    public var kilopascals: Double {
        value(in: .kilopascals)
    }

    @inlinable
    public var megapascals: Double {
        value(in: .megapascals)
    }

    @inlinable
    public var bars: Double {
        value(in: .bars)
    }

    @inlinable
    public var millibars: Double {
        value(in: .millibars)
    }

    @inlinable
    public var atmospheres: Double {
        value(in: .atmospheres)
    }

    @inlinable
    public var torr: Double {
        value(in: .torr)
    }

    @inlinable
    public var psi: Double {
        value(in: .psi)
    }
}

// MARK: - Pressure Formatting

extension Pressure {
    /// The value rendered with whichever unit keeps it in a readable range.
    ///
    /// MPa from 1 MPa up, then bar from 100 kPa, kPa from 1 kPa, hPa from 100 Pa, and Pa below
    /// that. Note that atmospheric pressure lands in the bar band: 1013 hPa renders as
    /// "1.01 bar", so weather readings need ``hectopascals`` and their own formatting.
    public var formatted: String {
        let pa = pascals
        if abs(pa) >= 1e6 {
            return String(format: "%.2f MPa", megapascals)
        } else if abs(pa) >= 1e5 {
            return String(format: "%.2f bar", bars)
        } else if abs(pa) >= 1e3 {
            return String(format: "%.2f kPa", kilopascals)
        } else if abs(pa) >= 1e2 {
            return String(format: "%.1f hPa", hectopascals)
        } else {
            return String(format: "%.2f Pa", pa)
        }
    }
}

// MARK: - Pressure Special Values

extension Pressure {
    /// 1 atm, which is exactly 101,325 Pa.
    public static let standardAtmosphere = Pressure(1, unit: .atmospheres)

    /// Exactly zero pressure — an idealization no real vacuum reaches.
    public static let vacuum = Pressure(0, unit: .pascals)
}
