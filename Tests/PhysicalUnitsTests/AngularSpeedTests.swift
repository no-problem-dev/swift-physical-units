import Foundation
import Testing
@testable import PhysicalUnits

@Suite("AngularSpeed Tests")
struct AngularSpeedTests {
    // MARK: - Basic Unit Conversions

    @Test("Radians per second is base unit")
    func radiansPerSecondBaseUnit() {
        let speed = AngularSpeed(10, unit: .radiansPerSecond)
        #expect(abs(speed.radiansPerSecond - 10) < 0.001)
    }

    @Test("Degrees per second to radians per second")
    func degreesPerSecondToRadPerSec() {
        let speed = AngularSpeed(180, unit: .degreesPerSecond)
        #expect(abs(speed.radiansPerSecond - .pi) < 0.001)
    }

    @Test("RPM to radians per second")
    func rpmToRadPerSec() {
        let speed = AngularSpeed(60, unit: .revolutionsPerMinute)
        // 60 rpm = 1 rps = 2π rad/s
        #expect(abs(speed.radiansPerSecond - 2 * .pi) < 0.001)
    }

    @Test("RPS to radians per second")
    func rpsToRadPerSec() {
        let speed = AngularSpeed(1, unit: .revolutionsPerSecond)
        #expect(abs(speed.radiansPerSecond - 2 * .pi) < 0.001)
    }

    // MARK: - Cross-Unit Conversions

    @Test("Radians per second to RPM")
    func radPerSecToRpm() {
        let speed = AngularSpeed(2 * .pi, unit: .radiansPerSecond)
        #expect(abs(speed.rpm - 60) < 0.001)
    }

    @Test("Radians per second to degrees per second")
    func radPerSecToDegreesPerSec() {
        let speed = AngularSpeed(.pi, unit: .radiansPerSecond)
        #expect(abs(speed.degreesPerSecond - 180) < 0.001)
    }

    @Test("RPM to RPS")
    func rpmToRps() {
        let speed = AngularSpeed(120, unit: .revolutionsPerMinute)
        #expect(abs(speed.rps - 2) < 0.001)
    }

    // MARK: - Practical Examples

    @Test("Hard drive speed (7200 RPM)")
    func hardDriveSpeed() {
        let hdd = AngularSpeed(7200, unit: .revolutionsPerMinute)
        #expect(abs(hdd.rps - 120) < 0.001)
        #expect(abs(hdd.radiansPerSecond - 754.0) < 0.1)
    }

    @Test("Car wheel at 60 km/h")
    func carWheelSpeed() {
        // 60 km/h = 16.67 m/s, wheel radius = 0.3 m
        // ω = v/r = 16.67/0.3 = 55.6 rad/s ≈ 531 rpm
        let speed = AngularSpeed(55.6, unit: .radiansPerSecond)
        #expect(abs(speed.rpm - 531) < 1)
    }

    @Test("Clock second hand")
    func clockSecondHand() {
        let secondHand = AngularSpeed.clockSecondHand
        #expect(abs(secondHand.rpm - 1) < 0.001)
        #expect(abs(secondHand.degreesPerSecond - 6) < 0.001)
    }

    @Test("Clock minute hand")
    func clockMinuteHand() {
        let minuteHand = AngularSpeed.clockMinuteHand
        #expect(abs(minuteHand.rpm - 1.0 / 60.0) < 0.0001)
    }

    @Test("Earth rotation")
    func earthRotation() {
        let earth = AngularSpeed.earthRotation
        // Should complete one rotation in ~23.934 hours (sidereal day)
        let oneRotation = Angle(2 * .pi, unit: .radians)
        let time: Duration = oneRotation / earth
        // Earth rotation period is about 23.93 hours (sidereal day)
        #expect(abs(time.hours - 23.93) < 0.1)
    }

    // MARK: - Hertz Property

    @Test("Hertz equals RPS")
    func hertzEqualsRps() {
        let speed = AngularSpeed(10, unit: .revolutionsPerSecond)
        #expect(abs(speed.hertz - 10) < 0.001)
    }

    // MARK: - Formatting

