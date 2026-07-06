import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/core/monitoring/release_validator.dart';

void main() {
  group('ValidationCheck', () {
    test('creates a passing check', () {
      final check = ValidationCheck(
        name: 'test-check',
        passed: true,
      );

      expect(check.name, 'test-check');
      expect(check.passed, isTrue);
      expect(check.message, isNull);
    });

    test('creates a failing check with message', () {
      final check = ValidationCheck(
        name: 'test-check',
        passed: false,
        message: 'Something went wrong',
      );

      expect(check.name, 'test-check');
      expect(check.passed, isFalse);
      expect(check.message, 'Something went wrong');
    });
  });

  group('ValidationReport', () {
    test('allPassed is true when all checks pass', () {
      final report = ValidationReport(
        checks: [
          ValidationCheck(name: 'a', passed: true),
          ValidationCheck(name: 'b', passed: true),
        ],
        allPassed: true,
        timestamp: DateTime(2026, 7, 3),
      );

      expect(report.allPassed, isTrue);
      expect(report.passedCount, 2);
      expect(report.failedCount, 0);
      expect(report.failures, isEmpty);
    });

    test('allPassed is false when any check fails', () {
      final report = ValidationReport(
        checks: [
          ValidationCheck(name: 'a', passed: true, message: null),
          ValidationCheck(
            name: 'b',
            passed: false,
            message: 'Firebase not initialized',
          ),
          ValidationCheck(name: 'c', passed: false, message: 'No token'),
        ],
        allPassed: false,
        timestamp: DateTime(2026, 7, 3),
      );

      expect(report.allPassed, isFalse);
      expect(report.passedCount, 1);
      expect(report.failedCount, 2);
      expect(report.failures.length, 2);
      expect(report.failures[0].name, 'b');
      expect(report.failures[1].name, 'c');
    });

    test('passedCount and failedCount handle empty checks', () {
      final report = ValidationReport(
        checks: [],
        allPassed: true,
        timestamp: DateTime(2026, 7, 3),
      );

      expect(report.passedCount, 0);
      expect(report.failedCount, 0);
      expect(report.failures, isEmpty);
    });
  });
}
