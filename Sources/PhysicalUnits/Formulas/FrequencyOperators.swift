import Foundation

// MARK: - Frequency Operators
// The relations between frequency, period, angle and angular speed, written as operators.
//
// Frequency      = 1 / period      (f = 1 / T)
// Period         = 1 / frequency   (T = 1 / f)
// Angular speed  = 2π × frequency  (ω = 2πf) - handled through the Angle operations
//
// The 2π that runs through this file is the definition of a revolution (1 cycle = 2π rad),
// not a measured quantity, so it is exact as a definition; the code spells it `2.0 * .pi`,
// which means the only error is `Double`'s representation of π. Nothing here is a rounded
// decimal literal, and neither is the rpm unit the examples use — its factor is written
// `2.0 * .pi / 60.0`, with the minute being exactly 60 s.
//
// Radians count as dimensionless throughout, which is what lets rad/s divide out against
// seconds and metres. The consequence is that the type checker cannot tell rad/s from a
// plain 1/s, so `Speed / Length` yielding an `AngularSpeed` is a convention this file
// chooses, not something the dimensions prove.

// MARK: - Frequency ↔ Duration Conversion Extensions

extension Duration {
    /// This duration read as a period, converted to the frequency it repeats at.
    ///
    /// f = 1 / T
    ///
    /// The reciprocal of the value in seconds, with no conversion factor involved. A zero
    /// duration produces an infinite frequency rather than trapping, because this is
    /// `Double` division.
    ///
    /// ```swift
    /// let period = Duration(0.001, unit: .seconds)  // 1 ms
    /// let frequency = period.asFrequency  // 1000 Hz
    /// ```
    @inlinable
    public var asFrequency: Frequency {
        // baseValue is in seconds
        // 1 / s = Hz
        Frequency(baseValue: 1.0 / baseValue)
    }
}

extension Frequency {
    /// The duration of one cycle at this frequency.
    ///
    /// T = 1 / f
    ///
    /// The reciprocal of the value in hertz. A zero frequency produces an infinite period
    /// rather than trapping.
    ///
    /// ```swift
    /// let frequency = Frequency(1000, unit: .hertz)  // 1 kHz
    /// let period = frequency.asPeriod  // 0.001 s = 1 ms
    /// ```
    @inlinable
    public var asPeriod: Duration {
        // baseValue is in Hz
        // 1 / Hz = s
        Duration(baseValue: 1.0 / baseValue)
    }
}

// MARK: - Angle = Frequency × Time (rad = Hz × s × 2π)

/// Multiplies a frequency by an elapsed time to give the phase swept out.
///
/// θ = 2π × f × t
///
/// The cycles completed in that time, turned into an angle at 2π rad per cycle. The result
/// accumulates without limit — ten cycles give 20π rad, not zero — so wrap it yourself if
/// you want a phase within one turn.
///
/// ```swift
/// let frequency = Frequency(1, unit: .hertz)  // 1 Hz
/// let time = Duration(0.5, unit: .seconds)    // 0.5 s
/// let angle: Angle = frequency * time  // π rad (180°)
/// ```
@inlinable
public func * (frequency: Frequency, time: Duration) -> Angle {
    // frequency.baseValue is in Hz, time.baseValue is in s
    // Hz × s × 2π = rad
    let cycles = frequency.baseValue * time.baseValue
    return Angle(baseValue: cycles * 2.0 * .pi)
}

/// The commutative form of θ = 2π × f × t, with the operands in the other order.
@inlinable
public func * (time: Duration, frequency: Frequency) -> Angle {
    frequency * time
}

// MARK: - Cycles (dimensionless) from Frequency × Time

