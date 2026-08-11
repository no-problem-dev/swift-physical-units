import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Duration Tests")
struct DurationTests {

    // MARK: - Initialization Tests

    @Test("Initialize with seconds")
    func initWithSeconds() {
        let duration = Duration(90, unit: .seconds)
        #expect(duration.seconds == 90)
        #expect(duration.minutes == 1.5)
    }

    @Test("Initialize with minutes")
    func initWithMinutes() {
        let duration = Duration(45, unit: .minutes)
        #expect(duration.minutes == 45)
        #expect(duration.seconds == 2700)
        #expect(duration.hours == 0.75)
    }

    @Test("Initialize with hours")
    func initWithHours() {
        let duration = Duration(2, unit: .hours)
        #expect(duration.hours == 2)
        #expect(duration.minutes == 120)
        #expect(duration.seconds == 7200)
    }

    @Test("Initialize with days")
    func initWithDays() {
        let duration = Duration(1, unit: .days)
        #expect(duration.days == 1)
        #expect(duration.hours == 24)
        #expect(duration.minutes == 1440)
        #expect(duration.seconds == 86400)
    }

    // MARK: - Small Unit Tests

    @Test("Initialize with milliseconds")
    func initWithMilliseconds() {
        let duration = Duration(1500, unit: .milliseconds)
        #expect(duration.milliseconds == 1500)
        #expect(duration.seconds == 1.5)
    }

    @Test("Initialize with microseconds")
    func initWithMicroseconds() {
        let duration = Duration(1_000_000, unit: .microseconds)
        #expect(duration.microseconds == 1_000_000)
        #expect(duration.seconds == 1)
    }

    // MARK: - Conversion Tests

    @Test("Convert between units")
    func conversion() {
        let duration = Duration(1, unit: .hours)
        #expect(duration.minutes == 60)
        #expect(duration.seconds == 3600)
        #expect(duration.milliseconds == 3_600_000)
    }

    // MARK: - Arithmetic Tests

    @Test("Addition")
    func addition() {
        let duration1 = Duration(30, unit: .minutes)
        let duration2 = Duration(1800, unit: .seconds)  // 30 minutes
        let result = duration1 + duration2
        #expect(result.hours == 1)
    }

    @Test("Subtraction")
    func subtraction() {
        let duration1 = Duration(1, unit: .hours)
        let duration2 = Duration(30, unit: .minutes)
        let result = duration1 - duration2
        #expect(result.minutes == 30)
    }

    // MARK: - Comparison Tests

    @Test("Comparison")
    func comparison() {
        let duration1 = Duration(1, unit: .hours)
        let duration2 = Duration(60, unit: .minutes)
        let duration3 = Duration(30, unit: .minutes)

        #expect(duration1 == duration2)
        #expect(duration1 > duration3)
        #expect(duration3 < duration1)
    }

    // MARK: - Zero Tests

    @Test("Zero duration")
    func zeroDuration() {
        let zero = Duration.zero
        #expect(zero.seconds == 0)
        #expect(zero.minutes == 0)
        #expect(zero.hours == 0)
    }

    // MARK: - Unit Symbol Tests

    @Test("TimeUnit symbols")
    func unitSymbols() {
        #expect(TimeUnit.seconds.symbol == "s")
        #expect(TimeUnit.milliseconds.symbol == "ms")
        #expect(TimeUnit.microseconds.symbol == "μs")
        #expect(TimeUnit.nanoseconds.symbol == "ns")
        #expect(TimeUnit.minutes.symbol == "min")
        #expect(TimeUnit.hours.symbol == "h")
        #expect(TimeUnit.days.symbol == "d")
    }

    // MARK: - Coefficient Tests

    @Test("TimeUnit coefficients")
    func coefficients() {
        #expect(TimeUnit.seconds.coefficientToBase == 1)
        #expect(TimeUnit.milliseconds.coefficientToBase == 0.001)
        #expect(TimeUnit.minutes.coefficientToBase == 60)
        #expect(TimeUnit.hours.coefficientToBase == 3600)
        #expect(TimeUnit.days.coefficientToBase == 86400)
    }

