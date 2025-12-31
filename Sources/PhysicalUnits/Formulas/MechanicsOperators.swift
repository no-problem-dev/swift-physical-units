import Foundation

// MARK: - Mechanics Operators
// 力学の基本公式を演算子として実装
//
// 仕事 = 力 × 距離        (W = F × d)
// 仕事率 = 仕事 / 時間    (P = W / t)
// 仕事率 = 力 × 速度      (P = F × v)
// 圧力 = 力 / 面積        (p = F / A)
// 力 = 圧力 × 面積        (F = p × A)

// MARK: - Work/Energy = Force × Distance

/// 力 × 距離 = 仕事（エネルギー）
///
/// W = F × d
///
/// ```swift
/// let force = Force(100, unit: .newtons)
/// let distance = Length(5, unit: .meters)
/// let work: Energy = force * distance  // 500 J
/// ```
@inlinable
public func * (force: Force, distance: Length) -> Energy {
    // force.baseValue is in N, distance.baseValue is in m
    // N × m = J (joules)
    Energy(baseValue: force.baseValue * distance.baseValue)
}

/// 距離 × 力 = 仕事（可換）
@inlinable
public func * (distance: Length, force: Force) -> Energy {
    force * distance
}

// MARK: - Power = Energy / Time

/// エネルギー / 時間 = 仕事率
///
/// P = E / t
///
/// ```swift
/// let energy = Energy(1000, unit: .joules)
/// let time = Duration(10, unit: .seconds)
/// let power: Power = energy / time  // 100 W
/// ```
@inlinable
public func / (energy: Energy, time: Duration) -> Power {
    // energy.baseValue is in J, time.baseValue is in s
    // J / s = W (watts)
    Power(baseValue: energy.baseValue / time.baseValue)
}

// MARK: - Energy = Power × Time

/// 仕事率 × 時間 = エネルギー
///
/// E = P × t
///
/// ```swift
/// let power = Power(100, unit: .watts)
/// let time = Duration(60, unit: .seconds)
/// let energy: Energy = power * time  // 6000 J
/// ```
@inlinable
public func * (power: Power, time: Duration) -> Energy {
    // power.baseValue is in W, time.baseValue is in s
    // W × s = J (joules)
    Energy(baseValue: power.baseValue * time.baseValue)
}

/// 時間 × 仕事率 = エネルギー（可換）
@inlinable
public func * (time: Duration, power: Power) -> Energy {
    power * time
}

// MARK: - Power = Force × Speed

/// 力 × 速度 = 仕事率
///
/// P = F × v
///
/// ```swift
/// let force = Force(500, unit: .newtons)
/// let speed = Speed(10, unit: .metersPerSecond)
/// let power: Power = force * speed  // 5000 W
/// ```
@inlinable
public func * (force: Force, speed: Speed) -> Power {
    // force.baseValue is in N, speed.baseValue is in m/s
    // N × m/s = W (watts)
    Power(baseValue: force.baseValue * speed.baseValue)
}

/// 速度 × 力 = 仕事率（可換）
@inlinable
public func * (speed: Speed, force: Force) -> Power {
    force * speed
}

// MARK: - Pressure = Force / Area

/// 力 / 面積 = 圧力
///
/// p = F / A
///
/// ```swift
/// let force = Force(1000, unit: .newtons)
/// let area = Area(2, unit: .squareMeters)
/// let pressure: Pressure = force / area  // 500 Pa
/// ```
@inlinable
public func / (force: Force, area: Area) -> Pressure {
    // force.baseValue is in N, area.baseValue is in m²
    // N / m² = Pa (pascals)
    Pressure(baseValue: force.baseValue / area.baseValue)
}

// MARK: - Force = Pressure × Area

/// 圧力 × 面積 = 力
///
/// F = p × A
///
/// ```swift
/// let pressure = Pressure(1, unit: .atmospheres)
/// let area = Area(1, unit: .squareMeters)
/// let force: Force = pressure * area  // 101325 N
/// ```
@inlinable
public func * (pressure: Pressure, area: Area) -> Force {
    // pressure.baseValue is in Pa, area.baseValue is in m²
    // Pa × m² = N (newtons)
    Force(baseValue: pressure.baseValue * area.baseValue)
}

