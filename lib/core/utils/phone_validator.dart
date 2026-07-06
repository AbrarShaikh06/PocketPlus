class PhoneValidator {
  /// Indian mobile: starts with 6-9, 10 digits
  static bool isValidIndian(String phone) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(phone.trim());
  }

  /// UAE mobile: 05XXXXXXXX (10 digits) or +9715XXXXXXXX
  static bool isValidUAE(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return RegExp(r'^(?:0|(?:\+971))?5[0-9]\d{7}$').hasMatch(cleaned);
  }

  /// Kenya mobile: 07XXXXXXXX or 01XXXXXXXX or +2547XXXXXXXX
  static bool isValidKenya(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return RegExp(r'^(?:0|(?:\+254))?[17]\d{8}$').hasMatch(cleaned);
  }

  /// International E.164 format fallback
  static bool isValidInternational(String phone) {
    return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(phone.trim());
  }

  /// Validate based on country code
  static bool isValid(String phone, String countryCode) {
    switch (countryCode) {
      case 'IN':
        return isValidIndian(phone);
      case 'AE':
        return isValidUAE(phone);
      case 'KE':
        return isValidKenya(phone);
      default:
        return isValidInternational(phone);
    }
  }

  /// Get country dial code
  static String dialCode(String countryCode) {
    switch (countryCode) {
      case 'IN':
        return '+91';
      case 'AE':
        return '+971';
      case 'KE':
        return '+254';
      default:
        return '+';
    }
  }

  static String normalize(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 12 && digits.startsWith('91')) {
      return digits.substring(2);
    }
    return digits;
  }

  static String? validate(String phone) {
    final cleaned = normalize(phone);
    if (cleaned.isEmpty) return null;
    if (cleaned.length != 10) {
      return 'Enter a valid 10-digit Indian mobile number.';
    }
    return null;
  }

  static String? validateStrict(String phone) {
    final cleaned = normalize(phone);
    if (cleaned.isEmpty) return null;
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned)) {
      return 'Enter a valid 10-digit Indian mobile number.';
    }
    return null;
  }
}
