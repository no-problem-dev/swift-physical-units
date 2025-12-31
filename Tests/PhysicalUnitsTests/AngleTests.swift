import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Angle Tests")
struct AngleTests {
    // MARK: - Basic Conversions

    @Test("Degrees to radians conversion")
    func degreesToRadians() {
        let angle = Angle(180, unit: .degrees)
        #expect(abs(angle.radians - .pi) < 0.0001)
    }

    @Test("Radians to degrees conversion")
    func radiansToDegrees() {
        let angle = Angle(.pi, unit: .radians)
        #expect(abs(angle.degrees - 180) < 0.0001)
    }

    @Test("Degrees to turns conversion")
    func degreesToTurns() {
        let angle = Angle(360, unit: .degrees)
        #expect(abs(angle.turns - 1) < 0.0001)
    }

    @Test("Gradians to degrees conversion")
    func gradiansToDegrees() {
        let angle = Angle(100, unit: .gradians)
        #expect(abs(angle.degrees - 90) < 0.0001)
    }

    @Test("Right angle is 90 degrees")
    func rightAngle() {
        let angle = Angle(90, unit: .degrees)
        #expect(abs(angle.radians - .pi / 2) < 0.0001)
    }

    // MARK: - Special Values

    @Test("Right angle special value")
    func rightAngleSpecial() {
        #expect(abs(Angle.rightAngle.degrees - 90) < 0.0001)
    }

    @Test("Straight angle special value")
    func straightAngleSpecial() {
        #expect(abs(Angle.straightAngle.degrees - 180) < 0.0001)
    }

    @Test("Full angle special value")
    func fullAngleSpecial() {
        #expect(abs(Angle.fullAngle.degrees - 360) < 0.0001)
    }

    // MARK: - Trigonometric Functions

    @Test("Sin of 30 degrees")
    func sin30() {
        let angle = Angle(30, unit: .degrees)
        #expect(abs(angle.sin - 0.5) < 0.0001)
    }

    @Test("Cos of 60 degrees")
    func cos60() {
        let angle = Angle(60, unit: .degrees)
        #expect(abs(angle.cos - 0.5) < 0.0001)
    }

    @Test("Tan of 45 degrees")
    func tan45() {
        let angle = Angle(45, unit: .degrees)
        #expect(abs(angle.tan - 1) < 0.0001)
    }

    // MARK: - Unit Symbols

    @Test("Angle unit symbols")
    func unitSymbols() {
        #expect(AngleUnit.radians.symbol == "rad")
        #expect(AngleUnit.degrees.symbol == "°")
        #expect(AngleUnit.gradians.symbol == "grad")
        #expect(AngleUnit.turns.symbol == "turn")
    }

    // MARK: - Codable

    @Test("Angle is Codable")
    func angleCodable() throws {
        let original = Angle(45, unit: .degrees)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Angle.self, from: encoded)
        #expect(abs(original.radians - decoded.radians) < 0.0001)
    }
}