/// 面積 × 圧力 = 力（可換）
@inlinable
public func * (area: Area, pressure: Pressure) -> Force {
    pressure * area
}

// MARK: - Distance = Force / Pressure (derived)
// Not commonly needed, but included for completeness

// MARK: - Time = Energy / Power

/// エネルギー / 仕事率 = 時間
///
/// t = E / P
///
/// ```swift
/// let energy = Energy(3600, unit: .kilojoules)
/// let power = Power(1, unit: .kilowatts)
/// let time: Duration = energy / power  // 3600 s = 1 hour
/// ```
@inlinable
public func / (energy: Energy, power: Power) -> Duration {
    // energy.baseValue is in J, power.baseValue is in W
    // J / W = s (seconds)
    Duration(baseValue: energy.baseValue / power.baseValue)
}

// MARK: - Force = Power / Speed

/// 仕事率 / 速度 = 力
///
/// F = P / v
///
/// ```swift
/// let power = Power(5000, unit: .watts)
/// let speed = Speed(10, unit: .metersPerSecond)
/// let force: Force = power / speed  // 500 N
/// ```
@inlinable
public func / (power: Power, speed: Speed) -> Force {
    // power.baseValue is in W, speed.baseValue is in m/s
    // W / (m/s) = N (newtons)
    Force(baseValue: power.baseValue / speed.baseValue)
}

// MARK: - Speed = Power / Force

/// 仕事率 / 力 = 速度
///
/// v = P / F
///
/// ```swift
/// let power = Power(5000, unit: .watts)
/// let force = Force(500, unit: .newtons)
/// let speed: Speed = power / force  // 10 m/s
/// ```
@inlinable
public func / (power: Power, force: Force) -> Speed {
    // power.baseValue is in W, force.baseValue is in N
    // W / N = m/s
    Speed(baseValue: power.baseValue / force.baseValue)
}

// MARK: - Distance = Energy / Force

/// エネルギー / 力 = 距離
///
/// d = W / F
///
/// ```swift
/// let energy = Energy(500, unit: .joules)
/// let force = Force(100, unit: .newtons)
/// let distance: Length = energy / force  // 5 m
/// ```
@inlinable
public func / (energy: Energy, force: Force) -> Length {
    // energy.baseValue is in J, force.baseValue is in N
    // J / N = m (meters)
    Length(baseValue: energy.baseValue / force.baseValue)
}

// MARK: - Force = Energy / Distance

/// エネルギー / 距離 = 力
///
/// F = W / d
///
/// ```swift
/// let energy = Energy(500, unit: .joules)
/// let distance = Length(5, unit: .meters)
/// let force: Force = energy / distance  // 100 N
/// ```
@inlinable
public func / (energy: Energy, distance: Length) -> Force {
    // energy.baseValue is in J, distance.baseValue is in m
    // J / m = N (newtons)
    Force(baseValue: energy.baseValue / distance.baseValue)
}

// MARK: - Area = Force / Pressure

/// 力 / 圧力 = 面積
///
/// A = F / p
///
/// ```swift
/// let force = Force(101325, unit: .newtons)
/// let pressure = Pressure(1, unit: .atmospheres)
/// let area: Area = force / pressure  // 1 m²
/// ```
@inlinable
public func / (force: Force, pressure: Pressure) -> Area {
    // force.baseValue is in N, pressure.baseValue is in Pa
    // N / Pa = m² (square meters)
    Area(baseValue: force.baseValue / pressure.baseValue)
}

// MARK: - ============================================
// MARK: - Newton's Second Law (F = ma)
// MARK: - ============================================

// MARK: - Force = Mass × Acceleration

