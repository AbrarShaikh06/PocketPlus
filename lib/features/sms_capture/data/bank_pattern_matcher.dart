import 'package:flutter_riverpod/flutter_riverpod.dart';

class BankPatternMatcher {
  bool isKnownBankSender(String senderId) {
    final id = senderId.replaceAll('-', '').replaceAll(' ', '').toUpperCase();

    if (id.contains('ICICI')) return true;

    // Indian bank suffixes (most banks append BK/BANK to their sender ID)
    final knownSuffixes = [
      'HDFCBK',
      'HDFCBANK',
      'HDFCBNK',
      'SBI',
      'SBIBNK',
      'SBTR',
      'ICICIB',
      'ICICIBK',
      'ICICIBNK',
      'AXISBK',
      'AXISBANK',
      'AXISBNK',
      'KOTAKB',
      'KOTAKBK',
      'KOTAKBNK',
      'YESBANK',
      'YESBK',
      'YESBNK',
      'IDBI',
      'IDBIBK',
      'CANARA',
      'CANARABK',
      'BOB',
      'BOBBK',
      'DENABK',
      'VIJAYABK',
      'PNB',
      'PNBBK',
      'ORIENTBNK',
      'UNITEDBNK',
      'UNIONBNK',
      'IOB',
      'UCOBNK',
      'CBIBNK',
      'BOIBNK',
      'INDIANBNK',
      'INDUSIND',
      'INDUSINDBK',
      'FEDBANK',
      'FEDBK',
      'BANDHAN',
      'BANDHANBK',
      'RBLBK',
      'RBLBANK',
      'RATNABK',
      'AUBNK',
      'AUBANK',
      'IDFC',
      'IDFCBK',
      'IDFCBANK',
      'HSBC',
      'CITI',
      'STANCHART',
      'SCB',
      'PSBBK',
      'SOUTHINDBK',
      'KARURBNK',
      'CUB',
      'DCBBK',
      'PAYPAY',
      'JANBANK',
      'EQUITAS',
      'DHANLAXMIBNK',
      'SYNDBK',
    ];
    for (final suffix in knownSuffixes) {
      if (id.endsWith(suffix)) {
        return true;
      }
    }

    // UAE bank suffixes
    final uaeSuffixes = [
      'ENBD', // Emirates NBD
      'FAB', // First Abu Dhabi Bank
      'ADCB', // Abu Dhabi Commercial Bank
      'MASHREQ', // Mashreq Bank
      'DIB', // Dubai Islamic Bank
      'RAKBANK', // RAKBANK
      'ADIB', // Abu Dhabi Islamic Bank
    ];
    for (final suffix in uaeSuffixes) {
      if (id.endsWith(suffix) || id.contains(suffix)) {
        return true;
      }
    }

    // Kenya bank / mobile money senders
    final kenyaSenders = [
      'MPESA',
      'EQUITY',
      'KCBBANK',
      'COOPBANK',
      'ABSA',
      'STANCHART',
    ];
    for (final sender in kenyaSenders) {
      if (id.contains(sender)) {
        return true;
      }
    }

    if (id.contains('UPI')) {
      return true;
    }
    final upiGateways = ['PAYTM', 'PHONEPE', 'BHIM', 'GPAY'];
    for (final gateway in upiGateways) {
      if (id.contains(gateway)) {
        return true;
      }
    }
    return false;
  }

  /// Returns the currency code hint for a known sender.
  String? currencyHint(String senderId) {
    final id = senderId.replaceAll('-', '').replaceAll(' ', '').toUpperCase();
    final uaeSenders = [
      'ENBD',
      'FAB',
      'ADCB',
      'MASHREQ',
      'DIB',
      'RAKBANK',
      'ADIB',
    ];
    for (final s in uaeSenders) {
      if (id.endsWith(s) || id.contains(s)) return 'AED';
    }
    final kenyaSenders = [
      'MPESA',
      'EQUITY',
      'KCBBANK',
      'COOPBANK',
      'ABSA',
      'STANCHART',
    ];
    for (final s in kenyaSenders) {
      if (id.contains(s)) return 'KES';
    }
    return null;
  }
}

final bankPatternMatcherProvider = Provider<BankPatternMatcher>((ref) {
  return BankPatternMatcher();
});
