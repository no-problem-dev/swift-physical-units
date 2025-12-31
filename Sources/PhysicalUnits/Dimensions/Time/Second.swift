import Foundation

/// 秒 - 時間の SI 基本単位
///
/// セシウム133原子の基底状態の2つの超微細構造準位間の遷移に対応する
/// 放射の周期の 9,192,631,770 倍の継続時間として定義されています。
///
/// ## 使用例
/// ```swift
/// let unit = MetricUnit<Second>(.milli)  // ミリ秒
/// print(unit.symbol)  // "ms"
/// ```
///
/// ## 注意
/// 分（60秒）や時間（3600秒）は SI 接頭辞では表現できないため、
/// `TimeUnit` enum を使用してください。
@frozen
public struct Second: BaseUnit {
    /// 単位記号
    public static let symbol = "s"

    /// デフォルトイニシャライザ
    @inlinable
    public init() {}
}
