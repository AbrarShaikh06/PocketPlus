import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/features/security/data/app_lock_service.dart';
import 'package:pocket_plus/features/security/data/secure_key_value_store.dart';
import 'package:pocket_plus/features/security/domain/pin_hasher.dart';

/// In-memory [SecureKeyValueStore] so PIN logic is tested without the keystore.
class _FakeStore implements SecureKeyValueStore {
  final Map<String, String> _data = {};

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async => _data[key] = value;

  @override
  Future<void> delete(String key) async => _data.remove(key);
}

void main() {
  group('PinHasher', () {
    test('accepts 4-6 digit PINs only', () {
      expect(PinHasher.isValidPinFormat('1234'), isTrue);
      expect(PinHasher.isValidPinFormat('123456'), isTrue);
      expect(PinHasher.isValidPinFormat('123'), isFalse);
      expect(PinHasher.isValidPinFormat('1234567'), isFalse);
      expect(PinHasher.isValidPinFormat('12a4'), isFalse);
      expect(PinHasher.isValidPinFormat(''), isFalse);
    });

    test('same PIN + salt is deterministic; verify matches', () {
      const salt = 'abc';
      final h = PinHasher.hashPin('1234', salt);
      expect(PinHasher.hashPin('1234', salt), h);
      expect(PinHasher.verify('1234', salt, h), isTrue);
      expect(PinHasher.verify('9999', salt, h), isFalse);
    });

    test('never stores the PIN in the clear', () {
      final h = PinHasher.hashPin('1234', PinHasher.generateSalt());
      expect(h.contains('1234'), isFalse);
      expect(h.length, 64); // sha256 hex
    });

    test('different salts produce different hashes for the same PIN', () {
      final a = PinHasher.hashPin('1234', PinHasher.generateSalt());
      final b = PinHasher.hashPin('1234', PinHasher.generateSalt());
      expect(a, isNot(b));
    });
  });

  group('AppLockService', () {
    late AppLockService service;

    setUp(() {
      service = AppLockService(store: _FakeStore());
    });

    test('lock is disabled by default', () async {
      expect(await service.isLockEnabled(), isFalse);
      expect(await service.isBiometricEnabled(), isFalse);
    });

    test('setPin enables the lock and stores no cleartext PIN', () async {
      await service.setPin('4821');
      expect(await service.isLockEnabled(), isTrue);
      expect(await service.verifyPin('4821'), isTrue);
      expect(await service.verifyPin('0000'), isFalse);
    });

    test('setPin rejects malformed PINs', () async {
      expect(() => service.setPin('12'),
          throwsA(isA<InvalidPinFormatException>()));
      expect(
        () => service.setPin('abcd'),
        throwsA(isA<InvalidPinFormatException>()),
      );
    });

    test('verifyPin is false when no PIN is set', () async {
      expect(await service.verifyPin('1234'), isFalse);
    });

    test('changePin requires the correct current PIN', () async {
      await service.setPin('1111');
      expect(await service.changePin('0000', '2222'), isFalse);
      expect(await service.verifyPin('1111'), isTrue); // unchanged

      expect(await service.changePin('1111', '2222'), isTrue);
      expect(await service.verifyPin('2222'), isTrue);
      expect(await service.verifyPin('1111'), isFalse);
    });

    test('disableLock requires the current PIN', () async {
      await service.setPin('3333');
      expect(await service.disableLock('0000'), isFalse);
      expect(await service.isLockEnabled(), isTrue); // still locked

      expect(await service.disableLock('3333'), isTrue);
      expect(await service.isLockEnabled(), isFalse);
      expect(await service.verifyPin('3333'), isFalse); // PIN cleared
      expect(await service.isBiometricEnabled(), isFalse);
    });

    test('biometric flag round-trips', () async {
      await service.setBiometricEnabled(true);
      expect(await service.isBiometricEnabled(), isTrue);
      await service.setBiometricEnabled(false);
      expect(await service.isBiometricEnabled(), isFalse);
    });
  });
}
