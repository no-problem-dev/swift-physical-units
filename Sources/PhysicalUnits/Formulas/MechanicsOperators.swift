import Foundation

// MARK: - Mechanics Operators
// The basic formulas of mechanics, expressed as operators.
//
// work     = force × distance  (W = F × d)
// power    = work / time       (P = W / t)
// power    = force × speed     (P = F × v)
// pressure = force / area      (p = F / A)
// force    = pressure × area   (F = p × A)
//
// Each dimension stores its value in a single base unit — m, s, g, N, Pa, J, W, m², m/s,
// m/s² — so these operators multiply and divide base values straight through, with no unit
// bookkeeping at run time. Mass is the odd one out: its base unit is the gram while the
// newton is kg-based, so the F = ma operators below scale by 1000. That factor is exact by
// definition (the SI kilo prefix is exactly 10³), so nothing is lost to rounding.
//
// Where compile-time dimension checking stops: the operators written here and in the sibling
// Formulas files are the whole of the cross-dimension arithmetic. There is no general
// dimensional algebra behind them, so a pairing nobody wrote out — Length × Length,
// Mass × Speed — is a compile error rather than a wrong number. The gaps are the escapes
// into Double: scalar multiply and divide (Measurement × Double) and the ratio of two
// measurements of the same dimension (Measurement / Measurement -> Double) both discard
// dimension tracking, and past that point the compiler can no longer say what the number is.

// MARK: - Work/Energy = Force × Distance

/// Mechanical work done by a force acting over a distance, W = F × d.
///
/// Both operands are already in SI base units (N × m), so the product is joules with no
/// conversion factor applied. This assumes the force is constant and acts along the
/// displacement; there is no vector component here to take an angle into account.
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

/// Commutative form of force × distance, so operand order never matters.
@inlinable
public func * (distance: Length, force: Force) -> Energy {
    force * distance
}

// MARK: - Power = Energy / Time

/// Average power: energy delivered divided by the time it took, P = E / t.
///
/// The division runs in base units (J / s), which is the definition of the watt, so no
/// conversion factor is applied. The result is the mean over the interval, not the power at
/// any instant within it.
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

/// Energy delivered by a constant power over a span of time, E = P × t.
///
/// The product runs in base units (W × s = J), so the result is joules even when the operands
/// were written as kilowatts and hours.
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

/// Commutative form of power × time, so operand order never matters.
@inlinable
public func * (time: Duration, power: Power) -> Energy {
    power * time
}

// MARK: - Power = Force × Speed

/// Instantaneous power of a force pushing something along at a given speed, P = F × v.
///
/// The product runs in base units (N × m/s = W), so no conversion factor is applied. As with
/// W = F × d, force and velocity are taken to be parallel.
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

/// Commutative form of force × speed, so operand order never matters.
@inlinable
public func * (speed: Speed, force: Force) -> Power {
    force * speed
}

// MARK: - Pressure = Force / Area

/// Pressure produced by a force spread evenly over an area, p = F / A.
///
/// The division runs in base units (N / m²), which is the definition of the pascal, so no
/// conversion factor is applied. It assumes the force is distributed uniformly and acts
/// perpendicular to the surface.
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

/// Force a pressure exerts on a surface of the given area, F = p × A.
///
/// The product runs in base units (Pa × m² = N), so no conversion factor is applied. The
/// 101325 N in the example below is exact, because one standard atmosphere is defined as
/// exactly 101325 Pa.
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

/// Commutative form of pressure × area, so operand order never matters.
@inlinable
public func * (area: Area, pressure: Pressure) -> Force {
    pressure * area
}

// MARK: - Time = Energy / Power

/// How long a constant power takes to deliver a given amount of energy, t = E / P.
///
/// The division runs in base units (J / W = s), so the result is seconds however the operands
/// were written — kilojoules over kilowatts still comes back in seconds.
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

/// Driving force behind a power output at a given speed, F = P / v.
///
/// The division runs in base units (W / (m/s) = N), so no conversion factor is applied. This
/// is the inverse of P = F × v, so it is the tractive force at that speed, not a peak force.
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

/// Speed a given power can sustain against a constant force, v = P / F.
///
/// The division runs in base units (W / N = m/s), so no conversion factor is applied. Read it
/// as the steady speed where drive power and resisting force balance.
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

/// Distance a constant force must act over to do a given amount of work, d = W / F.
///
/// The division runs in base units (J / N = m), so the result is meters. It is the inverse of
/// W = F × d and carries the same assumption that the force is constant along the path.
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

/// Constant force that does a given amount of work over a distance, F = W / d.
///
/// The division runs in base units (J / m = N), so the result is newtons. Where the real
/// force varies along the path, this gives its average.
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

/// Area a force must be spread over to produce a given pressure, A = F / p.
///
/// The division runs in base units (N / Pa = m²), so the result is square meters. The 1 m² in
/// the example is exact, since one standard atmosphere is defined as exactly 101325 Pa.
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

/// Newton's second law: the force that accelerates a mass, F = m × a.
///
/// Mass is stored in grams while the newton is kg-based, so this is the one operator group
/// that rescales an operand: the mass is divided by 1000 before the multiplication. That
/// factor is exact by definition, since the SI kilo prefix is exactly 10³.
///
/// To get weight under gravity, pass `Acceleration.gravity`, whose constant is the standard
/// gravity g₀ = 9.80665 m/s² — also exact, being a defined value rather than a measurement.
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

/// Commutative form of mass × acceleration, so operand order never matters.
@inlinable
public func * (acceleration: Acceleration, mass: Mass) -> Force {
    mass * acceleration
}

// MARK: - Acceleration = Force / Mass

/// Acceleration a force imparts to a mass, a = F / m, the rearranged second law.
///
/// The mass is converted from its gram base value to kilograms first (an exact factor of
/// 1000), because the newton is kg-based; the division N / kg then yields m/s² directly.
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

/// Mass that a force accelerates at the given rate, m = F / a, the rearranged second law.
///
/// N / (m/s²) gives kilograms, so the result is multiplied by 1000 on the way back into the
/// gram base unit that `Mass` stores. The factor is exact, so the round trip through
/// F = m × a returns the value it started from.
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

/// Average acceleration: a change in speed divided by the time it took, a = Δv / Δt.
///
/// The division runs in base units ((m/s) / s = m/s²), so no conversion factor is applied.
/// The left operand is a speed *difference*, not an absolute speed — subtract the two speeds
/// first unless the motion started from rest.
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

/// Change in speed produced by a constant acceleration over a span of time, Δv = a × Δt.
///
/// The product runs in base units (m/s² × s = m/s). The result is the *increment* in speed;
/// add it to the starting speed unless the motion began at rest.
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

/// Commutative form of acceleration × time, so operand order never matters.
@inlinable
public func * (time: Duration, acceleration: Acceleration) -> Speed {
    acceleration * time
}

// MARK: - Time = Speed / Acceleration

/// Time a constant acceleration needs to produce a given change in speed, t = Δv / a.
///
/// The division runs in base units ((m/s) / (m/s²) = s), so the result is seconds. As above,
/// the numerator is a speed difference; a zero acceleration yields infinity rather than a
/// trap, since this is plain `Double` division.
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
