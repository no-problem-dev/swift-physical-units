import Foundation

/// 温度の単位
///
/// 温度は他の物理量と異なり、単純な倍率変換ではなく
/// オフセット変換が必要です（摂氏・華氏）。
///
/// ## 変換式
/// - Kelvin → Celsius: °C = K - 273.15
/// - Kelvin → Fahrenheit: °F = K × 9/5 - 459.67
/// - Celsius → Kelvin: K = °C + 273.15
/// - Fahrenheit → Kelvin: K = (°F + 459.67) × 5/9
///
/// ## 使用例
/// ```swift
/// let bodyTemp = Temperature(37, unit: .celsius)
/// print(bodyTemp.fahrenheit)  // 98.6
/// print(bodyTemp.kelvin)      // 310.15
/// ```
@frozen
public enum TemperatureUnit: Unit, Codable, Sendable, Hashable {
    /// ケルビン（SI 基本単位）
    case kelvin

    /// 摂氏（セルシウス）
    case celsius

    /// 華氏（ファーレンハイト）
    case fahrenheit

    // MARK: - Constants

    /// 絶対零度からのオフセット（K to °C）
    public static let celsiusOffset: Double = 273.15

    /// 華氏のオフセット
    public static let fahrenheitOffset: Double = 459.67

    /// 華氏の倍率（K to °F）
    public static let fahrenheitScale: Double = 9.0 / 5.0

    // MARK: - Unit Protocol

    /// 基準単位（ケルビン）への変換係数
    ///
    /// 温度は線形変換ではないため、この値は相対的な温度差の変換にのみ使用します。
    /// 絶対温度の変換には `Temperature` 型の専用メソッドを使用してください。
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .kelvin:
            return 1.0
        case .celsius:
            return 1.0  // 1°C の差 = 1K の差
        case .fahrenheit:
            return 5.0 / 9.0  // 1°F の差 = 5/9 K の差
        }
    }

    /// 単位記号
    public var symbol: String {
        switch self {
        case .kelvin:
            return "K"
        case .celsius:
            return "°C"
        case .fahrenheit:
            return "°F"
        }
    }
}

// MARK: - CustomStringConvertible

extension TemperatureUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Temperature Type

/// 温度
///
/// 絶対温度を表現する型。内部ではケルビン (K) で値を保持します。
/// 温度は他の物理量と異なり、オフセット変換が必要なため専用の型として実装しています。
///
/// ## 使用例
/// ```swift
/// let room = Temperature(20, unit: .celsius)
/// print(room.kelvin)      // 293.15
/// print(room.fahrenheit)  // 68.0
///
/// let boiling = Temperature(100, unit: .celsius)
/// print(boiling.kelvin)   // 373.15
/// ```
@frozen
public struct Temperature: Sendable, Hashable, Comparable, Codable {
    /// ケルビンでの内部値
    @usableFromInline
    internal let kelvinValue: Double

    // MARK: - Initializers

    /// 指定単位で初期化
    ///
    /// - Parameters:
    ///   - value: 温度値
    ///   - unit: 単位
    @inlinable
    public init(_ value: Double, unit: TemperatureUnit) {
        switch unit {
        case .kelvin:
            self.kelvinValue = value
        case .celsius:
            self.kelvinValue = value + TemperatureUnit.celsiusOffset
        case .fahrenheit:
            self.kelvinValue = (value + TemperatureUnit.fahrenheitOffset) / TemperatureUnit.fahrenheitScale
        }
    }

    /// ケルビン値で直接初期化（内部使用）
    @usableFromInline
    internal init(kelvinValue: Double) {
        self.kelvinValue = kelvinValue
    }

    // MARK: - Value Access

    /// 指定単位で値を取得
    @inlinable
    public func value(in unit: TemperatureUnit) -> Double {
        switch unit {
        case .kelvin:
            return kelvinValue
        case .celsius:
            return kelvinValue - TemperatureUnit.celsiusOffset
        case .fahrenheit:
            return kelvinValue * TemperatureUnit.fahrenheitScale - TemperatureUnit.fahrenheitOffset
        }
    }

    /// ケルビン単位で値を取得
    @inlinable
    public var kelvin: Double {
        value(in: .kelvin)
    }

    /// 摂氏単位で値を取得
    @inlinable
    public var celsius: Double {
        value(in: .celsius)
    }

