import Foundation

/// 角速度の単位
///
/// 角速度は角度の時間変化率で、ラジアン毎秒 (rad/s) が基本単位です。
/// ω = θ / t = 2πf
///
/// ## 変換関係
/// - 1 rad/s = 基準単位
/// - 1 deg/s = π/180 rad/s
/// - 1 rpm = 2π/60 rad/s ≈ 0.1047 rad/s
/// - 1 Hz = 2π rad/s（回転周波数として）
///
/// ## 使用例
/// ```swift
/// let motor = AngularSpeed(3000, unit: .rpm)
/// print(motor.radiansPerSecond)  // 314.159...
/// ```
@frozen
public enum AngularSpeedUnit: Unit, Codable, Sendable, Hashable {
    /// ラジアン毎秒 (rad/s) - 基本単位
    case radiansPerSecond

    /// 度毎秒 (°/s)
    case degreesPerSecond

    /// 回転毎分 (rpm)
    case revolutionsPerMinute

    /// 回転毎秒 (rps) = Hz
    case revolutionsPerSecond

    // MARK: - Constants

    /// 度 → ラジアン 変換係数
    public static let degreesToRadians: Double = .pi / 180.0

    /// rpm → rad/s 変換係数
    public static let rpmToRadPerSec: Double = 2.0 * .pi / 60.0

    /// rps → rad/s 変換係数
    public static let rpsToRadPerSec: Double = 2.0 * .pi

    // MARK: - Unit Protocol

    /// 基準単位（rad/s）への変換係数
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .radiansPerSecond:
            return 1.0
        case .degreesPerSecond:
            return Self.degreesToRadians
        case .revolutionsPerMinute:
            return Self.rpmToRadPerSec
        case .revolutionsPerSecond:
            return Self.rpsToRadPerSec
        }
    }

    /// 単位記号
    public var symbol: String {
        switch self {
        case .radiansPerSecond:
            return "rad/s"
        case .degreesPerSecond:
            return "°/s"
        case .revolutionsPerMinute:
            return "rpm"
        case .revolutionsPerSecond:
            return "rps"
        }
    }
}

// MARK: - CustomStringConvertible

extension AngularSpeedUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - AngularSpeed Type Alias

/// 角速度
///
/// `Measurement<AngularSpeedUnit>` の型エイリアス。
/// 角速度を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let fan = AngularSpeed(1200, unit: .rpm)
/// print(fan.radiansPerSecond)  // 125.66...
///
/// // 角度と時間から角速度を計算
/// let angle = Angle(360, unit: .degrees)
/// let time = Duration(1, unit: .seconds)
/// let speed: AngularSpeed = angle / time  // 2π rad/s
/// ```
public typealias AngularSpeed = Measurement<AngularSpeedUnit>

// MARK: - AngularSpeed Convenience Accessors

extension AngularSpeed {
    /// ラジアン毎秒単位で値を取得
    @inlinable
    public var radiansPerSecond: Double {
        value(in: .radiansPerSecond)
    }

    /// 度毎秒単位で値を取得
    @inlinable
    public var degreesPerSecond: Double {
        value(in: .degreesPerSecond)
    }

    /// 回転毎分（rpm）単位で値を取得
    @inlinable
    public var rpm: Double {
        value(in: .revolutionsPerMinute)
    }

    /// 回転毎秒（rps）単位で値を取得
    @inlinable
    public var rps: Double {
        value(in: .revolutionsPerSecond)
    }

    /// 周波数（Hz）として取得（rpsと同じ）
    @inlinable
    public var hertz: Double {
        rps
    }
}

// MARK: - AngularSpeed Formatting

extension AngularSpeed {
    /// 適切な単位で自動フォーマット
    public var formatted: String {
        let rpmVal = rpm
        if abs(rpmVal) >= 1 {
            return String(format: "%.1f rpm", rpmVal)
        } else {
            return String(format: "%.3f rad/s", radiansPerSecond)
        }
    }
}

// MARK: - AngularSpeed Common Values

extension AngularSpeed {
    /// 地球の自転角速度（約 7.29×10⁻⁵ rad/s）
    public static let earthRotation = AngularSpeed(7.2921159e-5, unit: .radiansPerSecond)

    /// 時計の秒針（1 rpm = 6°/s）
    public static let clockSecondHand = AngularSpeed(1, unit: .revolutionsPerMinute)

    /// 時計の分針（1/60 rpm）
    public static let clockMinuteHand = AngularSpeed(1.0 / 60.0, unit: .revolutionsPerMinute)
}
