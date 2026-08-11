import Foundation

/// A unit of voltage, that is of electric potential difference: an SI prefix applied to the volt.
///
/// Every case is a power of ten away from the volt, so every conversion here is exact by
/// definition. The factors are `Double`s, and only the non-negative powers of ten are exactly
/// representable: `kilo` and `mega` scale exactly, while `milli` and `micro` multiply by a
/// rounded factor.
///
/// Five prefixes get a shorthand below. ``MetricPrefix`` has fifteen cases in all, from `femto`
/// (10⁻¹⁵) to `peta` (10¹⁵), and any of them can be passed directly: `VoltageUnit(.nano)`.
public typealias VoltageUnit = MetricUnit<Volt>

// MARK: - Convenience Static Properties

extension VoltageUnit {
    @inlinable
    public static var volts: VoltageUnit {
        VoltageUnit(.base)
    }

    @inlinable
    public static var microvolts: VoltageUnit {
        VoltageUnit(.micro)
    }

    @inlinable
    public static var millivolts: VoltageUnit {
        VoltageUnit(.milli)
    }

    @inlinable
    public static var kilovolts: VoltageUnit {
        VoltageUnit(.kilo)
    }

    @inlinable
    public static var megavolts: VoltageUnit {
        VoltageUnit(.mega)
    }
}

// MARK: - Voltage Type Alias

/// A voltage, stored internally in volts.
///
/// A potential *difference*, so it is signed and adds and subtracts freely — nothing here
/// carries a reference node, and a value is only meaningful against whatever you took as
/// ground. For AC the number is whatever you put in, RMS or peak; the type does not know which.
///
/// ## Example
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
    @inlinable
    public var volts: Double {
        value(in: .volts)
    }

    @inlinable
    public var microvolts: Double {
        value(in: .microvolts)
    }

    @inlinable
    public var millivolts: Double {
        value(in: .millivolts)
    }

    @inlinable
    public var kilovolts: Double {
        value(in: .kilovolts)
    }

    @inlinable
    public var megavolts: Double {
        value(in: .megavolts)
    }
}

// MARK: - Voltage Formatting

extension Voltage {
    /// The value in the largest metric multiple that fits: MV from 10⁶ V, then kV, V, mV, and μV below 1 mV.
    ///
    /// Two decimals down to mV, one for μV. Zero prints as `0.0 μV`.
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
    /// The 5 V a USB port carries on VBUS before anything is negotiated.
    ///
    /// USB Power Delivery raises it — 9, 15, 20 V and, at extended range, up to 48 V — so this
    /// is the default, not a ceiling. Nor does it pair with `Current.usbPDMax`: at 5 V the
    /// standard power profiles stop at 3 A, and 5 A belongs to the higher voltages.
    public static let usb = Voltage(5, unit: .volts)

    /// Japanese mains, 100 V nominal RMS.
    ///
    /// A nominal figure: the supply is only held near it, and the peak of the waveform is about
    /// √2 times as large. Japan is also split between 50 Hz and 60 Hz, which a voltage cannot
    /// express.
    public static let householdJapan = Voltage(100, unit: .volts)

    /// US mains, 120 V nominal RMS, measured from either leg to neutral.
    ///
    /// The same service supplies 240 V across the two legs, for ranges and dryers.
    public static let householdUS = Voltage(120, unit: .volts)

    /// European mains, 230 V nominal RMS.
    ///
    /// The harmonised nominal value, with a tolerance of ±10 % around it, so equipment sees
    /// anything from 207 V to 253 V.
    public static let householdEU = Voltage(230, unit: .volts)
}
