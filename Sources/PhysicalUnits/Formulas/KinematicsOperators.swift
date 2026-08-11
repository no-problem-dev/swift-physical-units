import Foundation

// MARK: - Kinematics Operators
// The basic formulas of constant-speed motion, expressed as operators.
//
// distance = speed × time     (d = v × t)
// speed    = distance / time  (v = d / t)
//
// Every operand is already held in its dimension's base unit (m, s, m/s), so each operator
// multiplies or divides base values straight through: no conversion factor is applied and
// the units the caller wrote have no effect on the result.

// MARK: - Distance = Speed × Time

/// Distance covered at a constant speed, d = v × t.
///
/// The product is taken in base units (m/s × s), so the result is a length in meters however
/// the operands were spelled. For a changing speed this is only the average-speed result.
///
/// ```swift
/// let speed = Speed(60, unit: .kilometersPerHour)
/// let time = Duration(2, unit: .hours)
/// let distance: Length = speed * time  // 120 km
/// ```
@inlinable
public func * (speed: Speed, time: Duration) -> Length {
    // speed.baseValue is in m/s, time.baseValue is in seconds
    // result is in meters
    Length(baseValue: speed.baseValue * time.baseValue)
}

/// Commutative form of speed × time, so operand order never matters.
@inlinable
public func * (time: Duration, speed: Speed) -> Length {
    speed * time
}

// MARK: - Speed = Distance / Time

/// Average speed over a distance and the time it took, v = d / t.
///
/// The division is done in base units (m / s), so the result is a speed in meters per second.
/// It is the mean over the interval, not the speed at any instant within it.
///
/// ```swift
/// let distance = Length(100, unit: .kilometers)
/// let time = Duration(2, unit: .hours)
/// let speed: Speed = distance / time  // 50 km/h
/// ```
@inlinable
public func / (distance: Length, time: Duration) -> Speed {
    // distance.baseValue is in meters, time.baseValue is in seconds
    // result is in m/s
    Speed(baseValue: distance.baseValue / time.baseValue)
}

// MARK: - Time = Distance / Speed

/// Time needed to cover a distance at a constant speed, t = d / v.
///
/// The division is done in base units (m / (m/s)), so the result is a duration in seconds.
/// A zero speed yields infinity rather than a trap, since this is plain `Double` division.
///
/// ```swift
/// let distance = Length(100, unit: .kilometers)
/// let speed = Speed(50, unit: .kilometersPerHour)
/// let time: Duration = distance / speed  // 2 hours
/// ```
@inlinable
public func / (distance: Length, speed: Speed) -> Duration {
    // distance.baseValue is in meters, speed.baseValue is in m/s
    // result is in seconds
    Duration(baseValue: distance.baseValue / speed.baseValue)
}
