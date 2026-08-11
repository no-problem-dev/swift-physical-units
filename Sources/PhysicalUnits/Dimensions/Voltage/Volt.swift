import Foundation

/// The volt (V), the SI derived unit of electric potential difference, as a base unit for
/// metric prefixes.
///
/// 1 V = 1 W/A = 1 kg⋅m²⋅s⁻³⋅A⁻¹. Being coherent, it brings no numeric factor with it: the
/// electrical operators multiply and divide base values straight through.
///
/// ## Example
/// ```swift
/// let unit = MetricUnit<Volt>(.kilo)  // kilovolts
/// print(unit.symbol)  // "kV"
/// ```
@frozen
public struct Volt: BaseUnit {
    public static let symbol = "V"

    @inlinable
    public init() {}
}
