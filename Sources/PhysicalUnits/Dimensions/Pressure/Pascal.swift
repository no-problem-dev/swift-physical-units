import Foundation

/// パスカル - 圧力の SI 導出単位
///
/// 1 Pa = 1 N/m² = 1 kg⋅m⁻¹⋅s⁻²
///
/// ## 使用例
/// ```swift
/// let unit = MetricUnit<Pascal>(.hecto)  // ヘクトパスカル
/// print(unit.symbol)  // "hPa"
/// ```
@frozen
public struct Pascal: BaseUnit {
    /// 単位記号
    public static let symbol = "Pa"

    /// デフォルトイニシャライザ
    @inlinable
    public init() {}
}
