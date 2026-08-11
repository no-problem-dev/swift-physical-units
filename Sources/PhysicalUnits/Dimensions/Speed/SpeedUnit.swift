import Foundation

/// A unit of speed, convertible to and from metres per second.
///
/// The base unit is m/s. Speed is a derived quantity (length ÷ time), so m/s is the coherent
/// SI derived unit for it rather than an SI base unit.
///
/// ## Conversions (to m/s)
/// - km/h = 1000/3600 m/s. An exact ratio that has no terminating decimal (≈ 0.2778); it is
///   stored as the division, so no digits are thrown away.
/// - mph = 1609.344/3600 m/s. Exact: 1 mile = 1609.344 m follows from 1 in = 25.4 mm exactly.
/// - knot = 1852/3600 m/s. Exact: 1 nautical mile = 1852 m by international agreement. Again a
///   ratio, not a terminating decimal (≈ 0.5144).
///
/// ## Example
/// ```swift
/// let running = Speed(10, unit: .kilometersPerHour)
/// print(running.metersPerSecond)  // 2.778
///
/// let wind = Speed(20, unit: .knots)
/// print(wind.kilometersPerHour)   // 37.04
/// ```
@frozen
public enum SpeedUnit: Unit, Codable, Sendable, Hashable, CaseIterable {
    /// Metre per second (m/s), the base unit every other case converts against.
    case metersPerSecond

    /// Kilometre per hour (km/h), exactly 1000/3600 m/s.
    case kilometersPerHour

    /// Statute mile per hour (mph), exactly 1609.344/3600 m/s.
    case milesPerHour

    /// Knot, one nautical mile per hour: exactly 1852/3600 m/s. Its symbol here is `kn`.
    case knots

    // MARK: - Constants

    /// km/h in m/s: the exact ratio 1000/3600, kept as a division rather than a rounded decimal.
    public static let kmhToMs: Double = 1000.0 / 3600.0

    /// mph in m/s: the exact ratio 1609.344/3600, since 1 mile = 1609.344 m exactly.
    public static let mphToMs: Double = 1609.344 / 3600.0

    /// knot in m/s: the exact ratio 1852/3600, since 1 nautical mile = 1852 m exactly.
    public static let knotToMs: Double = 1852.0 / 3600.0

    // MARK: - Unit Protocol

    /// The multiplier that turns a value in this unit into m/s.
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .metersPerSecond:
            return 1.0
        case .kilometersPerHour:
            return Self.kmhToMs
        case .milesPerHour:
            return Self.mphToMs
        case .knots:
            return Self.knotToMs
        }
    }

    public var symbol: String {
        switch self {
        case .metersPerSecond:
            return "m/s"
        case .kilometersPerHour:
            return "km/h"
        case .milesPerHour:
            return "mph"
        case .knots:
            return "kn"
        }
    }
}

// MARK: - CustomStringConvertible

extension SpeedUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Speed Type Alias

/// A speed, stored internally in m/s.
///
/// ## Example
/// ```swift
/// let car = Speed(100, unit: .kilometersPerHour)
/// print(car.metersPerSecond)  // 27.78
///
/// let plane = Speed(500, unit: .knots)
/// print(plane.kilometersPerHour)  // 926.0
/// ```
public typealias Speed = Measurement<SpeedUnit>

// MARK: - Speed Convenience Accessors

extension Speed {
    @inlinable
    public var metersPerSecond: Double {
        value(in: .metersPerSecond)
    }

    @inlinable
    public var kilometersPerHour: Double {
        value(in: .kilometersPerHour)
    }

    @inlinable
    public var milesPerHour: Double {
        value(in: .milesPerHour)
    }

    @inlinable
    public var knots: Double {
        value(in: .knots)
    }
}

// MARK: - Speed Formatting

extension Speed {
    /// The value as km/h at 100 m/s and above, otherwise as m/s — two decimals from 1 m/s up, three below.
    ///
    /// Only those two units are ever chosen: mph and knots never appear, so a speed entered in
    /// them comes back out metric. The 100 m/s cut-off is 360 km/h, so ordinary road and wind
    /// speeds print as m/s rather than km/h.
    public var formatted: String {
        let ms = metersPerSecond
        if abs(ms) >= 100 {
            return String(format: "%.1f km/h", kilometersPerHour)
        } else if abs(ms) >= 1 {
            return String(format: "%.2f m/s", ms)
        } else {
            return String(format: "%.3f m/s", ms)
        }
    }
}

// MARK: - Speed Special Values

extension Speed {
    /// The speed of light in vacuum, 299,792,458 m/s — exact, because the metre is defined from it.
    public static let speedOfLight = Speed(299_792_458, unit: .metersPerSecond)

    /// The speed of sound in air at 20 °C, 343 m/s — rounded, and it shifts with temperature.
    public static let speedOfSound = Speed(343, unit: .metersPerSecond)

    /// Mach 1 as a fixed 343 m/s, the same value as the speed of sound above.
    ///
    /// Real Mach 1 follows the local speed of sound and drops with altitude and cold, so this
    /// value only holds near sea level at 20 °C.
    public static var mach1: Speed { speedOfSound }
}