    /// 華氏単位で値を取得
    @inlinable
    public var fahrenheit: Double {
        value(in: .fahrenheit)
    }

    // MARK: - Comparable

    @inlinable
    public static func < (lhs: Temperature, rhs: Temperature) -> Bool {
        lhs.kelvinValue < rhs.kelvinValue
    }

    // MARK: - Arithmetic (温度差の演算)

    /// 温度差の加算
    @inlinable
    public static func + (lhs: Temperature, rhs: TemperatureDelta) -> Temperature {
        Temperature(kelvinValue: lhs.kelvinValue + rhs.kelvinDelta)
    }

    /// 温度差の減算
    @inlinable
    public static func - (lhs: Temperature, rhs: TemperatureDelta) -> Temperature {
        Temperature(kelvinValue: lhs.kelvinValue - rhs.kelvinDelta)
    }

    /// 温度間の差を計算
    @inlinable
    public static func - (lhs: Temperature, rhs: Temperature) -> TemperatureDelta {
        TemperatureDelta(kelvinDelta: lhs.kelvinValue - rhs.kelvinValue)
    }

    // MARK: - Codable

    private enum CodingKeys: String, CodingKey {
        case kelvinValue
    }

    // MARK: - Special Values

    /// 絶対零度
    public static let absoluteZero = Temperature(0, unit: .kelvin)

    /// 水の凝固点（標準気圧）
    public static let waterFreezingPoint = Temperature(0, unit: .celsius)

    /// 水の沸点（標準気圧）
    public static let waterBoilingPoint = Temperature(100, unit: .celsius)

    /// 人体の標準体温
    public static let bodyTemperature = Temperature(37, unit: .celsius)
}

// MARK: - Temperature Formatting

extension Temperature {
    /// 摂氏でフォーマット
    public var formattedCelsius: String {
        String(format: "%.1f°C", celsius)
    }

    /// 華氏でフォーマット
    public var formattedFahrenheit: String {
        String(format: "%.1f°F", fahrenheit)
    }

    /// ケルビンでフォーマット
    public var formattedKelvin: String {
        String(format: "%.2f K", kelvin)
    }
}

// MARK: - TemperatureDelta

/// 温度差
///
/// 2つの温度間の差を表す型。温度差は線形的に扱えます。
@frozen
public struct TemperatureDelta: Sendable, Hashable, Comparable, Codable, AdditiveArithmetic {
    /// ケルビンでの温度差
    @usableFromInline
    internal let kelvinDelta: Double

    /// 指定単位で初期化
    @inlinable
    public init(_ value: Double, unit: TemperatureUnit) {
        self.kelvinDelta = value * unit.coefficientToBase
    }

    /// ケルビン値で直接初期化（内部使用）
    @usableFromInline
    internal init(kelvinDelta: Double) {
        self.kelvinDelta = kelvinDelta
    }

    /// 指定単位で値を取得
    @inlinable
    public func value(in unit: TemperatureUnit) -> Double {
        kelvinDelta / unit.coefficientToBase
    }

    /// ケルビンでの温度差
    @inlinable
    public var kelvin: Double { kelvinDelta }

    /// 摂氏での温度差
    @inlinable
    public var celsius: Double { kelvinDelta }

    /// 華氏での温度差
    @inlinable
    public var fahrenheit: Double { kelvinDelta * TemperatureUnit.fahrenheitScale }

    // MARK: - Comparable

    @inlinable
    public static func < (lhs: TemperatureDelta, rhs: TemperatureDelta) -> Bool {
        lhs.kelvinDelta < rhs.kelvinDelta
    }

    // MARK: - AdditiveArithmetic

    @inlinable
    public static var zero: TemperatureDelta {
        TemperatureDelta(kelvinDelta: 0)
    }

    @inlinable
    public static func + (lhs: TemperatureDelta, rhs: TemperatureDelta) -> TemperatureDelta {
        TemperatureDelta(kelvinDelta: lhs.kelvinDelta + rhs.kelvinDelta)
    }

    @inlinable
    public static func - (lhs: TemperatureDelta, rhs: TemperatureDelta) -> TemperatureDelta {
        TemperatureDelta(kelvinDelta: lhs.kelvinDelta - rhs.kelvinDelta)
    }
}
