import Foundation

// MARK: - Sequence Extensions

extension Sequence {
    /// Adds every element, returning zero for an empty sequence.
    ///
    /// The addition happens in base units and left to right, so a long sequence of very
    /// different magnitudes accumulates `Double` rounding in the usual way.
    ///
    /// ```swift
    /// let masses = [Mass(1, unit: .kilograms), Mass(500, unit: .grams)]
    /// let total = masses.sum()  // 1500 g
    /// ```
    @inlinable
    public func sum<U: Unit>() -> Measurement<U> where Element == Measurement<U> {
        reduce(.zero, +)
    }
}

// MARK: - Collection Extensions

extension Collection {
    /// The arithmetic mean, or `nil` for an empty collection.
    ///
    /// It sums first and then divides once, so an empty collection is the only case that
    /// has no answer.
    ///
    /// ```swift
    /// let times = [Duration(30, unit: .seconds), Duration(60, unit: .seconds)]
    /// let avg = times.average()  // 45 seconds
    /// ```
    @inlinable
    public func average<U: Unit>() -> Measurement<U>? where Element == Measurement<U> {
        guard !isEmpty else { return nil }
        return sum() / Double(count)
    }

    /// The largest element, or `nil` for an empty collection.
    ///
    /// A spelled-out name for the standard library's `max()`, which reads badly next to a
    /// unit type.
    @inlinable
    public func maximum<U: Unit>() -> Measurement<U>? where Element == Measurement<U> {
        self.max()
    }

    /// The smallest element, or `nil` for an empty collection.
    @inlinable
    public func minimum<U: Unit>() -> Measurement<U>? where Element == Measurement<U> {
        self.min()
    }

    /// The spread between the largest and smallest element, or `nil` for an empty collection.
    ///
    /// This is a single measurement, not a Swift `Range`. It walks the collection twice,
    /// once for each end.
    @inlinable
    public func range<U: Unit>() -> Measurement<U>? where Element == Measurement<U> {
        guard let max = maximum(), let min = minimum() else { return nil }
        return max - min
    }
}

// MARK: - Numeric Literals Support

extension Measurement where UnitType: Unit {
    /// Reads an integer as a number of grams.
    ///
    /// Despite the label, this is an ordinary initializer. ``Measurement`` does not conform
    /// to `ExpressibleByIntegerLiteral` anywhere in this package, so `let m: Mass = 5` does
    /// not compile — only the explicit `Mass(integerLiteral: 5)` does. Prefer naming the
    /// unit, as in `Mass(5, unit: .kilograms)`, which reads the same everywhere and does
    /// not depend on knowing which unit is the base one.
    ///
    /// Only mass and length have this initializer. Making the type conform for every
    /// dimension would leave the type of a bare `0` ambiguous, since the conformance has to
    /// be declared per `Measurement<UnitType>`.
    @inlinable
    public init(integerLiteral value: Int) where UnitType == MassUnit {
        self.init(baseValue: Double(value))
    }

    /// Reads an integer as a number of meters, with the same caveats as the mass overload.
    @inlinable
    public init(integerLiteral value: Int) where UnitType == LengthUnit {
        self.init(baseValue: Double(value))
    }
}
