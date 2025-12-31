import Foundation

/// 長さの単位
///
/// `MetricUnit<Meter>` の型エイリアス。
/// 接頭辞を変えることで、メートル、センチメートル、キロメートルなどを表現できます。
public typealias LengthUnit = MetricUnit<Meter>

// MARK: - Convenience Static Properties

extension LengthUnit {
    /// メートル (m)
    @inlinable
    public static var meters: LengthUnit {
        LengthUnit(.base)
    }

    /// センチメートル (cm)
    @inlinable
    public static var centimeters: LengthUnit {
        LengthUnit(.centi)
    }

    /// ミリメートル (mm)
    @inlinable
    public static var millimeters: LengthUnit {
        LengthUnit(.milli)
    }

    /// キロメートル (km)
    @inlinable
    public static var kilometers: LengthUnit {
        LengthUnit(.kilo)
    }

    /// マイクロメートル (μm)
    @inlinable
    public static var micrometers: LengthUnit {
        LengthUnit(.micro)
    }

    /// ナノメートル (nm)
    @inlinable
    public static var nanometers: LengthUnit {
        LengthUnit(.nano)
    }

    /// デシメートル (dm)
    @inlinable
    public static var decimeters: LengthUnit {
        LengthUnit(.deci)
    }
}

// MARK: - Length Type Alias

/// 長さ
///
/// `Measurement<LengthUnit>` の型エイリアス。
/// 長さを型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let height = Length(175, unit: .centimeters)
/// print(height.meters)  // 1.75
///
/// let distance = Length(5, unit: .kilometers)
/// print(distance.meters)  // 5000.0
/// ```
public typealias Length = Measurement<LengthUnit>

// MARK: - Length Convenience Accessors

extension Length {
    /// メートル単位で値を取得
    @inlinable
    public var meters: Double {
        value(in: .meters)
    }

    /// センチメートル単位で値を取得
    @inlinable
    public var centimeters: Double {
        value(in: .centimeters)
    }

    /// ミリメートル単位で値を取得
    @inlinable
    public var millimeters: Double {
        value(in: .millimeters)
    }

    /// キロメートル単位で値を取得
    @inlinable
    public var kilometers: Double {
        value(in: .kilometers)
    }

    /// マイクロメートル単位で値を取得
    @inlinable
    public var micrometers: Double {
        value(in: .micrometers)
    }

    /// ナノメートル単位で値を取得
    @inlinable
    public var nanometers: Double {
        value(in: .nanometers)
    }
}

// MARK: - Length CustomStringConvertible

extension Length {
    /// 適切な単位で自動フォーマット
    ///
    /// 値の大きさに応じて適切な単位を選択します。
    public var formatted: String {
        let m = meters
        if abs(m) >= 1000 {
            return String(format: "%.2f km", kilometers)
        } else if abs(m) >= 1 {
            return String(format: "%.2f m", m)
        } else if abs(centimeters) >= 1 {
            return String(format: "%.2f cm", centimeters)
        } else if abs(millimeters) >= 1 {
            return String(format: "%.2f mm", millimeters)
        } else {
            return String(format: "%.2f μm", micrometers)
        }
    }
}
