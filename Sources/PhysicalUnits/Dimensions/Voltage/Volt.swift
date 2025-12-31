import Foundation

/// ボルト - 電圧（電位差）の SI 導出単位
///
/// 1 V = 1 W/A = 1 kg⋅m²⋅s⁻³⋅A⁻¹
///
/// ## 使用例
/// ```swift
/// let unit = MetricUnit<Volt>(.kilo)  // キロボルト
/// print(unit.symbol)  // "kV"
/// ```
@frozen
public struct Volt: BaseUnit {
    /// 単位記号
    public static let symbol = "V"

    /// デフォルトイニシャライザ
    @inlinable
    public init() {}
}