    // MARK: - Formatting Tests

    @Test("HMS formatting")
    func hmsFormatting() {
        let duration1 = Duration(90, unit: .minutes)
        #expect(duration1.formattedHMS == "1:30:00")

        let duration2 = Duration(65, unit: .seconds)
        #expect(duration2.formattedHMS == "1:05")

        let duration3 = Duration(3661, unit: .seconds)
        #expect(duration3.formattedHMS == "1:01:01")
    }

    @Test("HMS formatting signs the whole string, not each component")
    func hmsFormattingIsSignedOnce() {
        #expect(Duration(-90, unit: .seconds).formattedHMS == "-1:30")
        #expect(Duration(-59, unit: .seconds).formattedHMS == "-0:59")
        #expect(Duration(-3600, unit: .seconds).formattedHMS == "-1:00:00")
        #expect(Duration(-3661, unit: .seconds).formattedHMS == "-1:01:01")
    }

    @Test("HMS formatting at zero and at exactly one hour")
    func hmsFormattingBoundaries() {
        #expect(Duration(0, unit: .seconds).formattedHMS == "0:00")
        #expect(Duration(3599, unit: .seconds).formattedHMS == "59:59")
        #expect(Duration(3600, unit: .seconds).formattedHMS == "1:00:00")
        #expect(Duration(-0.4, unit: .seconds).formattedHMS == "0:00")

        // The hours field grows rather than wrapping into days, and rather than overflowing.
        #expect(Duration(1, unit: .days).formattedHMS == "24:00:00")
        #expect(Duration(359_999, unit: .seconds).formattedHMS == "99:59:59")
        #expect(Duration(1e18, unit: .seconds).formattedHMS == "277777777777777:46:40")
    }

    @Test("HMS formatting truncates toward zero in both directions")
    func hmsFormattingTruncatesTowardZero() {
        #expect(Duration(89.9, unit: .seconds).formattedHMS == "1:29")
        #expect(Duration(-89.9, unit: .seconds).formattedHMS == "-1:29")
    }

    @Test("HMS formatting has no answer for a non-finite duration")
    func hmsFormattingNonFinite() {
        // t = d / v with both at zero is the ordinary way a caller reaches a NaN duration.
        let stalled: Duration = Length(0, unit: .meters) / Speed(0, unit: .metersPerSecond)
        #expect(stalled.seconds.isNaN)
        #expect(stalled.formattedHMS == nil)

        let never: Duration = Length(100, unit: .meters) / Speed(0, unit: .metersPerSecond)
        #expect(never.seconds.isInfinite)
        #expect(never.formattedHMS == nil)
        #expect(Duration(-.infinity, unit: .seconds).formattedHMS == nil)
    }

    @Test("HMS formatting is total over every finite duration")
    func hmsFormattingIsTotal() {
        let probes: [Double] = [
            0, -0.0, 1, -1, 59.999, -59.999, 3600, -3600, 86_399, 86_400,
            1e9, -1e9, 1e18, -1e18, .greatestFiniteMagnitude, -.greatestFiniteMagnitude,
            .leastNormalMagnitude, -.leastNormalMagnitude, .leastNonzeroMagnitude
        ]
        for probe in probes {
            let rendered = Duration(probe, unit: .seconds).formattedHMS
            #expect(rendered?.isEmpty == false)
        }
    }

    @Test("Formatted output")
    func formattedOutput() {
        let duration = Duration(45, unit: .minutes)
        let formatted = duration.formatted

        #expect(formatted.contains("min"))
    }

    // MARK: - Codable Tests

    @Test("Duration is Codable")
    func codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let original = Duration(45, unit: .minutes)
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(Duration.self, from: data)

        #expect(decoded == original)
    }
}
