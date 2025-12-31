import Foundation
import Testing
@testable import PhysicalUnits

@Suite("Temperature Tests")
struct TemperatureTests {
    // MARK: - Basic Conversions

    @Test("Celsius to Kelvin conversion")
    func celsiusToKelvin() {
        let temp = Temperature(0, unit: .celsius)
        #expect(abs(temp.kelvin - 273.15) < 0.01)
    }

    @Test("Kelvin to Celsius conversion")
    func kelvinToCelsius() {
        let temp = Temperature(273.15, unit: .kelvin)
        #expect(abs(temp.celsius - 0) < 0.01)
    }

    @Test("Celsius to Fahrenheit conversion")
    func celsiusToFahrenheit() {
        let temp = Temperature(100, unit: .celsius)
        #expect(abs(temp.fahrenheit - 212) < 0.01)
    }

    @Test("Fahrenheit to Celsius conversion")
    func fahrenheitToCelsius() {
        let temp = Temperature(32, unit: .fahrenheit)
        #expect(abs(temp.celsius - 0) < 0.01)
    }

    @Test("Body temperature conversion")
    func bodyTemperature() {
        let temp = Temperature(37, unit: .celsius)
        #expect(abs(temp.fahrenheit - 98.6) < 0.1)
    }

    // MARK: - Special Values

    @Test("Absolute zero")
    func absoluteZero() {
        #expect(Temperature.absoluteZero.kelvin == 0)
        #expect(abs(Temperature.absoluteZero.celsius - (-273.15)) < 0.01)
    }

    @Test("Water freezing point")
    func waterFreezingPoint() {
        #expect(abs(Temperature.waterFreezingPoint.celsius - 0) < 0.01)
        #expect(abs(Temperature.waterFreezingPoint.fahrenheit - 32) < 0.01)
    }

    @Test("Water boiling point")
    func waterBoilingPoint() {
        #expect(abs(Temperature.waterBoilingPoint.celsius - 100) < 0.01)
        #expect(abs(Temperature.waterBoilingPoint.fahrenheit - 212) < 0.01)
    }

    // MARK: - Temperature Delta

    @Test("Temperature delta Celsius")
    func temperatureDeltaCelsius() {
        let delta = TemperatureDelta(10, unit: .celsius)
        #expect(delta.celsius == 10)
        #expect(delta.kelvin == 10)
    }

    @Test("Temperature delta Fahrenheit")
    func temperatureDeltaFahrenheit() {
        let delta = TemperatureDelta(18, unit: .fahrenheit)
        #expect(abs(delta.celsius - 10) < 0.01)
    }

    @Test("Temperature addition with delta")
    func temperatureAddition() {
        let temp = Temperature(20, unit: .celsius)
        let delta = TemperatureDelta(5, unit: .celsius)
        let result = temp + delta
        #expect(abs(result.celsius - 25) < 0.01)
    }

    @Test("Temperature subtraction")
    func temperatureSubtraction() {
        let temp1 = Temperature(30, unit: .celsius)
        let temp2 = Temperature(20, unit: .celsius)
        let delta = temp1 - temp2
        #expect(abs(delta.celsius - 10) < 0.01)
    }

    // MARK: - Comparison

    @Test("Temperature comparison")
    func temperatureComparison() {
        let hot = Temperature(100, unit: .celsius)
        let cold = Temperature(0, unit: .celsius)
        #expect(hot > cold)
        #expect(cold < hot)
    }

    // MARK: - Codable

    @Test("Temperature is Codable")
    func temperatureCodable() throws {
        let original = Temperature(25, unit: .celsius)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Temperature.self, from: encoded)
        #expect(abs(original.kelvin - decoded.kelvin) < 0.001)
    }
}
