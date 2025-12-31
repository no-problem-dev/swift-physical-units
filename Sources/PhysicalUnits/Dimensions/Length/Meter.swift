import Foundation

/// メートル - 長さの SI 基本単位
///
/// 光が真空中で 1/299,792,458 秒間に進む距離として定義されています。
///
/// ## 使用例
/// ```swift
/// let unit = MetricUnit<Meter>(.centi)  // センチメートル
/// print(unit.symbol)  // "cm"
/// ```
@frozen
public struct Meter: BaseUnit {
    /// 単位記号
    public static let symbol = "m"

    /// デフォルトイニシャライザ
    @inlinable
    public init() {}
}
