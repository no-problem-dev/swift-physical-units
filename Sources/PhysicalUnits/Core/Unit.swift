import Foundation

/// A unit that reaches its dimension's base unit by a single multiplication.
///
/// Every unit type in this package (`MetricUnit`, `EnergyUnit`, and the rest) conforms, and
/// ``Measurement`` takes a conforming type as its generic parameter. A measurement stores
/// its value in the base unit, so a conformer only has to say what to multiply by and how
/// the unit is spelled.
///
/// A conversion that needs an offset does not fit this shape. ``TemperatureUnit`` conforms
/// anyway, but its coefficient converts temperature *differences* only; absolute
/// temperatures go through the separate ``Temperature`` type.
///
/// ## Conforming
/// ```swift
/// struct MyUnit: Unit {
///     var coefficientToBase: Double { 1000.0 }
///     var symbol: String { "ku" }
/// }
/// ```
public protocol Unit: Sendable, Hashable {
    /// The factor a value in this unit is multiplied by to reach the base unit.
    ///
    /// Converting back divides by it. A kilogram returns `1000`, because mass in this
    /// package converts through the gram.
    var coefficientToBase: Double { get }

    /// The symbol used when displaying the unit, such as `kg`, `cm`, or `kcal`.
    ///
    /// Nothing in ``Measurement`` reads it: a measurement does not keep the unit it was
    /// built from, and its `description` prints the base-unit magnitude only. Pairing a
    /// number with a symbol is left to the caller.
    var symbol: String { get }
}
