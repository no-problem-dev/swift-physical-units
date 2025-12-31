import Foundation

// MARK: - Frequency Operators
// 周波数と時間の関係を演算子として実装
//
// 周波数 = 1 / 周期       (f = 1 / T)
// 周期 = 1 / 周波数       (T = 1 / f)
// 角周波数 = 2π × 周波数  (ω = 2πf) - Angle 演算で対応

// MARK: - Frequency ↔ Duration Conversion Extensions

extension Duration {
    /// 周期から周波数へ変換
    ///
    /// f = 1 / T
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
    /// 周波数から周期へ変換
    ///
    /// T = 1 / f
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

/// 周波数 × 時間 = 角度（rad）
///
/// θ = 2π × f × t
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

/// 時間 × 周波数 = 角度（可換）
@inlinable
public func * (time: Duration, frequency: Frequency) -> Angle {
    frequency * time
}

// MARK: - Cycles (dimensionless) from Frequency × Time

extension Frequency {
    /// 指定時間内のサイクル数を計算
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
    /// 角周波数（rad/s）を取得
    ///
    /// ω = 2πf
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

/// 角度 / 時間 = 角速度
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

/// 角速度 × 時間 = 角度
///
/// θ = ω × t
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

/// 時間 × 角速度 = 角度（可換）
@inlinable
public func * (time: Duration, angularSpeed: AngularSpeed) -> Angle {
    angularSpeed * time
}

// MARK: - Time = Angle / AngularSpeed

/// 角度 / 角速度 = 時間
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

/// 角速度 × 半径 = 線速度
///
/// v = ω × r
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

/// 半径 × 角速度 = 線速度（可換）
@inlinable
public func * (radius: Length, angularSpeed: AngularSpeed) -> Speed {
    angularSpeed * radius
}

// MARK: - AngularSpeed = Speed / Radius

/// 線速度 / 半径 = 角速度
///
/// ω = v / r
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

/// 線速度 / 角速度 = 半径
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
    /// 周波数から角速度を計算
    ///
    /// ω = 2πf
    ///
    /// ```swift
    /// let frequency = Frequency(60, unit: .hertz)
    /// let angularSpeed = AngularSpeed(from: frequency)  // 376.99 rad/s
    /// ```
    @inlinable
    public init(from frequency: Frequency) {
        self = AngularSpeed(baseValue: frequency.baseValue * 2.0 * .pi)
    }

    /// 周波数として取得
    ///
    /// f = ω / 2π
    @inlinable
    public var asFrequency: Frequency {
        Frequency(baseValue: baseValue / (2.0 * .pi))
    }
}

extension Frequency {
    /// 角速度から周波数を計算
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

    /// 角速度として取得
    ///
    /// ω = 2πf
    @inlinable
    public var asAngularSpeed: AngularSpeed {
        AngularSpeed(baseValue: baseValue * 2.0 * .pi)
    }
}
