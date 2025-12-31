import Foundation

/// 速度の単位
///
/// 速度は導出単位（長さ÷時間）であり、複数の慣用単位があります。
/// SI 基本単位はメートル毎秒 (m/s) です。
///
/// ## 変換係数（→ m/s）
/// - km/h: 1 km/h = 1000/3600 m/s ≈ 0.2778 m/s
/// - mph: 1 mph = 1609.344/3600 m/s ≈ 0.4470 m/s
/// - knot: 1 knot = 1852/3600 m/s ≈ 0.5144 m/s
///
/// ## 使用例
/// ```swift
/// let running = Speed(10, unit: .kilometersPerHour)
/// print(running.metersPerSecond)  // 2.778
///
/// let wind = Speed(20, unit: .knots)
/// print(wind.kilometersPerHour)   // 37.04
/// ```
@frozen
public enum SpeedUnit: Unit, Codable, Sendable, Hashable {
    /// メートル毎秒 (m/s) - SI 基本単位
    case metersPerSecond

    /// キロメートル毎時 (km/h)
    case kilometersPerHour

    /// マイル毎時 (mph)
    case milesPerHour

    /// ノット (knot) - 海里毎時
    case knots

    // MARK: - Constants

    /// km/h → m/s 変換係数
    public static let kmhToMs: Double = 1000.0 / 3600.0

    /// mph → m/s 変換係数（1 mile = 1609.344 m）
    public static let mphToMs: Double = 1609.344 / 3600.0

    /// knot → m/s 変換係数（1 nautical mile = 1852 m）
    public static let knotToMs: Double = 1852.0 / 3600.0

    // MARK: - Unit Protocol

    /// 基準単位（m/s）への変換係数
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .metersPerSecond:
            return 1.0
        case .kilometersPerHour:
            return Self.kmhToMs
        case .milesPerHour:
            return Self.mphToMs
        case .knots:
            return Self.knotToMs
        }
    }

    /// 単位記号
    public var symbol: String {
        switch self {
        case .metersPerSecond:
            return "m/s"
        case .kilometersPerHour:
            return "km/h"
        case .milesPerHour:
            return "mph"
        case .knots:
            return "kn"
        }
    }
}

// MARK: - CustomStringConvertible

extension SpeedUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Speed Type Alias

/// 速度
///
/// `Measurement<SpeedUnit>` の型エイリアス。
/// 速度を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let car = Speed(100, unit: .kilometersPerHour)
/// print(car.metersPerSecond)  // 27.78
///
/// let plane = Speed(500, unit: .knots)
/// print(plane.kilometersPerHour)  // 926.0
/// ```
public typealias Speed = Measurement<SpeedUnit>

// MARK: - Speed Convenience Accessors

extension Speed {
    /// メートル毎秒単位で値を取得
    @inlinable
    public var metersPerSecond: Double {
        value(in: .metersPerSecond)
    }

    /// キロメートル毎時単位で値を取得
    @inlinable
    public var kilometersPerHour: Double {
        value(in: .kilometersPerHour)
    }

    /// マイル毎時単位で値を取得
    @inlinable
    public var milesPerHour: Double {
        value(in: .milesPerHour)
    }

    /// ノット単位で値を取得
    @inlinable
    public var knots: Double {
        value(in: .knots)
    }
}

// MARK: - Speed Formatting

extension Speed {
    /// 適切な単位で自動フォーマット
    public var formatted: String {
        let ms = metersPerSecond
        if abs(ms) >= 100 {
            return String(format: "%.1f km/h", kilometersPerHour)
        } else if abs(ms) >= 1 {
            return String(format: "%.2f m/s", ms)
        } else {
            return String(format: "%.3f m/s", ms)
        }
    }
}

// MARK: - Speed Special Values

extension Speed {
    /// 光速 (真空中)
    public static let speedOfLight = Speed(299_792_458, unit: .metersPerSecond)

    /// 音速 (20°C の空気中)
    public static let speedOfSound = Speed(343, unit: .metersPerSecond)

    /// マッハ 1（音速）
    public static var mach1: Speed { speedOfSound }
}
