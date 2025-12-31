import Foundation

/// オーム - 電気抵抗の SI 導出単位
///
/// 1 Ω = 1 V/A = 1 kg⋅m²⋅s⁻³⋅A⁻²
///
/// ## 使用例
/// ```swift
/// let unit = MetricUnit<Ohm>(.kilo)  // キロオーム
/// print(unit.symbol)  // "kΩ"
/// ```
@frozen
public struct Ohm: BaseUnit {
    /// 単位記号
    public static let symbol = "Ω"

    /// デフォルトイニシャライザ
    @inlinable
    public init() {}
}
