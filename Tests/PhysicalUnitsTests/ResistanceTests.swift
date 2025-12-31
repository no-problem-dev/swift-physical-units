import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Resistance Tests")
struct ResistanceTests {
    // MARK: - Basic Unit Conversions

    @Test("Ohms is base unit")
    func ohmsBaseUnit() {
        let resistance = Resistance(100, unit: .ohms)
        #expect(abs(resistance.ohms - 100) < 0.001)
    }

    @Test("Milliohms to ohms")
    func milliohmsToOhms() {
        let resistance = Resistance(1000, unit: .milliohms)
        #expect(abs(resistance.ohms - 1) < 0.001)
    }

    @Test("Kilohms to ohms")
    func kilohmsToOhms() {
        let resistance = Resistance(4.7, unit: .kilohms)
        #expect(abs(resistance.ohms - 4700) < 0.001)
    }

    @Test("Megaohms to ohms")
    func megaohmsToOhms() {
        let resistance = Resistance(1, unit: .megaohms)
        #expect(abs(resistance.ohms - 1_000_000) < 0.001)
    }

    @Test("Gigaohms to ohms")
    func gigaohmsToOhms() {
        let resistance = Resistance(1, unit: .gigaohms)
        #expect(abs(resistance.ohms - 1_000_000_000) < 0.001)
    }

    // MARK: - Cross-Unit Conversions

    @Test("Ohms to kilohms")
    func ohmsToKilohms() {
        let resistance = Resistance(4700, unit: .ohms)
        #expect(abs(resistance.kilohms - 4.7) < 0.001)
    }

    @Test("Kilohms to megaohms")
    func kilohmsToMegaohms() {
        let resistance = Resistance(1000, unit: .kilohms)
        #expect(abs(resistance.megaohms - 1) < 0.001)
    }

    @Test("Megaohms to gigaohms")
    func megaohmsToGigaohms() {
        let resistance = Resistance(1000, unit: .megaohms)
        #expect(abs(resistance.gigaohms - 1) < 0.001)
    }

    // MARK: - Formatting

    @Test("Formatted output for milliohms")
    func formattedMilliohms() {
        let resistance = Resistance(0.5, unit: .ohms)
        #expect(resistance.formatted == "500.00 mΩ")
    }

    @Test("Formatted output for ohms")
    func formattedOhms() {
        let resistance = Resistance(220, unit: .ohms)
        #expect(resistance.formatted == "220.00 Ω")
    }

    @Test("Formatted output for kilohms")
    func formattedKilohms() {
        let resistance = Resistance(4.7, unit: .kilohms)
        #expect(resistance.formatted == "4.70 kΩ")
    }

    @Test("Formatted output for megaohms")
    func formattedMegaohms() {
        let resistance = Resistance(1, unit: .megaohms)
        #expect(resistance.formatted == "1.00 MΩ")
    }

    @Test("Formatted output for gigaohms")
    func formattedGigaohms() {
        let resistance = Resistance(1, unit: .gigaohms)
        #expect(resistance.formatted == "1.00 GΩ")
    }

    // MARK: - Common Values

    @Test("LED 220Ω resistor")
    func led220Resistor() {
        #expect(abs(Resistance.led220.ohms - 220) < 0.001)
    }

    @Test("Pull-up 10kΩ resistor")
    func pullUp10kResistor() {
        #expect(abs(Resistance.pullUp10k.kilohms - 10) < 0.001)
    }

    @Test("Pull-up 4.7kΩ resistor")
    func pullUp4k7Resistor() {
        #expect(abs(Resistance.pullUp4k7.kilohms - 4.7) < 0.001)
    }

    // MARK: - Arithmetic Operations

    @Test("Resistance addition (series)")
    func resistanceAddition() {
        let r1 = Resistance(100, unit: .ohms)
        let r2 = Resistance(220, unit: .ohms)
        let total = r1 + r2
        #expect(abs(total.ohms - 320) < 0.001)
    }

    @Test("Resistance subtraction")
    func resistanceSubtraction() {
        let r1 = Resistance(1, unit: .kilohms)
        let r2 = Resistance(300, unit: .ohms)
        let diff = r1 - r2
        #expect(abs(diff.ohms - 700) < 0.001)
    }

    @Test("Resistance scaling")
    func resistanceScaling() {
        let resistance = Resistance(100, unit: .ohms)
        let doubled = resistance * 2
        #expect(abs(doubled.ohms - 200) < 0.001)
    }

    // MARK: - Practical Examples

    @Test("Resistor color code: Brown-Black-Red = 1kΩ")
    func resistorColorCode1k() {
        // Brown=1, Black=0, Red=×100 → 1000Ω
        let resistance = Resistance(1, unit: .kilohms)
        #expect(abs(resistance.ohms - 1000) < 0.001)
    }

    @Test("Resistor color code: Yellow-Violet-Orange = 47kΩ")
    func resistorColorCode47k() {
        // Yellow=4, Violet=7, Orange=×1000 → 47000Ω
        let resistance = Resistance(47, unit: .kilohms)
        #expect(abs(resistance.ohms - 47000) < 0.001)
    }

    @Test("Insulation resistance (high value)")
    func insulationResistance() {
        let insulation = Resistance(100, unit: .megaohms)
        #expect(abs(insulation.gigaohms - 0.1) < 0.001)
    }

    // MARK: - Round-trip Conversions

    @Test("Round-trip: ohms -> kilohms -> ohms")
    func roundTripOhmsKilohms() {
        let original = Resistance(4700, unit: .ohms)
        let inKilohms = original.kilohms
        let backToOhms = Resistance(inKilohms, unit: .kilohms)
        #expect(abs(original.ohms - backToOhms.ohms) < 0.001)
    }

    @Test("Round-trip: milliohms -> ohms -> milliohms")
    func roundTripMilliohmsOhms() {
        let original = Resistance(500, unit: .milliohms)
        let inOhms = original.ohms
        let backToMilliohms = Resistance(inOhms, unit: .ohms)
        #expect(abs(original.milliohms - backToMilliohms.milliohms) < 0.001)
    }
}
