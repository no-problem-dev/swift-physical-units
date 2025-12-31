import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Acceleration Tests")
struct AccelerationTests {
    // MARK: - Basic Unit Conversions

    @Test("Meters per second squared is base unit")
    func metersPerSecondSquared() {
        let acceleration = Acceleration(9.8, unit: .metersPerSecondSquared)
        #expect(abs(acceleration.metersPerSecondSquared - 9.8) < 0.001)
    }

    @Test("Standard gravity conversion")
    func standardGravityConversion() {
        let acceleration = Acceleration(1, unit: .standardGravity)
        #expect(abs(acceleration.metersPerSecondSquared - 9.80665) < 0.00001)
    }

    @Test("Meters per second squared to standard gravity")
    func metersPerSecondSquaredToG() {
        let acceleration = Acceleration(19.6133, unit: .metersPerSecondSquared)
        #expect(abs(acceleration.standardGravity - 2) < 0.001)
    }

    @Test("Gal conversion (1 Gal = 0.01 m/s²)")
    func galConversion() {
        let acceleration = Acceleration(1, unit: .gal)
        #expect(abs(acceleration.metersPerSecondSquared - 0.01) < 0.00001)
    }

    @Test("Milligal conversion (1 mGal = 0.00001 m/s²)")
    func milligalConversion() {
        let acceleration = Acceleration(1000, unit: .milligal)
        #expect(abs(acceleration.metersPerSecondSquared - 0.01) < 0.00001)
    }

    // MARK: - Cross-Unit Conversions

    @Test("Standard gravity to Gal")
    func standardGravityToGal() {
        let acceleration = Acceleration(1, unit: .standardGravity)
        // 9.80665 m/s² = 980.665 Gal
        #expect(abs(acceleration.gal - 980.665) < 0.001)
    }

    @Test("Standard gravity to milliGal")
    func standardGravityToMilligal() {
        let acceleration = Acceleration(1, unit: .standardGravity)
        // 9.80665 m/s² = 980665 mGal
        #expect(abs(acceleration.milligal - 980665) < 1)
    }

    // MARK: - Practical Examples

    @Test("Earth surface gravity")
    func earthSurfaceGravity() {
        let earthGravity = Acceleration(1, unit: .standardGravity)
        #expect(abs(earthGravity.metersPerSecondSquared - 9.80665) < 0.00001)
    }

    @Test("Moon surface gravity (approx 1.62 m/s²)")
    func moonSurfaceGravity() {
        let moonGravity = Acceleration(1.62, unit: .metersPerSecondSquared)
        #expect(abs(moonGravity.standardGravity - 0.1652) < 0.001)
    }

    @Test("Mars surface gravity (approx 3.72 m/s²)")
    func marsSurfaceGravity() {
        let marsGravity = Acceleration(3.72, unit: .metersPerSecondSquared)
        #expect(abs(marsGravity.standardGravity - 0.379) < 0.001)
    }

    @Test("Car acceleration (0-100 km/h in 8 seconds)")
    func carAcceleration() {
        // 100 km/h = 27.78 m/s
        // a = v/t = 27.78 / 8 = 3.47 m/s²
        let acceleration = Acceleration(3.47, unit: .metersPerSecondSquared)
        #expect(abs(acceleration.standardGravity - 0.354) < 0.01)
    }

    // MARK: - Arithmetic Operations

    @Test("Acceleration addition")
    func accelerationAddition() {
        let a1 = Acceleration(5, unit: .metersPerSecondSquared)
        let a2 = Acceleration(3, unit: .metersPerSecondSquared)
        let sum = a1 + a2
        #expect(abs(sum.metersPerSecondSquared - 8) < 0.001)
    }

    @Test("Acceleration subtraction")
    func accelerationSubtraction() {
        let a1 = Acceleration(10, unit: .metersPerSecondSquared)
        let a2 = Acceleration(4, unit: .metersPerSecondSquared)
        let diff = a1 - a2
        #expect(abs(diff.metersPerSecondSquared - 6) < 0.001)
    }

    @Test("Acceleration scaling")
    func accelerationScaling() {
        let acceleration = Acceleration(5, unit: .metersPerSecondSquared)
        let doubled = acceleration * 2
        #expect(abs(doubled.metersPerSecondSquared - 10) < 0.001)
    }

    // MARK: - Round-trip Conversions

    @Test("Round-trip: m/s² -> g -> m/s²")
    func roundTripMetersToG() {
        let original = Acceleration(19.6133, unit: .metersPerSecondSquared)
        let inG = original.standardGravity
        let backToMps2 = Acceleration(inG, unit: .standardGravity)
        #expect(abs(original.metersPerSecondSquared - backToMps2.metersPerSecondSquared) < 0.001)
    }

    @Test("Round-trip: Gal -> mGal -> Gal")
    func roundTripGalToMilligal() {
        let original = Acceleration(500, unit: .gal)
        let inMGal = original.milligal
        let backToGal = Acceleration(inMGal, unit: .milligal)
        #expect(abs(original.gal - backToGal.gal) < 0.001)
    }
}
