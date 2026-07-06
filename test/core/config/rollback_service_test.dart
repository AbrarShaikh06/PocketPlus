import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/core/config/rollback_service.dart';

void main() {
  group('RollbackDecision', () {
    group('RollbackDecision.passed()', () {
      test('isPassed returns true', () {
        final decision = RollbackDecision.passed();
        expect(decision.isPassed, isTrue);
        expect(decision.isKillSwitch, isFalse);
        expect(decision.isForceUpdate, isFalse);
        expect(decision.killSwitchMessage, isNull);
        expect(decision.requiredVersion, isNull);
      });
    });

    group('RollbackDecision.killSwitch()', () {
      test('isKillSwitch returns true and stores message', () {
        const message = 'App is under maintenance.';
        final decision = RollbackDecision.killSwitch(message);

        expect(decision.isKillSwitch, isTrue);
        expect(decision.isPassed, isFalse);
        expect(decision.isForceUpdate, isFalse);
        expect(decision.killSwitchMessage, message);
        expect(decision.requiredVersion, isNull);
      });

      test('empty message is allowed', () {
        final decision = RollbackDecision.killSwitch('');
        expect(decision.isKillSwitch, isTrue);
        expect(decision.killSwitchMessage, '');
      });
    });

    group('RollbackDecision.forceUpdate()', () {
      test('isForceUpdate returns true and stores version', () {
        const version = '2.0.0';
        final decision = RollbackDecision.forceUpdate(version);

        expect(decision.isForceUpdate, isTrue);
        expect(decision.isPassed, isFalse);
        expect(decision.isKillSwitch, isFalse);
        expect(decision.requiredVersion, version);
        expect(decision.killSwitchMessage, isNull);
      });

      test('stores version correctly for patch updates', () {
        final decision = RollbackDecision.forceUpdate('1.0.1');
        expect(decision.requiredVersion, '1.0.1');
      });

      test('stores version correctly for major updates', () {
        final decision = RollbackDecision.forceUpdate('3.0.0');
        expect(decision.requiredVersion, '3.0.0');
      });
    });
  });

  group('RollbackService', () {
    test('accessing decision before evaluate throws', () {
      expect(
        () => RollbackService.decision,
        throwsA(isA<Error>()),
      );
    });
  });
}
