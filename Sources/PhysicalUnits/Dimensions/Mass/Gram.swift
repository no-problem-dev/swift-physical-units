import Foundation

/// The gram (g), this library's base unit of mass, as a base unit for metric prefixes.
///
/// The SI base unit of mass is the kilogram, which is the one SI base unit that already
/// carries a prefix. A prefix has to attach to something unprefixed, so prefixes attach to the
/// gram here and `MetricUnit<Gram>(.kilo)` is how the kilogram is spelled.
///
/// - Important: `Mass` therefore stores grams, not kilograms. Units defined on the kilogram —
///   the newton, and the joule through it — are a factor of 1000 away. The typed
///   `Mass` × `Acceleration` and `Force` / `Mass` operators apply that factor; arithmetic done
///   on raw `Double` values does not.
///
/// ## Example
/// ```swift
/// let unit = MetricUnit<Gram>(.kilo)  // kilograms
/// print(unit.symbol)  // "kg"
/// ```
@frozen
public struct Gram: BaseUnit {
    public static let symbol = "g"

    @inlinable
    public init() {}
}
