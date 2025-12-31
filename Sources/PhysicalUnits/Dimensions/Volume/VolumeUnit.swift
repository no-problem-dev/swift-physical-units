import Foundation

/// 体積の単位
///
/// `MetricUnit<Liter>` の型エイリアス。
/// 接頭辞を変えることで、リットル、ミリリットル、キロリットルなどを表現できます。
public typealias VolumeUnit = MetricUnit<Liter>

// MARK: - Convenience Static Properties

extension VolumeUnit {
    /// リットル (L)
    @inlinable
    public static var liters: VolumeUnit {
        VolumeUnit(.base)
    }

    /// ミリリットル (mL)
    @inlinable
    public static var milliliters: VolumeUnit {
        VolumeUnit(.milli)
    }

    /// マイクロリットル (μL)
    @inlinable
    public static var microliters: VolumeUnit {
        VolumeUnit(.micro)
    }

    /// センチリットル (cL)
    @inlinable
    public static var centiliters: VolumeUnit {
        VolumeUnit(.centi)
    }

    /// デシリットル (dL)
    @inlinable
    public static var deciliters: VolumeUnit {
        VolumeUnit(.deci)
    }

    /// キロリットル (kL) = 立方メートル
    @inlinable
    public static var kiloliters: VolumeUnit {
        VolumeUnit(.kilo)
    }
}

// MARK: - Volume Type Alias

/// 体積
///
/// `Measurement<VolumeUnit>` の型エイリアス。
/// 体積を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let water = Volume(500, unit: .milliliters)
/// print(water.liters)  // 0.5
///
/// let tank = Volume(100, unit: .liters)
/// print(tank.milliliters)  // 100000.0
/// ```
public typealias Volume = Measurement<VolumeUnit>

// MARK: - Volume Convenience Accessors

extension Volume {
    /// リットル単位で値を取得
    @inlinable
    public var liters: Double {
        value(in: .liters)
    }

    /// ミリリットル単位で値を取得
    @inlinable
    public var milliliters: Double {
        value(in: .milliliters)
    }

    /// センチリットル単位で値を取得
    @inlinable
    public var centiliters: Double {
        value(in: .centiliters)
    }

    /// デシリットル単位で値を取得
    @inlinable
    public var deciliters: Double {
        value(in: .deciliters)
    }

    /// キロリットル単位で値を取得
    @inlinable
    public var kiloliters: Double {
        value(in: .kiloliters)
    }

    /// 立方メートル単位で値を取得（1 kL = 1 m³）
    @inlinable
    public var cubicMeters: Double {
        kiloliters
    }
}

// MARK: - Volume Formatting

extension Volume {
    /// 適切な単位で自動フォーマット
    public var formatted: String {
        let l = liters
        if abs(l) >= 1000 {
            return String(format: "%.2f kL", kiloliters)
        } else if abs(l) >= 1 {
            return String(format: "%.2f L", l)
        } else if abs(milliliters) >= 1 {
            return String(format: "%.1f mL", milliliters)
        } else {
            return String(format: "%.1f μL", value(in: .microliters))
        }
    }
}
