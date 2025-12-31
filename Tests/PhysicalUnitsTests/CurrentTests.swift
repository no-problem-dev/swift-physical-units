import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Current Tests")
struct CurrentTests {
    // MARK: - Basic Conversions

    @Test("Amperes to milliamperes")
    func amperesToMilliamperes() {
        let current = Current(1, unit: .amperes)
        #expect(abs(current.milliamperes - 1000) < 0.001)
    }

    @Test("Milliamperes to microamperes")
    func milliamperesToMicroamperes() {
        let current = Current(1, unit: .milliamperes)
        #expect(abs(current.microamperes - 1000) < 0.001)
    }

    @Test("Microamperes to nanoamperes")
    func microamperesToNanoamperes() {
        let current = Current(1, unit: .microamperes)
        #expect(abs(current.nanoamperes - 1000) < 0.001)
    }

    @Test("Kiloamperes to amperes")
    func kiloamperesToAmperes() {
        let current = Current(1, unit: .kiloamperes)
        #expect(abs(current.amperes - 1000) < 0.001)
    }

    // MARK: - Special Values

    @Test("USB 2.0 max current")
    func usb2MaxCurrent() {
        #expect(abs(Current.usb2Max.milliamperes - 500) < 0.001)
    }

    @Test("USB 3.0 max current")
    func usb3MaxCurrent() {
        #expect(abs(Current.usb3Max.milliamperes - 900) < 0.001)
    }

    @Test("USB PD max current")
    func usbPDMaxCurrent() {
        #expect(abs(Current.usbPDMax.amperes - 5) < 0.001)
    }

    // MARK: - Unit Symbols

    @Test("Current unit symbols")
    func unitSymbols() {
        #expect(CurrentUnit.amperes.symbol == "A")
        #expect(CurrentUnit.milliamperes.symbol == "mA")
        #expect(CurrentUnit.microamperes.symbol == "μA")
        #expect(CurrentUnit.nanoamperes.symbol == "nA")
        #expect(CurrentUnit.kiloamperes.symbol == "kA")
    }

    // MARK: - Formatting

    @Test("Current formatting amperes")
    func currentFormattingAmperes() {
        let current = Current(5, unit: .amperes)
        #expect(current.formatted.contains("A"))
    }

    @Test("Current formatting milliamperes")
    func currentFormattingMilliamperes() {
        let current = Current(500, unit: .milliamperes)
        #expect(current.formatted.contains("mA"))
    }

    // MARK: - Arithmetic

    @Test("Current addition")
    func currentAddition() {
        let c1 = Current(1, unit: .amperes)
        let c2 = Current(500, unit: .milliamperes)
        let sum = c1 + c2
        #expect(abs(sum.amperes - 1.5) < 0.001)
    }

    // MARK: - Codable

    @Test("Current is Codable")
    func currentCodable() throws {
        let original = Current(2.5, unit: .amperes)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Current.self, from: encoded)
        #expect(abs(original.amperes - decoded.amperes) < 0.001)
    }
}
