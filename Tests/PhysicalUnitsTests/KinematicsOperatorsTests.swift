import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Kinematics Operators Tests")
struct KinematicsOperatorsTests {
    // MARK: - Distance = Speed × Time

    @Test("Speed times time equals distance")
    func speedTimesTime() {
        let speed = Speed(60, unit: .kilometersPerHour)
        let time = Duration(2, unit: .hours)
        let distance: Length = speed * time
        #expect(abs(distance.kilometers - 120) < 0.001)
    }

    @Test("Time times speed equals distance (commutative)")
    func timeTimesSpeed() {
        let speed = Speed(10, unit: .metersPerSecond)
        let time = Duration(5, unit: .seconds)
        let distance: Length = time * speed
        #expect(abs(distance.meters - 50) < 0.001)
    }

    // MARK: - Speed = Distance / Time

    @Test("Distance divided by time equals speed")
    func distanceDividedByTime() {
        let distance = Length(100, unit: .kilometers)
        let time = Duration(2, unit: .hours)
        let speed: Speed = distance / time
        #expect(abs(speed.kilometersPerHour - 50) < 0.001)
    }

    // MARK: - Time = Distance / Speed

    @Test("Distance divided by speed equals time")
    func distanceDividedBySpeed() {
        let distance = Length(100, unit: .kilometers)
        let speed = Speed(50, unit: .kilometersPerHour)
        let time: Duration = distance / speed
        #expect(abs(time.hours - 2) < 0.001)
    }

    // MARK: - Round-trip conversions

    @Test("Round-trip: distance -> speed -> distance")
    func roundTripDistance() {
        let originalDistance = Length(marathon: 42.195)
        let time = Duration(2, unit: .hours)
        let speed: Speed = originalDistance / time
        let calculatedDistance: Length = speed * time
        #expect(abs(originalDistance.meters - calculatedDistance.meters) < 0.001)
    }
}

// Helper for marathon distance
extension Length {
    init(marathon km: Double) {
        self = Length(km, unit: .kilometers)
    }
}
