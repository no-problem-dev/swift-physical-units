import Foundation

/// A temperature scale: kelvin, Celsius, or Fahrenheit.
///
/// Temperature is the one dimension here that does not convert by a bare multiplier — the
/// Celsius and Fahrenheit scales are offset from kelvin as well as scaled. ``Temperature``
/// carries absolute readings and applies those offsets; ``TemperatureDelta`` carries
/// differences, which need only the multiplier.
///
/// ## Conversions
/// - Kelvin → Celsius: °C = K - 273.15
/// - Kelvin → Fahrenheit: °F = K × 9/5 - 459.67
/// - Celsius → Kelvin: K = °C + 273.15
/// - Fahrenheit → Kelvin: K = (°F + 459.67) × 5/9
///
/// All four are exact: 273.15, 459.67, and the 9/5 ratio define the scales. They are not
/// measured values that a later revision could refine.
///
/// ## Example
/// ```swift
/// let bodyTemp = Temperature(37, unit: .celsius)
/// print(bodyTemp.fahrenheit)  // 98.6
/// print(bodyTemp.kelvin)      // 310.15
/// ```
@frozen
public enum TemperatureUnit: Unit, Codable, Sendable, Hashable, CaseIterable {
    /// Kelvin, the SI base unit and the scale readings are stored in.
    case kelvin

    /// Degrees Celsius: the same degree size as the kelvin, offset by exactly 273.15.
    case celsius

    /// Degrees Fahrenheit: a degree of exactly 5/9 K, on a scale where 0 K reads -459.67 °F.
    case fahrenheit

    // MARK: - Constants

    /// The kelvin value of 0 °C, exactly 273.15 by the definition of the Celsius scale.
    public static let celsiusOffset: Double = 273.15

    /// The 459.67 term in °F = K × 9/5 - 459.67, exact by the definition of the Fahrenheit scale.
    public static let fahrenheitOffset: Double = 459.67

    /// Degrees Fahrenheit per kelvin, exactly 9/5.
    public static let fahrenheitScale: Double = 9.0 / 5.0

    // MARK: - Unit Protocol

    /// How many kelvins one degree of this scale spans — a factor for intervals, not readings.
    ///
    /// A single multiplier cannot carry the 273.15 K and 459.67 °F offsets, so this converts
    /// "5 degrees warmer" and never "5 degrees outside". ``TemperatureDelta`` is built on it;
    /// ``Temperature`` ignores it and applies the offsets itself.
    ///
    /// - Warning: Nothing stops this being taken for an absolute conversion factor. Because the
    ///   enum conforms to `Unit`, `Measurement<TemperatureUnit>(20, unit: .celsius)` compiles
    ///   and stores 20, not 293.15 — the type checker guards dimensions, not scale offsets.
    ///   Absolute readings belong in ``Temperature``.
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .kelvin:
            return 1.0
        case .celsius:
            return 1.0  // A 1 °C difference is a 1 K difference
        case .fahrenheit:
            return 5.0 / 9.0  // A 1 °F difference is a 5/9 K difference
        }
    }

    public var symbol: String {
        switch self {
        case .kelvin:
            return "K"
        case .celsius:
            return "°C"
        case .fahrenheit:
            return "°F"
        }
    }
}

// MARK: - CustomStringConvertible

extension TemperatureUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Temperature Type

/// An absolute temperature, stored in kelvin.
///
/// Initializing from Celsius or Fahrenheit adds that scale's offset and reading back subtracts
/// it, so a value survives a round trip through any scale. Differences between readings are a
/// separate type, ``TemperatureDelta``; that separation is what keeps "20 °C" from being added
/// to "20 °C".
///
/// ## Example
/// ```swift
/// let room = Temperature(20, unit: .celsius)
/// print(room.kelvin)      // 293.15
/// print(room.fahrenheit)  // 68.0
///
/// let boiling = Temperature(100, unit: .celsius)
/// print(boiling.kelvin)   // 373.15
/// ```
@frozen
public struct Temperature: Sendable, Hashable, Comparable, Codable {
    @usableFromInline
    internal let kelvinValue: Double

    // MARK: - Initializers

    /// Creates a temperature from a reading on the given scale.
    ///
    /// Celsius and Fahrenheit readings are shifted by their offsets, so this is not the same
    /// operation as scaling an interval.
    ///
    /// - Parameters:
    ///   - value: The reading, expressed on the scale named by `unit`.
    ///   - unit: The scale `value` is written on.
    @inlinable
    public init(_ value: Double, unit: TemperatureUnit) {
        switch unit {
        case .kelvin:
            self.kelvinValue = value
        case .celsius:
            self.kelvinValue = value + TemperatureUnit.celsiusOffset
        case .fahrenheit:
            self.kelvinValue = (value + TemperatureUnit.fahrenheitOffset) / TemperatureUnit.fahrenheitScale
        }
    }

    /// Wraps a value that is already in kelvin, skipping the scale conversion.
    @usableFromInline
    internal init(kelvinValue: Double) {
        self.kelvinValue = kelvinValue
    }

    // MARK: - Value Access

    /// Returns the reading on the given scale, with that scale's offset applied.
    @inlinable
    public func value(in unit: TemperatureUnit) -> Double {
        switch unit {
        case .kelvin:
            return kelvinValue
        case .celsius:
            return kelvinValue - TemperatureUnit.celsiusOffset
        case .fahrenheit:
            return kelvinValue * TemperatureUnit.fahrenheitScale - TemperatureUnit.fahrenheitOffset
        }
    }

    @inlinable
    public var kelvin: Double {
        value(in: .kelvin)
    }

    @inlinable
    public var celsius: Double {
        value(in: .celsius)
    }