    @Test("Formatted output for RPM")
    func formattedRpm() {
        let speed = AngularSpeed(3000, unit: .revolutionsPerMinute)
        #expect(speed.formatted == "3000.0 rpm")
    }

    @Test("Formatted output for low speeds")
    func formattedLowSpeed() {
        let speed = AngularSpeed(0.5, unit: .radiansPerSecond)
        // 0.5 rad/s ≈ 4.77 rpm, so formatted shows rpm
        #expect(speed.formatted == "4.8 rpm")
    }

    // MARK: - Arithmetic Operations

    @Test("AngularSpeed addition")
    func angularSpeedAddition() {
        let s1 = AngularSpeed(100, unit: .revolutionsPerMinute)
        let s2 = AngularSpeed(50, unit: .revolutionsPerMinute)
        let sum = s1 + s2
        #expect(abs(sum.rpm - 150) < 0.001)
    }

    @Test("AngularSpeed subtraction")
    func angularSpeedSubtraction() {
        let s1 = AngularSpeed(100, unit: .revolutionsPerMinute)
        let s2 = AngularSpeed(30, unit: .revolutionsPerMinute)
        let diff = s1 - s2
        #expect(abs(diff.rpm - 70) < 0.001)
    }

    // MARK: - Round-trip Conversions

    @Test("Round-trip: rad/s -> rpm -> rad/s")
    func roundTripRadPerSecRpm() {
        let original = AngularSpeed(100, unit: .radiansPerSecond)
        let inRpm = original.rpm
        let back = AngularSpeed(inRpm, unit: .revolutionsPerMinute)
        #expect(abs(original.radiansPerSecond - back.radiansPerSecond) < 0.001)
    }
}

// MARK: - AngularSpeed Operators Tests

@Suite("AngularSpeed Operators Tests")
struct AngularSpeedOperatorsTests {
    // MARK: - ω = θ / t

    @Test("Angle divided by time equals angular speed")
    func angleDividedByTime() {
        let angle = Angle(360, unit: .degrees)
        let time = Duration(1, unit: .seconds)
        let speed: AngularSpeed = angle / time
        // 360°/s = 2π rad/s
        #expect(abs(speed.radiansPerSecond - 2 * .pi) < 0.001)
    }

    // MARK: - θ = ω × t

    @Test("Angular speed times time equals angle")
    func angularSpeedTimesTime() {
        let speed = AngularSpeed(60, unit: .revolutionsPerMinute)
        let time = Duration(1, unit: .minutes)
        let angle: Angle = speed * time
        // 60 rpm × 1 min = 60 revolutions = 120π rad
        #expect(abs(angle.radians - 120 * .pi) < 0.001)
    }

    @Test("Time times angular speed equals angle (commutative)")
    func timeTimesAngularSpeed() {
        let speed = AngularSpeed(2 * .pi, unit: .radiansPerSecond)
        let time = Duration(0.5, unit: .seconds)
        let angle: Angle = time * speed
        #expect(abs(angle.radians - .pi) < 0.001)
    }

    // MARK: - t = θ / ω

    @Test("Angle divided by angular speed equals time")
    func angleDividedByAngularSpeed() {
        let angle = Angle(2 * .pi, unit: .radians)  // 1 revolution
        let speed = AngularSpeed(60, unit: .revolutionsPerMinute)  // 1 rps
        let time: Duration = angle / speed
        #expect(abs(time.seconds - 1) < 0.001)
    }

    // MARK: - v = ω × r

    @Test("Angular speed times radius equals linear speed")
    func angularSpeedTimesRadius() {
        let speed = AngularSpeed(10, unit: .radiansPerSecond)
        let radius = Length(2, unit: .meters)
        let linearSpeed: Speed = speed * radius
        #expect(abs(linearSpeed.metersPerSecond - 20) < 0.001)
    }

    @Test("Radius times angular speed equals linear speed (commutative)")
    func radiusTimesAngularSpeed() {
        let speed = AngularSpeed(5, unit: .radiansPerSecond)
        let radius = Length(4, unit: .meters)
        let linearSpeed: Speed = radius * speed
        #expect(abs(linearSpeed.metersPerSecond - 20) < 0.001)
    }

