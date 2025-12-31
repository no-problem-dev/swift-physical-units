import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Speed Tests")
struct SpeedTests {
    // MARK: - Basic Conversions

    @Test("km/h to m/s conversion")
    func kmhToMs() {
        let speed = Speed(36, unit: .kilometersPerHour)
        #expect(abs(speed.metersPerSecond - 10) < 0.001)
    }

    @Test("m/s to km/h conversion")
    func msToKmh() {
        let speed = Speed(10, unit: .metersPerSecond)
        #expect(abs(speed.kilometersPerHour - 36) < 0.001)
    }

    @Test("mph to m/s conversion")
    func mphToMs() {
        let speed = Speed(60, unit: .milesPerHour)
        #expect(abs(speed.metersPerSecond - 26.8224) < 0.001)
    }

    @Test("knots to km/h conversion")
    func knotsToKmh() {
        let speed = Speed(1, unit: .knots)
        #expect(abs(speed.kilometersPerHour - 1.852) < 0.001)
    }

    // MARK: - Special Values

    @Test("Speed of light")
    func speedOfLight() {
        #expect(abs(Speed.speedOfLight.metersPerSecond - 299_792_458) < 1)
    }

    @Test("Speed of sound")
    func speedOfSound() {
        #expect(abs(Speed.speedOfSound.metersPerSecond - 343) < 0.1)
    }

    @Test("Mach 1 equals speed of sound")
    func mach1() {
        #expect(Speed.mach1.metersPerSecond == Speed.speedOfSound.metersPerSecond)
    }

    // MARK: - Unit Symbols

    @Test("Speed unit symbols")
    func unitSymbols() {
        #expect(SpeedUnit.metersPerSecond.symbol == "m/s")
        #expect(SpeedUnit.kilometersPerHour.symbol == "km/h")
        #expect(SpeedUnit.milesPerHour.symbol == "mph")
        #expect(SpeedUnit.knots.symbol == "kn")
    }

    // MARK: - Arithmetic

    @Test("Speed addition")
    func speedAddition() {
        let s1 = Speed(10, unit: .metersPerSecond)
        let s2 = Speed(36, unit: .kilometersPerHour)
        let sum = s1 + s2
        #expect(abs(sum.metersPerSecond - 20) < 0.001)
    }

    // MARK: - Codable

    @Test("Speed is Codable")
    func speedCodable() throws {
        let original = Speed(100, unit: .kilometersPerHour)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Speed.self, from: encoded)
        #expect(abs(original.metersPerSecond - decoded.metersPerSecond) < 0.001)
    }
}
