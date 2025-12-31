import Foundation

/// SI接頭辞（メートル法の接頭辞）
///
/// 基本単位に対する倍率を表現します。
/// `rawValue` に倍率を直接持つことで、switch による分岐を排除し高速化しています。
///
/// ## 使用例
/// ```swift
/// let kilo = MetricPrefix.kilo
/// print(kilo.factor)   // 1000.0
/// print(kilo.symbol)   // "k"
/// ```
@frozen
public enum MetricPrefix: Double, Sendable, Hashable, Codable, CaseIterable {
    /// ペタ (10¹⁵)
    case peta  = 1e15

    /// テラ (10¹²)
    case tera  = 1e12

    /// ギガ (10⁹)
    case giga  = 1e9

    /// メガ (10⁶)
    case mega  = 1e6

    /// キロ (10³)
    case kilo  = 1e3

    /// ヘクト (10²)
    case hecto = 1e2

    /// デカ (10¹)
    case deca  = 1e1

    /// 基本単位 (10⁰)
    case base  = 1

    /// デシ (10⁻¹)
    case deci  = 1e-1

    /// センチ (10⁻²)
    case centi = 1e-2

    /// ミリ (10⁻³)
    case milli = 1e-3

    /// マイクロ (10⁻⁶)
    case micro = 1e-6

    /// ナノ (10⁻⁹)
    case nano  = 1e-9

    /// ピコ (10⁻¹²)
    case pico  = 1e-12

    /// フェムト (10⁻¹⁵)
    case femto = 1e-15

    // MARK: - Properties

    /// 基本単位に対する倍率
    ///
    /// `rawValue` を直接返すため、分岐なしで O(1) でアクセス可能。
    @inlinable
    public var factor: Double { rawValue }

    /// 接頭辞の記号
    ///
    /// 例: "k" (キロ), "m" (ミリ), "μ" (マイクロ)
    public var symbol: String {
        switch self {
        case .peta:  return "P"
        case .tera:  return "T"
        case .giga:  return "G"
        case .mega:  return "M"
        case .kilo:  return "k"
        case .hecto: return "h"
        case .deca:  return "da"
        case .base:  return ""
        case .deci:  return "d"
        case .centi: return "c"
        case .milli: return "m"
        case .micro: return "μ"
        case .nano:  return "n"
        case .pico:  return "p"
        case .femto: return "f"
        }
    }

    /// 接頭辞の名称
    ///
    /// 例: "kilo", "milli", "micro"
    public var name: String {
        switch self {
        case .peta:  return "peta"
        case .tera:  return "tera"
        case .giga:  return "giga"
        case .mega:  return "mega"
        case .kilo:  return "kilo"
        case .hecto: return "hecto"
        case .deca:  return "deca"
        case .base:  return ""
        case .deci:  return "deci"
        case .centi: return "centi"
        case .milli: return "milli"
        case .micro: return "micro"
        case .nano:  return "nano"
        case .pico:  return "pico"
        case .femto: return "femto"
        }
    }

    /// 指数表記での倍率
    ///
    /// 例: kilo = 3 (10³), milli = -3 (10⁻³)
    public var exponent: Int {
        switch self {
        case .peta:  return 15
        case .tera:  return 12
        case .giga:  return 9
        case .mega:  return 6
        case .kilo:  return 3
        case .hecto: return 2
        case .deca:  return 1
        case .base:  return 0
        case .deci:  return -1
        case .centi: return -2
        case .milli: return -3
        case .micro: return -6
        case .nano:  return -9
        case .pico:  return -12
        case .femto: return -15
        }
    }
}

// MARK: - CustomStringConvertible

extension MetricPrefix: CustomStringConvertible {
    public var description: String {
        name.isEmpty ? "(base)" : name
    }
}
