import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/features/reports/data/firestore_report_data_source.dart';
import 'package:pocket_plus/features/reports/data/report_repository_impl.dart';
import 'package:pocket_plus/features/transactions/domain/entities/transaction.dart';
import 'package:pocket_plus/shared/models/models.dart';

class FakeFirestoreReportDataSource implements FirestoreReportDataSource {
  final List<Transaction> transactions = [];
  final _controller = StreamController<List<Transaction>>.broadcast();

  void addTransaction(Transaction t) {
    transactions.add(t);
    _controller.add(List.from(transactions));
  }

  void clear() {
    transactions.clear();
    _controller.add(List.from(transactions));
  }

  @override
  Stream<List<Transaction>> watchTransactionsForProfile({
    required String userId,
    required String profileId,
  }) {
    final StreamController<List<Transaction>> profileController =
        StreamController<List<Transaction>>();

    void emitFiltered() {
      if (!profileController.isClosed) {
        profileController.add(
          transactions
              .where(
                (t) =>
                    t.userId == userId &&
                    t.profileId == profileId &&
                    !t.isDeleted,
              )
              .toList(),
        );
      }
    }

    emitFiltered();

    final subscription = _controller.stream.listen((_) {
      emitFiltered();
    });

    profileController.onCancel = () {
      subscription.cancel();
      profileController.close();
    };

    return profileController.stream;
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  late FakeFirestoreReportDataSource fakeDataSource;
  late ReportRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeFirestoreReportDataSource();
    repository = ReportRepositoryImpl(fakeDataSource);
  });

  tearDown(() {
    fakeDataSource.dispose();
  });

  group('ReportRepository Calculations & Isolation Tests', () {
    final DateTime targetMonth = DateTime(2026, 6, 1);
    final DateTime prevMonth = DateTime(2026, 5, 1);
    const String profileA = 'profile_a';
    const String profileB = 'profile_b';

    test(
        'Positive profit: income > expense -> correct netProfit & changePercent',
        () async {
      // Previous month
      fakeDataSource.addTransaction(
        Transaction(
          id: 't_prev_inc',
          userId: 'user_1',
          profileId: profileA,
          amount: 10000, // 100 INR in paise
          type: TransactionType.income,
          source: TransactionSource.manual,
          transactionDate: DateTime(2026, 5, 15),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      fakeDataSource.addTransaction(
        Transaction(
          id: 't_prev_exp',
          userId: 'user_1',
          profileId: profileA,
          amount: 2000, // 20 INR in paise
          type: TransactionType.expense,
          source: TransactionSource.manual,
          transactionDate: DateTime(2026, 5, 20),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Target month
      fakeDataSource.addTransaction(
        Transaction(
          id: 't_target_inc',
          userId: 'user_1',
          profileId: profileA,
          amount: 15000, // 150 INR in paise
          type: TransactionType.income,
          source: TransactionSource.manual,
          transactionDate: DateTime(2026, 6, 10),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      fakeDataSource.addTransaction(
        Transaction(
          id: 't_target_exp',
          userId: 'user_1',
          profileId: profileA,
          amount: 5000, // 50 INR in paise
          type: TransactionType.expense,
          source: TransactionSource.manual,
          transactionDate: DateTime(2026, 6, 12),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final stream = repository.watchMonthlyReport(
        userId: 'user_1',
        profileId: profileA,
        month: targetMonth,
      );
      final report = await stream.first;

      // Net profit prev month = 10000 - 2000 = 8000
      // Net profit target month = 15000 - 5000 = 10000
      // Change percent = ((10000 - 8000) / 8000) * 100 = 25.0%
      expect(report.totalIncome, 15000);
      expect(report.totalExpense, 5000);
      expect(report.netProfit, 10000);
      expect(report.changePercent, 25.0);
      expect(report.month, targetMonth);
      expect(report.profileId, profileA);
    });

    test('Loss: expense > income -> negative netProfit', () async {
      fakeDataSource.addTransaction(
        Transaction(
          id: 't_inc',
          userId: 'user_1',
          profileId: profileA,
          amount: 5000,
          type: TransactionType.income,
          source: TransactionSource.manual,
          transactionDate: DateTime(2026, 6, 5),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      fakeDataSource.addTransaction(
        Transaction(
          id: 't_exp',
          userId: 'user_1',
          profileId: profileA,
          amount: 12000,
          type: TransactionType.expense,
          source: TransactionSource.manual,
          transactionDate: DateTime(2026, 6, 15),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final stream = repository.watchMonthlyReport(
        userId: 'user_1',
        profileId: profileA,
        month: targetMonth,
      );
      final report = await stream.first;

      expect(report.totalIncome, 5000);
      expect(report.totalExpense, 12000);
      expect(report.netProfit, -7000);
      expect(report.changePercent, 0.0); // No previous month data
    });

    test('Zero: no transactions -> all fields return 0 / 0.0', () async {
      final stream = repository.watchMonthlyReport(
        userId: 'user_1',
        profileId: profileA,
        month: targetMonth,
      );
      final report = await stream.first;

      expect(report.totalIncome, 0);
      expect(report.totalExpense, 0);
      expect(report.netProfit, 0);
      expect(report.changePercent, 0.0);
    });

    test(
        'Profile Isolation: transactions from profile B never appear in profile A report',
        () async {
      // Profile B has transactions
      fakeDataSource.addTransaction(
        Transaction(
          id: 't_b',
          userId: 'user_1',
          profileId: profileB,
          amount: 50000,
          type: TransactionType.income,
          source: TransactionSource.manual,
          transactionDate: DateTime(2026, 6, 5),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Watch Profile A
      final stream = repository.watchMonthlyReport(
        userId: 'user_1',
        profileId: profileA,
        month: targetMonth,
      );
      final report = await stream.first;

      expect(report.totalIncome, 0);
      expect(report.totalExpense, 0);
      expect(report.netProfit, 0);
      expect(report.changePercent, 0.0);
    });

    test('changePercent: handles various profit comparisons correctly',
        () async {
      // Scenario 1: Previous profit was negative, current is positive (improved)
      // Prev: -1000, Current: 500 -> ((500 - -1000) / 1000) * 100 = +150%
      fakeDataSource.addTransaction(
        Transaction(
          id: 't1_prev_exp',
          userId: 'user_1',
          profileId: profileA,
          amount: 1000,
          type: TransactionType.expense,
          source: TransactionSource.manual,
          transactionDate: prevMonth,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      fakeDataSource.addTransaction(
        Transaction(
          id: 't1_target_inc',
          userId: 'user_1',
          profileId: profileA,
          amount: 500,
          type: TransactionType.income,
          source: TransactionSource.manual,
          transactionDate: targetMonth,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      var report = await repository
          .watchMonthlyReport(
            userId: 'user_1',
            profileId: profileA,
            month: targetMonth,
          )
          .first;
      expect(report.changePercent, 150.0);

      // Scenario 2: Previous profit was 0 -> changePercent should be 0.0 (avoid divide-by-zero)
      fakeDataSource.clear();
      fakeDataSource.addTransaction(
        Transaction(
          id: 't2_target_inc',
          userId: 'user_1',
          profileId: profileA,
          amount: 1000,
          type: TransactionType.income,
          source: TransactionSource.manual,
          transactionDate: targetMonth,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      report = await repository
          .watchMonthlyReport(
            userId: 'user_1',
            profileId: profileA,
            month: targetMonth,
          )
          .first;
      expect(report.changePercent, 0.0);
    });

    test('monthlyChartProvider returns 6 chronological months of ReportSummary',
        () async {
      // Add transactions across different months
      // If today is June 2026, the 6 months should be Jan, Feb, Mar, Apr, May, June 2026.
      // Let's add income to each of these months.
      final now = DateTime.now();
      for (int i = 0; i < 6; i++) {
        final monthDate = DateTime(now.year, now.month - i, 15);
        fakeDataSource.addTransaction(
          Transaction(
            id: 't_chart_$i',
            userId: 'user_1',
            profileId: profileA,
            amount: (i + 1) * 1000, // distinct amounts: 1000, 2000, 3000...
            type: TransactionType.income,
            source: TransactionSource.manual,
            transactionDate: monthDate,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }

      final chartStream = repository.watchMonthlyChart(
        userId: 'user_1',
        profileId: profileA,
      );
      final chartData = await chartStream.first;

      expect(chartData.length, 6);

      // Verify chronological order: chartData[0] is 5 months ago, chartData[5] is current month
      final expectedMonths =
          List.generate(6, (i) => DateTime(now.year, now.month - (5 - i), 1));
      for (int i = 0; i < 6; i++) {
        expect(chartData[i].month, expectedMonths[i]);
        expect(chartData[i].profileId, profileA);
      }
    });
  });
}
