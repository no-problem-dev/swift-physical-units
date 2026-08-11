import Foundation

/// A quantity stored in its dimension's base unit and tagged with that dimension at compile time.
///
/// The value is converted into the base unit when it is created and back out again when it
/// is read, so the only storage is one `Double` — the unit itself is not kept. `UnitType`
/// makes two dimensions two unrelated types, so a mass and a length cannot be added,
/// compared, or assigned to each other.
///
/// ```swift
/// let mass1 = Measurement<MassUnit>(70, unit: .kilograms)
/// let mass2 = Measurement<MassUnit>(5000, unit: .grams)
///
/// // Through a dimension's type alias (preferred)
/// let mass = Mass(70, unit: .kilograms)
/// print(mass.value(in: .grams))  // 70000.0
/// ```
///
/// ## Where the compile-time checking stops
///
/// Within one dimension the typed operators cover addition, subtraction, and comparison.
/// Everything below leaves that guarantee, and each is a way to get a wrong answer that
/// still compiles:
///
/// - Scalar `*` and `/` with a `Double`, and the `Measurement / Measurement` ratio, move
///   values in and out as plain numbers, and nothing checks what those numbers meant.
/// - Two different dimensions combine only where an operator was written by hand in this
///   package's formula operators — speed × time, force ÷ acceleration, and so on. There is
///   no general dimensional algebra, so a combination nobody wrote is a compile error
///   rather than a wrong result.
/// - `Codable` writes only the base-unit number, under a single key, with no unit or
///   dimension recorded. A mass payload therefore decodes into a length without complaint,
///   and the `UnitType: Codable` constraint on the conformance is never exercised.
/// - A unit that needs an offset is silently wrong here. `Measurement<TemperatureUnit>`
///   compiles and reads 20 °C as 20 K, because ``TemperatureUnit`` only carries the scale
///   part of the conversion. Use ``Temperature`` for absolute temperatures.
///
/// - Note: Equality and hashing compare the stored base-unit `Double` exactly. Two values
///   that are mathematically equal can differ in their last bits after conversion, so
///   compare with a tolerance where that matters.
@frozen
public struct Measurement<UnitType: Unit>: Sendable, Hashable {
    /// The value in the dimension's base unit: the gram for mass, the meter for length,
    /// the second for time.
    @usableFromInline
    internal let baseValue: Double

    // MARK: - Initializers

    /// Converts `value` from `unit` into the base unit and stores only the result.
    ///
    /// The unit is not retained, so nothing later can report which unit the value was
    /// written in.
    @inlinable
    public init(_ value: Double, unit: UnitType) {
        self.baseValue = value * unit.coefficientToBase
    }

    @inlinable
    public init(_ value: Int, unit: UnitType) {
        self.baseValue = Double(value) * unit.coefficientToBase
    }

    /// Stores a base-unit value with no conversion.
    ///
    /// This is how the formula operators build a result whose dimension differs from their
    /// operands', since a base-unit number is all they have.
    @usableFromInline
    internal init(baseValue: Double) {
        self.baseValue = baseValue
    }

    // MARK: - Value Access

    /// Divides the stored base-unit value by the unit's coefficient.
    ///
    /// Both directions round, so a value written in one unit and read back in another can
    /// come out a few bits off the number that was written.
    @inlinable
    public func value(in unit: UnitType) -> Double {
        baseValue / unit.coefficientToBase
    }
}

// MARK: - Comparable

extension Measurement: Comparable {
    @inlinable
    public static func < (lhs: Measurement<UnitType>, rhs: Measurement<UnitType>) -> Bool {
        lhs.baseValue < rhs.baseValue
    }
}

// MARK: - AdditiveArithmetic

extension Measurement: AdditiveArithmetic {
    @inlinable
    public static var zero: Measurement<UnitType> {
        Measurement(baseValue: 0)
    }

    @inlinable
    public static func + (lhs: Measurement<UnitType>, rhs: Measurement<UnitType>) -> Measurement<UnitType> {
        Measurement(baseValue: lhs.baseValue + rhs.baseValue)
    }

