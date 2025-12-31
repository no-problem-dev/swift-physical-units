import Foundation

/// 周波数の単位
///
/// `MetricUnit<Hertz>` の型エイリアス。
/// 接頭辞を変えることで、ヘルツ、キロヘルツ、メガヘルツなどを表現できます。
public typealias FrequencyUnit = MetricUnit<Hertz>

// MARK: - Convenience Static Properties

extension FrequencyUnit {
    /// ヘルツ (Hz)
    @inlinable
    public static var hertz: FrequencyUnit {
        FrequencyUnit(.base)
    }

    /// ミリヘルツ (mHz)
    @inlinable
    public static var millihertz: FrequencyUnit {
        FrequencyUnit(.milli)
    }

    /// キロヘルツ (kHz)
    @inlinable
    public static var kilohertz: FrequencyUnit {
        FrequencyUnit(.kilo)
    }

    /// メガヘルツ (MHz)
    @inlinable
    public static var megahertz: FrequencyUnit {
        FrequencyUnit(.mega)
    }

    /// ギガヘルツ (GHz)
    @inlinable
    public static var gigahertz: FrequencyUnit {
        FrequencyUnit(.giga)
    }

    /// テラヘルツ (THz)
    @inlinable
    public static var terahertz: FrequencyUnit {
        FrequencyUnit(.tera)
    }
}

// MARK: - Frequency Type Alias

/// 周波数
///
/// `Measurement<FrequencyUnit>` の型エイリアス。
/// 周波数を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let radio = Frequency(88.1, unit: .megahertz)
/// print(radio.kilohertz)  // 88100.0
///
/// let cpu = Frequency(3.5, unit: .gigahertz)
/// print(cpu.megahertz)    // 3500.0
/// ```
public typealias Frequency = Measurement<FrequencyUnit>

// MARK: - Frequency Convenience Accessors

extension Frequency {
    /// ヘルツ単位で値を取得
    @inlinable
    public var hertz: Double {
        value(in: .hertz)
    }

    /// ミリヘルツ単位で値を取得
    @inlinable
    public var millihertz: Double {
        value(in: .millihertz)
    }

    /// キロヘルツ単位で値を取得
    @inlinable
    public var kilohertz: Double {
        value(in: .kilohertz)
    }

    /// メガヘルツ単位で値を取得
    @inlinable
    public var megahertz: Double {
        value(in: .megahertz)
    }

    /// ギガヘルツ単位で値を取得
    @inlinable
    public var gigahertz: Double {
        value(in: .gigahertz)
    }

    /// テラヘルツ単位で値を取得
    @inlinable
    public var terahertz: Double {
        value(in: .terahertz)
    }

    /// 周期（秒）を取得
    @inlinable
    public var period: Double {
        1.0 / hertz
    }
}

// MARK: - Frequency Formatting

extension Frequency {
    /// 適切な単位で自動フォーマット
    public var formatted: String {
        let hz = hertz
        if abs(hz) >= 1e12 {
            return String(format: "%.2f THz", terahertz)
        } else if abs(hz) >= 1e9 {
            return String(format: "%.2f GHz", gigahertz)
        } else if abs(hz) >= 1e6 {
            return String(format: "%.2f MHz", megahertz)
        } else if abs(hz) >= 1e3 {
            return String(format: "%.2f kHz", kilohertz)
        } else if abs(hz) >= 1 {
            return String(format: "%.2f Hz", hz)
        } else {
            return String(format: "%.3f mHz", millihertz)
        }
    }
}
