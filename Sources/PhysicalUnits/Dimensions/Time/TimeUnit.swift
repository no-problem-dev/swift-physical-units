import Foundation

/// 時間の単位
///
/// SI 接頭辞付きの秒と、非 SI 単位（分、時間、日）を統合した単位型。
/// 秒を基準単位として、すべての時間単位を表現します。
///
/// ## 設計思想
/// 時間は他の物理量と異なり、60進法（分、時間）や24進法（日）が広く使われます。
/// これらは SI 接頭辞では表現できないため、enum + associated value で実装しています。
///
/// ## 使用例
/// ```swift
/// let duration = Duration(90, unit: .minutes)
/// print(duration.hours)   // 1.5
/// print(duration.seconds) // 5400.0
///
/// let precise = Duration(500, unit: .milliseconds)
/// print(precise.seconds)  // 0.5
/// ```
@frozen
public enum TimeUnit: Unit, Codable, Sendable, Hashable {
    /// SI 接頭辞付きの秒
    case seconds(MetricPrefix)

    /// 分（60秒）
    case minutes

    /// 時間（3600秒）
    case hours

    /// 日（86400秒）
    case days

    // MARK: - Unit Protocol

    /// 基準単位（秒）への変換係数
    @inlinable
    public var coefficientToBase: Double {
        switch self {
        case .seconds(let prefix):
            return prefix.factor
        case .minutes:
            return 60
        case .hours:
            return 3600
        case .days:
            return 86400
        }
    }

    /// 単位記号
    public var symbol: String {
        switch self {
        case .seconds(let prefix):
            return prefix.symbol + "s"
        case .minutes:
            return "min"
        case .hours:
            return "h"
        case .days:
            return "d"
        }
    }
}

// MARK: - Convenience Static Properties

extension TimeUnit {
    /// 秒 (s)
    @inlinable
    public static var seconds: TimeUnit {
        .seconds(.base)
    }

    /// ミリ秒 (ms)
    @inlinable
    public static var milliseconds: TimeUnit {
        .seconds(.milli)
    }

    /// マイクロ秒 (μs)
    @inlinable
    public static var microseconds: TimeUnit {
        .seconds(.micro)
    }

    /// ナノ秒 (ns)
    @inlinable
    public static var nanoseconds: TimeUnit {
        .seconds(.nano)
    }
}

// MARK: - CustomStringConvertible

extension TimeUnit: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

// MARK: - Duration Type Alias

/// 時間（継続時間）
///
/// `Measurement<TimeUnit>` の型エイリアス。
/// 時間を型安全に表現します。
///
/// ## 使用例
/// ```swift
/// let workout = Duration(45, unit: .minutes)
/// print(workout.hours)    // 0.75
/// print(workout.seconds)  // 2700.0
///
/// let rest = Duration(90, unit: .seconds)
/// print(rest.minutes)     // 1.5
/// ```
public typealias Duration = Measurement<TimeUnit>

// MARK: - Duration Convenience Accessors

extension Duration {
    /// 秒単位で値を取得
    @inlinable
    public var seconds: Double {
        value(in: .seconds)
    }

    /// ミリ秒単位で値を取得
    @inlinable
    public var milliseconds: Double {
        value(in: .milliseconds)
    }

    /// マイクロ秒単位で値を取得
    @inlinable
    public var microseconds: Double {
        value(in: .microseconds)
    }

    /// ナノ秒単位で値を取得
    @inlinable
    public var nanoseconds: Double {
        value(in: .nanoseconds)
    }

    /// 分単位で値を取得
    @inlinable
    public var minutes: Double {
        value(in: .minutes)
    }

    /// 時間単位で値を取得
    @inlinable
    public var hours: Double {
        value(in: .hours)
    }

    /// 日単位で値を取得
    @inlinable
    public var days: Double {
        value(in: .days)
    }
}

// MARK: - Duration Formatting

extension Duration {
    /// 適切な単位で自動フォーマット
    ///
    /// 値の大きさに応じて適切な単位を選択します。
    public var formatted: String {
        let s = seconds
        if abs(s) >= 86400 {
            return String(format: "%.2f d", days)
        } else if abs(s) >= 3600 {
            return String(format: "%.2f h", hours)
        } else if abs(s) >= 60 {
            return String(format: "%.2f min", minutes)
        } else if abs(s) >= 1 {
            return String(format: "%.2f s", s)
        } else if abs(milliseconds) >= 1 {
            return String(format: "%.2f ms", milliseconds)
        } else {
            return String(format: "%.2f μs", microseconds)
        }
    }

    /// 時:分:秒 形式でフォーマット
    ///
    /// 例: "1:30:00" (1時間30分)
    public var formattedHMS: String {
        let totalSeconds = Int(seconds)
        let h = totalSeconds / 3600
        let m = (totalSeconds % 3600) / 60
        let s = totalSeconds % 60

        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        } else {
            return String(format: "%d:%02d", m, s)
        }
    }
}