    // MARK: - ω = v / r

    @Test("Linear speed divided by radius equals angular speed")
    func linearSpeedDividedByRadius() {
        let linearSpeed = Speed(10, unit: .metersPerSecond)
        let radius = Length(2, unit: .meters)
        let angularSpeed: AngularSpeed = linearSpeed / radius
        #expect(abs(angularSpeed.radiansPerSecond - 5) < 0.001)
    }

    // MARK: - r = v / ω

    @Test("Linear speed divided by angular speed equals radius")
    func linearSpeedDividedByAngularSpeed() {
        let linearSpeed = Speed(10, unit: .metersPerSecond)
        let angularSpeed = AngularSpeed(5, unit: .radiansPerSecond)
        let radius: Length = linearSpeed / angularSpeed
        #expect(abs(radius.meters - 2) < 0.001)
    }

    // MARK: - Frequency Conversion

    @Test("Angular speed to frequency")
    func angularSpeedToFrequency() {
        let angularSpeed = AngularSpeed(2 * .pi, unit: .radiansPerSecond)
        let frequency = angularSpeed.asFrequency
        #expect(abs(frequency.hertz - 1) < 0.001)
    }

    @Test("Frequency to angular speed")
    func frequencyToAngularSpeed() {
        let frequency = Frequency(60, unit: .hertz)
        let angularSpeed = frequency.asAngularSpeed
        #expect(abs(angularSpeed.radiansPerSecond - 120 * .pi) < 0.001)
    }

    @Test("Init angular speed from frequency")
    func initAngularSpeedFromFrequency() {
        let frequency = Frequency(1, unit: .hertz)
        let angularSpeed = AngularSpeed(from: frequency)
        #expect(abs(angularSpeed.radiansPerSecond - 2 * .pi) < 0.001)
    }

    @Test("Init frequency from angular speed")
    func initFrequencyFromAngularSpeed() {
        let angularSpeed = AngularSpeed(2 * .pi, unit: .radiansPerSecond)
        let frequency = Frequency(from: angularSpeed)
        #expect(abs(frequency.hertz - 1) < 0.001)
    }

    // MARK: - Practical Examples

    @Test("Car wheel speed calculation")
    func carWheelSpeedCalculation() {
        // Car at 100 km/h, wheel radius 0.3 m
        let carSpeed = Speed(100, unit: .kilometersPerHour)
        let wheelRadius = Length(0.3, unit: .meters)
        let wheelAngularSpeed: AngularSpeed = carSpeed / wheelRadius
        // Should be about 926 rad/s = 8842 rpm
        #expect(abs(wheelAngularSpeed.rpm - 884) < 1)
    }

    @Test("Fan blade tip speed")
    func fanBladeTipSpeed() {
        // Fan at 1200 RPM, blade radius 0.5 m
        let fanSpeed = AngularSpeed(1200, unit: .revolutionsPerMinute)
        let bladeRadius = Length(0.5, unit: .meters)
        let tipSpeed: Speed = fanSpeed * bladeRadius
        // 1200 rpm = 20 rps = 40π rad/s
        // v = 40π × 0.5 = 20π ≈ 62.83 m/s
        #expect(abs(tipSpeed.metersPerSecond - 62.83) < 0.1)
    }

    // MARK: - Round-trip Conversions

    @Test("Round-trip: angle -> angular speed -> angle")
    func roundTripAngleAngularSpeed() {
        let originalAngle = Angle(720, unit: .degrees)
        let time = Duration(2, unit: .seconds)
        let speed: AngularSpeed = originalAngle / time
        let calculatedAngle: Angle = speed * time
        #expect(abs(originalAngle.degrees - calculatedAngle.degrees) < 0.001)
    }

    @Test("Round-trip: frequency -> angular speed -> frequency")
    func roundTripFrequencyAngularSpeed() {
        let originalFrequency = Frequency(50, unit: .hertz)
        let angularSpeed = originalFrequency.asAngularSpeed
        let calculatedFrequency = angularSpeed.asFrequency
        #expect(abs(originalFrequency.hertz - calculatedFrequency.hertz) < 0.001)
    }
}
