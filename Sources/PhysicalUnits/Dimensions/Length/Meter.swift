import Foundation

/// The meter (m), the SI base unit of length, as a base unit for metric prefixes.
///
/// One meter is the distance light travels in vacuum in 1/299,792,458 of a second — a
/// definition that fixes the meter exactly, by fixing the speed of light at exactly
/// 299,792,458 m/s.
///
/// `LengthUnit` and `Length` are built on this type, so every length in the package converts
/// through meters.
///
/// ## Example
/// ```swift
/// let unit = MetricUnit<Meter>(.centi)  // centimeters
/// print(unit.symbol)  // "cm"
/// ```
@frozen
public struct Meter: BaseUnit {
    public static let symbol = "m"

    @inlinable
    public init() {}
}
