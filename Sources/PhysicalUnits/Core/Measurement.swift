import Foundation

/// 単位付き測定値
///
/// 内部では基準単位で値を保持し、必要に応じて他の単位に変換可能。
/// ジェネリックパラメータ `UnitType` により、異なる次元の値の混同を型レベルで防止します。
///
/// ## 使用例
/// ```swift
/// let mass1 = Measurement<MassUnit>(70, unit: .kilograms)
/// let mass2 = Measurement<MassUnit>(5000, unit: .grams)
///
/// // 型エイリアスを使用（推奨）
/// let mass = Mass(70, unit: .kilograms)
/// print(mass.value(in: .grams))  // 70000.0
/// ```
///
/// ## メモリ効率
/// - `baseValue` のみ保持 → 8 バイト
/// - `UnitType` はインスタンスを持たない
@frozen
public struct Measurement<UnitType: Unit>: Sendable, Hashable {
    /// 基準単位での内部値
    @usableFromInline
    internal let baseValue: Double

    // MARK: - Initializers

    /// 指定単位で初期化
    ///
    /// - Parameters:
    ///   - value: 値
    ///   - unit: 単位
    @inlinable
    public init(_ value: Double, unit: UnitType) {
        self.baseValue = value * unit.coefficientToBase
    }

    /// 整数値で初期化
    ///
    /// - Parameters:
    ///   - value: 整数値
    ///   - unit: 単位
    @inlinable
    public init(_ value: Int, unit: UnitType) {
        self.baseValue = Double(value) * unit.coefficientToBase
    }

    /// 基準単位の値で直接初期化（内部使用）
    @usableFromInline
    internal init(baseValue: Double) {
        self.baseValue = baseValue
    }

    // MARK: - Value Access

    /// 指定単位で値を取得
    ///
    /// - Parameter unit: 取得したい単位
    /// - Returns: 指定単位での値
    @inlinable
    public func value(in unit: UnitType) -> Double {
        baseValue / unit.coefficientToBase
    }
}

// MARK: - Comparable

extension Measurement: Comparable {
    @inlinable
    public static func < (lhs: Measurement<UnitType>, rhs: Measurement<UnitType>) -> Bool {
        lhs.baseValue < rhs.baseValue
    }
}

// MARK: - AdditiveArithmetic

extension Measurement: AdditiveArithmetic {
    /// ゼロ値
    @inlinable
    public static var zero: Measurement<UnitType> {
        Measurement(baseValue: 0)
    }

    /// 加算
    @inlinable
    public static func + (lhs: Measurement<UnitType>, rhs: Measurement<UnitType>) -> Measurement<UnitType> {
        Measurement(baseValue: lhs.baseValue + rhs.baseValue)
    }

    /// 減算
    @inlinable
    public static func - (lhs: Measurement<UnitType>, rhs: Measurement<UnitType>) -> Measurement<UnitType> {
        Measurement(baseValue: lhs.baseValue - rhs.baseValue)
    }
}

// MARK: - Scalar Multiplication

extension Measurement {
    /// スカラー乗算（Measurement * Double）
    @inlinable
    public static func * (lhs: Measurement<UnitType>, rhs: Double) -> Measurement<UnitType> {
        Measurement(baseValue: lhs.baseValue * rhs)
    }

    /// スカラー乗算（Double * Measurement）
    @inlinable
    public static func * (lhs: Double, rhs: Measurement<UnitType>) -> Measurement<UnitType> {
        Measurement(baseValue: lhs * rhs.baseValue)
    }

    /// スカラー除算
    @inlinable
    public static func / (lhs: Measurement<UnitType>, rhs: Double) -> Measurement<UnitType> {
        Measurement(baseValue: lhs.baseValue / rhs)
    }

    /// 測定値同士の比率
    @inlinable
    public static func / (lhs: Measurement<UnitType>, rhs: Measurement<UnitType>) -> Double {
        lhs.baseValue / rhs.baseValue
    }
}

// MARK: - Compound Assignment

extension Measurement {
    /// 複合加算代入
    @inlinable
    public static func += (lhs: inout Measurement<UnitType>, rhs: Measurement<UnitType>) {
        lhs = lhs + rhs
    }

    /// 複合減算代入
    @inlinable
    public static func -= (lhs: inout Measurement<UnitType>, rhs: Measurement<UnitType>) {
        lhs = lhs - rhs
    }

    /// 複合乗算代入
    @inlinable
    public static func *= (lhs: inout Measurement<UnitType>, rhs: Double) {
        lhs = lhs * rhs
    }

    /// 複合除算代入
    @inlinable
    public static func /= (lhs: inout Measurement<UnitType>, rhs: Double) {
        lhs = lhs / rhs
    }
}

// MARK: - Codable

extension Measurement: Codable where UnitType: Codable {
    private enum CodingKeys: String, CodingKey {
        case baseValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseValue = try container.decode(Double.self, forKey: .baseValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(baseValue, forKey: .baseValue)
    }
}

// MARK: - CustomStringConvertible

extension Measurement: CustomStringConvertible where UnitType: Unit {
    /// 基準単位での値を文字列として表示
    public var description: String {
        String(format: "%.4g (base units)", baseValue)
    }
}

// MARK: - Numeric Utilities

extension Measurement {
    /// 絶対値
    @inlinable
    public var magnitude: Measurement<UnitType> {
        Measurement(baseValue: abs(baseValue))
    }

    /// 負かどうか
    @inlinable
    public var isNegative: Bool {
        baseValue < 0
    }

    /// ゼロかどうか
    @inlinable
    public var isZero: Bool {
        baseValue == 0
    }

    /// 正かどうか
    @inlinable
    public var isPositive: Bool {
        baseValue > 0
    }
}

// MARK: - Clamping

extension Measurement {
    /// 指定範囲内に収める
    ///
    /// - Parameter range: 許容範囲
    /// - Returns: 範囲内に収められた値
    @inlinable
    public func clamped(to range: ClosedRange<Measurement<UnitType>>) -> Measurement<UnitType> {
        Measurement(baseValue: max(range.lowerBound.baseValue, min(baseValue, range.upperBound.baseValue)))
    }
}
