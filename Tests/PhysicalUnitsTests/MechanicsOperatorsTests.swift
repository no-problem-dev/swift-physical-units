import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Mechanics Operators Tests")
struct MechanicsOperatorsTests {
    // MARK: - Newton's Second Law (F = ma)

    @Test("Mass times acceleration equals force")
    func massTimesAcceleration() {
        let mass = Mass(10, unit: .kilograms)
        let acceleration = Acceleration(2, unit: .metersPerSecondSquared)
        let force: Force = mass * acceleration
        #expect(abs(force.newtons - 20) < 0.001)
    }

    @Test("Acceleration times mass equals force (commutative)")
    func accelerationTimesMass() {
        let mass = Mass(5, unit: .kilograms)
        let acceleration = Acceleration(1, unit: .standardGravity)
        let force: Force = acceleration * mass
        #expect(abs(force.newtons - 49.03325) < 0.001)
    }

    @Test("Force divided by mass equals acceleration")
    func forceDividedByMass() {
        let force = Force(100, unit: .newtons)
        let mass = Mass(50, unit: .kilograms)
        let acceleration: Acceleration = force / mass
        #expect(abs(acceleration.metersPerSecondSquared - 2) < 0.001)
    }

    @Test("Force divided by acceleration equals mass")
    func forceDividedByAcceleration() {
        let force = Force(100, unit: .newtons)
        let acceleration = Acceleration(2, unit: .metersPerSecondSquared)
        let mass: Mass = force / acceleration
        #expect(abs(mass.kilograms - 50) < 0.001)
    }

    // MARK: - Acceleration Kinematics (a = Δv / Δt)

    @Test("Speed divided by time equals acceleration")
    func speedDividedByTime() {
        let speed = Speed(20, unit: .metersPerSecond)
        let time = Duration(10, unit: .seconds)
        let acceleration: Acceleration = speed / time
        #expect(abs(acceleration.metersPerSecondSquared - 2) < 0.001)
    }

    @Test("Acceleration times time equals speed")
    func accelerationTimesTime() {
        let acceleration = Acceleration(2, unit: .metersPerSecondSquared)
        let time = Duration(10, unit: .seconds)
        let speed: Speed = acceleration * time
        #expect(abs(speed.metersPerSecond - 20) < 0.001)
    }

    @Test("Speed divided by acceleration equals time")
    func speedDividedByAcceleration() {
        let speed = Speed(20, unit: .metersPerSecond)
        let acceleration = Acceleration(2, unit: .metersPerSecondSquared)
        let time: Duration = speed / acceleration
        #expect(abs(time.seconds - 10) < 0.001)
    }

    // MARK: - Work/Energy (W = F × d)

    @Test("Force times distance equals energy")
    func forceTimesDistance() {
        let force = Force(100, unit: .newtons)
        let distance = Length(5, unit: .meters)
        let energy: Energy = force * distance
        #expect(abs(energy.joules - 500) < 0.001)
    }

    @Test("Distance times force equals energy (commutative)")
    func distanceTimesForce() {
        let force = Force(50, unit: .newtons)
        let distance = Length(10, unit: .meters)
        let energy: Energy = distance * force
        #expect(abs(energy.joules - 500) < 0.001)
    }

    @Test("Energy divided by force equals distance")
    func energyDividedByForce() {
        let energy = Energy(500, unit: .joules)
        let force = Force(100, unit: .newtons)
        let distance: Length = energy / force
        #expect(abs(distance.meters - 5) < 0.001)
    }

    @Test("Energy divided by distance equals force")
    func energyDividedByDistance() {
        let energy = Energy(500, unit: .joules)
        let distance = Length(5, unit: .meters)
        let force: Force = energy / distance
        #expect(abs(force.newtons - 100) < 0.001)
    }

    // MARK: - Power (P = E / t)

    @Test("Energy divided by time equals power")
    func energyDividedByTime() {
        let energy = Energy(1000, unit: .joules)
        let time = Duration(10, unit: .seconds)
        let power: Power = energy / time
        #expect(abs(power.watts - 100) < 0.001)
    }