    @inlinable
    public static func - (lhs: Measurement<UnitType>, rhs: Measurement<UnitType>) -> Measurement<UnitType> {
        Measurement(baseValue: lhs.baseValue - rhs.baseValue)
    }
}

// MARK: - Scalar Multiplication

extension Measurement {
    @inlinable
    public static func * (lhs: Measurement<UnitType>, rhs: Double) -> Measurement<UnitType> {
        Measurement(baseValue: lhs.baseValue * rhs)
    }

    @inlinable
    public static func * (lhs: Double, rhs: Measurement<UnitType>) -> Measurement<UnitType> {
        Measurement(baseValue: lhs * rhs.baseValue)
    }

    @inlinable
    public static func / (lhs: Measurement<UnitType>, rhs: Double) -> Measurement<UnitType> {
        Measurement(baseValue: lhs.baseValue / rhs)
    }

    /// Returns the ratio of two measurements of the same dimension.
    ///
    /// The unit cancels, so the result is a dimensionless `Double` and the compiler stops
    /// tracking what it measures. Dividing by a zero measurement gives an infinity or a
    /// NaN, as `Double` division does.
    @inlinable
    public static func / (lhs: Measurement<UnitType>, rhs: Measurement<UnitType>) -> Double {
        lhs.baseValue / rhs.baseValue
    }
}

// MARK: - Compound Assignment

extension Measurement {
    @inlinable
    public static func += (lhs: inout Measurement<UnitType>, rhs: Measurement<UnitType>) {
        lhs = lhs + rhs
    }

    @inlinable
    public static func -= (lhs: inout Measurement<UnitType>, rhs: Measurement<UnitType>) {
        lhs = lhs - rhs
    }

    @inlinable
    public static func *= (lhs: inout Measurement<UnitType>, rhs: Double) {
        lhs = lhs * rhs
    }

    @inlinable
    public static func /= (lhs: inout Measurement<UnitType>, rhs: Double) {
        lhs = lhs / rhs
    }
}

// MARK: - Codable

extension Measurement: Codable where UnitType: Codable {
    private enum CodingKeys: String, CodingKey {
        case baseValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseValue = try container.decode(Double.self, forKey: .baseValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(baseValue, forKey: .baseValue)
    }
}

// MARK: - CustomStringConvertible

extension Measurement: CustomStringConvertible where UnitType: Unit {
    /// The base-unit magnitude to four significant digits, followed by the literal text
    /// `(base units)`.
    ///
    /// No symbol appears, because a measurement does not keep the unit it was built from.
    /// `Mass(70, unit: .kilograms)` prints `7e+04 (base units)`, grams being the base unit.
    /// Format the value yourself when a reader needs to know the unit.
    public var description: String {
        String(format: "%.4g (base units)", baseValue)
    }
}

// MARK: - Numeric Utilities

extension Measurement {
    /// The absolute value, as a measurement of the same dimension.
    ///
    /// Named after `Numeric.magnitude`, but ``Measurement`` does not conform to `Numeric`
    /// and this returns a measurement rather than a bare number.
    @inlinable
    public var magnitude: Measurement<UnitType> {
        Measurement(baseValue: abs(baseValue))
    }

    @inlinable
    public var isNegative: Bool {
        baseValue < 0
    }

    /// Whether the base-unit value is exactly zero.
    ///
    /// The test is `== 0`, so a value that only rounds to zero is not zero here, and
    /// ``isNegative``, ``isZero``, and ``isPositive`` are all false for a NaN.
    @inlinable
    public var isZero: Bool {
        baseValue == 0
    }

    @inlinable
    public var isPositive: Bool {
        baseValue > 0
    }
}

// MARK: - Clamping

extension Measurement {
    /// Returns the value held inside `range`.
    ///
    /// The comparison runs on the stored base-unit numbers, so the units the bounds were
    /// written in make no difference to the result.
    @inlinable
    public func clamped(to range: ClosedRange<Measurement<UnitType>>) -> Measurement<UnitType> {
        Measurement(baseValue: max(range.lowerBound.baseValue, min(baseValue, range.upperBound.baseValue)))
    }
}
