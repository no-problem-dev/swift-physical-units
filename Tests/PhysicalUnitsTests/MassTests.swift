import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Mass Tests")
struct MassTests {

    // MARK: - Initialization Tests

    @Test("Initialize with kilograms")
    func initWithKilograms() {
        let mass = Mass(70, unit: .kilograms)
        #expect(mass.kilograms == 70)
        #expect(mass.grams == 70000)
    }

    @Test("Initialize with grams")
    func initWithGrams() {
        let mass = Mass(5000, unit: .grams)
        #expect(mass.grams == 5000)
        #expect(mass.kilograms == 5)
    }

    @Test("Initialize with milligrams")
    func initWithMilligrams() {
        let mass = Mass(1000, unit: .milligrams)
        #expect(mass.milligrams == 1000)
        #expect(mass.grams == 1)
    }

    @Test("Initialize with integer")
    func initWithInteger() {
        let mass = Mass(70, unit: .kilograms)
        #expect(mass.kilograms == 70)
    }

    // MARK: - Conversion Tests

    @Test("Convert between units")
    func conversion() {
        let mass = Mass(1, unit: .kilograms)
        #expect(mass.grams == 1000)
        #expect(mass.milligrams == 1_000_000)
        #expect(mass.micrograms == 1_000_000_000)
    }

    @Test("Tonnes conversion")
    func tonnesConversion() {
        let mass = Mass(2000, unit: .kilograms)
        #expect(mass.tonnes == 2)
    }

    // MARK: - Arithmetic Tests

    @Test("Addition")
    func addition() {
        let mass1 = Mass(1, unit: .kilograms)
        let mass2 = Mass(500, unit: .grams)
        let result = mass1 + mass2
        #expect(result.grams == 1500)
    }

    @Test("Subtraction")
    func subtraction() {
        let mass1 = Mass(2, unit: .kilograms)
        let mass2 = Mass(500, unit: .grams)
        let result = mass1 - mass2
        #expect(result.grams == 1500)
    }

    @Test("Scalar multiplication")
    func scalarMultiplication() {
        let mass = Mass(1, unit: .kilograms)
        let result1 = mass * 2.5
        let result2 = 2.5 * mass
        #expect(result1.grams == 2500)
        #expect(result2.grams == 2500)
    }

    @Test("Scalar division")
    func scalarDivision() {
        let mass = Mass(1, unit: .kilograms)
        let result = mass / 2
        #expect(result.grams == 500)
    }

    @Test("Ratio between measurements")
    func ratio() {
        let mass1 = Mass(2, unit: .kilograms)
        let mass2 = Mass(500, unit: .grams)
        let ratio = mass1 / mass2
        #expect(ratio == 4)
    }

    // MARK: - Comparison Tests

    @Test("Comparison")
    func comparison() {
        let mass1 = Mass(1, unit: .kilograms)
        let mass2 = Mass(500, unit: .grams)
        let mass3 = Mass(1000, unit: .grams)

        #expect(mass1 > mass2)
        #expect(mass2 < mass1)
        #expect(mass1 == mass3)
        #expect(mass1 >= mass3)
        #expect(mass1 <= mass3)
    }

    // MARK: - AdditiveArithmetic Tests

    @Test("Zero value")
    func zeroValue() {
        let zero = Mass.zero
        #expect(zero.grams == 0)

        let mass = Mass(1, unit: .kilograms)
        #expect(mass + .zero == mass)
    }

    @Test("Sum of sequence")
    func sumOfSequence() {
        let masses = [
            Mass(1, unit: .kilograms),
            Mass(500, unit: .grams),
            Mass(250, unit: .grams)
        ]
        let total = masses.sum()
        #expect(total.grams == 1750)
    }

    // MARK: - Compound Assignment Tests

    @Test("Compound assignment operators")
    func compoundAssignment() {
        var mass = Mass(1, unit: .kilograms)

        mass += Mass(500, unit: .grams)
        #expect(mass.grams == 1500)

        mass -= Mass(250, unit: .grams)
        #expect(mass.grams == 1250)

        mass *= 2
        #expect(mass.grams == 2500)

        mass /= 5
        #expect(mass.grams == 500)
    }

    // MARK: - Utility Tests

    @Test("Magnitude")
    func magnitude() {
        let negative = Mass(-100, unit: .grams)
        #expect(negative.magnitude.grams == 100)
    }

    @Test("IsZero, isPositive, isNegative")
    func signChecks() {
        let zero = Mass.zero
        let positive = Mass(1, unit: .grams)
        let negative = Mass(-1, unit: .grams)

        #expect(zero.isZero)
        #expect(!zero.isPositive)
        #expect(!zero.isNegative)

        #expect(!positive.isZero)
        #expect(positive.isPositive)
        #expect(!positive.isNegative)

        #expect(!negative.isZero)
        #expect(!negative.isPositive)
        #expect(negative.isNegative)
    }

    @Test("Clamped")
    func clamped() {
        let mass = Mass(500, unit: .grams)
        let min = Mass(100, unit: .grams)
        let max = Mass(300, unit: .grams)

        let clamped = mass.clamped(to: min...max)
        #expect(clamped.grams == 300)
    }

    // MARK: - Codable Tests

    @Test("Mass is Codable")
    func codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let original = Mass(70, unit: .kilograms)
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(Mass.self, from: data)

        #expect(decoded == original)
    }

    // MARK: - Hashable Tests

    @Test("Mass is Hashable")
    func hashable() {
        var set = Set<Mass>()
        set.insert(Mass(1, unit: .kilograms))
        set.insert(Mass(1000, unit: .grams))  // same value
        set.insert(Mass(500, unit: .grams))

        #expect(set.count == 2)
    }

    // MARK: - Unit Symbol Tests

    @Test("MassUnit symbols")
    func unitSymbols() {
        #expect(MassUnit.grams.symbol == "g")
        #expect(MassUnit.kilograms.symbol == "kg")
        #expect(MassUnit.milligrams.symbol == "mg")
        #expect(MassUnit.micrograms.symbol == "μg")
        #expect(MassUnit.tonnes.symbol == "Mg")
    }
}
