import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/features/security/presentation/app_lock_provider.dart';

void main() {
  group('shouldAutoLock', () {
    final t0 = DateTime(2026, 7, 6, 12, 0, 0);

    test('does not lock when the lock is disabled', () {
      expect(
        shouldAutoLock(
          enabled: false,
          backgroundedAt: t0,
          now: t0.add(const Duration(hours: 1)),
        ),
        isFalse,
      );
    });

    test('does not lock when never backgrounded', () {
      expect(
        shouldAutoLock(enabled: true, backgroundedAt: null, now: t0),
        isFalse,
      );
    });

    test('does not lock before the 5-minute threshold', () {
      expect(
        shouldAutoLock(
          enabled: true,
          backgroundedAt: t0,
          now: t0.add(const Duration(minutes: 4, seconds: 59)),
        ),
        isFalse,
      );
    });

    test('locks at or beyond the 5-minute threshold', () {
      expect(
        shouldAutoLock(
          enabled: true,
          backgroundedAt: t0,
          now: t0.add(const Duration(minutes: 5)),
        ),
        isTrue,
      );
      expect(
        shouldAutoLock(
          enabled: true,
          backgroundedAt: t0,
          now: t0.add(const Duration(minutes: 30)),
        ),
        isTrue,
      );
    });
  });
}
