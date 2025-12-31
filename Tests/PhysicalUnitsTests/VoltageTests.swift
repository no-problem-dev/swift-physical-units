import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Voltage Tests")
struct VoltageTests {
    // MARK: - Basic Conversions

    @Test("Kilovolts to volts")
    func kilovoltsToVolts() {
        let voltage = Voltage(1, unit: .kilovolts)
        #expect(abs(voltage.volts - 1000) < 0.001)
    }

    @Test("Volts to millivolts")
    func voltsToMillivolts() {
        let voltage = Voltage(1, unit: .volts)
        #expect(abs(voltage.millivolts - 1000) < 0.001)
    }

    @Test("Millivolts to microvolts")
    func millivoltsToMicrovolts() {
        let voltage = Voltage(1, unit: .millivolts)
        #expect(abs(voltage.microvolts - 1000) < 0.001)
    }

    @Test("Megavolts to kilovolts")
    func megavoltsToKilovolts() {
        let voltage = Voltage(1, unit: .megavolts)
        #expect(abs(voltage.kilovolts - 1000) < 0.001)
    }

    // MARK: - Special Values

    @Test("USB voltage")
    func usbVoltage() {
        #expect(abs(Voltage.usb.volts - 5) < 0.001)
    }

    @Test("Japan household voltage")
    func japanHouseholdVoltage() {
        #expect(abs(Voltage.householdJapan.volts - 100) < 0.001)
    }

    @Test("US household voltage")
    func usHouseholdVoltage() {
        #expect(abs(Voltage.householdUS.volts - 120) < 0.001)
    }

    @Test("EU household voltage")
    func euHouseholdVoltage() {
        #expect(abs(Voltage.householdEU.volts - 230) < 0.001)
    }

    // MARK: - Unit Symbols

    @Test("Voltage unit symbols")
    func unitSymbols() {
        #expect(VoltageUnit.volts.symbol == "V")
        #expect(VoltageUnit.millivolts.symbol == "mV")
        #expect(VoltageUnit.kilovolts.symbol == "kV")
        #expect(VoltageUnit.megavolts.symbol == "MV")
    }

    // MARK: - Formatting

    @Test("Voltage formatting kilovolts")
    func voltageFormattingKilovolts() {
        let voltage = Voltage(11, unit: .kilovolts)
        #expect(voltage.formatted.contains("kV"))
    }

    @Test("Voltage formatting volts")
    func voltageFormattingVolts() {
        let voltage = Voltage(12, unit: .volts)
        #expect(voltage.formatted.contains("V"))
    }

    // MARK: - Arithmetic

    @Test("Voltage addition")
    func voltageAddition() {
        let v1 = Voltage(1, unit: .volts)
        let v2 = Voltage(500, unit: .millivolts)
        let sum = v1 + v2
        #expect(abs(sum.volts - 1.5) < 0.001)
    }

    // MARK: - Codable

    @Test("Voltage is Codable")
    func voltageCodable() throws {
        let original = Voltage(12, unit: .volts)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Voltage.self, from: encoded)
        #expect(abs(original.volts - decoded.volts) < 0.001)
    }
}
