import Foundation

/// The liter (L), this library's base unit of volume, as a base unit for metric prefixes.
///
/// SI measures volume in cubic meters, which is a derived unit no prefix attaches to cleanly:
/// prefixing it would cube the factor, so a "millicubic meter" is not a thing anyone writes.
/// The liter takes prefixes the ordinary way and is what everyday quantities are written in,
/// so it is the base unit here.
///
/// 1 L = 1 dm³ = 0.001 m³ exactly — the liter has been defined as exactly one cubic decimeter
/// since 1964. That makes 1 kL exactly 1 m³, which is what `Volume.cubicMeters` reads.
///
/// ## Example
/// ```swift
/// let unit = MetricUnit<Liter>(.milli)  // milliliters
/// print(unit.symbol)  // "mL"
/// ```
@frozen
public struct Liter: BaseUnit {
    public static let symbol = "L"

    @inlinable
    public init() {}
}
