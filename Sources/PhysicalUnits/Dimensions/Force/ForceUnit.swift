import Foundation

/// 力の単位
///
/// 力は SI 導出単位で、ニュートン (N) が基本単位です。
/// 1 N = 1 kg⋅m⋅s⁻² （1 kg の質量を 1 m/s² で加速させる力）
///
/// ## 変換関係
/// - 1 kN = 1000 N
/// - 1 kgf (重量キログラム) ≈ 9.80665 N
/// - 1 lbf (ポンド力) ≈ 4.44822 N
/// - 1 dyne = 10⁻⁵ N
///
/// ## 使用例
/// ```swift
/// let weight = Force(70, unit: .kilogramsForce)
/// print(weight.newtons)  // 686.47
///
/// let thrust = Force(100, unit: .kilonewtons)
/// print(thrust.newtons)  // 100000.0
/// ```
@frozen
public enum ForceUnit: Unit, Codable, Sendable, Hashable {
    /// ニュートン (N) - SI 導出単位
    case newtons

    /// ミリニュートン (mN)
    case millinewtons

    /// キロニュートン (kN)
    case kilonewtons

    /// メガニュートン (MN)
    case meganewtons

    /// 重量キログラム (kgf)
    case kilogramsForce

    /// ポンド力 (lbf)
    case poundsForce

    /// ダイン (dyn) - CGS 単位
    case dynes

    // MARK: - Constants

    /// 標準重力加速度 (m/s²)
    public static let standardGravity: Double = 9.80665

    /// ポンド力 → ニュートン 変換係数
    public static let lbfToNewtons: Double = 4.4482216152605

    /// ダイン → ニュートン 変換係数
    public static let dyneToNewtons: Double = 1e-5

    // MARK: - Unit Protocol

    /// 基準単位（ニュートン）への変換係数
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .newtons:
            return 1.0
        case .millinewtons:
            return 1e-3
        case .kilonewtons:
            return 1e3
        case .meganewtons:
            return 1e6
        case .kilogramsForce:
            return Self.standardGravity
        case .poundsForce:
            return Self.lbfToNewtons
        case .dynes:
            return Self.dyneToNewtons
        }
    }

    /// 単位記号
    public var symbol: String {
        switch self {
        case .newtons:
            return "N"
        case .millinewtons:
            return "mN"
        case .kilonewtons:
            return "kN"
        case .meganewtons:
            return "MN"
        case .kilogramsForce:
            return "kgf"
        case .poundsForce:
            return "lbf"
        case .dynes:
            return "dyn"
        }
    }
}

// MARK: - CustomStringConvertible

extension ForceUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Force Type Alias

/// 力
///
/// `Measurement<ForceUnit>` の型エイリアス。
/// 力を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let push = Force(50, unit: .newtons)
/// print(push.kilogramsForce)  // 5.10
///
/// let engineThrust = Force(500, unit: .kilonewtons)
/// print(engineThrust.meganewtons)  // 0.5
/// ```
public typealias Force = Measurement<ForceUnit>

// MARK: - Force Convenience Accessors

extension Force {
    /// ニュートン単位で値を取得
    @inlinable
    public var newtons: Double {
        value(in: .newtons)
    }

    /// ミリニュートン単位で値を取得
    @inlinable
    public var millinewtons: Double {
        value(in: .millinewtons)
    }

    /// キロニュートン単位で値を取得
    @inlinable
    public var kilonewtons: Double {
        value(in: .kilonewtons)
    }

    /// メガニュートン単位で値を取得
    @inlinable
    public var meganewtons: Double {
        value(in: .meganewtons)
    }

    /// 重量キログラム単位で値を取得
    @inlinable
    public var kilogramsForce: Double {
        value(in: .kilogramsForce)
    }

    /// ポンド力単位で値を取得
    @inlinable
    public var poundsForce: Double {
        value(in: .poundsForce)
    }

    /// ダイン単位で値を取得
    @inlinable
    public var dynes: Double {
        value(in: .dynes)
    }
}

// MARK: - Force Formatting

extension Force {
    /// 適切な単位で自動フォーマット
    public var formatted: String {
        let n = newtons
        if abs(n) >= 1e6 {
            return String(format: "%.2f MN", meganewtons)
        } else if abs(n) >= 1e3 {
            return String(format: "%.2f kN", kilonewtons)
        } else if abs(n) >= 1 {
            return String(format: "%.2f N", n)
        } else {
            return String(format: "%.2f mN", millinewtons)
        }
    }
}
