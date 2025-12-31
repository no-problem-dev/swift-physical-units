import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Length Tests")
struct LengthTests {

    // MARK: - Initialization Tests

    @Test("Initialize with meters")
    func initWithMeters() {
        let length = Length(1.75, unit: .meters)
        #expect(length.meters == 1.75)
        #expect(length.centimeters == 175)
    }

    @Test("Initialize with centimeters")
    func initWithCentimeters() {
        let length = Length(175, unit: .centimeters)
        #expect(length.centimeters == 175)
        #expect(length.meters == 1.75)
    }

    @Test("Initialize with kilometers")
    func initWithKilometers() {
        let length = Length(5, unit: .kilometers)
        #expect(length.kilometers == 5)
        #expect(length.meters == 5000)
    }

    // MARK: - Conversion Tests

    @Test("Convert between units")
    func conversion() {
        let length = Length(1, unit: .meters)
        #expect(length.centimeters == 100)
        #expect(length.millimeters == 1000)
        #expect(length.kilometers == 0.001)
    }

    @Test("Small unit conversion")
    func smallUnitConversion() {
        let length = Length(1, unit: .millimeters)
        // Use approximate comparison for floating point
        #expect(abs(length.micrometers - 1000) < 0.001)
        #expect(abs(length.nanometers - 1_000_000) < 0.001)
    }

    // MARK: - Arithmetic Tests

    @Test("Addition")
    func addition() {
        let length1 = Length(1, unit: .meters)
        let length2 = Length(50, unit: .centimeters)
        let result = length1 + length2
        #expect(result.meters == 1.5)
    }

    @Test("Subtraction")
    func subtraction() {
        let length1 = Length(2, unit: .meters)
        let length2 = Length(50, unit: .centimeters)
        let result = length1 - length2
        #expect(result.meters == 1.5)
    }

    // MARK: - Comparison Tests

    @Test("Comparison")
    func comparison() {
        let length1 = Length(1, unit: .meters)
        let length2 = Length(100, unit: .centimeters)
        let length3 = Length(50, unit: .centimeters)

        #expect(length1 == length2)
        #expect(length1 > length3)
        #expect(length3 < length1)
    }

    // MARK: - Zero Tests

    @Test("Zero length")
    func zeroLength() {
        let zero = Length.zero
        #expect(zero.meters == 0)
        #expect(zero.centimeters == 0)
    }

    // MARK: - Unit Symbol Tests

    @Test("LengthUnit symbols")
    func unitSymbols() {
        #expect(LengthUnit.meters.symbol == "m")
        #expect(LengthUnit.centimeters.symbol == "cm")
        #expect(LengthUnit.millimeters.symbol == "mm")
        #expect(LengthUnit.kilometers.symbol == "km")
        #expect(LengthUnit.micrometers.symbol == "μm")
        #expect(LengthUnit.nanometers.symbol == "nm")
    }

    // MARK: - Codable Tests

    @Test("Length is Codable")
    func codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let original = Length(175, unit: .centimeters)
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(Length.self, from: data)

        #expect(decoded == original)
    }

    // MARK: - Formatted Output Tests

    @Test("Formatted output")
    func formattedOutput() {
        let height = Length(175, unit: .centimeters)
        let formatted = height.formatted

        #expect(formatted.contains("m") || formatted.contains("cm"))
    }
}
