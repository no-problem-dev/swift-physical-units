import Foundation

/// ヘルツ - 周波数の SI 導出単位
///
/// 1 Hz = 1 s⁻¹（1 秒あたり 1 回の振動）
///
/// ## 使用例
/// ```swift
/// let unit = MetricUnit<Hertz>(.mega)  // メガヘルツ
/// print(unit.symbol)  // "MHz"
/// ```
@frozen
public struct Hertz: BaseUnit {
    /// 単位記号
    public static let symbol = "Hz"

    /// デフォルトイニシャライザ
    @inlinable
    public init() {}
}
