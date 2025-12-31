import Foundation

/// 質量の単位
///
/// `MetricUnit<Gram>` の型エイリアス。
/// 接頭辞を変えることで、グラム、キログラム、ミリグラムなどを表現できます。
public typealias MassUnit = MetricUnit<Gram>

// MARK: - Convenience Static Properties

extension MassUnit {
    /// グラム (g)
    @inlinable
    public static var grams: MassUnit {
        MassUnit(.base)
    }

    /// キログラム (kg)
    @inlinable
    public static var kilograms: MassUnit {
        MassUnit(.kilo)
    }

    /// ミリグラム (mg)
    @inlinable
    public static var milligrams: MassUnit {
        MassUnit(.milli)
    }

    /// マイクログラム (μg)
    @inlinable
    public static var micrograms: MassUnit {
        MassUnit(.micro)
    }

    /// ナノグラム (ng)
    @inlinable
    public static var nanograms: MassUnit {
        MassUnit(.nano)
    }

    /// メガグラム (Mg) = トン
    @inlinable
    public static var megagrams: MassUnit {
        MassUnit(.mega)
    }

    /// トン (t) = メガグラム
    ///
    /// SI では「トン」は「メガグラム」と同義です。
    @inlinable
    public static var tonnes: MassUnit {
        MassUnit(.mega)
    }
}

// MARK: - Mass Type Alias

/// 質量
///
/// `Measurement<MassUnit>` の型エイリアス。
/// 質量を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let weight = Mass(70, unit: .kilograms)
/// print(weight.grams)  // 70000.0
///
/// let small = Mass(500, unit: .milligrams)
/// print(small.grams)   // 0.5
/// ```
public typealias Mass = Measurement<MassUnit>

// MARK: - Mass Convenience Accessors

extension Mass {
    /// グラム単位で値を取得
    @inlinable
    public var grams: Double {
        value(in: .grams)
    }

    /// キログラム単位で値を取得
    @inlinable
    public var kilograms: Double {
        value(in: .kilograms)
    }

    /// ミリグラム単位で値を取得
    @inlinable
    public var milligrams: Double {
        value(in: .milligrams)
    }

    /// マイクログラム単位で値を取得
    @inlinable
    public var micrograms: Double {
        value(in: .micrograms)
    }

    /// トン単位で値を取得
    @inlinable
    public var tonnes: Double {
        value(in: .tonnes)
    }
}

// MARK: - Mass CustomStringConvertible

extension Mass {
    /// 適切な単位で自動フォーマット
    ///
    /// 値の大きさに応じて適切な単位を選択します。
    public var formatted: String {
        let kg = kilograms
        if abs(kg) >= 1000 {
            return String(format: "%.2f t", tonnes)
        } else if abs(kg) >= 1 {
            return String(format: "%.2f kg", kg)
        } else if abs(grams) >= 1 {
            return String(format: "%.2f g", grams)
        } else if abs(milligrams) >= 1 {
            return String(format: "%.2f mg", milligrams)
        } else {
            return String(format: "%.2f μg", micrograms)
        }
    }
}
