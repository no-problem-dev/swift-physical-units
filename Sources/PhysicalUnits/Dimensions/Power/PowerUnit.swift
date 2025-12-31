import Foundation

/// 仕事率・電力の単位
///
/// 仕事率は SI 導出単位で、ワット (W) が基本単位です。
/// 1 W = 1 J/s = 1 kg⋅m²⋅s⁻³
///
/// ## 変換関係
/// - 1 kW = 1000 W
/// - 1 hp (metric) ≈ 735.5 W
/// - 1 hp (imperial) ≈ 745.7 W
///
/// ## 使用例
/// ```swift
/// let motor = Power(5, unit: .kilowatts)
/// print(motor.horsepower)  // 6.80
///
/// let bulb = Power(100, unit: .watts)
/// print(bulb.kilowatts)    // 0.1
/// ```
@frozen
public enum PowerUnit: Unit, Codable, Sendable, Hashable {
    /// ワット (W) - SI 導出単位
    case watts

    /// ミリワット (mW)
    case milliwatts

    /// キロワット (kW)
    case kilowatts

    /// メガワット (MW)
    case megawatts

    /// ギガワット (GW)
    case gigawatts

    /// 馬力 (hp) - メトリック馬力
    case horsepower

    /// 英馬力 (hp) - インペリアル馬力
    case horsepowerImperial

    // MARK: - Constants

    /// メトリック馬力 → ワット 変換係数
    public static let metricHpToWatts: Double = 735.49875

    /// インペリアル馬力 → ワット 変換係数
    public static let imperialHpToWatts: Double = 745.69987158

    // MARK: - Unit Protocol

    /// 基準単位（ワット）への変換係数
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .watts:
            return 1.0
        case .milliwatts:
            return 1e-3
        case .kilowatts:
            return 1e3
        case .megawatts:
            return 1e6
        case .gigawatts:
            return 1e9
        case .horsepower:
            return Self.metricHpToWatts
        case .horsepowerImperial:
            return Self.imperialHpToWatts
        }
    }

    /// 単位記号
    public var symbol: String {
        switch self {
        case .watts:
            return "W"
        case .milliwatts:
            return "mW"
        case .kilowatts:
            return "kW"
        case .megawatts:
            return "MW"
        case .gigawatts:
            return "GW"
        case .horsepower:
            return "hp"
        case .horsepowerImperial:
            return "hp(I)"
        }
    }
}

// MARK: - CustomStringConvertible

extension PowerUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Power Type Alias

/// 仕事率・電力
///
/// `Measurement<PowerUnit>` の型エイリアス。
/// 仕事率・電力を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let engine = Power(150, unit: .horsepower)
/// print(engine.kilowatts)  // 110.32
///
/// let plant = Power(1.21, unit: .gigawatts)
/// print(plant.megawatts)   // 1210.0
/// ```
public typealias Power = Measurement<PowerUnit>

// MARK: - Power Convenience Accessors

extension Power {
    /// ワット単位で値を取得
    @inlinable
    public var watts: Double {
        value(in: .watts)
    }

    /// ミリワット単位で値を取得
    @inlinable
    public var milliwatts: Double {
        value(in: .milliwatts)
    }

    /// キロワット単位で値を取得
    @inlinable
    public var kilowatts: Double {
        value(in: .kilowatts)
    }

    /// メガワット単位で値を取得
    @inlinable
    public var megawatts: Double {
        value(in: .megawatts)
    }

    /// ギガワット単位で値を取得
    @inlinable
    public var gigawatts: Double {
        value(in: .gigawatts)
    }

    /// 馬力（メトリック）単位で値を取得
    @inlinable
    public var horsepower: Double {
        value(in: .horsepower)
    }
}

// MARK: - Power Formatting

extension Power {
    /// 適切な単位で自動フォーマット
    public var formatted: String {
        let w = watts
        if abs(w) >= 1e9 {
            return String(format: "%.2f GW", gigawatts)
        } else if abs(w) >= 1e6 {
            return String(format: "%.2f MW", megawatts)
        } else if abs(w) >= 1e3 {
            return String(format: "%.2f kW", kilowatts)
        } else if abs(w) >= 1 {
            return String(format: "%.1f W", w)
        } else {
            return String(format: "%.2f mW", milliwatts)
        }
    }
}
