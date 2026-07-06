import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thrown when the on-device Gemini usage limit has been hit. [retryAfter] is
/// how long until the window resets.
class GeminiRateLimitException implements Exception {
  const GeminiRateLimitException(this.retryAfter);

  final Duration retryAfter;

  /// Human-friendly "try again in ..." label.
  String get retryAfterLabel {
    if (retryAfter.inMinutes >= 60) {
      final h = retryAfter.inHours + (retryAfter.inMinutes % 60 == 0 ? 0 : 1);
      return h <= 1 ? '1 hour' : '$h hours';
    }
    final m = retryAfter.inMinutes;
    if (m <= 1) return 'a minute';
    return '$m minutes';
  }

  @override
  String toString() => 'GeminiRateLimitException(retryAfter: $retryAfter)';
}

/// Client-side throttle on calls to our (shared) Gemini API key, to cap cost
/// and deter abuse. Enforces BOTH an hourly and a daily cap via fixed-window
/// counters persisted on-device.
///
/// IMPORTANT: a client-side limit is a deterrent, not a hard guarantee — the
/// key is embedded in the app binary, so a modified client can bypass it. The
/// ONLY real backstop against an unbounded bill is a Google Cloud **quota cap +
/// billing budget** on the Generative Language API. Set both in the console.
class GeminiRateLimiter {
  GeminiRateLimiter({
    FlutterSecureStorage? storage,
    this.maxPerHour = 15,
    this.maxPerDay = 40,
  }) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Max Gemini calls allowed per rolling hour.
  final int maxPerHour;

  /// Max Gemini calls allowed per rolling 24 hours.
  final int maxPerDay;

  static const _kHourStart = 'gemini_rl_hour_start';
  static const _kHourCount = 'gemini_rl_hour_count';
  static const _kDayStart = 'gemini_rl_day_start';
  static const _kDayCount = 'gemini_rl_day_count';

  Future<(int, DateTime)> _read(String startKey, String countKey) async {
    final startStr = await _storage.read(key: startKey);
    final count = int.tryParse(await _storage.read(key: countKey) ?? '') ?? 0;
    final start = startStr != null
        ? (DateTime.tryParse(startStr) ??
            DateTime.fromMillisecondsSinceEpoch(0))
        : DateTime.fromMillisecondsSinceEpoch(0);
    return (count, start);
  }

  Future<void> _write(
    String startKey,
    String countKey,
    int count,
    DateTime start,
  ) async {
    await _storage.write(key: countKey, value: '$count');
    await _storage.write(key: startKey, value: start.toIso8601String());
  }

  /// Consumes one unit of quota. Throws [GeminiRateLimitException] if either the
  /// hourly or the daily window is exhausted; otherwise increments both.
  Future<void> consume() async {
    final now = DateTime.now();

    // Evaluate both windows up front so neither is incremented when the other
    // is the one that's exhausted.
    final (hourCount, hourStart) = await _read(_kHourStart, _kHourCount);
    final (dayCount, dayStart) = await _read(_kDayStart, _kDayCount);

    const hour = Duration(hours: 1);
    const day = Duration(hours: 24);

    final hourExpired = now.difference(hourStart) >= hour;
    final dayExpired = now.difference(dayStart) >= day;

    // Daily ceiling (only blocks while the window is still active).
    if (!dayExpired && dayCount >= maxPerDay) {
      throw GeminiRateLimitException(day - now.difference(dayStart));
    }
    // Hourly ceiling.
    if (!hourExpired && hourCount >= maxPerHour) {
      throw GeminiRateLimitException(hour - now.difference(hourStart));
    }

    // Passed both gates → increment (resetting any expired window).
    await _write(
      _kHourStart,
      _kHourCount,
      hourExpired ? 1 : hourCount + 1,
      hourExpired ? now : hourStart,
    );
    await _write(
      _kDayStart,
      _kDayCount,
      dayExpired ? 1 : dayCount + 1,
      dayExpired ? now : dayStart,
    );
  }
}

final geminiRateLimiterProvider = Provider<GeminiRateLimiter>((ref) {
  return GeminiRateLimiter();
});
