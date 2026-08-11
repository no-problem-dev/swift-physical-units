import Foundation

/// The newton (N), the SI derived unit of force, as a base unit for metric prefixes.
///
/// 1 N = 1 kg⋅m⋅s⁻².
///
/// - Note: This type only feeds `MetricUnit<Newton>`. The `Force` measurement type is built on
///   the `ForceUnit` enum instead, so `Measurement<MetricUnit<Newton>>` and `Force` are
///   separate types that do not mix and share no conversions.
///
/// ## Example
/// ```swift
/// let unit = MetricUnit<Newton>(.kilo)  // kilonewtons
/// print(unit.symbol)  // "kN"
/// ```
@frozen
public struct Newton: BaseUnit {
    public static let symbol = "N"

    @inlinable
    public init() {}
}