/// 質量 × 加速度 = 力（ニュートンの第二法則）
///
/// F = m × a
///
/// ```swift
/// let mass = Mass(10, unit: .kilograms)
/// let acceleration = Acceleration(2, unit: .metersPerSecondSquared)
/// let force: Force = mass * acceleration  // 20 N
/// ```
@inlinable
public func * (mass: Mass, acceleration: Acceleration) -> Force {
    // mass.baseValue is in grams, acceleration.baseValue is in m/s²
    // Convert grams to kg: g / 1000 = kg
    // kg × m/s² = N (newtons)
    Force(baseValue: (mass.baseValue / 1000.0) * acceleration.baseValue)
}

/// 加速度 × 質量 = 力（可換）
@inlinable
public func * (acceleration: Acceleration, mass: Mass) -> Force {
    mass * acceleration
}

// MARK: - Acceleration = Force / Mass

/// 力 / 質量 = 加速度
///
/// a = F / m
///
/// ```swift
/// let force = Force(100, unit: .newtons)
/// let mass = Mass(50, unit: .kilograms)
/// let acceleration: Acceleration = force / mass  // 2 m/s²
/// ```
@inlinable
public func / (force: Force, mass: Mass) -> Acceleration {
    // force.baseValue is in N, mass.baseValue is in grams
    // Convert grams to kg: g / 1000 = kg
    // N / kg = m/s²
    Acceleration(baseValue: force.baseValue / (mass.baseValue / 1000.0))
}

// MARK: - Mass = Force / Acceleration

/// 力 / 加速度 = 質量
///
/// m = F / a
///
/// ```swift
/// let force = Force(100, unit: .newtons)
/// let acceleration = Acceleration(2, unit: .metersPerSecondSquared)
/// let mass: Mass = force / acceleration  // 50 kg
/// ```
@inlinable
public func / (force: Force, acceleration: Acceleration) -> Mass {
    // force.baseValue is in N, acceleration.baseValue is in m/s²
    // N / (m/s²) = kg
    // Convert kg to grams for Mass.baseValue: kg * 1000 = g
    Mass(baseValue: (force.baseValue / acceleration.baseValue) * 1000.0)
}

// MARK: - ============================================
// MARK: - Acceleration Kinematics
// MARK: - ============================================

// MARK: - Acceleration = Speed / Time

/// 速度 / 時間 = 加速度（速度変化率）
///
/// a = Δv / Δt
///
/// ```swift
/// let speedChange = Speed(20, unit: .metersPerSecond)
/// let time = Duration(10, unit: .seconds)
/// let acceleration: Acceleration = speedChange / time  // 2 m/s²
/// ```
@inlinable
public func / (speed: Speed, time: Duration) -> Acceleration {
    // speed.baseValue is in m/s, time.baseValue is in s
    // (m/s) / s = m/s²
    Acceleration(baseValue: speed.baseValue / time.baseValue)
}

// MARK: - Speed = Acceleration × Time

/// 加速度 × 時間 = 速度変化
///
/// Δv = a × Δt
///
/// ```swift
/// let acceleration = Acceleration(2, unit: .metersPerSecondSquared)
/// let time = Duration(10, unit: .seconds)
/// let speedChange: Speed = acceleration * time  // 20 m/s
/// ```
@inlinable
public func * (acceleration: Acceleration, time: Duration) -> Speed {
    // acceleration.baseValue is in m/s², time.baseValue is in s
    // m/s² × s = m/s
    Speed(baseValue: acceleration.baseValue * time.baseValue)
}

/// 時間 × 加速度 = 速度変化（可換）
@inlinable
public func * (time: Duration, acceleration: Acceleration) -> Speed {
    acceleration * time
}

// MARK: - Time = Speed / Acceleration

/// 速度 / 加速度 = 時間
///
/// t = v / a
///
/// ```swift
/// let speed = Speed(20, unit: .metersPerSecond)
/// let acceleration = Acceleration(2, unit: .metersPerSecondSquared)
/// let time: Duration = speed / acceleration  // 10 s
/// ```
@inlinable
public func / (speed: Speed, acceleration: Acceleration) -> Duration {
    // speed.baseValue is in m/s, acceleration.baseValue is in m/s²
    // (m/s) / (m/s²) = s
    Duration(baseValue: speed.baseValue / acceleration.baseValue)
}
