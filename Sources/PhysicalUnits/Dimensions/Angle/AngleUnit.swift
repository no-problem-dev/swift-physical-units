import Foundation

/// 角度の単位
///
/// 角度は幾何学的な量で、SI では補助単位としてラジアン (rad) が定義されています。
/// 日常的には度 (°) がよく使われます。
///
/// ## 変換関係
/// - 1 turn = 2π rad = 360° = 400 grad
/// - 1 rad = 180/π° ≈ 57.2958°
/// - 1° = π/180 rad ≈ 0.01745 rad
///
/// ## 使用例
/// ```swift
/// let rightAngle = Angle(90, unit: .degrees)
/// print(rightAngle.radians)  // 1.5708 (π/2)
///
/// let halfTurn = Angle(.pi, unit: .radians)
/// print(halfTurn.degrees)    // 180.0
/// ```
@frozen
public enum AngleUnit: Unit, Codable, Sendable, Hashable {
    /// ラジアン (rad) - SI 補助単位
    case radians

    /// 度 (°)
    case degrees

    /// グラジアン (grad) - 直角の 1/100
    case gradians

    /// 回転 (turn) - 完全な一周
    case turns

    // MARK: - Constants

    /// 度 → ラジアン 変換係数
    public static let degreesToRadians: Double = .pi / 180.0

    /// グラジアン → ラジアン 変換係数
    public static let gradiansToRadians: Double = .pi / 200.0

    /// 回転 → ラジアン 変換係数
    public static let turnsToRadians: Double = 2.0 * .pi

    // MARK: - Unit Protocol

    /// 基準単位（ラジアン）への変換係数
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .radians:
            return 1.0
        case .degrees:
            return Self.degreesToRadians
        case .gradians:
            return Self.gradiansToRadians
        case .turns:
            return Self.turnsToRadians
        }
    }

    /// 単位記号
    public var symbol: String {
        switch self {
        case .radians:
            return "rad"
        case .degrees:
            return "°"
        case .gradians:
            return "grad"
        case .turns:
            return "turn"
        }
    }
}

// MARK: - CustomStringConvertible

extension AngleUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Angle Type Alias

/// 角度
///
/// `Measurement<AngleUnit>` の型エイリアス。
/// 角度を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let angle = Angle(45, unit: .degrees)
/// print(angle.radians)  // 0.7854 (π/4)
///
/// let rotation = Angle(1.5, unit: .turns)
/// print(rotation.degrees)  // 540.0
/// ```
public typealias Angle = Measurement<AngleUnit>

// MARK: - Angle Convenience Accessors

extension Angle {
    /// ラジアン単位で値を取得
    @inlinable
    public var radians: Double {
        value(in: .radians)
    }

    /// 度単位で値を取得
    @inlinable
    public var degrees: Double {
        value(in: .degrees)
    }

    /// グラジアン単位で値を取得
    @inlinable
    public var gradians: Double {
        value(in: .gradians)
    }

    /// 回転単位で値を取得
    @inlinable
    public var turns: Double {
        value(in: .turns)
    }
}

// MARK: - Angle Formatting

extension Angle {
    /// 度でフォーマット
    public var formattedDegrees: String {
        String(format: "%.2f°", degrees)
    }

    /// ラジアンでフォーマット
    public var formattedRadians: String {
        String(format: "%.4f rad", radians)
    }
}

// MARK: - Angle Special Values

extension Angle {
    /// 直角 (90°)
    public static let rightAngle = Angle(90, unit: .degrees)

    /// 平角 (180°)
    public static let straightAngle = Angle(180, unit: .degrees)

    /// 周角 (360°)
    public static let fullAngle = Angle(360, unit: .degrees)

    /// 零角
    public static let zero = Angle(0, unit: .radians)
}

// MARK: - Trigonometric Functions

extension Angle {
    /// 正弦 (sin)
    @inlinable
    public var sin: Double {
        Foundation.sin(radians)
    }

    /// 余弦 (cos)
    @inlinable
    public var cos: Double {
        Foundation.cos(radians)
    }

    /// 正接 (tan)
    @inlinable
    public var tan: Double {
        Foundation.tan(radians)
    }
}
