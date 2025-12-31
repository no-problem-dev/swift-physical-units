import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Force Tests")
struct ForceTests {
    // MARK: - Basic Conversions

    @Test("Kilonewtons to newtons")
    func kilonewtonsToNewtons() {
        let force = Force(1, unit: .kilonewtons)
        #expect(abs(force.newtons - 1000) < 0.001)
    }

    @Test("Newtons to kilonewtons")
    func newtonsToKilonewtons() {
        let force = Force(5000, unit: .newtons)
        #expect(abs(force.kilonewtons - 5) < 0.001)
    }

    @Test("Kilogram-force to newtons")
    func kgfToNewtons() {
        let force = Force(1, unit: .kilogramsForce)
        #expect(abs(force.newtons - 9.80665) < 0.0001)
    }

    @Test("Newtons to kilogram-force")
    func newtonsToKgf() {
        let force = Force(9.80665, unit: .newtons)
        #expect(abs(force.kilogramsForce - 1) < 0.0001)
    }

    @Test("Pound-force to newtons")
    func lbfToNewtons() {
        let force = Force(1, unit: .poundsForce)
        #expect(abs(force.newtons - 4.44822) < 0.001)
    }

    @Test("Dynes to newtons")
    func dynesToNewtons() {
        let force = Force(100000, unit: .dynes)
        #expect(abs(force.newtons - 1) < 0.0001)
    }

    // MARK: - Standard Gravity Constant

    @Test("Standard gravity constant")
    func standardGravity() {
        #expect(abs(ForceUnit.standardGravity - 9.80665) < 0.00001)
    }

    // MARK: - Unit Symbols

    @Test("Force unit symbols")
    func unitSymbols() {
        #expect(ForceUnit.newtons.symbol == "N")
        #expect(ForceUnit.kilonewtons.symbol == "kN")
        #expect(ForceUnit.kilogramsForce.symbol == "kgf")
        #expect(ForceUnit.poundsForce.symbol == "lbf")
        #expect(ForceUnit.dynes.symbol == "dyn")
    }

    // MARK: - Formatting

    @Test("Force formatting kilonewtons")
    func forceFormattingKilonewtons() {
        let force = Force(5, unit: .kilonewtons)
        #expect(force.formatted.contains("kN"))
    }

    @Test("Force formatting newtons")
    func forceFormattingNewtons() {
        let force = Force(100, unit: .newtons)
        #expect(force.formatted.contains("N"))
    }

    // MARK: - Arithmetic

    @Test("Force addition")
    func forceAddition() {
        let f1 = Force(1, unit: .kilonewtons)
        let f2 = Force(500, unit: .newtons)
        let sum = f1 + f2
        #expect(abs(sum.kilonewtons - 1.5) < 0.001)
    }

    // MARK: - Codable

    @Test("Force is Codable")
    func forceCodable() throws {
        let original = Force(10, unit: .kilonewtons)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Force.self, from: encoded)
        #expect(abs(original.newtons - decoded.newtons) < 0.001)
    }
}
