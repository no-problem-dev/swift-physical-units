import Foundation

/// The ohm (Ω), the SI derived unit of electrical resistance, as a base unit for metric prefixes.
///
/// 1 Ω = 1 V/A = 1 kg⋅m²⋅s⁻³⋅A⁻², coherent and so free of any conversion factor.
///
/// - Note: The symbol is the Greek capital letter omega (U+03A9), not the deprecated ohm sign
///   (U+2126), which matters when comparing symbols byte for byte.
///
/// ## Example
/// ```swift
/// let unit = MetricUnit<Ohm>(.kilo)  // kilohms
/// print(unit.symbol)  // "kΩ"
/// ```
@frozen
public struct Ohm: BaseUnit {
    public static let symbol = "Ω"

    @inlinable
    public init() {}
}
