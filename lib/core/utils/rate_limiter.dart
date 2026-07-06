import 'dart:async';
import 'dart:collection';

/// Generic sliding-window rate limiter.
///
/// Tracks timestamps per key and rejects calls that exceed [maxCalls]
/// within [windowDuration].
///
/// ```dart
/// final limiter = RateLimiter(maxCalls: 5, window: Duration(minutes: 1));
/// if (limiter.allow('sms_parse')) { ... }
/// ```
class RateLimiter {
  RateLimiter({required this.maxCalls, required this.window});

  final int maxCalls;
  final Duration window;

  final _timestamps = <String, Queue<DateTime>>{};

  /// Returns `true` if the call for [key] is within the rate limit.
  bool allow(String key) {
    final now = DateTime.now();
    final queue = _timestamps.putIfAbsent(key, () => Queue<DateTime>());

    _prune(queue, now);

    if (queue.length >= maxCalls) {
      return false;
    }

    queue.add(now);
    return true;
  }

  /// Number of remaining calls for [key] within the current window.
  int remaining(String key) {
    final queue = _timestamps[key];
    if (queue == null) return maxCalls;
    _prune(queue, DateTime.now());
    final used = queue.length;
    return (maxCalls - used).clamp(0, maxCalls);
  }

  /// Seconds until the oldest timestamp in the window expires.
  double retryAfter(String key) {
    final queue = _timestamps[key];
    if (queue == null || queue.isEmpty) return 0;
    final oldest = queue.first;
    final elapsed = DateTime.now().difference(oldest);
    final remaining = window - elapsed;
    return remaining.inMilliseconds > 0 ? remaining.inMilliseconds / 1000 : 0;
  }

  void _prune(Queue<DateTime> queue, DateTime now) {
    while (queue.isNotEmpty && now.difference(queue.first) > window) {
      queue.removeFirst();
    }
  }

  /// Clear all tracked timestamps.
  void reset() => _timestamps.clear();

  /// Clear timestamps for a specific [key].
  void resetKey(String key) => _timestamps.remove(key);
}

/// Debouncer – delays execution until [delay] after the last call.
///
/// ```dart
/// final debouncer = Debouncer(delay: Duration(milliseconds: 300));
/// debouncer.run(() => search(query));
/// ```
class Debouncer {
  Debouncer({required this.delay});

  final Duration delay;

  void Function()? _action;
  Timer? _timer;

  void run(void Function() action) {
    _action = action;
    _timer?.cancel();
    _timer = Timer(delay, _execute);
  }

  void _execute() {
    _timer = null;
    _action?.call();
    _action = null;
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _action = null;
  }
}

/// Throttler – executes at most once per [interval].
///
/// ```dart
/// final throttler = Throttler(interval: Duration(seconds: 1));
/// throttler.run(() => refresh());
/// ```
class Throttler {
  Throttler({required this.interval});

  final Duration interval;
  DateTime _lastRun = DateTime(2000);
  Timer? _deferredTimer;

  void run(void Function() action) {
    final now = DateTime.now();
    if (now.difference(_lastRun) >= interval) {
      _lastRun = now;
      action();
      _deferredTimer?.cancel();
      _deferredTimer = null;
    } else if (_deferredTimer == null || !_deferredTimer!.isActive) {
      final remaining = interval - now.difference(_lastRun);
      _deferredTimer = Timer(remaining, () {
        _lastRun = DateTime.now();
        action();
        _deferredTimer = null;
      });
    }
  }

  void cancel() {
    _deferredTimer?.cancel();
    _deferredTimer = null;
  }

  void reset() {
    _lastRun = DateTime(2000);
    _deferredTimer?.cancel();
    _deferredTimer = null;
  }
}

/// Retry policy with exponential backoff.
///
/// ```dart
/// final policy = RetryPolicy(maxRetries: 3, baseDelay: Duration(seconds: 1));
/// final result = await policy.retry(() => someApiCall());
/// ```
class RetryPolicy {
  RetryPolicy({
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
  });

  final int maxRetries;
  final Duration baseDelay;
  final Duration maxDelay;

  /// Retries [fn] up to [maxRetries] times with exponential backoff + jitter.
  /// Throws the last error if all retries fail.
  Future<T> retry<T>(Future<T> Function() fn) async {
    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        return await fn();
      } catch (e) {
        lastError = e;
        attempt++;
        if (attempt > maxRetries) break;

        final delayMs = (baseDelay.inMilliseconds * (1 << (attempt - 1))).clamp(
          0,
          maxDelay.inMilliseconds,
        );
        final jitter = DateTime.now().microsecondsSinceEpoch % delayMs;
        await Future.delayed(Duration(milliseconds: delayMs + jitter));
      }
    }

    throw lastError!;
  }
}
