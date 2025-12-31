import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Energy Tests")
struct EnergyTests {

    // MARK: - Initialization Tests

    @Test("Initialize with kilocalories")
    func initWithKilocalories() {
        let energy = Energy(300, unit: .kilocalories)
        #expect(energy.kilocalories == 300)
    }

    @Test("Initialize with kilojoules")
    func initWithKilojoules() {
        let energy = Energy(1000, unit: .kilojoules)
        #expect(energy.kilojoules == 1000)
        #expect(energy.joules == 1_000_000)
    }

    // MARK: - Conversion Tests

    @Test("Convert between joules and calories")
    func jouleCalorieConversion() {
        let energy = Energy(1000, unit: .calories)

        // 1 cal = 4.184 J
        let expectedJoules = 1000 * 4.184
        #expect(abs(energy.joules - expectedJoules) < 0.001)
    }

    @Test("Convert kilocalories to kilojoules")
    func kcalToKjConversion() {
        let energy = Energy(1, unit: .kilocalories)

        // 1 kcal = 4.184 kJ
        let expectedKj = 4.184
        #expect(abs(energy.kilojoules - expectedKj) < 0.001)
    }

    @Test("Bidirectional conversion is accurate")
    func bidirectionalConversion() {
        let original = Energy(500, unit: .kilocalories)
        let inJoules = original.joules
        let backToKcal = Energy(inJoules, unit: .joules).kilocalories

        #expect(abs(backToKcal - 500) < 0.001)
    }

    // MARK: - Arithmetic Tests

    @Test("Addition with different units")
    func additionDifferentUnits() {
        let kcal = Energy(100, unit: .kilocalories)
        let kj = Energy(418.4, unit: .kilojoules)  // ~100 kcal

        let total = kcal + kj
        #expect(abs(total.kilocalories - 200) < 0.1)
    }

    @Test("Subtraction")
    func subtraction() {
        let energy1 = Energy(500, unit: .kilocalories)
        let energy2 = Energy(200, unit: .kilocalories)

        let result = energy1 - energy2
        #expect(result.kilocalories == 300)
    }

    // MARK: - Unit Symbol Tests

    @Test("EnergyUnit symbols")
    func unitSymbols() {
        #expect(EnergyUnit.joules.symbol == "J")
        #expect(EnergyUnit.kilojoules.symbol == "kJ")
        #expect(EnergyUnit.megajoules.symbol == "MJ")
        #expect(EnergyUnit.calories.symbol == "cal")
        #expect(EnergyUnit.kilocalories.symbol == "kcal")
    }

    // MARK: - Coefficient Tests

    @Test("Joule coefficients")
    func jouleCoefficients() {
        #expect(EnergyUnit.joules.coefficientToBase == 1)
        #expect(EnergyUnit.kilojoules.coefficientToBase == 1000)
        #expect(EnergyUnit.megajoules.coefficientToBase == 1_000_000)
    }

    @Test("Calorie coefficients")
    func calorieCoefficients() {
        #expect(EnergyUnit.calories.coefficientToBase == 4.184)
        #expect(EnergyUnit.kilocalories.coefficientToBase == 4184)
    }

    // MARK: - Zero Tests

    @Test("Zero energy")
    func zeroEnergy() {
        let zero = Energy.zero
        #expect(zero.joules == 0)
        #expect(zero.kilocalories == 0)
    }

    // MARK: - Codable Tests

    @Test("Energy is Codable")
    func codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let original = Energy(350, unit: .kilocalories)
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(Energy.self, from: data)

        #expect(abs(decoded.kilocalories - original.kilocalories) < 0.001)
    }

    // MARK: - Formatting Tests

    @Test("Formatted output")
    func formattedOutput() {
        let energy = Energy(350, unit: .kilocalories)
        let formatted = energy.formattedCalories

        #expect(formatted.contains("kcal"))
    }
}
