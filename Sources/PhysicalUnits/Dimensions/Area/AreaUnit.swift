import Foundation

/// A unit of area, from square millimetres up to acres.
///
/// Area is length squared and the base unit is the square metre. Land is quoted in hectares or
/// acres rather than in m², so both are cases here.
///
/// ## Conversions
/// Every factor is exact by definition:
/// - 1 km² = 1,000,000 m²
/// - 1 ha = 10,000 m²
/// - 1 a = 100 m²
/// - 1 acre = 4046.8564224 m², the international acre: 4840 yd² at exactly 0.9144 m to the yard
///
/// The cm² and mm² factors (`1e-4`, `1e-6`) are exact decimals with no exact binary form, so
/// they are held as the nearest `Double`. The US survey acre (≈ 4046.8726 m²) is a different
/// unit and is not offered here.
///
/// - Note: There is no `Length × Length` operator, so multiplying two lengths will not give you
///   an `Area`. Build one with `Area(_:unit:)`, or divide a `Force` by a `Pressure`.
///
/// ## Example
/// ```swift
/// let field = Area(2.5, unit: .hectares)
/// print(field.squareMeters)  // 25000.0
///
/// let lot = Area(1000, unit: .squareMeters)
/// print(lot.ares)            // 10.0
/// ```
@frozen
public enum AreaUnit: Unit, Codable, Sendable, Hashable, CaseIterable {
    /// The square metre, the SI derived unit of area and the base of this type.
    case squareMeters

    case squareCentimeters

    case squareMillimeters

    case squareKilometers

    /// The are (a): exactly 100 m², a 10 m square. Still used in land registries.
    case ares

    /// The hectare (ha): exactly 10,000 m².
    case hectares

    /// The international acre: exactly 4046.8564224 m². Not the US survey acre.
    case acres

    // MARK: - Constants

    /// Square centimetres to square metres: exactly 1e-4, held as the nearest `Double`.
    public static let squareCmToM: Double = 1e-4

    /// Square millimetres to square metres: exactly 1e-6, held as the nearest `Double`.
    public static let squareMmToM: Double = 1e-6

    /// Square kilometres to square metres: exactly 1e6.
    public static let squareKmToM: Double = 1e6

    /// Ares to square metres: exactly 100.
    public static let aresToM: Double = 100.0

    /// Hectares to square metres: exactly 10,000.
    public static let hectaresToM: Double = 10_000.0

    /// International acres to square metres: exactly 4046.8564224, the full defined value.
    public static let acresToM: Double = 4046.8564224

    // MARK: - Unit Protocol

    /// The factor that converts a value in this unit to square metres.
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .squareMeters:
            return 1.0
        case .squareCentimeters:
            return Self.squareCmToM
        case .squareMillimeters:
            return Self.squareMmToM
        case .squareKilometers:
            return Self.squareKmToM
        case .ares:
            return Self.aresToM
        case .hectares:
            return Self.hectaresToM
        case .acres:
            return Self.acresToM
        }
    }

    /// The symbol: "m²", "cm²", "mm²", "km²", "a", "ha", and "ac" for the acre.
    public var symbol: String {
        switch self {
        case .squareMeters:
            return "m²"
        case .squareCentimeters:
            return "cm²"
        case .squareMillimeters:
            return "mm²"
        case .squareKilometers:
            return "km²"
        case .ares:
            return "a"
        case .hectares:
            return "ha"
        case .acres:
            return "ac"
        }
    }
}

// MARK: - CustomStringConvertible

extension AreaUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Area Type Alias

/// An area, stored in square metres.
///
/// A type alias for `Measurement<AreaUnit>`.
///
/// ## Example
/// ```swift
/// let room = Area(20, unit: .squareMeters)
/// print(room.squareCentimeters)  // 200000.0
///
/// let farm = Area(50, unit: .hectares)
/// print(farm.squareKilometers)   // 0.5
/// ```
public typealias Area = Measurement<AreaUnit>

// MARK: - Area Convenience Accessors

extension Area {
    @inlinable
    public var squareMeters: Double {
        value(in: .squareMeters)
    }

    @inlinable
    public var squareCentimeters: Double {
        value(in: .squareCentimeters)
    }

    @inlinable
    public var squareMillimeters: Double {
        value(in: .squareMillimeters)
    }

    @inlinable
    public var squareKilometers: Double {
        value(in: .squareKilometers)
    }

    @inlinable
    public var ares: Double {
        value(in: .ares)
    }

    @inlinable
    public var hectares: Double {
        value(in: .hectares)
    }

    @inlinable
    public var acres: Double {
        value(in: .acres)
    }
}

// MARK: - Area Formatting

extension Area {
    /// A string in the largest metric unit the value reaches, from km² down to mm².
    ///
    /// Chosen by magnitude: km² from 1,000,000 m² up, then ha, m², cm², mm². Ares and acres are
    /// never picked. m² and above print with two decimals, cm² and mm² with one.
    public var formatted: String {
        let m2 = squareMeters
        if abs(m2) >= 1_000_000 {
            return String(format: "%.2f km²", squareKilometers)
        } else if abs(m2) >= 10_000 {
            return String(format: "%.2f ha", hectares)
        } else if abs(m2) >= 1 {
            return String(format: "%.2f m²", m2)
        } else if abs(squareCentimeters) >= 1 {
            return String(format: "%.1f cm²", squareCentimeters)
        } else {
            return String(format: "%.1f mm²", squareMillimeters)
        }
    }
}
