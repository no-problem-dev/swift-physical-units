import Foundation

/// 単位の基底プロトコル
///
/// すべての単位型（`MetricUnit`, `EnergyUnit` など）が準拠するプロトコル。
/// `Measurement` 型のジェネリックパラメータとして使用されます。
///
/// ## 必須プロパティ
/// - `coefficientToBase`: 基準単位への変換係数
/// - `symbol`: 単位記号（例: "kg", "cm", "kcal"）
///
/// ## 準拠例
/// ```swift
/// struct MyUnit: Unit {
///     var coefficientToBase: Double { 1000.0 }
///     var symbol: String { "ku" }
/// }
/// ```
public protocol Unit: Sendable, Hashable {
    /// 基準単位への変換係数
    ///
    /// 例: キログラム (kg) の係数は 1000（基準がグラムの場合）
    var coefficientToBase: Double { get }

    /// 単位記号
    ///
    /// 例: "kg", "cm", "kcal"
    var symbol: String { get }
}
