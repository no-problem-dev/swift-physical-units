import Foundation

/// リットル - 体積の基本単位
///
/// SI では立方メートル (m³) が基本ですが、日常的にはリットル (L) がよく使われます。
/// 1 L = 0.001 m³ = 1 dm³
///
/// ## 使用例
/// ```swift
/// let unit = MetricUnit<Liter>(.milli)  // ミリリットル
/// print(unit.symbol)  // "mL"
/// ```
@frozen
public struct Liter: BaseUnit {
    /// 単位記号
    public static let symbol = "L"

    /// デフォルトイニシャライザ
    @inlinable
    public init() {}
}
