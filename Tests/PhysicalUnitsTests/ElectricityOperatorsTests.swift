import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Electricity Operators Tests")
struct ElectricityOperatorsTests {
    // MARK: - Power = Voltage × Current (P = VI)

    @Test("Voltage times current equals power")
    func voltageTimesCurrent() {
        let voltage = Voltage(100, unit: .volts)
        let current = Current(5, unit: .amperes)
        let power: Power = voltage * current
        #expect(abs(power.watts - 500) < 0.001)
    }

    @Test("Current times voltage equals power (commutative)")
    func currentTimesVoltage() {
        let voltage = Voltage(220, unit: .volts)
        let current = Current(10, unit: .amperes)
        let power: Power = current * voltage
        #expect(abs(power.watts - 2200) < 0.001)
    }

    @Test("Power divided by current equals voltage")
    func powerDividedByCurrent() {
        let power = Power(500, unit: .watts)
        let current = Current(5, unit: .amperes)
        let voltage: Voltage = power / current
        #expect(abs(voltage.volts - 100) < 0.001)
    }

    @Test("Power divided by voltage equals current")
    func powerDividedByVoltage() {
        let power = Power(500, unit: .watts)
        let voltage = Voltage(100, unit: .volts)
        let current: Current = power / voltage
        #expect(abs(current.amperes - 5) < 0.001)
    }

    // MARK: - Ohm's Law (V = IR)

    @Test("Current times resistance equals voltage")
    func currentTimesResistance() {
        let current = Current(0.5, unit: .amperes)
        let resistance = Resistance(100, unit: .ohms)
        let voltage: Voltage = current * resistance
        #expect(abs(voltage.volts - 50) < 0.001)
    }

    @Test("Resistance times current equals voltage (commutative)")
    func resistanceTimesCurrent() {
        let current = Current(2, unit: .amperes)
        let resistance = Resistance(50, unit: .ohms)
        let voltage: Voltage = resistance * current
        #expect(abs(voltage.volts - 100) < 0.001)
    }

    @Test("Voltage divided by resistance equals current")
    func voltageDividedByResistance() {
        let voltage = Voltage(12, unit: .volts)
        let resistance = Resistance(4, unit: .kilohms)
        let current: Current = voltage / resistance
        #expect(abs(current.milliamperes - 3) < 0.001)
    }

    @Test("Voltage divided by current equals resistance")
    func voltageDividedByCurrent() {
        let voltage = Voltage(5, unit: .volts)
        let current = Current(10, unit: .milliamperes)
        let resistance: Resistance = voltage / current
        #expect(abs(resistance.ohms - 500) < 0.001)
    }

    // MARK: - Power with Resistance (P = I²R)

    @Test("Resistance power at current (P = I²R)")
    func resistancePowerAtCurrent() {
        let resistance = Resistance(100, unit: .ohms)
        let current = Current(0.5, unit: .amperes)
        let power = resistance.power(at: current)
        #expect(abs(power.watts - 25) < 0.001)
    }

    @Test("Resistance power at voltage (P = V²/R)")
    func resistancePowerAtVoltage() {
        let resistance = Resistance(100, unit: .ohms)
        let voltage = Voltage(10, unit: .volts)
        let power = resistance.power(at: voltage)
        #expect(abs(power.watts - 1) < 0.001)
    }

    // MARK: - Resistance from Power (R = P/I², R = V²/P)

    @Test("Power resistance at current (R = P/I²)")
    func powerResistanceAtCurrent() {
        let power = Power(10, unit: .watts)
        let current = Current(0.5, unit: .amperes)
        let resistance = power.resistance(at: current)
        #expect(abs(resistance.ohms - 40) < 0.001)
    }

    @Test("Power resistance at voltage (R = V²/P)")
    func powerResistanceAtVoltage() {
        let power = Power(100, unit: .watts)
        let voltage = Voltage(100, unit: .volts)
        let resistance = power.resistance(at: voltage)
        #expect(abs(resistance.ohms - 100) < 0.001)
    }

    // MARK: - Practical examples

    @Test("LED circuit calculation")
    func ledCircuitCalculation() {
        // 5V supply, 2V LED forward voltage, 20mA desired current
        // Required resistance: (5V - 2V) / 20mA = 150Ω
        let supplyVoltage = Voltage(5, unit: .volts)
        let ledVoltage = Voltage(2, unit: .volts)
        let voltageDrop = Voltage(supplyVoltage.volts - ledVoltage.volts, unit: .volts)
        let desiredCurrent = Current(20, unit: .milliamperes)
        let resistance: Resistance = voltageDrop / desiredCurrent
        #expect(abs(resistance.ohms - 150) < 0.001)
    }

    @Test("Power consumption calculation")
    func powerConsumptionCalculation() {
        // 100W bulb at 100V
        let power = Power(100, unit: .watts)
        let voltage = Voltage(100, unit: .volts)
        let current: Current = power / voltage
        #expect(abs(current.amperes - 1) < 0.001)

        // Resistance of bulb
        let resistance = power.resistance(at: voltage)
        #expect(abs(resistance.ohms - 100) < 0.001)
    }

    // MARK: - Round-trip conversions

    @Test("Round-trip: voltage -> current -> voltage via Ohm's law")
    func roundTripOhmsLaw() {
        let originalVoltage = Voltage(12, unit: .volts)
        let resistance = Resistance(100, unit: .ohms)
        let current: Current = originalVoltage / resistance
        let calculatedVoltage: Voltage = current * resistance
        #expect(abs(originalVoltage.volts - calculatedVoltage.volts) < 0.001)
    }

    @Test("Round-trip: power -> resistance -> power via I²R")
    func roundTripPowerResistance() {
        let current = Current(2, unit: .amperes)
        let resistance = Resistance(50, unit: .ohms)
        let power = resistance.power(at: current)
        let calculatedResistance = power.resistance(at: current)
        #expect(abs(resistance.ohms - calculatedResistance.ohms) < 0.001)
    }
}
