import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Frequency Tests")
struct FrequencyTests {
    // MARK: - Basic Conversions

    @Test("Kilohertz to hertz")
    func kilohertzToHertz() {
        let frequency = Frequency(1, unit: .kilohertz)
        #expect(abs(frequency.hertz - 1000) < 0.001)
    }

    @Test("Megahertz to kilohertz")
    func megahertzToKilohertz() {
        let frequency = Frequency(1, unit: .megahertz)
        #expect(abs(frequency.kilohertz - 1000) < 0.001)
    }

    @Test("Gigahertz to megahertz")
    func gigahertzToMegahertz() {
        let frequency = Frequency(3.5, unit: .gigahertz)
        #expect(abs(frequency.megahertz - 3500) < 0.001)
    }

    @Test("Terahertz to gigahertz")
    func terahertzToGigahertz() {
        let frequency = Frequency(1, unit: .terahertz)
        #expect(abs(frequency.gigahertz - 1000) < 0.001)
    }

    @Test("Hertz to millihertz")
    func hertzToMillihertz() {
        let frequency = Frequency(1, unit: .hertz)
        #expect(abs(frequency.millihertz - 1000) < 0.001)
    }

    // MARK: - Period Calculation

    @Test("Period of 1 Hz")
    func periodOf1Hz() {
        let frequency = Frequency(1, unit: .hertz)
        #expect(abs(frequency.period - 1) < 0.001)
    }

    @Test("Period of 1 kHz")
    func periodOf1kHz() {
        let frequency = Frequency(1, unit: .kilohertz)
        #expect(abs(frequency.period - 0.001) < 0.0001)
    }

    // MARK: - Unit Symbols

    @Test("Frequency unit symbols")
    func unitSymbols() {
        #expect(FrequencyUnit.hertz.symbol == "Hz")
        #expect(FrequencyUnit.kilohertz.symbol == "kHz")
        #expect(FrequencyUnit.megahertz.symbol == "MHz")
        #expect(FrequencyUnit.gigahertz.symbol == "GHz")
        #expect(FrequencyUnit.terahertz.symbol == "THz")
    }

    // MARK: - Formatting

    @Test("Frequency formatting gigahertz")
    func frequencyFormattingGigahertz() {
        let frequency = Frequency(3.5, unit: .gigahertz)
        #expect(frequency.formatted.contains("GHz"))
    }

    @Test("Frequency formatting megahertz")
    func frequencyFormattingMegahertz() {
        let frequency = Frequency(88.1, unit: .megahertz)
        #expect(frequency.formatted.contains("MHz"))
    }

    // MARK: - Arithmetic

    @Test("Frequency addition")
    func frequencyAddition() {
        let f1 = Frequency(1, unit: .megahertz)
        let f2 = Frequency(500, unit: .kilohertz)
        let sum = f1 + f2
        #expect(abs(sum.megahertz - 1.5) < 0.001)
    }

    // MARK: - Codable

    @Test("Frequency is Codable")
    func frequencyCodable() throws {
        let original = Frequency(2.4, unit: .gigahertz)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Frequency.self, from: encoded)
        #expect(abs(original.hertz - decoded.hertz) < 0.001)
    }
}
