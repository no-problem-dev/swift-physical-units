import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Volume Tests")
struct VolumeTests {
    // MARK: - Basic Conversions

    @Test("Liters to milliliters conversion")
    func litersToMilliliters() {
        let volume = Volume(1, unit: .liters)
        #expect(abs(volume.milliliters - 1000) < 0.001)
    }

    @Test("Milliliters to liters conversion")
    func millilitersToLiters() {
        let volume = Volume(500, unit: .milliliters)
        #expect(abs(volume.liters - 0.5) < 0.001)
    }

    @Test("Liters to kiloliters conversion")
    func litersToKiloliters() {
        let volume = Volume(1000, unit: .liters)
        #expect(abs(volume.kiloliters - 1) < 0.001)
    }

    @Test("Deciliters to liters conversion")
    func decilitersToLiters() {
        let volume = Volume(10, unit: .deciliters)
        #expect(abs(volume.liters - 1) < 0.001)
    }

    @Test("Centiliters to milliliters conversion")
    func centilitersToMilliliters() {
        let volume = Volume(1, unit: .centiliters)
        #expect(abs(volume.milliliters - 10) < 0.001)
    }

    @Test("Cubic meters equals kiloliters")
    func cubicMetersEqualsKiloliters() {
        let volume = Volume(1, unit: .kiloliters)
        #expect(abs(volume.cubicMeters - 1) < 0.001)
    }

    // MARK: - Formatting

    @Test("Volume formatting liters")
    func volumeFormattingLiters() {
        let volume = Volume(5, unit: .liters)
        #expect(volume.formatted.contains("L"))
    }

    @Test("Volume formatting milliliters")
    func volumeFormattingMilliliters() {
        let volume = Volume(500, unit: .milliliters)
        #expect(volume.formatted.contains("mL"))
    }

    // MARK: - Arithmetic

    @Test("Volume addition")
    func volumeAddition() {
        let v1 = Volume(1, unit: .liters)
        let v2 = Volume(500, unit: .milliliters)
        let sum = v1 + v2
        #expect(abs(sum.liters - 1.5) < 0.001)
    }

    @Test("Volume subtraction")
    func volumeSubtraction() {
        let v1 = Volume(2, unit: .liters)
        let v2 = Volume(500, unit: .milliliters)
        let diff = v1 - v2
        #expect(abs(diff.liters - 1.5) < 0.001)
    }

    // MARK: - Codable

    @Test("Volume is Codable")
    func volumeCodable() throws {
        let original = Volume(2.5, unit: .liters)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Volume.self, from: encoded)
        #expect(abs(original.liters - decoded.liters) < 0.001)
    }
}
