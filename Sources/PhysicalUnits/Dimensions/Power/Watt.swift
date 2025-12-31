import Foundation

/// ワット - 仕事率・電力の SI 導出単位
///
/// 1 W = 1 J/s = 1 kg⋅m²⋅s⁻³
///
/// ## 使用例
/// ```swift
/// let unit = MetricUnit<Watt>(.kilo)  // キロワット
/// print(unit.symbol)  // "kW"
/// ```
@frozen
public struct Watt: BaseUnit {
    /// 単位記号
    public static let symbol = "W"

    /// デフォルトイニシャライザ
    @inlinable
    public init() {}
}
