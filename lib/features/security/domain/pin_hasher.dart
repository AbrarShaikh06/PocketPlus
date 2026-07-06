import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Pure, dependency-free PIN hashing so the crypto is unit-testable without
/// secure storage or platform channels.
///
/// A PIN is never stored in the clear. We persist a random per-install [salt]
/// and `SHA256("$salt:$pin")`. A 4–6 digit PIN has a tiny keyspace, so the
/// salt's only job here is to stop identical PINs across installs sharing a
/// hash — it is not a defence against a determined attacker with the hash.
/// The real protection is that the hash lives in the OS keystore
/// (flutter_secure_storage), never in Firestore or logs.
abstract final class PinHasher {
  /// Only 4–6 digit numeric PINs are accepted (CLAUDE.md: PIN fallback).
  static final RegExp _pinFormat = RegExp(r'^\d{4,6}$');

  static bool isValidPinFormat(String pin) => _pinFormat.hasMatch(pin);

  /// 16 random bytes, base64-encoded. Pass a seeded [rng] in tests.
  static String generateSalt([Random? rng]) {
    final r = rng ?? Random.secure();
    final bytes = List<int>.generate(16, (_) => r.nextInt(256));
    return base64Encode(bytes);
  }

  static String hashPin(String pin, String salt) {
    return sha256.convert(utf8.encode('$salt:$pin')).toString();
  }

  static bool verify(String pin, String salt, String expectedHash) {
    return hashPin(pin, salt) == expectedHash;
  }
}
