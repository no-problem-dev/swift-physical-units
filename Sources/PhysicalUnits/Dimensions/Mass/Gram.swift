import Foundation

/// グラム - 質量の基本単位
///
/// SI 基本単位としてはキログラム (kg) が定義されていますが、
/// 歴史的経緯により接頭辞なしのグラムを基本単位として扱います。
///
/// ## 使用例
/// ```swift
/// let unit = MetricUnit<Gram>(.kilo)  // キログラム
/// print(unit.symbol)  // "kg"
/// ```
@frozen
public struct Gram: BaseUnit {
    /// 単位記号
    public static let symbol = "g"

    /// デフォルトイニシャライザ
    @inlinable
    public init() {}
}
