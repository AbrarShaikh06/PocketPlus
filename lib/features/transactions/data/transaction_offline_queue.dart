import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../core/utils/logger.dart';
import '../domain/entities/transaction.dart';

class TransactionOfflineQueue {
  final List<Transaction> _pending = [];
  bool _loaded = false;

  List<Transaction> get pending => List.unmodifiable(_pending);
  int get pendingCount => _pending.length;
  bool get hasPending => _pending.isNotEmpty;

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/transaction_queue.json');
  }

  Future<void> _load() async {
    if (_loaded) return;
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final list = json.decode(content) as List<dynamic>;
        for (final item in list) {
          _pending.add(Transaction.fromJson(item as Map<String, dynamic>));
        }
        AppLogger.info(
          '[TransactionOfflineQueue] Loaded ${_pending.length} pending transactions',
        );
      }
      _loaded = true;
    } catch (e) {
      AppLogger.error(
        '[TransactionOfflineQueue] Failed to load queue',
        error: e,
      );
      _loaded = true;
    }
  }

  Future<void> _save() async {
    try {
      final file = await _getFile();
      final content = json.encode(_pending.map((t) => t.toJson()).toList());
      await file.writeAsString(content);
    } catch (e) {
      AppLogger.error(
        '[TransactionOfflineQueue] Failed to save queue',
        error: e,
      );
    }
  }

  Future<void> enqueue(Transaction transaction) async {
    await _load();
    _pending.add(transaction);
    await _save();
    AppLogger.info(
      '[TransactionOfflineQueue] Enqueued transaction=${transaction.id} (${_pending.length} pending)',
    );
  }

  Future<void> dequeue(String transactionId) async {
    await _load();
    _pending.removeWhere((t) => t.id == transactionId);
    await _save();
    AppLogger.info(
      '[TransactionOfflineQueue] Dequeued transaction=$transactionId (${_pending.length} remaining)',
    );
  }

  Future<void> clear() async {
    _pending.clear();
    await _save();
    AppLogger.info(
      '[TransactionOfflineQueue] Cleared all pending transactions',
    );
  }

  Future<List<Transaction>> drainAll() async {
    await _load();
    final items = List<Transaction>.from(_pending);
    _pending.clear();
    await _save();
    return items;
  }
}
