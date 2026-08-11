import Foundation

/// A unit of time, from SI-prefixed seconds up to days.
///
/// The second is the base unit, so `coefficientToBase` always converts to seconds.
/// Time is the one quantity here that people also count in sixties and twenty-fours:
/// minutes, hours and days are not powers of ten and cannot be written as a prefixed second,
/// which is why they are separate cases rather than another `MetricPrefix`.
///
/// ## Exactness
/// 1 min = 60 s, 1 h = 3600 s and 1 d = 86400 s are exact by definition. The day here is the
/// SI day of exactly 86400 s: it knows nothing about leap seconds, daylight saving or any other
/// calendar rule, so reach for `Calendar` when you mean "the same time tomorrow".
/// The SI prefixes are exact decimal factors, but the ones below one (`1e-3`, `1e-6`, `1e-9`)
/// have no exact binary form and are held as the nearest `Double`, so a round trip through
/// milliseconds is only good to `Double` precision.
///
/// ## Example
/// ```swift
/// let duration = Duration(90, unit: .minutes)
/// print(duration.hours)   // 1.5
/// print(duration.seconds) // 5400.0
///
/// let precise = Duration(500, unit: .milliseconds)
/// print(precise.seconds)  // 0.5
/// ```
@frozen
public enum TimeUnit: Unit, Codable, Sendable, Hashable {
    /// A second scaled by an SI prefix, such as `.seconds(.milli)` for milliseconds.
    case seconds(MetricPrefix)

    /// A minute: exactly 60 seconds.
    case minutes

    /// An hour: exactly 3600 seconds.
    case hours

    /// A day: exactly 86400 seconds, the SI day that ignores leap seconds and daylight saving.
    case days

    // MARK: - Unit Protocol

    /// The factor that converts a value in this unit to seconds.
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .seconds(let prefix):
            return prefix.factor
        case .minutes:
            return 60
        case .hours:
            return 3600
        case .days:
            return 86400
        }
    }

    /// The symbol with the SI prefix applied: "ms", "s", "min", "h", "d".
    public var symbol: String {
        switch self {
        case .seconds(let prefix):
            return prefix.symbol + "s"
        case .minutes:
            return "min"
        case .hours:
            return "h"
        case .days:
            return "d"
        }
    }
}

// MARK: - Convenience Static Properties

extension TimeUnit {
    @inlinable
    public static var seconds: TimeUnit {
        .seconds(.base)
    }

    @inlinable
    public static var milliseconds: TimeUnit {
        .seconds(.milli)
    }

    @inlinable
    public static var microseconds: TimeUnit {
        .seconds(.micro)
    }

    @inlinable
    public static var nanoseconds: TimeUnit {
        .seconds(.nano)
    }
}

// MARK: - CustomStringConvertible

extension TimeUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Duration Type Alias

/// An elapsed span of time, stored in seconds.
///
/// A type alias for `Measurement<TimeUnit>`. It is a plain span with no calendar attached:
/// a day is 86400 s, which is not "the same clock time tomorrow" across a daylight-saving change.
///
/// - Note: In files that import this package, `Duration` resolves to this type rather than the
///   standard library's clock `Duration`. Write `Swift.Duration` when you mean that one.
///
/// ## Example
/// ```swift
/// let workout = Duration(45, unit: .minutes)
/// print(workout.hours)    // 0.75
/// print(workout.seconds)  // 2700.0
///
/// let rest = Duration(90, unit: .seconds)
/// print(rest.minutes)     // 1.5
/// ```
public typealias Duration = Measurement<TimeUnit>

// MARK: - Duration Convenience Accessors

extension Duration {
    @inlinable
    public var seconds: Double {
        value(in: .seconds)
    }

    @inlinable
    public var milliseconds: Double {
        value(in: .milliseconds)
    }

    @inlinable
    public var microseconds: Double {
        value(in: .microseconds)
    }

    @inlinable
    public var nanoseconds: Double {
        value(in: .nanoseconds)
    }

    @inlinable
    public var minutes: Double {
        value(in: .minutes)
    }

    @inlinable
    public var hours: Double {
        value(in: .hours)
    }

    @inlinable
    public var days: Double {
        value(in: .days)
    }
}

// MARK: - Duration Formatting

extension Duration {
    /// A string in the largest unit the value reaches, to two decimal places.
    ///
    /// The unit is chosen by magnitude: days from 86400 s up, then hours, minutes, seconds and
    /// milliseconds. The sign does not affect the choice, so -90 s reads "-1.50 min", and
    /// anything below a microsecond still prints as microseconds ("0.00 μs").
    public var formatted: String {
        let s = seconds
        if abs(s) >= 86400 {
            return String(format: "%.2f d", days)
        } else if abs(s) >= 3600 {
            return String(format: "%.2f h", hours)
        } else if abs(s) >= 60 {
            return String(format: "%.2f min", minutes)
        } else if abs(s) >= 1 {
            return String(format: "%.2f s", s)
        } else if abs(milliseconds) >= 1 {
            return String(format: "%.2f ms", milliseconds)
        } else {
            return String(format: "%.2f μs", microseconds)
        }
    }

    /// A string as h:mm:ss, dropping the hours field for durations under an hour.
    ///
    /// "1:30:00" is an hour and a half; "1:05" is 65 seconds, not 65 minutes. Seconds are
    /// truncated toward zero, so 89.9 s reads "1:29".
    ///
    /// - Warning: A negative duration comes out malformed, as "-1:-30"; format its `magnitude`
    ///   and add the sign yourself. A duration too large to fit `Int` seconds traps.
    public var formattedHMS: String {
        let totalSeconds = Int(seconds)
        let h = totalSeconds / 3600
        let m = (totalSeconds % 3600) / 60
        let s = totalSeconds % 60

        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        } else {
            return String(format: "%d:%02d", m, s)
        }
    }
}
