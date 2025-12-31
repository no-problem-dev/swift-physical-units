import Foundation

/// クーロン - 電荷の SI 基本単位
///
/// 1 C = 1 A × 1 s
///
/// ## 使用例
/// ```swift
/// let unit = MetricUnit<Coulomb>(.milli)  // ミリクーロン
/// print(unit.symbol)  // "mC"
/// ```
@frozen
public struct Coulomb: BaseUnit {
    /// 単位記号
    public static let symbol = "C"

    /// デフォルトイニシャライザ
    @inlinable
    public init() {}
}
