import Foundation

/// 電流の単位
///
/// `MetricUnit<Ampere>` の型エイリアス。
/// 接頭辞を変えることで、アンペア、ミリアンペア、マイクロアンペアなどを表現できます。
public typealias CurrentUnit = MetricUnit<Ampere>

// MARK: - Convenience Static Properties

extension CurrentUnit {
    /// アンペア (A)
    @inlinable
    public static var amperes: CurrentUnit {
        CurrentUnit(.base)
    }

    /// ナノアンペア (nA)
    @inlinable
    public static var nanoamperes: CurrentUnit {
        CurrentUnit(.nano)
    }

    /// マイクロアンペア (μA)
    @inlinable
    public static var microamperes: CurrentUnit {
        CurrentUnit(.micro)
    }

    /// ミリアンペア (mA)
    @inlinable
    public static var milliamperes: CurrentUnit {
        CurrentUnit(.milli)
    }

    /// キロアンペア (kA)
    @inlinable
    public static var kiloamperes: CurrentUnit {
        CurrentUnit(.kilo)
    }
}

// MARK: - Current Type Alias

/// 電流
///
/// `Measurement<CurrentUnit>` の型エイリアス。
/// 電流を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let led = Current(20, unit: .milliamperes)
/// print(led.amperes)  // 0.02
///
/// let motor = Current(5, unit: .amperes)
/// print(motor.milliamperes)  // 5000.0
/// ```
public typealias Current = Measurement<CurrentUnit>

// MARK: - Current Convenience Accessors

extension Current {
    /// アンペア単位で値を取得
    @inlinable
    public var amperes: Double {
        value(in: .amperes)
    }

    /// ナノアンペア単位で値を取得
    @inlinable
    public var nanoamperes: Double {
        value(in: .nanoamperes)
    }

    /// マイクロアンペア単位で値を取得
    @inlinable
    public var microamperes: Double {
        value(in: .microamperes)
    }

    /// ミリアンペア単位で値を取得
    @inlinable
    public var milliamperes: Double {
        value(in: .milliamperes)
    }

    /// キロアンペア単位で値を取得
    @inlinable
    public var kiloamperes: Double {
        value(in: .kiloamperes)
    }
}

// MARK: - Current Formatting

extension Current {
    /// 適切な単位で自動フォーマット
    public var formatted: String {
        let a = amperes
        if abs(a) >= 1e3 {
            return String(format: "%.2f kA", kiloamperes)
        } else if abs(a) >= 1 {
            return String(format: "%.2f A", a)
        } else if abs(milliamperes) >= 1 {
            return String(format: "%.2f mA", milliamperes)
        } else if abs(microamperes) >= 1 {
            return String(format: "%.1f μA", microamperes)
        } else {
            return String(format: "%.1f nA", nanoamperes)
        }
    }
}

// MARK: - Current Special Values

extension Current {
    /// USB 2.0 最大電流（500 mA）
    public static let usb2Max = Current(500, unit: .milliamperes)

    /// USB 3.0 最大電流（900 mA）
    public static let usb3Max = Current(900, unit: .milliamperes)

    /// USB PD 最大電流（5 A）
    public static let usbPDMax = Current(5, unit: .amperes)
}
