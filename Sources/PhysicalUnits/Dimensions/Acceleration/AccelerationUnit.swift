import Foundation

/// 加速度の単位
///
/// 加速度は SI 導出単位で、メートル毎秒毎秒 (m/s²) が基本単位です。
/// a = Δv / Δt （速度の時間変化率）
///
/// ## 変換関係
/// - 1 m/s² = 基準単位
/// - 1 g (標準重力加速度) ≈ 9.80665 m/s²
/// - 1 Gal (ガル) = 0.01 m/s² = 1 cm/s²（地震学で使用）
///
/// ## 使用例
/// ```swift
/// let gravity = Acceleration(1, unit: .standardGravity)
/// print(gravity.metersPerSecondSquared)  // 9.80665
///
/// let car = Acceleration(3, unit: .metersPerSecondSquared)
/// print(car.standardGravity)  // 0.306
/// ```
@frozen
public enum AccelerationUnit: Unit, Codable, Sendable, Hashable {
    /// メートル毎秒毎秒 (m/s²) - SI 導出単位
    case metersPerSecondSquared

    /// 標準重力加速度 (g)
    case standardGravity

    /// ガル (Gal) = cm/s²（地震学で使用）
    case gal

    /// ミリガル (mGal)
    case milligal

    // MARK: - Constants

    /// 標準重力加速度 (m/s²)
    public static let standardGravityValue: Double = 9.80665

    /// ガル → m/s² 変換係数
    public static let galToMsSquared: Double = 0.01

    // MARK: - Unit Protocol

    /// 基準単位（m/s²）への変換係数
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .metersPerSecondSquared:
            return 1.0
        case .standardGravity:
            return Self.standardGravityValue
        case .gal:
            return Self.galToMsSquared
        case .milligal:
            return Self.galToMsSquared * 1e-3
        }
    }

    /// 単位記号
    public var symbol: String {
        switch self {
        case .metersPerSecondSquared:
            return "m/s²"
        case .standardGravity:
            return "g"
        case .gal:
            return "Gal"
        case .milligal:
            return "mGal"
        }
    }
}

// MARK: - CustomStringConvertible

extension AccelerationUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Acceleration Type Alias

/// 加速度
///
/// `Measurement<AccelerationUnit>` の型エイリアス。
/// 加速度を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let freefall = Acceleration(1, unit: .standardGravity)
/// print(freefall.metersPerSecondSquared)  // 9.80665
///
/// let braking = Acceleration(-5, unit: .metersPerSecondSquared)
/// print(braking.standardGravity)  // -0.51
/// ```
public typealias Acceleration = Measurement<AccelerationUnit>

// MARK: - Acceleration Convenience Accessors

extension Acceleration {
    /// メートル毎秒毎秒単位で値を取得
    @inlinable
    public var metersPerSecondSquared: Double {
        value(in: .metersPerSecondSquared)
    }

    /// 標準重力加速度単位で値を取得
    @inlinable
    public var standardGravity: Double {
        value(in: .standardGravity)
    }

    /// ガル単位で値を取得
    @inlinable
    public var gal: Double {
        value(in: .gal)
    }

    /// ミリガル単位で値を取得
    @inlinable
    public var milligal: Double {
        value(in: .milligal)
    }
}

// MARK: - Acceleration Formatting

extension Acceleration {
    /// 適切な単位で自動フォーマット
    public var formatted: String {
        let ms2 = metersPerSecondSquared
        if abs(ms2) >= AccelerationUnit.standardGravityValue {
            return String(format: "%.2f g", standardGravity)
        } else if abs(ms2) >= 0.01 {
            return String(format: "%.3f m/s²", ms2)
        } else if abs(gal) >= 1 {
            return String(format: "%.2f Gal", gal)
        } else {
            return String(format: "%.1f mGal", milligal)
        }
    }
}

// MARK: - Acceleration Special Values

extension Acceleration {
    /// 標準重力加速度（海面上）
    public static let gravity = Acceleration(1, unit: .standardGravity)

    /// 月面重力加速度（約 1.62 m/s²）
    public static let moonGravity = Acceleration(1.62, unit: .metersPerSecondSquared)

    /// 火星表面重力加速度（約 3.72 m/s²）
    public static let marsGravity = Acceleration(3.72, unit: .metersPerSecondSquared)

    /// ゼロ加速度
    public static let zero = Acceleration(0, unit: .metersPerSecondSquared)
}
