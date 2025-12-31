import Foundation

/// アンペア - 電流の SI 基本単位
///
/// 電流の大きさを表す SI 基本単位です。
/// 2019 年の SI 再定義により、電気素量 e の値を固定して定義されています。
///
/// ## 使用例
/// ```swift
/// let unit = MetricUnit<Ampere>(.milli)  // ミリアンペア
/// print(unit.symbol)  // "mA"
/// ```
@frozen
public struct Ampere: BaseUnit {
    /// 単位記号
    public static let symbol = "A"

    /// デフォルトイニシャライザ
    @inlinable
    public init() {}
}
