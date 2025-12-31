import Foundation

/// 接頭辞付き単位
///
/// `MetricPrefix`（接頭辞）と `BaseUnit`（基本単位）を組み合わせた単位型。
/// 概念として接頭辞と基本単位を分離しつつ、型安全な単位を提供します。
///
/// ## 設計思想
/// 「キログラム」は「キロ（10³）」と「グラム」の組み合わせであり、
/// これらは本来別の概念です。`MetricUnit` はこの分離を型として表現します。
///
/// ## 使用例
/// ```swift
/// // 直接使用
/// let kg = MetricUnit<Gram>(.kilo)
///
/// // typealias 経由で使用（推奨）
/// let mass = Mass(70, unit: .kilograms)
/// ```
///
/// ## メモリ効率
/// - `Base` は phantom type（インスタンスを持たない）→ 0 バイト
/// - `prefix` は enum → 1 バイト
/// - 合計: 1 バイト（padding で最大 8 バイト）
@frozen
public struct MetricUnit<Base: BaseUnit>: Unit, Codable {
    /// SI 接頭辞
    public let prefix: MetricPrefix

    /// 指定した接頭辞で初期化
    ///
    /// - Parameter prefix: 使用する SI 接頭辞（デフォルト: `.base`）
    @inlinable
    public init(_ prefix: MetricPrefix = .base) {
        self.prefix = prefix
    }

    // MARK: - Unit Protocol

    /// 基準単位への変換係数
    ///
    /// 接頭辞の倍率がそのまま係数となります。
    /// 例: キログラムの係数は 1000（基準がグラムの場合）
    @inlinable
    public var coefficientToBase: Double {
        prefix.factor
    }

    /// 単位記号
    ///
    /// 接頭辞の記号 + 基本単位の記号
    /// 例: "kg" (kilo + gram), "cm" (centi + meter)
    @inlinable
    public var symbol: String {
        prefix.symbol + Base.symbol
    }
}

// MARK: - CustomStringConvertible

extension MetricUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Convenience Factory Methods

extension MetricUnit {
    /// 基本単位（接頭辞なし）
    @inlinable
    public static var base: MetricUnit {
        MetricUnit(.base)
    }

    /// キロ (10³)
    @inlinable
    public static var kilo: MetricUnit {
        MetricUnit(.kilo)
    }

    /// ミリ (10⁻³)
    @inlinable
    public static var milli: MetricUnit {
        MetricUnit(.milli)
    }

    /// マイクロ (10⁻⁶)
    @inlinable
    public static var micro: MetricUnit {
        MetricUnit(.micro)
    }

    /// ナノ (10⁻⁹)
    @inlinable
    public static var nano: MetricUnit {
        MetricUnit(.nano)
    }

    /// センチ (10⁻²)
    @inlinable
    public static var centi: MetricUnit {
        MetricUnit(.centi)
    }

    /// メガ (10⁶)
    @inlinable
    public static var mega: MetricUnit {
        MetricUnit(.mega)
    }

    /// ギガ (10⁹)
    @inlinable
    public static var giga: MetricUnit {
        MetricUnit(.giga)
    }
}
