import Foundation

/// 面積の単位
///
/// 面積は長さの二乗の導出単位です。SI 基本単位は平方メートル (m²) です。
/// 土地面積にはヘクタール (ha) やエーカーがよく使われます。
///
/// ## 変換関係
/// - 1 km² = 1,000,000 m²
/// - 1 ha = 10,000 m²
/// - 1 a (アール) = 100 m²
/// - 1 acre ≈ 4,046.86 m²
///
/// ## 使用例
/// ```swift
/// let field = Area(2.5, unit: .hectares)
/// print(field.squareMeters)  // 25000.0
///
/// let lot = Area(1000, unit: .squareMeters)
/// print(lot.ares)            // 10.0
/// ```
@frozen
public enum AreaUnit: Unit, Codable, Sendable, Hashable {
    /// 平方メートル (m²) - SI 導出単位
    case squareMeters

    /// 平方センチメートル (cm²)
    case squareCentimeters

    /// 平方ミリメートル (mm²)
    case squareMillimeters

    /// 平方キロメートル (km²)
    case squareKilometers

    /// アール (a) = 100 m²
    case ares

    /// ヘクタール (ha) = 10,000 m²
    case hectares

    /// エーカー (acre)
    case acres

    // MARK: - Constants

    /// cm² → m² 変換係数
    public static let squareCmToM: Double = 1e-4

    /// mm² → m² 変換係数
    public static let squareMmToM: Double = 1e-6

    /// km² → m² 変換係数
    public static let squareKmToM: Double = 1e6

    /// アール → m² 変換係数
    public static let aresToM: Double = 100.0

    /// ヘクタール → m² 変換係数
    public static let hectaresToM: Double = 10_000.0

    /// エーカー → m² 変換係数
    public static let acresToM: Double = 4046.8564224

    // MARK: - Unit Protocol

    /// 基準単位（m²）への変換係数
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

    /// 単位記号
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

/// 面積
///
/// `Measurement<AreaUnit>` の型エイリアス。
/// 面積を型安全に表現します。
///
/// ## 使用例
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
    /// 平方メートル単位で値を取得
    @inlinable
    public var squareMeters: Double {
        value(in: .squareMeters)
    }

    /// 平方センチメートル単位で値を取得
    @inlinable
    public var squareCentimeters: Double {
        value(in: .squareCentimeters)
    }

    /// 平方ミリメートル単位で値を取得
    @inlinable
    public var squareMillimeters: Double {
        value(in: .squareMillimeters)
    }

    /// 平方キロメートル単位で値を取得
    @inlinable
    public var squareKilometers: Double {
        value(in: .squareKilometers)
    }

    /// アール単位で値を取得
    @inlinable
    public var ares: Double {
        value(in: .ares)
    }

    /// ヘクタール単位で値を取得
    @inlinable
    public var hectares: Double {
        value(in: .hectares)
    }

    /// エーカー単位で値を取得
    @inlinable
    public var acres: Double {
        value(in: .acres)
    }
}

// MARK: - Area Formatting

extension Area {
    /// 適切な単位で自動フォーマット
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
