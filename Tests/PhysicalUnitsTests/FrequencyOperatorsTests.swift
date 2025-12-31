import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Frequency Operators Tests")
struct FrequencyOperatorsTests {
    // MARK: - Frequency ↔ Duration Conversion

    @Test("Duration to frequency conversion")
    func durationToFrequency() {
        let period = Duration(0.1, unit: .seconds)  // 100ms period
        let frequency = period.asFrequency
        #expect(abs(frequency.hertz - 10) < 0.001)
    }

    @Test("Frequency to duration conversion")
    func frequencyToDuration() {
        let frequency = Frequency(50, unit: .hertz)  // 50 Hz
        let period = frequency.asPeriod
        #expect(abs(period.seconds - 0.02) < 0.001)
    }

    @Test("Round-trip: duration -> frequency -> duration")
    func roundTripDurationFrequency() {
        let originalPeriod = Duration(0.001, unit: .seconds)  // 1ms = 1kHz
        let frequency = originalPeriod.asFrequency
        let calculatedPeriod = frequency.asPeriod
        #expect(abs(originalPeriod.seconds - calculatedPeriod.seconds) < 0.0000001)
    }

    @Test("Round-trip: frequency -> duration -> frequency")
    func roundTripFrequencyDuration() {
        let originalFrequency = Frequency(440, unit: .hertz)  // A4 note
        let period = originalFrequency.asPeriod
        let calculatedFrequency = period.asFrequency
        #expect(abs(originalFrequency.hertz - calculatedFrequency.hertz) < 0.001)
    }

    // MARK: - Angle = Frequency × Time (ω = 2πf × t)

    @Test("Frequency times time equals angle")
    func frequencyTimesTime() {
        let frequency = Frequency(1, unit: .hertz)  // 1 Hz
        let time = Duration(1, unit: .seconds)
        let angle: Angle = frequency * time
        // 1 Hz × 1 s = 1 cycle = 2π radians
        #expect(abs(angle.radians - 2 * .pi) < 0.001)
    }

    @Test("Time times frequency equals angle (commutative)")
    func timeTimesFrequency() {
        let frequency = Frequency(0.5, unit: .hertz)  // 0.5 Hz
        let time = Duration(2, unit: .seconds)
        let angle: Angle = time * frequency
        // 0.5 Hz × 2 s = 1 cycle = 2π radians
        #expect(abs(angle.radians - 2 * .pi) < 0.001)
    }

    @Test("Multiple cycles accumulate angle correctly")
    func multipleCyclesAngle() {
        let frequency = Frequency(10, unit: .hertz)  // 10 Hz
        let time = Duration(0.5, unit: .seconds)
        let angle: Angle = frequency * time
        // 10 Hz × 0.5 s = 5 cycles = 10π radians
        #expect(abs(angle.radians - 10 * .pi) < 0.001)
    }

    // MARK: - Practical examples

    @Test("AC power frequency (50 Hz)")
    func acPowerFrequency50Hz() {
        let frequency = Frequency(50, unit: .hertz)
        let period = frequency.asPeriod
        #expect(abs(period.milliseconds - 20) < 0.001)
    }

    @Test("AC power frequency (60 Hz)")
    func acPowerFrequency60Hz() {
        let frequency = Frequency(60, unit: .hertz)
        let period = frequency.asPeriod
        #expect(abs(period.milliseconds - 16.6667) < 0.001)
    }

    @Test("Musical note A4 (440 Hz)")
    func musicalNoteA4() {
        let frequency = Frequency(440, unit: .hertz)
        let period = frequency.asPeriod
        #expect(abs(period.milliseconds - 2.2727) < 0.001)
    }

    @Test("Radio frequency (FM band)")
    func radioFrequencyFM() {
        let frequency = Frequency(100, unit: .megahertz)
        let period = frequency.asPeriod
        // 100 MHz = 10^8 Hz, period = 10^-8 s = 10 ns
        #expect(abs(period.seconds - 1e-8) < 1e-12)
    }

    @Test("CPU clock frequency")
    func cpuClockFrequency() {
        let frequency = Frequency(3, unit: .gigahertz)
        let period = frequency.asPeriod
        // 3 GHz = 3×10^9 Hz, period ≈ 0.333 ns
        #expect(abs(period.seconds - 1.0 / 3e9) < 1e-15)
    }

    // MARK: - Angular velocity calculation

    @Test("Angular displacement over time")
    func angularDisplacementOverTime() {
        // Motor spinning at 60 RPM = 1 Hz
        let frequency = Frequency(1, unit: .hertz)
        let time = Duration(10, unit: .seconds)
        let angle: Angle = frequency * time
        // 10 complete rotations = 20π radians
        #expect(abs(angle.radians - 20 * .pi) < 0.001)
        // Also 10 × 360° = 3600°
        #expect(abs(angle.degrees - 3600) < 0.1)
    }

    @Test("Quarter cycle timing")
    func quarterCycleTiming() {
        let frequency = Frequency(4, unit: .hertz)  // 4 Hz
        let quarterPeriod = Duration(0.0625, unit: .seconds)  // 1/16 s
        let angle: Angle = frequency * quarterPeriod
        // 4 Hz × 0.0625 s = 0.25 cycles = π/2 radians = 90°
        #expect(abs(angle.radians - .pi / 2) < 0.001)
        #expect(abs(angle.degrees - 90) < 0.01)
    }
}
