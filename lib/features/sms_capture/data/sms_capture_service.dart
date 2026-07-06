import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/models/models.dart';
import '../../transactions/domain/entities/transaction.dart';
import '../../transactions/transactions_providers.dart';
import '../../home/presentation/home_providers.dart';
import 'sms_platform_channel.dart';
import 'sms_permission_service.dart';
import 'firestore_sms_dedup_data_source.dart';
import '../domain/entities/parsed_sms.dart';
import '../domain/use_cases/process_sms_use_case.dart';
import '../domain/services/capture_notification_service.dart';
import '../../profiles/domain/entities/profile.dart';

class SmsCaptureService with WidgetsBindingObserver {
  final SmsPlatformChannel _platformChannel;
  final SmsPermissionService _permissionService;
  final ProcessSmsUseCase _processSmsUseCase;
  final CaptureNotificationService _notificationService;
  final Ref _ref;
  StreamSubscription<RawSms>? _subscription;
  int _totalSmsProcessed = 0;
  int _totalParsed = 0;
  String? _lastReceivedSmsText;
  String? _lastReceivedSender;
  String? _lastError;
  bool _autoSaveEnabled = false;

  // Diagnostics data for the debug screen
  int get totalSmsProcessed => _totalSmsProcessed;
  int get totalParsed => _totalParsed;
  String? get lastReceivedSmsText => _lastReceivedSmsText;
  String? get lastReceivedSender => _lastReceivedSender;
  String? get lastError => _lastError;
  bool get autoSaveEnabled => _autoSaveEnabled;

  SmsCaptureService({
    required SmsPlatformChannel platformChannel,
    required SmsPermissionService permissionService,
    required ProcessSmsUseCase processSmsUseCase,
    required CaptureNotificationService notificationService,
    required Ref ref,
  })  : _platformChannel = platformChannel,
        _permissionService = permissionService,
        _processSmsUseCase = processSmsUseCase,
        _notificationService = notificationService,
        _ref = ref {
    _init();
  }

  void _init() {
    AppLogger.debug('[SmsCaptureService] Initializing SMS listener');
    _subscription = _platformChannel.smsStream.listen(
      _onSmsReceived,
      onError: (e) {
        AppLogger.error('[SmsCaptureService] Stream error', error: e);
        _lastError = e.toString();
      },
    );
    WidgetsBinding.instance.addObserver(this);
    _checkPermissionAndScan();
  }

  void setAutoSave(bool enabled) {
    _autoSaveEnabled = enabled;
    AppLogger.info('[SmsCaptureService] Auto-save set to: $enabled');
  }

  Future<void> retryScan() async {
    AppLogger.info('[SmsCaptureService] Manual retry scan triggered');
    await _checkPermissionAndScan();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppLogger.debug('[SmsCaptureService] Lifecycle: $state');
    if (state == AppLifecycleState.resumed) {
      _restartListener();
      _checkPermissionAndScan();
    }
  }

  void _restartListener() {
    _subscription?.cancel();
    _subscription = _platformChannel.smsStream.listen(
      _onSmsReceived,
      onError: (e) {
        AppLogger.error(
          '[SmsCaptureService] Stream error after restart',
          error: e,
        );
        _lastError = e.toString();
      },
    );
    AppLogger.debug('[SmsCaptureService] Listener restarted');
  }

  Future<void> _checkPermissionAndScan() async {
    final hasPermission = await _permissionService.isGranted();
    AppLogger.debug(
      '[SmsCaptureService] SMS Permission Granted: $hasPermission',
    );
    if (hasPermission) {
      await _scanHistoricalSms();
    }
  }

