import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Area Tests")
struct AreaTests {
    // MARK: - Basic Conversions

    @Test("Square meters to square centimeters")
    func squareMetersToSquareCm() {
        let area = Area(1, unit: .squareMeters)
        #expect(abs(area.squareCentimeters - 10000) < 0.001)
    }

    @Test("Square kilometers to square meters")
    func squareKmToSquareMeters() {
        let area = Area(1, unit: .squareKilometers)
        #expect(abs(area.squareMeters - 1_000_000) < 0.001)
    }

    @Test("Hectares to square meters")
    func hectaresToSquareMeters() {
        let area = Area(1, unit: .hectares)
        #expect(abs(area.squareMeters - 10_000) < 0.001)
    }

    @Test("Ares to square meters")
    func aresToSquareMeters() {
        let area = Area(1, unit: .ares)
        #expect(abs(area.squareMeters - 100) < 0.001)
    }

    @Test("Hectares to ares")
    func hectaresToAres() {
        let area = Area(1, unit: .hectares)
        #expect(abs(area.ares - 100) < 0.001)
    }

    @Test("Acres to square meters")
    func acresToSquareMeters() {
        let area = Area(1, unit: .acres)
        #expect(abs(area.squareMeters - 4046.8564224) < 0.01)
    }

    // MARK: - Unit Symbols

    @Test("Area unit symbols")
    func unitSymbols() {
        #expect(AreaUnit.squareMeters.symbol == "m²")
        #expect(AreaUnit.squareCentimeters.symbol == "cm²")
        #expect(AreaUnit.hectares.symbol == "ha")
        #expect(AreaUnit.ares.symbol == "a")
        #expect(AreaUnit.acres.symbol == "ac")
    }

    // MARK: - Formatting

    @Test("Area formatting hectares")
    func areaFormattingHectares() {
        let area = Area(5, unit: .hectares)
        #expect(area.formatted.contains("ha"))
    }

    @Test("Area formatting square meters")
    func areaFormattingSquareMeters() {
        let area = Area(500, unit: .squareMeters)
        #expect(area.formatted.contains("m²"))
    }

    // MARK: - Arithmetic

    @Test("Area addition")
    func areaAddition() {
        let a1 = Area(1, unit: .hectares)
        let a2 = Area(5000, unit: .squareMeters)
        let sum = a1 + a2
        #expect(abs(sum.hectares - 1.5) < 0.001)
    }

    // MARK: - Codable

    @Test("Area is Codable")
    func areaCodable() throws {
        let original = Area(2.5, unit: .hectares)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Area.self, from: encoded)
        #expect(abs(original.squareMeters - decoded.squareMeters) < 0.001)
    }
}
