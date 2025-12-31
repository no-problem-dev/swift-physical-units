import Foundation

// MARK: - Kinematics Operators
// 運動学の基本公式を演算子として実装
//
// 距離 = 速度 × 時間  (d = v × t)
// 速度 = 距離 / 時間  (v = d / t)

// MARK: - Distance = Speed × Time

/// 速度 × 時間 = 距離
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

/// 時間 × 速度 = 距離（可換）
@inlinable
public func * (time: Duration, speed: Speed) -> Length {
    speed * time
}

// MARK: - Speed = Distance / Time

/// 距離 / 時間 = 速度
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

/// 距離 / 速度 = 時間
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
