import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Power Tests")
struct PowerTests {
    // MARK: - Basic Conversions

    @Test("Kilowatts to watts")
    func kilowattsToWatts() {
        let power = Power(1, unit: .kilowatts)
        #expect(abs(power.watts - 1000) < 0.001)
    }

    @Test("Watts to kilowatts")
    func wattsToKilowatts() {
        let power = Power(5000, unit: .watts)
        #expect(abs(power.kilowatts - 5) < 0.001)
    }

    @Test("Megawatts to kilowatts")
    func megawattsToKilowatts() {
        let power = Power(1, unit: .megawatts)
        #expect(abs(power.kilowatts - 1000) < 0.001)
    }

    @Test("Gigawatts to megawatts")
    func gigawattsToMegawatts() {
        let power = Power(1.21, unit: .gigawatts)
        #expect(abs(power.megawatts - 1210) < 0.001)
    }

    @Test("Horsepower to watts (metric)")
    func horsepowerToWatts() {
        let power = Power(1, unit: .horsepower)
        #expect(abs(power.watts - 735.49875) < 0.01)
    }

    @Test("Kilowatts to horsepower")
    func kilowattsToHorsepower() {
        let power = Power(73.5, unit: .kilowatts)
        #expect(abs(power.horsepower - 100) < 0.1)
    }

    @Test("Imperial horsepower to watts")
    func imperialHorsepowerToWatts() {
        let power = Power(1, unit: .horsepowerImperial)
        #expect(abs(power.watts - 745.699) < 0.01)
    }

    // MARK: - Unit Symbols

    @Test("Power unit symbols")
    func unitSymbols() {
        #expect(PowerUnit.watts.symbol == "W")
        #expect(PowerUnit.kilowatts.symbol == "kW")
        #expect(PowerUnit.megawatts.symbol == "MW")
        #expect(PowerUnit.gigawatts.symbol == "GW")
        #expect(PowerUnit.horsepower.symbol == "hp")
    }

    // MARK: - Formatting

    @Test("Power formatting kilowatts")
    func powerFormattingKilowatts() {
        let power = Power(5, unit: .kilowatts)
        #expect(power.formatted.contains("kW"))
    }

    @Test("Power formatting watts")
    func powerFormattingWatts() {
        let power = Power(100, unit: .watts)
        #expect(power.formatted.contains("W"))
    }

    // MARK: - Arithmetic

    @Test("Power addition")
    func powerAddition() {
        let p1 = Power(1, unit: .kilowatts)
        let p2 = Power(500, unit: .watts)
        let sum = p1 + p2
        #expect(abs(sum.kilowatts - 1.5) < 0.001)
    }

    // MARK: - Codable

    @Test("Power is Codable")
    func powerCodable() throws {
        let original = Power(100, unit: .kilowatts)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Power.self, from: encoded)
        #expect(abs(original.watts - decoded.watts) < 0.001)
    }
}
