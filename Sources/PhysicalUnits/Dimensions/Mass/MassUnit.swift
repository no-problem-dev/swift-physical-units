import Foundation

/// A unit of mass: an SI prefix applied to the gram.
///
/// The base unit is the **gram**, not the SI kilogram — a prefix has to attach to an unprefixed
/// unit. So `Mass` stores grams, `.kilograms` has a coefficient of 1000, and crossing into the
/// kilogram-based newton costs a factor of 1000 that the typed `Mass` × `Acceleration` and
/// `Force` / `Mass` operators apply for you.
///
/// Every case is a power of ten away from the gram, so every conversion here is exact by
/// definition. There are no avoirdupois units: no pounds, ounces or short tons, and none of
/// their conversion factors. The factors are `Double`s, though, and only the non-negative
/// powers of ten are exactly representable: `kilo` and `mega` scale exactly, while `milli`,
/// `micro` and `nano` multiply by a rounded factor.
///
/// Six prefixes get a shorthand below — `megagrams` and `tonnes` are two names for the same
/// one. ``MetricPrefix`` has fifteen cases in all, from `femto` (10⁻¹⁵) to `peta` (10¹⁵), and
/// any of them can be passed directly: `MassUnit(.deca)`.
public typealias MassUnit = MetricUnit<Gram>

// MARK: - Convenience Static Properties

extension MassUnit {
    @inlinable
    public static var grams: MassUnit {
        MassUnit(.base)
    }

    @inlinable
    public static var kilograms: MassUnit {
        MassUnit(.kilo)
    }

    @inlinable
    public static var milligrams: MassUnit {
        MassUnit(.milli)
    }

    @inlinable
    public static var micrograms: MassUnit {
        MassUnit(.micro)
    }

    /// Nanogram (ng), exactly 10⁻⁹ g.
    ///
    /// `Mass` has no matching accessor, so read a value back with `value(in: .nanograms)`.
    @inlinable
    public static var nanograms: MassUnit {
        MassUnit(.nano)
    }

    /// Megagram (Mg), exactly 10⁶ g.
    ///
    /// The same unit as ``tonnes``, spelled the SI way. Its symbol is `Mg`, not `t`; nothing in
    /// this package prints `t` except `Mass.formatted`.
    @inlinable
    public static var megagrams: MassUnit {
        MassUnit(.mega)
    }

    /// Tonne (t), the metric ton: exactly 1000 kg.
    ///
    /// ``megagrams`` under its everyday name — the same prefix, so the two are interchangeable.
    /// This is not the US short ton (907.18474 kg) or the imperial long ton (1016.0469088 kg);
    /// neither of those has a unit here.
    @inlinable
    public static var tonnes: MassUnit {
        MassUnit(.mega)
    }
}

// MARK: - Mass Type Alias

/// A mass, stored internally in grams.
///
/// - Important: Grams, not kilograms. `Force` is kilogram-based, so the `Mass` × `Acceleration`
///   and `Force` / `Mass` operators divide and multiply by 1000 on the way across — an exact
///   factor, since the SI kilo prefix is exactly 10³. Reaching past those operators into plain
///   `Double` arithmetic skips the bridge and comes out a factor of 1000 wrong.
///
/// ## Example
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
    @inlinable
    public var grams: Double {
        value(in: .grams)
    }

    @inlinable
    public var kilograms: Double {
        value(in: .kilograms)
    }

    @inlinable
    public var milligrams: Double {
        value(in: .milligrams)
    }

    @inlinable
    public var micrograms: Double {
        value(in: .micrograms)
    }

    /// The value in metric tonnes, which is also the value in megagrams.
    @inlinable
    public var tonnes: Double {
        value(in: .tonnes)
    }
}

// MARK: - Mass CustomStringConvertible

extension Mass {
    /// The value in the largest metric multiple that fits: t from 1000 kg, then kg, g, mg, and μg below 1 mg.
    ///
    /// Always two decimals, and the threshold is read in kilograms rather than in the stored
    /// grams. Nanograms are never chosen, so anything below a microgram prints as a fraction of
    /// one and zero prints as `0.00 μg`.
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
