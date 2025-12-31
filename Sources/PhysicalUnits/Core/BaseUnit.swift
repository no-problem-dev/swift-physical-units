import Foundation

/// 基本単位プロトコル
///
/// SI 基本単位や派生単位の「基本形」を表します。
/// `MetricUnit<Base>` と組み合わせることで、接頭辞付きの単位を生成できます。
///
/// ## 概念
/// - `Gram`: 質量の基本単位
/// - `Meter`: 長さの基本単位
/// - `Second`: 時間の基本単位
///
/// これらに `MetricPrefix` を組み合わせることで、
/// キログラム (kilo + gram)、センチメートル (centi + meter) などを表現します。
///
/// ## 実装例
/// ```swift
/// public struct Gram: BaseUnit {
///     public static let symbol = "g"
///     public init() {}
/// }
/// ```
public protocol BaseUnit: Sendable, Hashable {
    /// 基本単位の記号
    ///
    /// 例: "g" (グラム), "m" (メートル), "s" (秒)
    static var symbol: String { get }

    /// デフォルトイニシャライザ
    ///
    /// `BaseUnit` は phantom type として使用されるため、
    /// インスタンス化は必須ではありませんが、型の一貫性のために必要です。
    init()
}
