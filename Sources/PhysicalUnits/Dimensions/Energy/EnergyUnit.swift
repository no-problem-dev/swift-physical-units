import Foundation

/// エネルギーの単位
///
/// SI 単位（ジュール）と非 SI 単位（カロリー）を統合した単位型。
/// ジュールを基準単位として、すべてのエネルギー単位を表現します。
///
/// ## 設計思想
/// - **ジュール (J)**: SI 派生単位。1 J = 1 kg⋅m²/s²
/// - **カロリー (cal)**: 歴史的単位。1 cal = 4.184 J（熱力学カロリー）
///
/// フィットネスや栄養学ではカロリー（特にキロカロリー）が広く使われるため、
/// 両方の単位系を統合しています。
///
/// ## 使用例
/// ```swift
/// let burned = Energy(300, unit: .kilocalories)
/// print(burned.kilojoules)  // 1255.2
///
/// let work = Energy(1000, unit: .joules)
/// print(work.calories)      // 239.006...
/// ```
@frozen
public enum EnergyUnit: Unit, Codable, Sendable, Hashable {
    /// ジュール（SI 単位）+ 接頭辞
    case joules(MetricPrefix)

    /// カロリー（非 SI 単位）+ 接頭辞
    ///
    /// 熱力学カロリー（1 cal = 4.184 J）を使用。
    case calories(MetricPrefix)

    // MARK: - Constants

    /// 1 カロリー = 4.184 ジュール（熱力学カロリー）
    ///
    /// 注: 国際カロリー（4.1868 J）や 15℃カロリー（4.1855 J）など
    /// 複数の定義が存在しますが、最も一般的な熱力学カロリーを採用。
    public static let joulesPerCalorie: Double = 4.184

    // MARK: - Unit Protocol

    /// 基準単位（ジュール）への変換係数
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .joules(let prefix):
            return prefix.factor
        case .calories(let prefix):
            return prefix.factor * Self.joulesPerCalorie
        }
    }

    /// 単位記号
    public var symbol: String {
        switch self {
        case .joules(let prefix):
            return prefix.symbol + "J"
        case .calories(let prefix):
            return prefix.symbol + "cal"
        }
    }
}

// MARK: - Convenience Static Properties

extension EnergyUnit {
    // MARK: Joules

    /// ジュール (J)
    @inlinable
    public static var joules: EnergyUnit {
        .joules(.base)
    }

    /// キロジュール (kJ)
    @inlinable
    public static var kilojoules: EnergyUnit {
        .joules(.kilo)
    }

    /// メガジュール (MJ)
    @inlinable
    public static var megajoules: EnergyUnit {
        .joules(.mega)
    }

    /// ミリジュール (mJ)
    @inlinable
    public static var millijoules: EnergyUnit {
        .joules(.milli)
    }

    // MARK: Calories

    /// カロリー (cal)
    @inlinable
    public static var calories: EnergyUnit {
        .calories(.base)
    }

    /// キロカロリー (kcal)
    ///
    /// 栄養学で一般的に使用される単位。
    /// 「大カロリー」や「食品カロリー」とも呼ばれる。
    @inlinable
    public static var kilocalories: EnergyUnit {
        .calories(.kilo)
    }

    /// メガカロリー (Mcal)
    @inlinable
    public static var megacalories: EnergyUnit {
        .calories(.mega)
    }
}

// MARK: - CustomStringConvertible

extension EnergyUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Energy Type Alias

/// エネルギー
///
/// `Measurement<EnergyUnit>` の型エイリアス。
/// エネルギーを型安全に表現します。
///
/// ## 使用例
/// ```swift
/// // 運動で消費したエネルギー
/// let burned = Energy(350, unit: .kilocalories)
/// print(burned.kilojoules)  // 1464.4
///
/// // 仕事量
/// let work = Energy(500, unit: .joules)
/// print(work.calories)      // 119.5...
/// ```
public typealias Energy = Measurement<EnergyUnit>

// MARK: - Energy Convenience Accessors

extension Energy {
    // MARK: Joules

    /// ジュール単位で値を取得
    @inlinable
    public var joules: Double {
        value(in: .joules)
    }

    /// キロジュール単位で値を取得
    @inlinable
    public var kilojoules: Double {
        value(in: .kilojoules)
    }

    /// メガジュール単位で値を取得
    @inlinable
    public var megajoules: Double {
        value(in: .megajoules)
    }

    // MARK: Calories

    /// カロリー単位で値を取得
    @inlinable
    public var calories: Double {
        value(in: .calories)
    }

    /// キロカロリー単位で値を取得
    @inlinable
    public var kilocalories: Double {
        value(in: .kilocalories)
    }
}

// MARK: - Energy Formatting

extension Energy {
    /// 適切な単位で自動フォーマット（カロリー系）
    ///
    /// 栄養学・フィットネス向けにカロリー系で表示します。
    public var formattedCalories: String {
        let kcal = kilocalories
        if abs(kcal) >= 1000 {
            return String(format: "%.1f Mcal", kcal / 1000)
        } else if abs(kcal) >= 1 {
            return String(format: "%.1f kcal", kcal)
        } else {
            return String(format: "%.1f cal", calories)
        }
    }

    /// 適切な単位で自動フォーマット（ジュール系）
    ///
    /// 物理学・工学向けにジュール系で表示します。
    public var formattedJoules: String {
        let j = joules
        if abs(j) >= 1_000_000 {
            return String(format: "%.2f MJ", megajoules)
        } else if abs(j) >= 1000 {
            return String(format: "%.2f kJ", kilojoules)
        } else {
            return String(format: "%.2f J", j)
        }
    }

    /// デフォルトのフォーマット（キロカロリー）
    public var formatted: String {
        formattedCalories
    }
}
