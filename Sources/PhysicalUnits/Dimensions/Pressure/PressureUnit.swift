import Foundation

/// 圧力の単位
///
/// 圧力は SI 導出単位で、パスカル (Pa) が基本単位です。
/// 1 Pa = 1 N/m² = 1 kg⋅m⁻¹⋅s⁻²
///
/// ## 変換関係
/// - 1 hPa = 100 Pa（気象で使用）
/// - 1 bar = 100,000 Pa
/// - 1 atm = 101,325 Pa（標準大気圧）
/// - 1 torr ≈ 133.322 Pa（mmHg）
/// - 1 psi ≈ 6,894.76 Pa
///
/// ## 使用例
/// ```swift
/// let tire = Pressure(2.5, unit: .bars)
/// print(tire.kilopascals)  // 250.0
///
/// let weather = Pressure(1013.25, unit: .hectopascals)
/// print(weather.atmospheres)  // 1.0
/// ```
@frozen
public enum PressureUnit: Unit, Codable, Sendable, Hashable {
    /// パスカル (Pa) - SI 導出単位
    case pascals

    /// ヘクトパスカル (hPa) - 気象で使用
    case hectopascals

    /// キロパスカル (kPa)
    case kilopascals

    /// メガパスカル (MPa)
    case megapascals

    /// バール (bar)
    case bars

    /// ミリバール (mbar) = ヘクトパスカル
    case millibars

    /// 気圧 (atm) - 標準大気圧
    case atmospheres

    /// トル (Torr) - 水銀柱ミリメートル
    case torr

    /// ポンド毎平方インチ (psi)
    case psi

    // MARK: - Constants

    /// バール → パスカル 変換係数
    public static let barToPascals: Double = 1e5

    /// 標準大気圧（パスカル）
    public static let atmospherePascals: Double = 101_325.0

    /// トル → パスカル 変換係数
    public static let torrToPascals: Double = 133.32236842

    /// psi → パスカル 変換係数
    public static let psiToPascals: Double = 6894.757293168

    // MARK: - Unit Protocol

    /// 基準単位（パスカル）への変換係数
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

    /// 単位記号
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

/// 圧力
///
/// `Measurement<PressureUnit>` の型エイリアス。
/// 圧力を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let blood = Pressure(120, unit: .torr)
/// print(blood.kilopascals)  // 16.0
///
/// let vacuum = Pressure(0.001, unit: .pascals)
/// print(vacuum.torr)        // 7.5e-6
/// ```
public typealias Pressure = Measurement<PressureUnit>

// MARK: - Pressure Convenience Accessors

extension Pressure {
    /// パスカル単位で値を取得
    @inlinable
    public var pascals: Double {
        value(in: .pascals)
    }

    /// ヘクトパスカル単位で値を取得
    @inlinable
    public var hectopascals: Double {
        value(in: .hectopascals)
    }

    /// キロパスカル単位で値を取得
    @inlinable
    public var kilopascals: Double {
        value(in: .kilopascals)
    }

    /// メガパスカル単位で値を取得
    @inlinable
    public var megapascals: Double {
        value(in: .megapascals)
    }

    /// バール単位で値を取得
    @inlinable
    public var bars: Double {
        value(in: .bars)
    }

    /// ミリバール単位で値を取得
    @inlinable
    public var millibars: Double {
        value(in: .millibars)
    }

    /// 気圧単位で値を取得
    @inlinable
    public var atmospheres: Double {
        value(in: .atmospheres)
    }

    /// トル単位で値を取得
    @inlinable
    public var torr: Double {
        value(in: .torr)
    }

    /// psi 単位で値を取得
    @inlinable
    public var psi: Double {
        value(in: .psi)
    }
}

// MARK: - Pressure Formatting

extension Pressure {
    /// 適切な単位で自動フォーマット
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
    /// 標準大気圧
    public static let standardAtmosphere = Pressure(1, unit: .atmospheres)

    /// 真空（理想）
    public static let vacuum = Pressure(0, unit: .pascals)
}
