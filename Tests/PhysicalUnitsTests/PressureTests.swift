import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Pressure Tests")
struct PressureTests {
    // MARK: - Basic Conversions

    @Test("Bar to pascals")
    func barToPascals() {
        let pressure = Pressure(1, unit: .bars)
        #expect(abs(pressure.pascals - 100_000) < 0.1)
    }

    @Test("Pascals to bar")
    func pascalsToBar() {
        let pressure = Pressure(100_000, unit: .pascals)
        #expect(abs(pressure.bars - 1) < 0.0001)
    }

    @Test("Hectopascals to pascals")
    func hectopascalsToPascals() {
        let pressure = Pressure(1013.25, unit: .hectopascals)
        #expect(abs(pressure.pascals - 101_325) < 0.1)
    }

    @Test("Atmosphere to pascals")
    func atmosphereToPascals() {
        let pressure = Pressure(1, unit: .atmospheres)
        #expect(abs(pressure.pascals - 101_325) < 0.1)
    }

    @Test("Atmosphere to bar")
    func atmosphereToBar() {
        let pressure = Pressure(1, unit: .atmospheres)
        #expect(abs(pressure.bars - 1.01325) < 0.0001)
    }

    @Test("Torr to pascals")
    func torrToPascals() {
        let pressure = Pressure(760, unit: .torr)
        #expect(abs(pressure.atmospheres - 1) < 0.001)
    }

    @Test("PSI to kilopascals")
    func psiToKilopascals() {
        let pressure = Pressure(14.696, unit: .psi)
        #expect(abs(pressure.atmospheres - 1) < 0.01)
    }

    @Test("Millibar equals hectopascal")
    func millibarEqualsHectopascal() {
        let pressure = Pressure(1000, unit: .millibars)
        #expect(abs(pressure.hectopascals - 1000) < 0.001)
    }

    // MARK: - Special Values

    @Test("Standard atmosphere")
    func standardAtmosphere() {
        #expect(abs(Pressure.standardAtmosphere.pascals - 101_325) < 0.1)
    }

    @Test("Vacuum is zero")
    func vacuum() {
        #expect(Pressure.vacuum.pascals == 0)
    }

    // MARK: - Unit Symbols

    @Test("Pressure unit symbols")
    func unitSymbols() {
        #expect(PressureUnit.pascals.symbol == "Pa")
        #expect(PressureUnit.hectopascals.symbol == "hPa")
        #expect(PressureUnit.bars.symbol == "bar")
        #expect(PressureUnit.atmospheres.symbol == "atm")
        #expect(PressureUnit.torr.symbol == "Torr")
        #expect(PressureUnit.psi.symbol == "psi")
    }

    // MARK: - Formatting

    @Test("Pressure formatting bar")
    func pressureFormattingBar() {
        let pressure = Pressure(2.5, unit: .bars)
        #expect(pressure.formatted.contains("bar"))
    }

    @Test("Pressure formatting hectopascal")
    func pressureFormattingHectopascal() {
        // Use 5 hPa (500 Pa) which is in the 100-999 Pa range for hPa formatting
        let pressure = Pressure(5, unit: .hectopascals)
        #expect(pressure.formatted.contains("hPa"))
    }

    // MARK: - Arithmetic

    @Test("Pressure addition")
    func pressureAddition() {
        let p1 = Pressure(1, unit: .bars)
        let p2 = Pressure(50000, unit: .pascals)
        let sum = p1 + p2
        #expect(abs(sum.bars - 1.5) < 0.001)
    }

    // MARK: - Codable

    @Test("Pressure is Codable")
    func pressureCodable() throws {
        let original = Pressure(1, unit: .atmospheres)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Pressure.self, from: encoded)
        #expect(abs(original.pascals - decoded.pascals) < 0.001)
    }
}
