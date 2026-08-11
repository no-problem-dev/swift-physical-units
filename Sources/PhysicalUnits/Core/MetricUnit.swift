import Foundation

/// A unit built from an SI prefix and an unprefixed base unit.
///
/// "Kilogram" is "kilo" and "gram", two separate ideas, and this type keeps them separate:
/// `Base` is a phantom type read only for its symbol, and the prefix is the single stored
/// property. A value is therefore one byte of payload, whatever the base unit is.
///
/// ```swift
/// // Directly
/// let kg = MetricUnit<Gram>(.kilo)
///
/// // Through a dimension's type alias (preferred)
/// let mass = Mass(70, unit: .kilograms)
/// ```
///
/// Eight of the fifteen ``MetricPrefix`` cases have a static factory here — `base`, `centi`,
/// `milli`, `micro`, `nano`, `kilo`, `mega`, `giga`. For any other prefix, pass the case
/// itself: `MetricUnit<Gram>(.hecto)`.
@frozen
public struct MetricUnit<Base: BaseUnit>: Unit, Codable {
    public let prefix: MetricPrefix

    @inlinable
    public init(_ prefix: MetricPrefix = .base) {
        self.prefix = prefix
    }

    // MARK: - Unit Protocol

    /// The prefix factor, unchanged.
    ///
    /// That makes the dimension's base unit the *unprefixed* one: mass converts through
    /// grams, not kilograms, so a kilogram's coefficient is 1000.
    @inlinable
    public var coefficientToBase: Double {
        prefix.factor
    }

    /// The prefix symbol followed by the base unit's, giving `kg` or `cm`.
    @inlinable
    public var symbol: String {
        prefix.symbol + Base.symbol
    }
}

// MARK: - CustomStringConvertible

extension MetricUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - CaseIterable

extension MetricUnit: CaseIterable {
    /// One unit per ``MetricPrefix``, in the order the prefixes are declared: `Pg`, `Tg`, …, `fg`.
    ///
    /// The prefix is the only thing a `MetricUnit` stores, so these fifteen are every value the
    /// type can hold — which is what lets a test assert over the whole of it.
    public static var allCases: [MetricUnit<Base>] {
        MetricPrefix.allCases.map { MetricUnit($0) }
    }
}

// MARK: - Convenience Factory Methods

extension MetricUnit {
    /// The unprefixed unit, whose coefficient is 1.
    @inlinable
    public static var base: MetricUnit {
        MetricUnit(.base)
    }

    @inlinable
    public static var kilo: MetricUnit {
        MetricUnit(.kilo)
    }

    @inlinable
    public static var milli: MetricUnit {
        MetricUnit(.milli)
    }

    @inlinable
    public static var micro: MetricUnit {
        MetricUnit(.micro)
    }

    @inlinable
    public static var nano: MetricUnit {
        MetricUnit(.nano)
    }

    @inlinable
    public static var centi: MetricUnit {
        MetricUnit(.centi)
    }

    @inlinable
    public static var mega: MetricUnit {
        MetricUnit(.mega)
    }

    @inlinable
    public static var giga: MetricUnit {
        MetricUnit(.giga)
    }
}
