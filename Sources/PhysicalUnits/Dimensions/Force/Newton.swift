import Foundation

/// ニュートン - 力の SI 導出単位
///
/// 1 N = 1 kg⋅m⋅s⁻²
///
/// ## 使用例
/// ```swift
/// let unit = MetricUnit<Newton>(.kilo)  // キロニュートン
/// print(unit.symbol)  // "kN"
/// ```
@frozen
public struct Newton: BaseUnit {
    /// 単位記号
    public static let symbol = "N"

    /// デフォルトイニシャライザ
    @inlinable
    public init() {}
}
