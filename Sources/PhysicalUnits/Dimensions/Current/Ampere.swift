import Foundation

/// The ampere (A), the SI base unit of electric current, as a base unit for metric prefixes.
///
/// Since the 2019 redefinition the ampere is fixed by the elementary charge, taken to be
/// exactly 1.602176634 × 10⁻¹⁹ C: one ampere is a flow of 1/e elementary charges per second.
/// The older two-parallel-wires definition, which depended on a measured force, is gone.
///
/// ## Example
/// ```swift
/// let unit = MetricUnit<Ampere>(.milli)  // milliamperes
/// print(unit.symbol)  // "mA"
/// ```
@frozen
public struct Ampere: BaseUnit {
    public static let symbol = "A"

    @inlinable
    public init() {}
}
