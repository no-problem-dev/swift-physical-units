import Foundation

/// 電圧（電位差）の単位
///
/// `MetricUnit<Volt>` の型エイリアス。
/// 接頭辞を変えることで、ボルト、ミリボルト、キロボルトなどを表現できます。
public typealias VoltageUnit = MetricUnit<Volt>

// MARK: - Convenience Static Properties

extension VoltageUnit {
    /// ボルト (V)
    @inlinable
    public static var volts: VoltageUnit {
        VoltageUnit(.base)
    }

    /// マイクロボルト (μV)
    @inlinable
    public static var microvolts: VoltageUnit {
        VoltageUnit(.micro)
    }

    /// ミリボルト (mV)
    @inlinable
    public static var millivolts: VoltageUnit {
        VoltageUnit(.milli)
    }

    /// キロボルト (kV)
    @inlinable
    public static var kilovolts: VoltageUnit {
        VoltageUnit(.kilo)
    }

    /// メガボルト (MV)
    @inlinable
    public static var megavolts: VoltageUnit {
        VoltageUnit(.mega)
    }
}

// MARK: - Voltage Type Alias

/// 電圧（電位差）
///
/// `Measurement<VoltageUnit>` の型エイリアス。
/// 電圧を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let battery = Voltage(1.5, unit: .volts)
/// print(battery.millivolts)  // 1500.0
///
/// let powerLine = Voltage(100, unit: .kilovolts)
/// print(powerLine.volts)     // 100000.0
/// ```
public typealias Voltage = Measurement<VoltageUnit>

// MARK: - Voltage Convenience Accessors

extension Voltage {
    /// ボルト単位で値を取得
    @inlinable
    public var volts: Double {
        value(in: .volts)
    }

    /// マイクロボルト単位で値を取得
    @inlinable
    public var microvolts: Double {
        value(in: .microvolts)
    }

    /// ミリボルト単位で値を取得
    @inlinable
    public var millivolts: Double {
        value(in: .millivolts)
    }

    /// キロボルト単位で値を取得
    @inlinable
    public var kilovolts: Double {
        value(in: .kilovolts)
    }

    /// メガボルト単位で値を取得
    @inlinable
    public var megavolts: Double {
        value(in: .megavolts)
    }
}

// MARK: - Voltage Formatting

extension Voltage {
    /// 適切な単位で自動フォーマット
    public var formatted: String {
        let v = volts
        if abs(v) >= 1e6 {
            return String(format: "%.2f MV", megavolts)
        } else if abs(v) >= 1e3 {
            return String(format: "%.2f kV", kilovolts)
        } else if abs(v) >= 1 {
            return String(format: "%.2f V", v)
        } else if abs(millivolts) >= 1 {
            return String(format: "%.2f mV", millivolts)
        } else {
            return String(format: "%.1f μV", microvolts)
        }
    }
}

// MARK: - Voltage Special Values

extension Voltage {
    /// USB 電圧（5V）
    public static let usb = Voltage(5, unit: .volts)

    /// 家庭用電源（日本: 100V）
    public static let householdJapan = Voltage(100, unit: .volts)

    /// 家庭用電源（米国: 120V）
    public static let householdUS = Voltage(120, unit: .volts)

    /// 家庭用電源（欧州: 230V）
    public static let householdEU = Voltage(230, unit: .volts)
}
