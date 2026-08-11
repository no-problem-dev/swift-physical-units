import Foundation

/// The watt (W), the SI derived unit of power, as a base unit for metric prefixes.
///
/// 1 W = 1 J/s = 1 kg⋅m²⋅s⁻³.
///
/// - Note: This type only feeds `MetricUnit<Watt>`. The `Power` measurement type is built on
///   the `PowerUnit` enum instead, so `Measurement<MetricUnit<Watt>>` and `Power` are separate
///   types that do not mix and share no conversions.
///
/// ## Example
/// ```swift
/// let unit = MetricUnit<Watt>(.kilo)  // kilowatts
/// print(unit.symbol)  // "kW"
/// ```
@frozen
public struct Watt: BaseUnit {
    public static let symbol = "W"

    @inlinable
    public init() {}
}
