import Foundation
import Testing
@testable import PhysicalUnits

@Suite("MetricPrefix Tests")
struct MetricPrefixTests {

    // MARK: - Factor Tests

    @Test("Factor values are correct")
    func factorValues() {
        #expect(MetricPrefix.peta.factor == 1e15)
        #expect(MetricPrefix.tera.factor == 1e12)
        #expect(MetricPrefix.giga.factor == 1e9)
        #expect(MetricPrefix.mega.factor == 1e6)
        #expect(MetricPrefix.kilo.factor == 1e3)
        #expect(MetricPrefix.hecto.factor == 1e2)
        #expect(MetricPrefix.deca.factor == 1e1)
        #expect(MetricPrefix.base.factor == 1)
        #expect(MetricPrefix.deci.factor == 1e-1)
        #expect(MetricPrefix.centi.factor == 1e-2)
        #expect(MetricPrefix.milli.factor == 1e-3)
        #expect(MetricPrefix.micro.factor == 1e-6)
        #expect(MetricPrefix.nano.factor == 1e-9)
        #expect(MetricPrefix.pico.factor == 1e-12)
        #expect(MetricPrefix.femto.factor == 1e-15)
    }

    @Test("Factor equals rawValue for performance")
    func factorEqualsRawValue() {
        for prefix in MetricPrefix.allCases {
            #expect(prefix.factor == prefix.rawValue)
        }
    }

    // MARK: - Symbol Tests

    @Test("Symbol values are correct")
    func symbolValues() {
        #expect(MetricPrefix.peta.symbol == "P")
        #expect(MetricPrefix.tera.symbol == "T")
        #expect(MetricPrefix.giga.symbol == "G")
        #expect(MetricPrefix.mega.symbol == "M")
        #expect(MetricPrefix.kilo.symbol == "k")
        #expect(MetricPrefix.hecto.symbol == "h")
        #expect(MetricPrefix.deca.symbol == "da")
        #expect(MetricPrefix.base.symbol == "")
        #expect(MetricPrefix.deci.symbol == "d")
        #expect(MetricPrefix.centi.symbol == "c")
        #expect(MetricPrefix.milli.symbol == "m")
        #expect(MetricPrefix.micro.symbol == "μ")
        #expect(MetricPrefix.nano.symbol == "n")
        #expect(MetricPrefix.pico.symbol == "p")
        #expect(MetricPrefix.femto.symbol == "f")
    }

    // MARK: - Exponent Tests

    @Test("Exponent values are correct")
    func exponentValues() {
        #expect(MetricPrefix.kilo.exponent == 3)
        #expect(MetricPrefix.base.exponent == 0)
        #expect(MetricPrefix.milli.exponent == -3)
        #expect(MetricPrefix.micro.exponent == -6)
    }

    // MARK: - Codable Tests

    @Test("Prefix is Codable")
    func codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let original = MetricPrefix.kilo
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(MetricPrefix.self, from: data)

        #expect(decoded == original)
    }

    // MARK: - Hashable Tests

    @Test("Prefix is Hashable")
    func hashable() {
        var set = Set<MetricPrefix>()
        set.insert(.kilo)
        set.insert(.milli)
        set.insert(.kilo)  // duplicate

        #expect(set.count == 2)
    }
}
