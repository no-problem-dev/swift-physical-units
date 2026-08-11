import Foundation

// MARK: - Electricity Operators
// The basic electrical formulas, written as operators.
//
// Power   = voltage × current   (P = V × I)
// Voltage = power / current     (V = P / I)
// Current = power / voltage     (I = P / V)
// Energy  = power × time        (E = P × t) - already defined in MechanicsOperators
//
// Every operator here works directly on SI base values (V, A, W, Ω, C, s), so no numeric
// conversion factor is involved anywhere in this file. The SI electrical units are coherent
// by definition — 1 W = 1 V·A, 1 Ω = 1 V/A and 1 C = 1 A·s are exact — so the only error is
// `Double` rounding, not unit conversion.
//
// Where compile-time dimension checking stops: these operators are the whole of it. A
// cross-dimension expression type-checks only for the pairs spelled out in this file and its
// siblings; there is no general dimensional algebra behind them, so a combination nobody
// wrote is a compile error rather than a newly derived dimension. Anything that leaves the
// typed operators also leaves the checking: scalar arithmetic (`Measurement * Double`) keeps
// whatever dimension the operand had regardless of what the scalar meant, the same-dimension
// ratio `Measurement / Measurement -> Double` drops the dimension entirely, and a `baseValue`
// read hands back a bare number that can be fed into any dimension's initializer.

// MARK: - Power = Voltage × Current

/// Multiplies a voltage by a current to give power.
///
/// P = V × I
///
/// ```swift
/// let voltage = Voltage(100, unit: .volts)
/// let current = Current(5, unit: .amperes)
/// let power: Power = voltage * current  // 500 W
/// ```
@inlinable
public func * (voltage: Voltage, current: Current) -> Power {
    // voltage.baseValue is in V, current.baseValue is in A
    // V × A = W (watts)
    Power(baseValue: voltage.baseValue * current.baseValue)
}

/// The commutative form of P = V × I, with the operands in the other order.
@inlinable
public func * (current: Current, voltage: Voltage) -> Power {
    voltage * current
}

// MARK: - Voltage = Power / Current

/// Divides power by current to give the voltage across the load.
///
/// V = P / I
///
/// ```swift
/// let power = Power(500, unit: .watts)
/// let current = Current(5, unit: .amperes)
/// let voltage: Voltage = power / current  // 100 V
/// ```
@inlinable
public func / (power: Power, current: Current) -> Voltage {
    // power.baseValue is in W, current.baseValue is in A
    // W / A = V (volts)
    Voltage(baseValue: power.baseValue / current.baseValue)
}

// MARK: - Current = Power / Voltage

/// Divides power by voltage to give the current drawn.
///
/// I = P / V
///
/// ```swift
/// let power = Power(500, unit: .watts)
/// let voltage = Voltage(100, unit: .volts)
/// let current: Current = power / voltage  // 5 A
/// ```
@inlinable
public func / (power: Power, voltage: Voltage) -> Current {
    // power.baseValue is in W, voltage.baseValue is in V
    // W / V = A (amperes)
    Current(baseValue: power.baseValue / voltage.baseValue)
}

// MARK: - ============================================
// MARK: - Ohm's Law (V = IR)
// MARK: - ============================================

// MARK: - Voltage = Current × Resistance

/// Multiplies a current by a resistance to give the voltage drop, by Ohm's law.
///
/// V = I × R
///
/// ```swift
/// let current = Current(0.5, unit: .amperes)
/// let resistance = Resistance(100, unit: .ohms)
/// let voltage: Voltage = current * resistance  // 50 V
/// ```
@inlinable
public func * (current: Current, resistance: Resistance) -> Voltage {
    // current.baseValue is in A, resistance.baseValue is in Ω
    // A × Ω = V (volts)
    Voltage(baseValue: current.baseValue * resistance.baseValue)
}

/// The commutative form of Ohm's law V = I × R, with the operands in the other order.
@inlinable
public func * (resistance: Resistance, current: Current) -> Voltage {
    current * resistance
}

// MARK: - Current = Voltage / Resistance

/// Divides a voltage by a resistance to give the current, by Ohm's law.
///
/// I = V / R
///
/// ```swift
/// let voltage = Voltage(12, unit: .volts)
/// let resistance = Resistance(4, unit: .kilohms)
/// let current: Current = voltage / resistance  // 3 mA
/// ```
@inlinable
public func / (voltage: Voltage, resistance: Resistance) -> Current {
    // voltage.baseValue is in V, resistance.baseValue is in Ω
    // V / Ω = A (amperes)
    Current(baseValue: voltage.baseValue / resistance.baseValue)
}

// MARK: - Resistance = Voltage / Current

/// Divides a voltage by a current to give the resistance, by Ohm's law.
///
/// R = V / I
///
/// ```swift
/// let voltage = Voltage(5, unit: .volts)
/// let current = Current(10, unit: .milliamperes)
/// let resistance: Resistance = voltage / current  // 500 Ω
/// ```
@inlinable
public func / (voltage: Voltage, current: Current) -> Resistance {
    // voltage.baseValue is in V, current.baseValue is in A
    // V / A = Ω (ohms)
    Resistance(baseValue: voltage.baseValue / current.baseValue)
}

