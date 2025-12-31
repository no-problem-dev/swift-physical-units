import Foundation

/// 電荷の単位
///
/// `MetricUnit<Coulomb>` の型エイリアス。
/// 接頭辞を変えることで、クーロン、ミリクーロン、マイクロクーロンなどを表現できます。
///
/// ## 電荷の基本公式
/// Q = I × t （電荷 = 電流 × 時間）
///
/// ## 使用例
/// ```swift
/// let charge = Charge(1, unit: .coulombs)
/// print(charge.milliampereHours)  // 277.78
/// ```
public typealias ChargeUnit = MetricUnit<Coulomb>

// MARK: - Convenience Static Properties

extension ChargeUnit {
    /// クーロン (C)
    @inlinable
    public static var coulombs: ChargeUnit {
        ChargeUnit(.base)
    }

    /// ミリクーロン (mC)
    @inlinable
    public static var millicoulombs: ChargeUnit {
        ChargeUnit(.milli)
    }

    /// マイクロクーロン (μC)
    @inlinable
    public static var microcoulombs: ChargeUnit {
        ChargeUnit(.micro)
    }

    /// ナノクーロン (nC)
    @inlinable
    public static var nanocoulombs: ChargeUnit {
        ChargeUnit(.nano)
    }

    /// キロクーロン (kC)
    @inlinable
    public static var kilocoulombs: ChargeUnit {
        ChargeUnit(.kilo)
    }
}

// MARK: - Charge Type Alias

/// 電荷
///
/// `Measurement<ChargeUnit>` の型エイリアス。
/// 電荷を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let batteryCharge = Charge(5000, unit: .millicoulombs)
/// print(batteryCharge.coulombs)  // 5.0
///
/// // 電流と時間から電荷を計算
/// let current = Current(2, unit: .amperes)
/// let time = Duration(10, unit: .seconds)
/// let charge: Charge = current * time  // 20 C
/// ```
public typealias Charge = Measurement<ChargeUnit>

// MARK: - Charge Convenience Accessors

extension Charge {
    /// クーロン単位で値を取得
    @inlinable
    public var coulombs: Double {
        value(in: .coulombs)
    }

    /// ミリクーロン単位で値を取得
    @inlinable
    public var millicoulombs: Double {
        value(in: .millicoulombs)
    }

    /// マイクロクーロン単位で値を取得
    @inlinable
    public var microcoulombs: Double {
        value(in: .microcoulombs)
    }

    /// ナノクーロン単位で値を取得
    @inlinable
    public var nanocoulombs: Double {
        value(in: .nanocoulombs)
    }

    /// キロクーロン単位で値を取得
    @inlinable
    public var kilocoulombs: Double {
        value(in: .kilocoulombs)
    }
}

// MARK: - Charge Practical Units

extension Charge {
    /// アンペア時（Ah）単位で値を取得
    ///
    /// 1 Ah = 3600 C
    @inlinable
    public var ampereHours: Double {
        coulombs / 3600.0
    }

    /// ミリアンペア時（mAh）単位で値を取得
    ///
    /// 1 mAh = 3.6 C
    @inlinable
    public var milliampereHours: Double {
        coulombs / 3.6
    }

    /// アンペア時から初期化
    ///
    /// ```swift
    /// let battery = Charge(ampereHours: 5)  // 18000 C
    /// ```
    @inlinable
    public init(ampereHours: Double) {
        self = Charge(ampereHours * 3600.0, unit: .coulombs)
    }

    /// ミリアンペア時から初期化
    ///
    /// ```swift
    /// let battery = Charge(milliampereHours: 5000)  // 18000 C
    /// ```
    @inlinable
    public init(milliampereHours: Double) {
        self = Charge(milliampereHours * 3.6, unit: .coulombs)
    }
}

// MARK: - Charge Formatting

extension Charge {
    /// 適切な単位で自動フォーマット
    public var formatted: String {
        let c = coulombs
        if abs(c) >= 1000 {
            return String(format: "%.2f kC", kilocoulombs)
        } else if abs(c) >= 1 {
            return String(format: "%.2f C", c)
        } else if abs(millicoulombs) >= 1 {
            return String(format: "%.2f mC", millicoulombs)
        } else if abs(microcoulombs) >= 1 {
            return String(format: "%.2f μC", microcoulombs)
        } else {
            return String(format: "%.2f nC", nanocoulombs)
        }
    }
}

// MARK: - Charge Common Values

extension Charge {
    /// 電子1個の電荷（素電荷）
    public static let elementaryCharge = Charge(1.602176634e-19, unit: .coulombs)
}