  Future<void> _scanHistoricalSms() async {
    final profile = _ref.read(currentProfileProvider);
    final userId = profile?.userId;
    if (userId == null) {
      AppLogger.debug(
        '[SmsCaptureService] No active user, skipping historical scan',
      );
      return;
    }
    try {
      AppLogger.info(
        '[SmsCaptureService] Starting historical SMS scan for user=$userId',
      );
      final result = await _platformChannel.scanInbox();
      if (result == null) {
        AppLogger.debug('[SmsCaptureService] scanInbox returned null');
        return;
      }
      final messages = result as List<dynamic>;
      AppLogger.info(
        '[SmsCaptureService] Total SMS fetched from inbox: ${messages.length}',
      );
      int processed = 0;
      for (int i = 0; i < messages.length; i++) {
        final msg = messages[i];
        if (msg is Map) {
          final text = msg['text'] as String? ?? '';
          final senderId = msg['senderId'] as String? ?? '';
          final timestamp = (msg['timestamp'] as num?)?.toInt();
          if (text.isNotEmpty && senderId.isNotEmpty) {
            processed++;
            _totalSmsProcessed++;
            final rawSms = RawSms(
              text: text,
              senderId: senderId,
              timestampMillis: timestamp,
            );
            _processHistoricalSms(rawSms, userId);
          }
        }
        if (i % 10 == 9) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
      AppLogger.info(
        '[SmsCaptureService] Historical scan dispatched. Processed=$processed, totalCandidate=$_totalSmsProcessed',
      );
    } catch (e) {
      _lastError = e.toString();
      AppLogger.error('[SmsCaptureService] Historical scan failed', error: e);
    }
  }

  Future<void> _processHistoricalSms(RawSms rawSms, String userId) async {
    try {
      final parsedSms = await _processSmsUseCase.execute(rawSms, userId);
      if (parsedSms != null) {
        _totalParsed++;
        AppLogger.info(
          '[SmsCaptureService] Historical SMS parsed: amount=${parsedSms.amount}paise type=${parsedSms.type.name} sender=${rawSms.senderId}',
        );
        if (_autoSaveEnabled) {
          final profile = _ref.read(currentProfileProvider);
          if (profile != null) {
            await _autoSaveTransaction(parsedSms, userId, profile.id);
          }
        } else {
          _notificationService.triggerNotification(parsedSms);
        }
      }
    } catch (e) {
      _lastError = e.toString();
      AppLogger.error(
        '[SmsCaptureService] Error processing historical SMS',
        error: e,
      );
    }
  }

  Future<void> _onSmsReceived(RawSms rawSms) async {
    AppLogger.info(
      '[SmsCaptureService] Real-time SMS received from=${rawSms.senderId} body="${rawSms.text.substring(0, rawSms.text.length.clamp(0, 80))}"',
    );
    _lastReceivedSmsText = rawSms.text;
    _lastReceivedSender = rawSms.senderId;

    final hasPermission = await _permissionService.isGranted();
    if (!hasPermission) {
      AppLogger.debug(
        '[SmsCaptureService] Permission denied, dropping real-time SMS',
      );
      _lastError = 'SMS permission not granted';
      return;
    }

    final profile = _ref.read(currentProfileProvider);
    final userId = profile?.userId;
    if (userId == null) {
      AppLogger.debug(
        '[SmsCaptureService] No active user profile, dropping real-time SMS',
      );
      _lastError = 'No active user profile';
      return;
    }

    _totalSmsProcessed++;

    AppLogger.debug('[SmsCaptureService] Passing to ProcessSmsUseCase');
    final parsedSms = await _processSmsUseCase.execute(rawSms, userId);

    if (parsedSms != null) {
      _totalParsed++;
      AppLogger.info(
        '[SmsCaptureService] Real-time SMS parsed: amount=${parsedSms.amount}paise type=${parsedSms.type.name} merchant=${parsedSms.merchantName}',
      );

      if (_autoSaveEnabled) {
        AppLogger.info(
          '[SmsCaptureService] Auto-save enabled, creating transaction directly',
        );
        await _autoSaveTransaction(parsedSms, userId, profile!.id);
      } else {
        AppLogger.info(
          '[SmsCaptureService] Showing notification for user confirmation',
        );
        _notificationService.triggerNotification(parsedSms);
      }
    } else {
      AppLogger.debug(
        '[SmsCaptureService] SMS could not be parsed as transaction (unknown sender or no amount/verb match)',
      );
    }
  }

  Future<void> _autoSaveTransaction(
    ParsedSms parsedSms,
    String userId,
    String profileId,
  ) async {
    try {
      final transactionRepo = _ref.read(transactionRepositoryProvider);
      final transactionId = const Uuid().v4();
      final now = DateTime.now();

      final transaction = Transaction(
        id: transactionId,
        userId: userId,
        profileId: profileId,
        amount: parsedSms.amount,
        type: parsedSms.type,
        source: parsedSms.senderId.contains('MPESA')
            ? TransactionSource.mpesa
            : TransactionSource.sms,
        categoryId: parsedSms.type == TransactionType.expense
            ? 'sys_unaccounted_expense'
            : 'sys_unaccounted_income',
        merchantName: parsedSms.merchantName ?? 'Unknown Merchant',
        transactionDate: parsedSms.transactionDate,
        smsHash: parsedSms.smsHash,
        createdAt: now,
        updatedAt: now,
      );

      final result = await transactionRepo.createTransaction(transaction);
      await result.fold(
        (failure) async {
          _lastError = 'Auto-save failed: ${failure.message}';
          AppLogger.error(
            '[SmsCaptureService] Auto-save failed',
            error: failure.message,
          );
          _notificationService.triggerNotification(parsedSms);
        },
        (_) async {
          AppLogger.info(
            '[SmsCaptureService] Auto-save succeeded: transaction=$transactionId amount=${parsedSms.amount}paise',
          );
          // Update the atomic claim (written in ProcessSmsUseCase) with the
          // transactionId for auditability.
          try {
            await _ref.read(smsDedupRepositoryProvider).writeDedupLog(
                  userId,
                  parsedSms.smsHash,
                  DedupAction.logged,
                  transactionId,
                );
          } catch (e) {
            AppLogger.error(
              '[SmsCaptureService] Failed to update dedup log with transactionId',
              error: e,
            );
          }
        },
      );
    } catch (e) {
      _lastError = 'Auto-save error: $e';
      AppLogger.error('[SmsCaptureService] Auto-save error', error: e);
      _notificationService.triggerNotification(parsedSms);
    }
  }

  void dispose() {
    AppLogger.debug('[SmsCaptureService] Disposing');
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
  }
}

final smsCaptureServiceProvider = Provider<SmsCaptureService>((ref) {
  final router = ref.watch(appRouterProvider);
  final service = SmsCaptureService(
    platformChannel: ref.watch(smsPlatformChannelProvider),
    permissionService: ref.watch(smsPermissionServiceProvider),
    processSmsUseCase: ref.watch(processSmsUseCaseProvider),
    notificationService: ref.watch(captureNotificationServiceProvider),
    ref: ref,
  );
  ref.read(captureNotificationServiceProvider).setRouter(router);
  service.setAutoSave(true);

  // Watch for profile becoming available (user logs in) -> trigger historical scan
  ref.listen<Profile?>(currentProfileProvider, (prev, next) {
    if (prev == null && next != null) {
      AppLogger.info(
        '[SmsCaptureService] Profile detected, triggering delayed historical scan',
      );
      Future.delayed(const Duration(seconds: 2), () {
        service.retryScan();
      });
    }
  });

  ref.onDispose(() => service.dispose());
  return service;
});
