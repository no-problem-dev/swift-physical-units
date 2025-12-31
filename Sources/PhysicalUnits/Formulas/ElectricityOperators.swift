import Foundation

// MARK: - Electricity Operators
// 電気の基本公式を演算子として実装
//
// 電力 = 電圧 × 電流      (P = V × I)
// 電圧 = 電力 / 電流      (V = P / I)
// 電流 = 電力 / 電圧      (I = P / V)
// 電力量 = 電力 × 時間    (E = P × t) - MechanicsOperators で定義済み

// MARK: - Power = Voltage × Current

/// 電圧 × 電流 = 電力
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

/// 電流 × 電圧 = 電力（可換）
@inlinable
public func * (current: Current, voltage: Voltage) -> Power {
    voltage * current
}

// MARK: - Voltage = Power / Current

/// 電力 / 電流 = 電圧
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

/// 電力 / 電圧 = 電流
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

/// 電流 × 抵抗 = 電圧（オームの法則）
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

/// 抵抗 × 電流 = 電圧（可換）
@inlinable
public func * (resistance: Resistance, current: Current) -> Voltage {
    current * resistance
}

// MARK: - Current = Voltage / Resistance

/// 電圧 / 抵抗 = 電流
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

/// 電圧 / 電流 = 抵抗
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
    /// 電流と電力から抵抗を計算
    ///
    /// R = P / I²
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

    /// 電圧と電力から抵抗を計算
    ///
    /// R = V² / P
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
    /// 電流から消費電力を計算
    ///
    /// P = I² × R
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

    /// 電圧から消費電力を計算
    ///
    /// P = V² / R
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

/// 電流 × 時間 = 電荷
///
/// Q = I × t
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

/// 時間 × 電流 = 電荷（可換）
@inlinable
public func * (time: Duration, current: Current) -> Charge {
    current * time
}

// MARK: - Current = Charge / Time

/// 電荷 / 時間 = 電流
///
/// I = Q / t
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

/// 電荷 / 電流 = 時間
///
/// t = Q / I
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
