import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/analytics/analytics_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pocket_plus/core/errors/error_codes.dart';
import '../data/pdf_export_service.dart';
import '../../../shared/providers/firebase_providers.dart';
import '../../../../shared/models/models.dart';
import '../domain/entities/report_summary.dart';
import '../../home/presentation/home_providers.dart';
import '../../../shared/providers/user_provider.dart';
import '../../transactions/transactions_providers.dart';
import '../../transactions/domain/entities/transaction.dart';

part 'reports_view_model.freezed.dart';

enum PeriodType { week, month, all, custom }

@freezed
abstract class ReportsState with _$ReportsState {
  const factory ReportsState({
    @Default(PeriodType.month) PeriodType periodType,
    required DateTimeRange dateRange,
    @Default(false) bool isExporting,
    String? exportError,
  }) = _ReportsState;
}

class ReportsViewModel extends Notifier<ReportsState> {
  @override
  ReportsState build() {
    return ReportsState(
      dateRange: _getDateRangeForPeriod(PeriodType.month),
    );
  }

  DateTimeRange _getDateRangeForPeriod(PeriodType type) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    switch (type) {
      case PeriodType.week:
        final start = todayStart.subtract(const Duration(days: 6));
        return DateTimeRange(start: start, end: todayEnd);
      case PeriodType.month:
        final start = DateTime(now.year, now.month, 1);
        return DateTimeRange(start: start, end: todayEnd);
      case PeriodType.all:
        return DateTimeRange(
          start: DateTime(2000, 1, 1),
          end: DateTime(2100, 1, 1),
        );
      case PeriodType.custom:
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: todayEnd,
        );
    }
  }

  void selectPeriod(PeriodType type) {
    if (type == PeriodType.custom) {
      state = state.copyWith(periodType: type);
    } else {
      state = state.copyWith(
        periodType: type,
        dateRange: _getDateRangeForPeriod(type),
      );
    }
  }

  void selectCustomRange(DateTimeRange range) {
    // Force end of date to cover full day (23:59:59.999)
    final adjustedRange = DateTimeRange(
      start: DateTime(range.start.year, range.start.month, range.start.day),
      end: DateTime(
        range.end.year,
        range.end.month,
        range.end.day,
        23,
        59,
        59,
        999,
      ),
    );
    state = state.copyWith(
      periodType: PeriodType.custom,
      dateRange: adjustedRange,
    );
  }

  Future<void> exportPDF(BuildContext context) async {
    state = state.copyWith(isExporting: true, exportError: null);

    try {
      final auth = ref.read(firebaseAuthProvider);
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        throw Exception(ErrorCodes.userNotLoggedIn);
      }

      // Paywalls removed: PDF export is unconditional and free for everyone.
      await ref.read(analyticsServiceProvider).logPdfExportAttempted(
            plan: 'FREE',
            quotaRemaining: 9999,
          );

      await _doExport();
    } catch (e) {
      state = state.copyWith(exportError: e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      state = state.copyWith(isExporting: false);
    }
  }

  Future<void> _doExport() async {
    final activeProfile = ref.read(currentProfileProvider);
    final auth = ref.read(firebaseAuthProvider);
    final userId = auth.currentUser?.uid;
    if (activeProfile == null || userId == null) {
      throw Exception(ErrorCodes.activeProfileNotFound);
    }

    final pdfService = ref.read(pdfExportServiceProvider);

    final txns = await pdfService.fetchTransactions(
      activeProfile.id,
      state.dateRange,
    );

    final userDoc = ref.read(userDocProvider).asData?.value;
    final businessName =
        userDoc?.data()?['businessName'] as String? ?? 'PocketPlus Business';

    int totalIncome = 0;
    int totalExpense = 0;
    for (final t in txns) {
      if (t.type == TransactionType.income) {
        totalIncome += (t.amount as num).toInt();
      } else {
        totalExpense += (t.amount as num).toInt();
      }
    }
    final summary = ReportSummary(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netProfit: totalIncome - totalExpense,
      changePercent: 0.0,
      month: state.dateRange.start,
      profileId: activeProfile.id,
    );

    final file = await pdfService.generatePDF(
      txns,
      summary,
      businessName,
      state.dateRange,
    );

    await pdfService.shareReport(file);
  }
}

final reportsViewModelProvider =
    NotifierProvider.autoDispose<ReportsViewModel, ReportsState>(
  ReportsViewModel.new,
);

final periodReportSummaryProvider =
    StreamProvider.family<ReportSummary, DateTimeRange>((ref, range) {
  final userId = ref.watch(currentBookUserIdProvider);
  final activeProfile = ref.watch(currentProfileProvider);
  if (userId == null || activeProfile == null) {
    return Stream.value(
      ReportSummary(
        totalIncome: 0,
        totalExpense: 0,
        netProfit: 0,
        changePercent: 0.0,
        month: range.start,
        profileId: '',
      ),
    );
  }

  final stream = ref
      .watch(transactionRepositoryProvider)
      .watchTransactions(userId: userId, profileId: activeProfile.id);

  return stream.map((txns) {
    int totalIncome = 0;
    int totalExpense = 0;
    for (final t in txns) {
      final date = t.transactionDate;
      if ((date.isAfter(range.start) || date.isAtSameMomentAs(range.start)) &&
          (date.isBefore(range.end) || date.isAtSameMomentAs(range.end))) {
        if (t.type == TransactionType.income) {
          totalIncome += (t.amount as num).toInt();
        } else if (t.type == TransactionType.expense) {
          totalExpense += (t.amount as num).toInt();
        }
      }
    }
    final netProfit = totalIncome - totalExpense;
    return ReportSummary(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netProfit: netProfit,
      changePercent: 0.0,
      month: range.start,
      profileId: activeProfile.id,
    );
  });
});

final periodTransactionsProvider =
    StreamProvider.family<List<Transaction>, DateTimeRange>((ref, range) {
  final userId = ref.watch(currentBookUserIdProvider);
  final activeProfile = ref.watch(currentProfileProvider);
  if (userId == null || activeProfile == null) {
    return Stream.value([]);
  }

  final stream = ref
      .watch(transactionRepositoryProvider)
      .watchTransactions(userId: userId, profileId: activeProfile.id);

  return stream.map((txns) {
    return txns.where((t) {
      final date = t.transactionDate;
      return (date.isAfter(range.start) ||
              date.isAtSameMomentAs(range.start)) &&
          (date.isBefore(range.end) || date.isAtSameMomentAs(range.end));
    }).toList();
  });
});