    @inlinable
    public var fahrenheit: Double {
        value(in: .fahrenheit)
    }

    // MARK: - Comparable

    @inlinable
    public static func < (lhs: Temperature, rhs: Temperature) -> Bool {
        lhs.kelvinValue < rhs.kelvinValue
    }

    // MARK: - Arithmetic (interval operations)

    /// Shifts a reading up by an interval.
    ///
    /// Adding two absolute temperatures is deliberately absent: on an offset scale the answer
    /// would depend on which scale the operands happened to be written in.
    @inlinable
    public static func + (lhs: Temperature, rhs: TemperatureDelta) -> Temperature {
        Temperature(kelvinValue: lhs.kelvinValue + rhs.kelvinDelta)
    }

    /// Shifts a reading down by an interval.
    @inlinable
    public static func - (lhs: Temperature, rhs: TemperatureDelta) -> Temperature {
        Temperature(kelvinValue: lhs.kelvinValue - rhs.kelvinDelta)
    }

    /// Returns the interval between two readings.
    ///
    /// The offsets cancel, so the answer is the same number of kelvins whichever scale the two
    /// readings were written on.
    @inlinable
    public static func - (lhs: Temperature, rhs: Temperature) -> TemperatureDelta {
        TemperatureDelta(kelvinDelta: lhs.kelvinValue - rhs.kelvinValue)
    }

    // MARK: - Codable

    private enum CodingKeys: String, CodingKey {
        case kelvinValue
    }

    // MARK: - Special Values

    /// 0 K, which is -273.15 °C and -459.67 °F.
    public static let absoluteZero = Temperature(0, unit: .kelvin)

    /// 0 °C, the conventional freezing point of water at standard pressure.
    ///
    /// The stored value is exactly 273.15 K because that is how the Celsius scale is defined.
    /// Water's measured freezing point sits close to it but is not what fixes the number.
    public static let waterFreezingPoint = Temperature(0, unit: .celsius)

    /// 100 °C, the conventional boiling point of water at standard pressure.
    ///
    /// A scale convention inherited from the original Celsius definition rather than a
    /// measurement: on ITS-90, water at 1 atm boils at roughly 99.98 °C.
    public static let waterBoilingPoint = Temperature(100, unit: .celsius)

    /// 37 °C, the conventional normal human body temperature.
    ///
    /// A round convention, not a physical constant — normal readings vary with the person, the
    /// measurement site, and the time of day.
    public static let bodyTemperature = Temperature(37, unit: .celsius)
}

// MARK: - Temperature Formatting

extension Temperature {
    /// The Celsius reading to one decimal place, suffixed "°C".
    public var formattedCelsius: String {
        String(format: "%.1f°C", celsius)
    }

    /// The Fahrenheit reading to one decimal place, suffixed "°F".
    public var formattedFahrenheit: String {
        String(format: "%.1f°F", fahrenheit)
    }

    /// The kelvin reading to two decimal places, with the space before "K" that SI calls for.
    public var formattedKelvin: String {
        String(format: "%.2f K", kelvin)
    }
}

// MARK: - TemperatureDelta

/// A difference between two temperatures.
///
/// Differences convert by a plain factor — 1 °C of difference is 1 K, 1 °F is 5/9 K — because
/// the scale offsets cancel. Keeping them in their own type is what stops an interval being
/// read as an absolute reading, which dimension checking alone would never catch.
@frozen
public struct TemperatureDelta: Sendable, Hashable, Comparable, Codable, AdditiveArithmetic {
    @usableFromInline
    internal let kelvinDelta: Double

    /// Creates an interval from a difference expressed on the given scale.
    ///
    /// - Warning: This takes a difference, not a reading. `TemperatureDelta(20, unit: .celsius)`
    ///   is 20 K of difference, not 293.15 K; a reading belongs in ``Temperature``.
    @inlinable
    public init(_ value: Double, unit: TemperatureUnit) {
        self.kelvinDelta = value * unit.coefficientToBase
    }

    /// Wraps a value that is already a difference in kelvin.
    @usableFromInline
    internal init(kelvinDelta: Double) {
        self.kelvinDelta = kelvinDelta
    }

    /// Returns the interval expressed on the given scale, with no offset applied.
    @inlinable
    public func value(in unit: TemperatureUnit) -> Double {
        kelvinDelta / unit.coefficientToBase
    }

    @inlinable
    public var kelvin: Double { kelvinDelta }

    /// The interval in degrees Celsius, numerically identical to the kelvin value.
    @inlinable
    public var celsius: Double { kelvinDelta }

    /// The interval in degrees Fahrenheit, which is 9/5 of the kelvin value.
    @inlinable
    public var fahrenheit: Double { kelvinDelta * TemperatureUnit.fahrenheitScale }

    // MARK: - Comparable

    @inlinable
    public static func < (lhs: TemperatureDelta, rhs: TemperatureDelta) -> Bool {
        lhs.kelvinDelta < rhs.kelvinDelta
    }

    // MARK: - AdditiveArithmetic

    @inlinable
    public static var zero: TemperatureDelta {
        TemperatureDelta(kelvinDelta: 0)
    }

    @inlinable
    public static func + (lhs: TemperatureDelta, rhs: TemperatureDelta) -> TemperatureDelta {
        TemperatureDelta(kelvinDelta: lhs.kelvinDelta + rhs.kelvinDelta)
    }

    @inlinable
    public static func - (lhs: TemperatureDelta, rhs: TemperatureDelta) -> TemperatureDelta {
        TemperatureDelta(kelvinDelta: lhs.kelvinDelta - rhs.kelvinDelta)
    }
}
