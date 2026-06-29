import Foundation

// MARK: - Sequence Extensions

extension Sequence {
    /// Measurement の合計を計算
    ///
    /// `AdditiveArithmetic` に準拠しているため、`reduce` で簡単に合計できる。
    ///
    /// ## 使用例
    /// ```swift
    /// let masses = [Mass(1, unit: .kilograms), Mass(500, unit: .grams)]
    /// let total = masses.sum()  // 1500g
    /// ```
    @inlinable
    public func sum<U: Unit>() -> Measurement<U> where Element == Measurement<U> {
        reduce(.zero, +)
    }
}

// MARK: - Collection Extensions

extension Collection {
    /// Measurement の平均を計算
    ///
    /// 空のコレクションの場合は `nil` を返す。
    ///
    /// ## 使用例
    /// ```swift
    /// let times = [Duration(30, unit: .seconds), Duration(60, unit: .seconds)]
    /// let avg = times.average()  // 45 seconds
    /// ```
    @inlinable
    public func average<U: Unit>() -> Measurement<U>? where Element == Measurement<U> {
        guard !isEmpty else { return nil }
        return sum() / Double(count)
    }

    /// Measurement の最大値を取得
    @inlinable
    public func maximum<U: Unit>() -> Measurement<U>? where Element == Measurement<U> {
        self.max()
    }

    /// Measurement の最小値を取得
    @inlinable
    public func minimum<U: Unit>() -> Measurement<U>? where Element == Measurement<U> {
        self.min()
    }

    /// Measurement の範囲（最大 - 最小）を取得
    @inlinable
    public func range<U: Unit>() -> Measurement<U>? where Element == Measurement<U> {
        guard let max = maximum(), let min = minimum() else { return nil }
        return max - min
    }
}

// MARK: - Numeric Literals Support

extension Measurement where UnitType: Unit {
    /// 整数リテラルから基準単位で初期化
    ///
    /// 値は基準単位（`MassUnit` なら gram、`LengthUnit` なら meter）として解釈される。
    /// 明示的な単位指定（`Mass(70, unit: .kilograms)` など）を推奨する。
    ///
    /// ## 設計上の制限
    /// `ExpressibleByIntegerLiteral` 準拠は `MassUnit` と `LengthUnit` のみに限定している。
    /// 理由: Swift のプロトコル準拠は型単位（`Measurement<UnitType>` ごと）に必要であり、
    /// 全次元に追加するとリテラル `0` の型推論があいまいになる。
    /// 必要な次元は都度 `Measurement<SomeUnit>(baseValue: Double(n))` で初期化する。
    @inlinable
    public init(integerLiteral value: Int) where UnitType == MassUnit {
        self.init(baseValue: Double(value))
    }

    @inlinable
    public init(integerLiteral value: Int) where UnitType == LengthUnit {
        self.init(baseValue: Double(value))
    }
}