// MARK: - ============================================
// MARK: - Power with Resistance (P = I²R, P = V²/R)
// MARK: - ============================================

// MARK: - Resistance = Power / Current²
// Note: These require quadratic operations, implemented as extension methods

extension Power {
    /// The resistance that dissipates this power at the given current.
    ///
    /// R = P / I²
    ///
    /// This is a method rather than an operator because the current is squared, which the
    /// typed operators cannot express: there is no `Current × Current` dimension.
    ///
    /// ```swift
    /// let power = Power(10, unit: .watts)
    /// let current = Current(0.5, unit: .amperes)
    /// let resistance = power.resistance(at: current)  // 40 Ω
    /// ```
    @inlinable
    public func resistance(at current: Current) -> Resistance {
        // P = I²R → R = P / I²
        Resistance(baseValue: baseValue / (current.baseValue * current.baseValue))
    }

    /// The resistance that dissipates this power at the given voltage.
    ///
    /// R = V² / P
    ///
    /// Shares the `at:` label with the current-based overload; which relation you get is
    /// decided by the argument's type, so a bare `Double` will not compile.
    ///
    /// ```swift
    /// let power = Power(100, unit: .watts)
    /// let voltage = Voltage(100, unit: .volts)
    /// let resistance = power.resistance(at: voltage)  // 100 Ω
    /// ```
    @inlinable
    public func resistance(at voltage: Voltage) -> Resistance {
        // P = V²/R → R = V²/P
        Resistance(baseValue: (voltage.baseValue * voltage.baseValue) / baseValue)
    }
}

extension Resistance {
    /// The power this resistance dissipates when carrying the given current.
    ///
    /// P = I² × R
    ///
    /// The current is squared, so this is a method rather than an operator.
    ///
    /// ```swift
    /// let resistance = Resistance(100, unit: .ohms)
    /// let current = Current(0.5, unit: .amperes)
    /// let power = resistance.power(at: current)  // 25 W
    /// ```
    @inlinable
    public func power(at current: Current) -> Power {
        // P = I²R
        Power(baseValue: current.baseValue * current.baseValue * baseValue)
    }

    /// The power this resistance dissipates with the given voltage across it.
    ///
    /// P = V² / R
    ///
    /// Shares the `at:` label with the current-based overload; the argument's type picks
    /// which of the two relations applies.
    ///
    /// ```swift
    /// let resistance = Resistance(100, unit: .ohms)
    /// let voltage = Voltage(10, unit: .volts)
    /// let power = resistance.power(at: voltage)  // 1 W
    /// ```
    @inlinable
    public func power(at voltage: Voltage) -> Power {
        // P = V²/R
        Power(baseValue: (voltage.baseValue * voltage.baseValue) / baseValue)
    }
}

// MARK: - ============================================
// MARK: - Charge (Q = It)
// MARK: - ============================================

// MARK: - Charge = Current × Time

/// Multiplies a current by a duration to give the charge transferred.
///
/// Q = I × t
///
/// Assumes the current is constant over the interval; 1 C = 1 A·s exactly, so nothing is
/// converted. To go the other way from a battery rating, `Charge(ampereHours:)` and
/// `Charge(milliampereHours:)` are exact too — an hour is exactly 3600 s, so 1 A·h = 3600 C.
///
/// ```swift
/// let current = Current(2, unit: .amperes)
/// let time = Duration(10, unit: .seconds)
/// let charge: Charge = current * time  // 20 C
/// ```
@inlinable
public func * (current: Current, time: Duration) -> Charge {
    // current.baseValue is in A, time.baseValue is in s
    // A × s = C (coulombs)
    Charge(baseValue: current.baseValue * time.baseValue)
}

/// The commutative form of Q = I × t, with the operands in the other order.
@inlinable
public func * (time: Duration, current: Current) -> Charge {
    current * time
}

// MARK: - Current = Charge / Time

/// Divides charge by the duration it moved over to give the average current.
///
/// I = Q / t
///
/// The result is the mean over the interval, not an instantaneous value.
///
/// ```swift
/// let charge = Charge(100, unit: .coulombs)
/// let time = Duration(10, unit: .seconds)
/// let current: Current = charge / time  // 10 A
/// ```
@inlinable
public func / (charge: Charge, time: Duration) -> Current {
    // charge.baseValue is in C, time.baseValue is in s
    // C / s = A (amperes)
    Current(baseValue: charge.baseValue / time.baseValue)
}

// MARK: - Time = Charge / Current

/// Divides charge by current to give how long that charge lasts.
///
/// t = Q / I
///
/// This is the flat-rate battery discharge estimate: a capacity divided by a steady draw.
/// Feeding it a capacity from `Charge(ampereHours:)` costs nothing in accuracy, because
/// 1 A·h = 3600 C exactly — the hour is defined as exactly 3600 s. What it does assume is a
/// constant current and a battery that delivers its full nameplate capacity, neither of
/// which real cells honour.
///
/// ```swift
/// let charge = Charge(100, unit: .coulombs)
/// let current = Current(10, unit: .amperes)
/// let time: Duration = charge / current  // 10 s
/// ```
@inlinable
public func / (charge: Charge, current: Current) -> Duration {
    // charge.baseValue is in C, current.baseValue is in A
    // C / A = s (seconds)
    Duration(baseValue: charge.baseValue / current.baseValue)
}
