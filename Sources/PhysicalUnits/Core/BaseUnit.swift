import Foundation

/// The unprefixed unit that an SI prefix attaches to.
///
/// `Gram`, `Meter`, and `Second` are base units; combining one with a ``MetricPrefix``
/// through ``MetricUnit`` produces kilogram (kilo + gram), centimeter (centi + meter), and
/// so on.
///
/// A conformer is a phantom type. It carries no stored properties and is only ever read
/// statically, through ``symbol``, so `MetricUnit<Gram>` stores the prefix and nothing else.
///
/// ## Conforming
/// ```swift
/// public struct Gram: BaseUnit {
///     public static let symbol = "g"
///     public init() {}
/// }
/// ```
public protocol BaseUnit: Sendable, Hashable {
    /// The symbol of the unprefixed unit, such as `g`, `m`, or `s`.
    ///
    /// ``MetricUnit`` builds its own symbol by putting the prefix symbol in front of this one.
    static var symbol: String { get }

    /// Creates a value of the base unit, which nothing in this package ever does.
    ///
    /// Base units are used as phantom types, so a conformer still has to write
    /// `public init() {}` even though no instance is created.
    init()
}