extension Frequency {
    /// The number of cycles completed in the given time.
    ///
    /// A count is dimensionless, so this returns a bare `Double` and the result carries no
    /// dimension onward. Fractional cycles are kept rather than truncated.
    ///
    /// ```swift
    /// let frequency = Frequency(60, unit: .hertz)
    /// let time = Duration(1, unit: .seconds)
    /// let cycles = frequency.cycles(in: time)  // 60.0
    /// ```
    @inlinable
    public func cycles(in time: Duration) -> Double {
        baseValue * time.baseValue
    }
}

// MARK: - Angular Speed Extensions

extension Frequency {
    /// This frequency as an angular speed in rad/s, as a plain number.
    ///
    /// ω = 2πf
    ///
    /// Returning `Double` drops the dimension, so nothing downstream will catch a rad/s value
    /// used where something else was meant. Prefer `asAngularSpeed`, which returns a typed
    /// `AngularSpeed` from the same arithmetic.
    ///
    /// ```swift
    /// let frequency = Frequency(1, unit: .hertz)
    /// let omega = frequency.angularSpeed  // 2π rad/s
    /// ```
    @inlinable
    public var angularSpeed: Double {
        baseValue * 2.0 * .pi
    }
}

// MARK: - ============================================
// MARK: - Angular Speed (ω = θ/t)
// MARK: - ============================================

// MARK: - AngularSpeed = Angle / Time

/// Divides an angle by the time taken to sweep it, giving the average angular speed.
///
/// ω = θ / t
///
/// ```swift
/// let angle = Angle(360, unit: .degrees)
/// let time = Duration(1, unit: .seconds)
/// let angularSpeed: AngularSpeed = angle / time  // 2π rad/s
/// ```
@inlinable
public func / (angle: Angle, time: Duration) -> AngularSpeed {
    // angle.baseValue is in radians, time.baseValue is in seconds
    // rad / s = rad/s
    AngularSpeed(baseValue: angle.baseValue / time.baseValue)
}

// MARK: - Angle = AngularSpeed × Time

/// Multiplies an angular speed by a duration to give the angle swept.
///
/// θ = ω × t
///
/// Assumes a constant rate, and the angle accumulates past a full turn rather than wrapping.
///
/// ```swift
/// let angularSpeed = AngularSpeed(100, unit: .rpm)
/// let time = Duration(1, unit: .minutes)
/// let angle: Angle = angularSpeed * time  // 100 revolutions = 200π rad
/// ```
@inlinable
public func * (angularSpeed: AngularSpeed, time: Duration) -> Angle {
    // angularSpeed.baseValue is in rad/s, time.baseValue is in seconds
    // rad/s × s = rad
    Angle(baseValue: angularSpeed.baseValue * time.baseValue)
}

/// The commutative form of θ = ω × t, with the operands in the other order.
@inlinable
public func * (time: Duration, angularSpeed: AngularSpeed) -> Angle {
    angularSpeed * time
}

// MARK: - Time = Angle / AngularSpeed

/// Divides an angle by an angular speed to give how long that rotation takes.
///
/// t = θ / ω
///
/// ```swift
/// let angle = Angle(2 * .pi, unit: .radians)  // 1 revolution
/// let angularSpeed = AngularSpeed(60, unit: .rpm)
/// let time: Duration = angle / angularSpeed  // 1 second
/// ```
@inlinable
public func / (angle: Angle, angularSpeed: AngularSpeed) -> Duration {
    // angle.baseValue is in radians, angularSpeed.baseValue is in rad/s
    // rad / (rad/s) = s
    Duration(baseValue: angle.baseValue / angularSpeed.baseValue)
}

// MARK: - Linear Speed = AngularSpeed × Radius

/// Multiplies an angular speed by a radius to give the tangential speed at that radius.
///
/// v = ω × r
///
/// Holds only because radians are dimensionless: rad/s × m falls out as m/s. The length
/// operand has to be a radius from the axis — nothing in the types enforces that, so a
/// diameter passed by mistake type-checks and silently doubles the answer.
///
/// ```swift
/// let angularSpeed = AngularSpeed(100, unit: .rpm)
/// let radius = Length(0.5, unit: .meters)
/// let speed: Speed = angularSpeed * radius  // 5.24 m/s
/// ```
@inlinable
public func * (angularSpeed: AngularSpeed, radius: Length) -> Speed {
    // angularSpeed.baseValue is in rad/s, radius.baseValue is in meters
    // rad/s × m = m/s
    Speed(baseValue: angularSpeed.baseValue * radius.baseValue)
}

