import Foundation

/// The coulomb, the SI unit of electric charge.
///
/// 1 C = 1 A × 1 s, exactly. The coulomb is a derived unit — the ampere is the SI base unit for
/// electricity — so charge computed from a current and a duration converts without rounding.
/// Since the 2019 SI redefinition the elementary charge is fixed at exactly
/// 1.602176634 × 10⁻¹⁹ C, which is the value `Charge.elementaryCharge` holds.
///
/// ## Example
/// ```swift
/// let unit = MetricUnit<Coulomb>(.milli)  // millicoulombs
/// print(unit.symbol)  // "mC"
/// ```
@frozen
public struct Coulomb: BaseUnit {
    public static let symbol = "C"

    @inlinable
    public init() {}
}
