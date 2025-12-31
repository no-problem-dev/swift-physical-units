import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Charge Tests")
struct ChargeTests {
    // MARK: - Basic Unit Conversions

    @Test("Coulombs is base unit")
    func coulombsBaseUnit() {
        let charge = Charge(10, unit: .coulombs)
        #expect(abs(charge.coulombs - 10) < 0.001)
    }

    @Test("Millicoulombs to coulombs")
    func millicoulombsToCoulombs() {
        let charge = Charge(1000, unit: .millicoulombs)
        #expect(abs(charge.coulombs - 1) < 0.001)
    }

    @Test("Microcoulombs to coulombs")
    func microcoulombsToCoulombs() {
        let charge = Charge(1_000_000, unit: .microcoulombs)
        #expect(abs(charge.coulombs - 1) < 0.001)
    }

    @Test("Nanocoulombs to coulombs")
    func nanocoulombsToCoulombs() {
        let charge = Charge(1_000_000_000, unit: .nanocoulombs)
        #expect(abs(charge.coulombs - 1) < 0.001)
    }

    @Test("Kilocoulombs to coulombs")
    func kilocoulombsToCoulombs() {
        let charge = Charge(1, unit: .kilocoulombs)
        #expect(abs(charge.coulombs - 1000) < 0.001)
    }

    // MARK: - Ampere-hour Conversions

    @Test("Coulombs to ampere-hours")
    func coulombsToAmpereHours() {
        let charge = Charge(3600, unit: .coulombs)
        #expect(abs(charge.ampereHours - 1) < 0.001)
    }

    @Test("Coulombs to milliampere-hours")
    func coulombsToMilliampereHours() {
        let charge = Charge(3.6, unit: .coulombs)
        #expect(abs(charge.milliampereHours - 1) < 0.001)
    }

    @Test("Initialize with ampere-hours")
    func initWithAmpereHours() {
        let charge = Charge(ampereHours: 5)
        #expect(abs(charge.coulombs - 18000) < 0.001)
    }

    @Test("Initialize with milliampere-hours")
    func initWithMilliampereHours() {
        let charge = Charge(milliampereHours: 5000)
        #expect(abs(charge.coulombs - 18000) < 0.001)
    }

    // MARK: - Practical Examples

    @Test("Smartphone battery (3000 mAh)")
    func smartphoneBattery() {
        let battery = Charge(milliampereHours: 3000)
        #expect(abs(battery.coulombs - 10800) < 0.001)
        #expect(abs(battery.ampereHours - 3) < 0.001)
    }

    @Test("Car battery (60 Ah)")
    func carBattery() {
        let battery = Charge(ampereHours: 60)
        #expect(abs(battery.coulombs - 216000) < 0.001)
        #expect(abs(battery.kilocoulombs - 216) < 0.001)
    }

    @Test("Elementary charge")
    func elementaryCharge() {
        let e = Charge.elementaryCharge
        #expect(abs(e.coulombs - 1.602176634e-19) < 1e-28)
    }

    // MARK: - Formatting

    @Test("Formatted output for coulombs")
    func formattedCoulombs() {
        let charge = Charge(50, unit: .coulombs)
        #expect(charge.formatted == "50.00 C")
    }

    @Test("Formatted output for millicoulombs")
    func formattedMillicoulombs() {
        let charge = Charge(50, unit: .millicoulombs)
        #expect(charge.formatted == "50.00 mC")
    }

    @Test("Formatted output for kilocoulombs")
    func formattedKilocoulombs() {
        let charge = Charge(5, unit: .kilocoulombs)
        #expect(charge.formatted == "5.00 kC")
    }

    // MARK: - Arithmetic Operations

    @Test("Charge addition")
    func chargeAddition() {
        let c1 = Charge(100, unit: .coulombs)
        let c2 = Charge(50, unit: .coulombs)
        let sum = c1 + c2
        #expect(abs(sum.coulombs - 150) < 0.001)
    }

    @Test("Charge subtraction")
    func chargeSubtraction() {
        let c1 = Charge(100, unit: .coulombs)
        let c2 = Charge(30, unit: .coulombs)
        let diff = c1 - c2
        #expect(abs(diff.coulombs - 70) < 0.001)
    }

    // MARK: - Round-trip Conversions

    @Test("Round-trip: coulombs -> mAh -> coulombs")
    func roundTripCoulombsMah() {
        let original = Charge(7200, unit: .coulombs)
        let inMah = original.milliampereHours
        let back = Charge(milliampereHours: inMah)
        #expect(abs(original.coulombs - back.coulombs) < 0.001)
    }
}

// MARK: - Charge Operators Tests

@Suite("Charge Operators Tests")
struct ChargeOperatorsTests {
    // MARK: - Q = I × t

    @Test("Current times time equals charge")
    func currentTimesTime() {
        let current = Current(2, unit: .amperes)
        let time = Duration(10, unit: .seconds)
        let charge: Charge = current * time
        #expect(abs(charge.coulombs - 20) < 0.001)
    }

    @Test("Time times current equals charge (commutative)")
    func timeTimesCurrent() {
        let current = Current(500, unit: .milliamperes)
        let time = Duration(1, unit: .hours)
        let charge: Charge = time * current
        // 0.5 A × 3600 s = 1800 C
        #expect(abs(charge.coulombs - 1800) < 0.001)
    }

    // MARK: - I = Q / t

    @Test("Charge divided by time equals current")
    func chargeDividedByTime() {
        let charge = Charge(100, unit: .coulombs)
        let time = Duration(10, unit: .seconds)
        let current: Current = charge / time
        #expect(abs(current.amperes - 10) < 0.001)
    }

    // MARK: - t = Q / I

    @Test("Charge divided by current equals time")
    func chargeDividedByCurrent() {
        let charge = Charge(100, unit: .coulombs)
        let current = Current(10, unit: .amperes)
        let time: Duration = charge / current
        #expect(abs(time.seconds - 10) < 0.001)
    }

    // MARK: - Practical Examples

    @Test("Battery discharge time")
    func batteryDischargeTime() {
        // 5000 mAh battery, 500 mA draw
        let battery = Charge(milliampereHours: 5000)
        let current = Current(500, unit: .milliamperes)
        let time: Duration = battery / current
        #expect(abs(time.hours - 10) < 0.001)
    }

    @Test("USB charging")
    func usbCharging() {
        // USB 2.0: 500 mA for 2 hours
        let current = Current(500, unit: .milliamperes)
        let time = Duration(2, unit: .hours)
        let charge: Charge = current * time
        #expect(abs(charge.milliampereHours - 1000) < 0.1)
    }

    // MARK: - Round-trip Conversions

    @Test("Round-trip: current -> charge -> current")
    func roundTripChargeCurrent() {
        let originalCurrent = Current(2.5, unit: .amperes)
        let time = Duration(100, unit: .seconds)
        let charge: Charge = originalCurrent * time
        let calculatedCurrent: Current = charge / time
        #expect(abs(originalCurrent.amperes - calculatedCurrent.amperes) < 0.001)
    }
}