/// The commutative form of v = ω × r, with the operands in the other order.
@inlinable
public func * (radius: Length, angularSpeed: AngularSpeed) -> Speed {
    angularSpeed * radius
}

// MARK: - AngularSpeed = Speed / Radius

/// Divides a tangential speed by the radius it was measured at to give the angular speed.
///
/// ω = v / r
///
/// m/s ÷ m leaves 1/s, which is read back as rad/s because radians are dimensionless. That
/// step is a convention, not a proof: the same division would equally describe a frequency,
/// and the type system cannot tell you which one you meant.
///
/// ```swift
/// let speed = Speed(10, unit: .metersPerSecond)
/// let radius = Length(2, unit: .meters)
/// let angularSpeed: AngularSpeed = speed / radius  // 5 rad/s
/// ```
@inlinable
public func / (speed: Speed, radius: Length) -> AngularSpeed {
    // speed.baseValue is in m/s, radius.baseValue is in meters
    // m/s / m = 1/s = rad/s (since radians are dimensionless)
    AngularSpeed(baseValue: speed.baseValue / radius.baseValue)
}

// MARK: - Radius = Speed / AngularSpeed

/// Divides a tangential speed by an angular speed to give the radius they imply.
///
/// r = v / ω
///
/// ```swift
/// let speed = Speed(10, unit: .metersPerSecond)
/// let angularSpeed = AngularSpeed(5, unit: .radiansPerSecond)
/// let radius: Length = speed / angularSpeed  // 2 m
/// ```
@inlinable
public func / (speed: Speed, angularSpeed: AngularSpeed) -> Length {
    // speed.baseValue is in m/s, angularSpeed.baseValue is in rad/s
    // m/s / (rad/s) = m (since radians are dimensionless)
    Length(baseValue: speed.baseValue / angularSpeed.baseValue)
}

// MARK: - AngularSpeed ↔ Frequency Conversion

extension AngularSpeed {
    /// Creates an angular speed from a frequency.
    ///
    /// ω = 2πf
    ///
    /// One cycle is 2π rad by definition, so the factor is exact as a definition and the
    /// only loss is `Double`'s π.
    ///
    /// ```swift
    /// let frequency = Frequency(60, unit: .hertz)
    /// let angularSpeed = AngularSpeed(from: frequency)  // 376.99 rad/s
    /// ```
    @inlinable
    public init(from frequency: Frequency) {
        self = AngularSpeed(baseValue: frequency.baseValue * 2.0 * .pi)
    }

    /// This angular speed expressed as a cycle rate.
    ///
    /// f = ω / 2π
    @inlinable
    public var asFrequency: Frequency {
        Frequency(baseValue: baseValue / (2.0 * .pi))
    }
}

extension Frequency {
    /// Creates a frequency from an angular speed.
    ///
    /// f = ω / 2π
    ///
    /// ```swift
    /// let angularSpeed = AngularSpeed(2 * .pi, unit: .radiansPerSecond)
    /// let frequency = Frequency(from: angularSpeed)  // 1 Hz
    /// ```
    @inlinable
    public init(from angularSpeed: AngularSpeed) {
        self = Frequency(baseValue: angularSpeed.baseValue / (2.0 * .pi))
    }

    /// This frequency expressed as an angular speed, keeping the dimension.
    ///
    /// ω = 2πf
    @inlinable
    public var asAngularSpeed: AngularSpeed {
        AngularSpeed(baseValue: baseValue * 2.0 * .pi)
    }
}
