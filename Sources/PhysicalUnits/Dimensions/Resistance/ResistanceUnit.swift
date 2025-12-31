import Foundation

/// 電気抵抗の単位
///
/// `MetricUnit<Ohm>` の型エイリアス。
/// 接頭辞を変えることで、オーム、キロオーム、メガオームなどを表現できます。
///
/// ## オームの法則
/// V = I × R （電圧 = 電流 × 抵抗）
///
/// ## 使用例
/// ```swift
/// let resistor = Resistance(4.7, unit: .kilohms)
/// print(resistor.ohms)  // 4700.0
/// ```
public typealias ResistanceUnit = MetricUnit<Ohm>

// MARK: - Convenience Static Properties

extension ResistanceUnit {
    /// オーム (Ω)
    @inlinable
    public static var ohms: ResistanceUnit {
        ResistanceUnit(.base)
    }

    /// ミリオーム (mΩ)
    @inlinable
    public static var milliohms: ResistanceUnit {
        ResistanceUnit(.milli)
    }

    /// キロオーム (kΩ)
    @inlinable
    public static var kilohms: ResistanceUnit {
        ResistanceUnit(.kilo)
    }

    /// メガオーム (MΩ)
    @inlinable
    public static var megaohms: ResistanceUnit {
        ResistanceUnit(.mega)
    }

    /// ギガオーム (GΩ)
    @inlinable
    public static var gigaohms: ResistanceUnit {
        ResistanceUnit(.giga)
    }
}

// MARK: - Resistance Type Alias

/// 電気抵抗
///
/// `Measurement<ResistanceUnit>` の型エイリアス。
/// 電気抵抗を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let resistor = Resistance(220, unit: .ohms)
/// print(resistor.kilohms)  // 0.22
///
/// // オームの法則を使用
/// let voltage = Voltage(5, unit: .volts)
/// let current: Current = voltage / resistor  // 22.7 mA
/// ```
public typealias Resistance = Measurement<ResistanceUnit>

// MARK: - Resistance Convenience Accessors

extension Resistance {
    /// オーム単位で値を取得
    @inlinable
    public var ohms: Double {
        value(in: .ohms)
    }

    /// ミリオーム単位で値を取得
    @inlinable
    public var milliohms: Double {
        value(in: .milliohms)
    }

    /// キロオーム単位で値を取得
    @inlinable
    public var kilohms: Double {
        value(in: .kilohms)
    }

    /// メガオーム単位で値を取得
    @inlinable
    public var megaohms: Double {
        value(in: .megaohms)
    }

    /// ギガオーム単位で値を取得
    @inlinable
    public var gigaohms: Double {
        value(in: .gigaohms)
    }
}

// MARK: - Resistance Formatting

extension Resistance {
    /// 適切な単位で自動フォーマット
    public var formatted: String {
        let r = ohms
        if abs(r) >= 1e9 {
            return String(format: "%.2f GΩ", gigaohms)
        } else if abs(r) >= 1e6 {
            return String(format: "%.2f MΩ", megaohms)
        } else if abs(r) >= 1e3 {
            return String(format: "%.2f kΩ", kilohms)
        } else if abs(r) >= 1 {
            return String(format: "%.2f Ω", r)
        } else {
            return String(format: "%.2f mΩ", milliohms)
        }
    }
}

// MARK: - Resistance Common Values

extension Resistance {
    /// LED 電流制限抵抗の代表値 (220Ω)
    public static let led220 = Resistance(220, unit: .ohms)

    /// 一般的なプルアップ抵抗値 (10kΩ)
    public static let pullUp10k = Resistance(10, unit: .kilohms)

    /// 一般的なプルアップ抵抗値 (4.7kΩ)
    public static let pullUp4k7 = Resistance(4.7, unit: .kilohms)
}