    @Test("Power times time equals energy")
    func powerTimesTime() {
        let power = Power(100, unit: .watts)
        let time = Duration(60, unit: .seconds)
        let energy: Energy = power * time
        #expect(abs(energy.joules - 6000) < 0.001)
    }

    @Test("Energy divided by power equals time")
    func energyDividedByPower() {
        let energy = Energy(3600, unit: .kilojoules)
        let power = Power(1, unit: .kilowatts)
        let time: Duration = energy / power
        #expect(abs(time.seconds - 3600) < 0.001)
    }

    // MARK: - Power from Force and Speed (P = F × v)

    @Test("Force times speed equals power")
    func forceTimesSpeed() {
        let force = Force(500, unit: .newtons)
        let speed = Speed(10, unit: .metersPerSecond)
        let power: Power = force * speed
        #expect(abs(power.watts - 5000) < 0.001)
    }

    @Test("Speed times force equals power (commutative)")
    func speedTimesForce() {
        let force = Force(250, unit: .newtons)
        let speed = Speed(20, unit: .metersPerSecond)
        let power: Power = speed * force
        #expect(abs(power.watts - 5000) < 0.001)
    }

    @Test("Power divided by speed equals force")
    func powerDividedBySpeed() {
        let power = Power(5000, unit: .watts)
        let speed = Speed(10, unit: .metersPerSecond)
        let force: Force = power / speed
        #expect(abs(force.newtons - 500) < 0.001)
    }

    @Test("Power divided by force equals speed")
    func powerDividedByForce() {
        let power = Power(5000, unit: .watts)
        let force = Force(500, unit: .newtons)
        let speed: Speed = power / force
        #expect(abs(speed.metersPerSecond - 10) < 0.001)
    }

    // MARK: - Pressure (p = F / A)

    @Test("Force divided by area equals pressure")
    func forceDividedByArea() {
        let force = Force(1000, unit: .newtons)
        let area = Area(2, unit: .squareMeters)
        let pressure: Pressure = force / area
        #expect(abs(pressure.pascals - 500) < 0.001)
    }

    @Test("Pressure times area equals force")
    func pressureTimesArea() {
        let pressure = Pressure(1, unit: .atmospheres)
        let area = Area(1, unit: .squareMeters)
        let force: Force = pressure * area
        #expect(abs(force.newtons - 101325) < 0.001)
    }

    @Test("Area times pressure equals force (commutative)")
    func areaTimesPressure() {
        let pressure = Pressure(500, unit: .pascals)
        let area = Area(2, unit: .squareMeters)
        let force: Force = area * pressure
        #expect(abs(force.newtons - 1000) < 0.001)
    }

    @Test("Force divided by pressure equals area")
    func forceDividedByPressure() {
        let force = Force(101325, unit: .newtons)
        let pressure = Pressure(1, unit: .atmospheres)
        let area: Area = force / pressure
        #expect(abs(area.squareMeters - 1) < 0.001)
    }

    // MARK: - Round-trip conversions

    @Test("Round-trip: mass -> force -> mass")
    func roundTripMass() {
        let originalMass = Mass(75, unit: .kilograms)
        let acceleration = Acceleration(1, unit: .standardGravity)
        let force: Force = originalMass * acceleration
        let calculatedMass: Mass = force / acceleration
        #expect(abs(originalMass.kilograms - calculatedMass.kilograms) < 0.001)
    }

    @Test("Round-trip: energy -> power -> energy")
    func roundTripEnergy() {
        let originalEnergy = Energy(3600, unit: .kilojoules)  // 3600 kJ = 1 kWh
        let time = Duration(1, unit: .hours)
        let power: Power = originalEnergy / time
        let calculatedEnergy: Energy = power * time
        #expect(abs(originalEnergy.joules - calculatedEnergy.joules) < 0.001)
    }
}
