import Foundation

/// The second, the SI base unit of time.
///
/// Defined as the duration of 9,192,631,770 periods of the radiation from the transition
/// between the two hyperfine levels of the caesium-133 ground state. That count is exact by
/// definition, and every SI prefix over it is an exact decimal factor, held to `Double`
/// precision.
///
/// ## Example
/// ```swift
/// let unit = MetricUnit<Second>(.milli)  // millisecond
/// print(unit.symbol)  // "ms"
/// ```
///
/// - Note: Minutes (60 s) and hours (3600 s) are not powers of ten and cannot be built from a
///   prefix. Use the `TimeUnit` enum when you need them.
@frozen
public struct Second: BaseUnit {
    public static let symbol = "s"

    /// Creates a value of this phantom type.
    ///
    /// `Second` carries no state; it exists to parameterise `MetricUnit`, and the initializer
    /// is here only because `BaseUnit` requires one.
    @inlinable
    public init() {}
}
