import Foundation

/// The pascal, the SI derived unit of pressure.
///
/// 1 Pa = 1 N/m² = 1 kg⋅m⁻¹⋅s⁻²
///
/// This is the phantom base a `MetricUnit<Pascal>` is built on, giving the SI prefixes and
/// nothing else. ``Pressure`` values are measured in ``PressureUnit``, which carries bar, atm,
/// torr, and psi alongside the prefixed pascals.
///
/// ## Example
/// ```swift
/// let unit = MetricUnit<Pascal>(.hecto)  // hectopascals
/// print(unit.symbol)  // "hPa"
/// ```
@frozen
public struct Pascal: BaseUnit {
    public static let symbol = "Pa"

    @inlinable
    public init() {}
}
