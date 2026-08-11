import Foundation

/// The hertz (Hz), the SI derived unit of frequency, as a base unit for metric prefixes.
///
/// 1 Hz = 1 s⁻¹, one cycle per second.
///
/// SI keeps the hertz for periodic events counted in cycles; an angular rate belongs to
/// `AngularSpeed` in rad/s, a different unit for the same dimension. `Frequency.asAngularSpeed`
/// converts between them at 2π rad per cycle — exact as a definition, so the only error is
/// `Double`'s π.
///
/// ## Example
/// ```swift
/// let unit = MetricUnit<Hertz>(.mega)  // megahertz
/// print(unit.symbol)  // "MHz"
/// ```
@frozen
public struct Hertz: BaseUnit {
    public static let symbol = "Hz"

    @inlinable
    public init() {}
}
