import 'package:local_auth/local_auth.dart';

import '../domain/pin_hasher.dart';
import 'secure_key_value_store.dart';

/// Thrown when a PIN does not match the required 4–6 digit format.
class InvalidPinFormatException implements Exception {
  const InvalidPinFormatException();
  @override
  String toString() => 'PIN must be 4 to 6 digits.';
}

/// Owns the biometric / PIN app-lock state: PIN storage & verification (via
/// [SecureKeyValueStore]) and biometric checks (via [LocalAuthentication]).
///
/// The PIN paths are fully unit-testable with an in-memory store; the biometric
/// paths degrade to `false` when the platform is unavailable (e.g. in tests).
class AppLockService {
  AppLockService({
    SecureKeyValueStore? store,
    LocalAuthentication? localAuth,
  })  : _store = store ?? FlutterSecureKeyValueStore(),
        _auth = localAuth ?? LocalAuthentication();

  final SecureKeyValueStore _store;
  final LocalAuthentication _auth;

  static const _kPinHash = 'applock_pin_hash';
  static const _kSalt = 'applock_salt';
  static const _kEnabled = 'applock_enabled';
  static const _kBiometric = 'applock_biometric';

  Future<bool> isLockEnabled() async =>
      (await _store.read(_kEnabled)) == 'true';

  Future<bool> isBiometricEnabled() async =>
      (await _store.read(_kBiometric)) == 'true';

  /// Sets (or replaces) the PIN and enables the lock. Rotates the salt each
  /// time so a changed PIN never reuses the old hash.
  Future<void> setPin(String pin) async {
    if (!PinHasher.isValidPinFormat(pin)) {
      throw const InvalidPinFormatException();
    }
    final salt = PinHasher.generateSalt();
    await _store.write(_kSalt, salt);
    await _store.write(_kPinHash, PinHasher.hashPin(pin, salt));
    await _store.write(_kEnabled, 'true');
  }

  Future<bool> verifyPin(String pin) async {
    final salt = await _store.read(_kSalt);
    final hash = await _store.read(_kPinHash);
    if (salt == null || hash == null) return false;
    return PinHasher.verify(pin, salt, hash);
  }

  /// Changes the PIN, requiring the current one. Returns false if [currentPin]
  /// is wrong; the stored PIN is left untouched in that case.
  Future<bool> changePin(String currentPin, String newPin) async {
    if (!await verifyPin(currentPin)) return false;
    await setPin(newPin);
    return true;
  }

  /// Disables the lock. Requires the current PIN (CLAUDE.md: the lock cannot be
  /// turned off without the PIN). Clears the PIN, salt, and biometric flag.
  Future<bool> disableLock(String currentPin) async {
    if (!await verifyPin(currentPin)) return false;
    await _store.delete(_kPinHash);
    await _store.delete(_kSalt);
    await _store.write(_kEnabled, 'false');
    await _store.write(_kBiometric, 'false');
    return true;
  }

  Future<void> setBiometricEnabled(bool enabled) =>
      _store.write(_kBiometric, enabled ? 'true' : 'false');

  /// Whether the device has enrolled biometrics available.
  Future<bool> canUseBiometric() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return supported && canCheck;
    } catch (_) {
      return false;
    }
  }

  /// Prompts for a fingerprint/face unlock. Returns false on cancel/error.
  Future<bool> authenticateBiometric() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Unlock PocketPlus',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
