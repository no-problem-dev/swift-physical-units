import Foundation

/// A charge unit: coulombs with any SI prefix.
///
/// The coulomb is the base, and the prefix supplies the only conversion factor, so every
/// conversion within this type is an exact power of ten.
///
/// ## Relation to current
/// Q = I × t — charge is current times time, and 1 C = 1 A·s exactly.
///
/// ## Example
/// ```swift
/// let charge = Charge(1, unit: .coulombs)
/// print(charge.milliampereHours)  // 0.2777...
/// ```
public typealias ChargeUnit = MetricUnit<Coulomb>

// MARK: - Convenience Static Properties

extension ChargeUnit {
    @inlinable
    public static var coulombs: ChargeUnit {
        ChargeUnit(.base)
    }

    @inlinable
    public static var millicoulombs: ChargeUnit {
        ChargeUnit(.milli)
    }

    @inlinable
    public static var microcoulombs: ChargeUnit {
        ChargeUnit(.micro)
    }

    @inlinable
    public static var nanocoulombs: ChargeUnit {
        ChargeUnit(.nano)
    }

    @inlinable
    public static var kilocoulombs: ChargeUnit {
        ChargeUnit(.kilo)
    }
}

// MARK: - Charge Type Alias

/// A charge value, stored in coulombs whichever prefix it was written with.
///
/// ## Example
/// ```swift
/// let batteryCharge = Charge(5000, unit: .millicoulombs)
/// print(batteryCharge.coulombs)  // 5.0
///
/// // Charge from a current and how long it flowed
/// let current = Current(2, unit: .amperes)
/// let time = Duration(10, unit: .seconds)
/// let charge: Charge = current * time  // 20 C
/// ```
public typealias Charge = Measurement<ChargeUnit>

// MARK: - Charge Convenience Accessors

extension Charge {
    @inlinable
    public var coulombs: Double {
        value(in: .coulombs)
    }

    @inlinable
    public var millicoulombs: Double {
        value(in: .millicoulombs)
    }

    @inlinable
    public var microcoulombs: Double {
        value(in: .microcoulombs)
    }

    @inlinable
    public var nanocoulombs: Double {
        value(in: .nanocoulombs)
    }

    @inlinable
    public var kilocoulombs: Double {
        value(in: .kilocoulombs)
    }
}

// MARK: - Charge Practical Units

extension Charge {
    /// The charge expressed in ampere-hours, the rating printed on batteries.
    ///
    /// 1 A·h = 3600 C exactly, since an hour is exactly 3600 s. The ampere-hour is not one of
    /// the units this type checks, so the result is a bare `Double` that the compiler will let
    /// you mix with any other number.
    @inlinable
    public var ampereHours: Double {
        coulombs / 3600.0
    }

    /// The charge expressed in milliampere-hours, the rating printed on phone and laptop cells.
    ///
    /// 1 mA·h = 3.6 C exactly. Like `ampereHours`, this leaves the unit system: it returns a
    /// plain `Double` with nothing to stop it being added to a value in some other unit.
    @inlinable
    public var milliampereHours: Double {
        coulombs / 3.6
    }

    /// Creates a charge from an ampere-hour rating, multiplying by exactly 3600.
    ///
    /// ```swift
    /// let battery = Charge(ampereHours: 5)  // 18000 C
    /// ```
    @inlinable
    public init(ampereHours: Double) {
        self = Charge(ampereHours * 3600.0, unit: .coulombs)
    }

    /// Creates a charge from a milliampere-hour rating, multiplying by exactly 3.6.
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
    /// The value rendered with whichever prefix keeps it in a readable range.
    ///
    /// kC from 1000 C up, then C, mC, and μC, always to two decimal places. The ladder stops at
    /// nanocoulombs, so anything smaller renders as "0.00 nC" — an elementary charge included.
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
    /// The elementary charge e, exactly 1.602176634 × 10⁻¹⁹ C.
    ///
    /// Exact rather than measured: the 2019 SI redefinition fixed e to define the ampere, so no
    /// future experiment revises it. Stored positive — an electron carries -e, so negate this
    /// when the sign matters.
    public static let elementaryCharge = Charge(1.602176634e-19, unit: .coulombs)
}
