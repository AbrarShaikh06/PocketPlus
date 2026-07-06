import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:pocket_plus/core/errors/error_codes.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/firebase_providers.dart';
import '../../../shared/providers/locale_provider.dart';

class SettingsState {
  final LanguageCode language;
  final String country;
  final bool smsEnabled;
  final bool isExporting;
  final bool isDeleting;
  final PlanType plan;
  final String? errorMessage;

  const SettingsState({
    this.language = LanguageCode.en,
    this.country = 'INR',
    this.smsEnabled = true,
    this.isExporting = false,
    this.isDeleting = false,
    this.plan = PlanType.free,
    this.errorMessage,
  });

  SettingsState copyWith({
    LanguageCode? language,
    String? country,
    bool? smsEnabled,
    bool? isExporting,
    bool? isDeleting,
    PlanType? plan,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SettingsState(
      language: language ?? this.language,
      country: country ?? this.country,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      isExporting: isExporting ?? this.isExporting,
      isDeleting: isDeleting ?? this.isDeleting,
      plan: plan ?? this.plan,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class SettingsViewModel extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    _loadInitialSettings();
    return const SettingsState();
  }

  Future<void> _loadInitialSettings() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data();

      final language = data != null
          ? LanguageCodeX.fromFirestore(data['language'] as String? ?? 'EN')
          : LanguageCode.en;

      final country = data?['country'] as String? ?? 'INR';
      final smsEnabled = data?['smsEnabled'] as bool? ?? true;
      final plan = data != null
          ? PlanTypeX.fromFirestore(data['plan'] as String? ?? 'FREE')
          : PlanType.free;

      state = SettingsState(
        language: language,
        country: country,
        smsEnabled: smsEnabled,
        plan: plan,
      );
    } catch (_) {}
  }

  FirebaseAuth get _auth => ref.read(firebaseAuthProvider);
  FirebaseFirestore get _firestore => ref.read(firestoreProvider);

  Future<void> updateLanguage(LanguageCode code) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    state = state.copyWith(language: code);
    ref.read(localeProvider.notifier).setFromLanguageCode(code);

    await _firestore.collection('users').doc(uid).update({
      'language': code.firestoreValue,
    });
  }

  Future<void> updateCountry(String currencyCode) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    state = state.copyWith(country: currencyCode);

    await _firestore.collection('users').doc(uid).update({
      'country': currencyCode,
    });
  }

  Future<void> toggleSmsCapture(bool enabled) async {
    state = state.copyWith(smsEnabled: enabled);

    try {
      const channel = MethodChannel('pocketplus/sms');
      if (enabled) {
        await channel.invokeMethod('registerReceiver');
      } else {
        await channel.invokeMethod('unregisterReceiver');
      }
    } catch (_) {}

    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('users').doc(uid).update({
        'smsEnabled': enabled,
      });
    }
  }

  Future<void> exportData() async {
    state = state.copyWith(isExporting: true, clearError: true);

    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception('Not logged in');

      final collections = [
        'transactions',
        'categories',
        'profiles',
        'invoices',
        'khata_customers',
        'khata_entries',
      ];

      final export = <String, dynamic>{};

      for (final collection in collections) {
        final snapshot = await _firestore
            .collection(collection)
            .where('userId', isEqualTo: uid)
            .get();
        export[collection] =
            snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
      }

      final userDoc = await _firestore.collection('users').doc(uid).get();
      export['user'] = {'id': userDoc.id, ...?userDoc.data()};

      final jsonStr = const JsonEncoder.withIndent('  ').convert(export);
      final dateStr = DateTime.now().toIso8601String().split('T').first;
      final fileName = 'pocketplus_data_export_$dateStr.json';

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(jsonStr);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'PocketPlus Data Export - $dateStr',
        ),
      );

      state = state.copyWith(isExporting: false);
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        errorMessage: '${ErrorCodes.somethingWrong}: $e',
      );
    }
  }

  Future<void> initiateAccountDeletion() async {
    state = state.copyWith(isDeleting: true, clearError: true);

    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception('Not logged in');

      await _firestore.collection('users').doc(uid).update({
        'deletedAt': FieldValue.serverTimestamp(),
      });

      await _auth.signOut();
    } catch (_) {
      state = state.copyWith(isDeleting: false);
    }
  }
}

final settingsViewModelProvider =
    NotifierProvider<SettingsViewModel, SettingsState>(
  SettingsViewModel.new,
);
