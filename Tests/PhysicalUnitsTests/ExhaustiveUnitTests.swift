import Foundation
import Testing
@testable import PhysicalUnits

/// Properties asserted over every case of every unit type, and over a swept domain for every
/// formatter, rather than over the handful of examples someone happened to think of.
///
/// A units library is a closed set of pure functions, so the whole domain can be enumerated.
/// The checks here are derived from the ways this package can fail — a case that converts as
/// another one, a formatter branch no input reaches, an input that traps — rather than
/// generalized from the bugs already found.
@Suite("Exhaustive Unit Properties")
struct ExhaustiveUnitTests {

    // MARK: - Conversion Properties

    /// Values fed through every unit of every dimension. They span the range a `Double` holds
    /// comfortably in both directions, so a coefficient that overflows or flushes to zero on
    /// the way through shows up as a broken round trip.
    static let conversionProbes: [Double] = [0, 1, -1, 2.5, -1234.5678, 1e-6, 1e6, -1e9]

    private func expectRoundTrips<U: PhysicalUnits.Unit & CaseIterable>(_ type: U.Type, _ name: String) {
        let units = Array(U.allCases)
        #expect(!units.isEmpty, "\(name) enumerates no cases")

        for unit in units {
            let coefficient = unit.coefficientToBase
            #expect(
                coefficient.isFinite && coefficient > 0,
                "\(name).\(unit.symbol) converts by \(coefficient), which is not a usable scale"
            )
            #expect(!unit.symbol.isEmpty, "\(name) has a case with no symbol")

            // Through the base unit and back: this is the whole of what `Measurement` does.
            for probe in Self.conversionProbes {
                let stored = Measurement<U>(probe, unit: unit)
                #expect(
                    isClose(stored.value(in: unit), probe),
                    "\(name).\(unit.symbol): \(probe) came back as \(stored.value(in: unit))"
                )
            }
        }

        // Every ordered pair, so a coefficient that is right against the base but wrong against
        // its neighbours still fails.
        for from in units {
            for to in units {
                let there = Measurement<U>(1, unit: from).value(in: to)
                let back = Measurement<U>(there, unit: to).value(in: from)
                #expect(
                    isClose(back, 1),
                    "\(name): 1 \(from.symbol) -> \(to.symbol) -> \(from.symbol) gave \(back)"
                )
            }
        }
    }

    /// Two cases that convert by the same factor are the same unit under two names: one of them
    /// is silently doing the other's job. Where a package declares fewer distinct factors than
    /// cases, the coincidence is a fact about the scales and is named at the call site.
    private func expectCasesAreDistinct<U: PhysicalUnits.Unit & CaseIterable>(
        _ type: U.Type,
        _ name: String,
        distinctCoefficients: Int
    ) {
        let units = Array(U.allCases)
        #expect(
            Set(units.map(\.symbol)).count == units.count,
            "\(name) has \(units.count) cases but only \(Set(units.map(\.symbol)).count) symbols"
        )
        #expect(
            Set(units.map(\.coefficientToBase)).count == distinctCoefficients,
            "\(name) has \(Set(units.map(\.coefficientToBase)).count) distinct coefficients, expected \(distinctCoefficients)"
        )
    }

    @Test("Every unit of every dimension round-trips through its base unit")
    func everyUnitRoundTrips() {
        expectRoundTrips(AccelerationUnit.self, "AccelerationUnit")
        expectRoundTrips(AngleUnit.self, "AngleUnit")
        expectRoundTrips(AngularSpeedUnit.self, "AngularSpeedUnit")
        expectRoundTrips(AreaUnit.self, "AreaUnit")
        expectRoundTrips(ForceUnit.self, "ForceUnit")
        expectRoundTrips(PowerUnit.self, "PowerUnit")
        expectRoundTrips(PressureUnit.self, "PressureUnit")
        expectRoundTrips(SpeedUnit.self, "SpeedUnit")
        expectRoundTrips(TemperatureUnit.self, "TemperatureUnit")
        expectRoundTrips(EnergyUnit.self, "EnergyUnit")
        expectRoundTrips(TimeUnit.self, "TimeUnit")
        expectRoundTrips(LengthUnit.self, "LengthUnit")
        expectRoundTrips(MassUnit.self, "MassUnit")
        expectRoundTrips(VolumeUnit.self, "VolumeUnit")
        expectRoundTrips(ChargeUnit.self, "ChargeUnit")
        expectRoundTrips(CurrentUnit.self, "CurrentUnit")
        expectRoundTrips(VoltageUnit.self, "VoltageUnit")
        expectRoundTrips(ResistanceUnit.self, "ResistanceUnit")
        expectRoundTrips(FrequencyUnit.self, "FrequencyUnit")
    }

    @Test("No unit silently converts as another unit of the same dimension")
    func everyUnitIsDistinct() {
        expectCasesAreDistinct(AccelerationUnit.self, "AccelerationUnit", distinctCoefficients: 4)
        expectCasesAreDistinct(AngleUnit.self, "AngleUnit", distinctCoefficients: 4)
        expectCasesAreDistinct(AngularSpeedUnit.self, "AngularSpeedUnit", distinctCoefficients: 4)
        expectCasesAreDistinct(AreaUnit.self, "AreaUnit", distinctCoefficients: 7)
        expectCasesAreDistinct(ForceUnit.self, "ForceUnit", distinctCoefficients: 7)
        expectCasesAreDistinct(PowerUnit.self, "PowerUnit", distinctCoefficients: 7)
        expectCasesAreDistinct(SpeedUnit.self, "SpeedUnit", distinctCoefficients: 4)
        expectCasesAreDistinct(EnergyUnit.self, "EnergyUnit", distinctCoefficients: 30)
        expectCasesAreDistinct(TimeUnit.self, "TimeUnit", distinctCoefficients: 18)
        expectCasesAreDistinct(LengthUnit.self, "LengthUnit", distinctCoefficients: 15)
        expectCasesAreDistinct(MassUnit.self, "MassUnit", distinctCoefficients: 15)
        expectCasesAreDistinct(VolumeUnit.self, "VolumeUnit", distinctCoefficients: 15)
        expectCasesAreDistinct(ChargeUnit.self, "ChargeUnit", distinctCoefficients: 15)
        expectCasesAreDistinct(CurrentUnit.self, "CurrentUnit", distinctCoefficients: 15)
        expectCasesAreDistinct(VoltageUnit.self, "VoltageUnit", distinctCoefficients: 15)
        expectCasesAreDistinct(ResistanceUnit.self, "ResistanceUnit", distinctCoefficients: 15)
        expectCasesAreDistinct(FrequencyUnit.self, "FrequencyUnit", distinctCoefficients: 15)

        // 1 mbar is 1 hPa by definition, so those two share a coefficient and nothing is wrong.
        expectCasesAreDistinct(PressureUnit.self, "PressureUnit", distinctCoefficients: 8)
        #expect(PressureUnit.millibars.coefficientToBase == PressureUnit.hectopascals.coefficientToBase)

        // A 1 °C difference is a 1 K difference, so those two share a coefficient. The offset
        // that separates the scales lives in `Temperature`, not in the coefficient.
        expectCasesAreDistinct(TemperatureUnit.self, "TemperatureUnit", distinctCoefficients: 2)
        #expect(TemperatureUnit.celsius.coefficientToBase == TemperatureUnit.kelvin.coefficientToBase)
    }

    @Test("Every metric unit's coefficient is its prefix's factor")
    func metricUnitsFollowTheirPrefix() {
        for prefix in MetricPrefix.allCases {
            #expect(LengthUnit(prefix).coefficientToBase == prefix.factor)
            #expect(MassUnit(prefix).coefficientToBase == prefix.factor)
            #expect(LengthUnit(prefix).symbol == prefix.symbol + "m")
            #expect(EnergyUnit.joules(prefix).coefficientToBase == prefix.factor)
            #expect(TimeUnit.seconds(prefix).coefficientToBase == prefix.factor)
        }
        #expect(Set(MetricPrefix.allCases.map(\.factor)).count == MetricPrefix.allCases.count)
        #expect(Set(MetricPrefix.allCases.map(\.exponent)).count == MetricPrefix.allCases.count)
        for prefix in MetricPrefix.allCases {
            #expect(isClose(pow(10, Double(prefix.exponent)), prefix.factor))
        }
    }

    // MARK: - Formatting Properties

    /// A formatter, the units it declares in its own branches, and a way to feed it a base-unit
    /// value. `expectedUnits` is read off the source, not off the output — a branch that no
    /// input reaches is exactly the failure this is here to catch.
    private struct FormatterUnderTest: Sendable {
        let name: String
        let expectedUnits: Set<String>
        let render: @Sendable (Double) -> String
    }

    /// A sweep wide enough to land in every band of every ladder, plus the values that break
    /// formatters: both zeroes, both infinities, a NaN, and the extremes of `Double`.
    static let formattingProbes: [Double] = {
        var probes: [Double] = [0, -0.0, .infinity, -.infinity, .nan,
                                .greatestFiniteMagnitude, -.greatestFiniteMagnitude,
                                .leastNonzeroMagnitude, .leastNormalMagnitude]
        for exponent in -30...30 {
            for mantissa in [1.0, 3.7, 9.99] {
                let magnitude = mantissa * pow(10, Double(exponent))
                probes.append(magnitude)
                probes.append(-magnitude)
            }
        }
        return probes
    }()

    private static let formatters: [FormatterUnderTest] = [
        FormatterUnderTest(name: "Acceleration.formatted",
                           expectedUnits: ["g", "m/s²", "Gal", "mGal"],
                           render: { Acceleration(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Length.formatted",
                           expectedUnits: ["km", "m", "cm", "mm", "μm"],
                           render: { Length(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Mass.formatted",
                           expectedUnits: ["t", "kg", "g", "mg", "μg"],
                           render: { Mass(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Duration.formatted",
                           expectedUnits: ["d", "h", "min", "s", "ms", "μs"],
                           render: { Duration(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Speed.formatted",
                           expectedUnits: ["km/h", "m/s"],
                           render: { Speed(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Area.formatted",
                           expectedUnits: ["km²", "ha", "m²", "cm²", "mm²"],
                           render: { Area(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Volume.formatted",
                           expectedUnits: ["kL", "L", "mL", "μL"],
                           render: { Volume(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Force.formatted",
                           expectedUnits: ["MN", "kN", "N", "mN"],
                           render: { Force(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Pressure.formatted",
                           expectedUnits: ["MPa", "bar", "kPa", "hPa", "Pa"],
                           render: { Pressure(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Power.formatted",
                           expectedUnits: ["GW", "MW", "kW", "W", "mW"],
                           render: { Power(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Frequency.formatted",
                           expectedUnits: ["THz", "GHz", "MHz", "kHz", "Hz", "mHz"],
                           render: { Frequency(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Current.formatted",
                           expectedUnits: ["kA", "A", "mA", "μA", "nA"],
                           render: { Current(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Voltage.formatted",
                           expectedUnits: ["MV", "kV", "V", "mV", "μV"],
                           render: { Voltage(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Resistance.formatted",
                           expectedUnits: ["GΩ", "MΩ", "kΩ", "Ω", "mΩ"],
                           render: { Resistance(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Charge.formatted",
                           expectedUnits: ["kC", "C", "mC", "μC", "nC"],
                           render: { Charge(baseValue: $0).formatted }),
        FormatterUnderTest(name: "AngularSpeed.formatted",
                           expectedUnits: ["rpm", "rad/s"],
                           render: { AngularSpeed(baseValue: $0).formatted }),
        FormatterUnderTest(name: "Energy.formattedCalories",
                           expectedUnits: ["Mcal", "kcal", "cal"],
                           render: { Energy(baseValue: $0).formattedCalories }),
        FormatterUnderTest(name: "Energy.formattedJoules",
                           expectedUnits: ["MJ", "kJ", "J"],
                           render: { Energy(baseValue: $0).formattedJoules })
    ]

    @Test("Every formatter reaches every unit it declares a branch for")
    func everyFormatterBranchIsReachable() {
        for formatter in Self.formatters {
            var reached = Set<String>()
            for probe in Self.formattingProbes {
                if let unit = formatter.render(probe).split(separator: " ").last {
                    reached.insert(String(unit))
                }
            }
            #expect(
                reached == formatter.expectedUnits,
                "\(formatter.name) reached \(reached.sorted()), declares \(formatter.expectedUnits.sorted())"
            )
        }
    }

    @Test("Every formatter is total: no value in the domain traps or returns nothing")
    func everyFormatterIsTotal() {
        for formatter in Self.formatters {
            for probe in Self.formattingProbes {
                // A trap here takes the whole run down, which is the assertion.
                #expect(!formatter.render(probe).isEmpty, "\(formatter.name) rendered \(probe) as empty")
            }
        }

        for probe in Self.formattingProbes {
            #expect(!Angle(baseValue: probe).formattedDegrees.isEmpty)
            #expect(!Angle(baseValue: probe).formattedRadians.isEmpty)
            #expect(!Temperature(kelvinValue: probe).formattedCelsius.isEmpty)
            #expect(!Temperature(kelvinValue: probe).formattedFahrenheit.isEmpty)
            #expect(!Temperature(kelvinValue: probe).formattedKelvin.isEmpty)
            #expect(!Measurement<LengthUnit>(baseValue: probe).description.isEmpty)

            let hms = Duration(baseValue: probe).formattedHMS
            #expect(hms == nil || hms?.isEmpty == false)
            #expect((hms == nil) == !probe.isFinite, "formattedHMS disagreed with isFinite at \(probe)")
        }
    }

    @Test("Every formatter picks the same unit for a value and its negation")
    func everyFormatterIsSignSymmetric() {
        for formatter in Self.formatters {
            for probe in Self.formattingProbes where probe.isFinite && probe != 0 {
                let positive = formatter.render(abs(probe))
                let negative = formatter.render(-abs(probe))
                #expect(
                    positive.split(separator: " ").last == negative.split(separator: " ").last,
                    "\(formatter.name) picked different units for ±\(abs(probe)): \(positive) / \(negative)"
                )
            }
        }
    }

    @Test("Every formatter renders zero in its smallest unit, unsigned")
    func everyFormatterHandlesZero() {
        for formatter in Self.formatters {
            let zero = formatter.render(0)
            #expect(!zero.hasPrefix("-"), "\(formatter.name) signed a positive zero")

            // A negative zero keeps its sign, because `String(format:)` reads the sign bit and
            // this package does not second-guess it: -0.0 renders "-0.00 mΩ". Only the unit has
            // to agree between the two zeroes, since a signed zero is still a zero quantity.
            #expect(
                zero.split(separator: " ").last == formatter.render(-0.0).split(separator: " ").last,
                "\(formatter.name) picked different units for the two zeroes"
            )
        }

        // `formattedHMS` builds its own sign rather than going through `String(format:)` for the
        // whole value, so it signs only what it displays as nonzero: both zeroes read "0:00",
        // and so does anything that truncates to zero.
        #expect(Duration(baseValue: 0).formattedHMS == "0:00")
        #expect(Duration(baseValue: -0.0).formattedHMS == "0:00")
        #expect(Duration(-0.9, unit: .seconds).formattedHMS == "0:00")
    }
}

// MARK: - Helpers

private func isClose(_ lhs: Double, _ rhs: Double, relativeTolerance: Double = 1e-12) -> Bool {
    if lhs == rhs { return true }
    guard lhs.isFinite, rhs.isFinite else { return false }
    return abs(lhs - rhs) <= relativeTolerance * max(abs(lhs), abs(rhs))
}
