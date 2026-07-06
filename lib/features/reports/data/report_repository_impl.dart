import '../../../shared/models/models.dart';
import '../../transactions/domain/entities/transaction.dart';
import '../domain/entities/report_summary.dart';
import '../domain/report_repository.dart';
import 'firestore_report_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl(this._dataSource);

  final FirestoreReportDataSource _dataSource;

  @override
  Stream<ReportSummary> watchMonthlyReport({
    required String userId,
    required String profileId,
    required DateTime month,
  }) {
    final monthStart = DateTime(month.year, month.month, 1);
    return _dataSource
        .watchTransactionsForProfile(userId: userId, profileId: profileId)
        .map((txns) => _summaryFor(txns, monthStart, profileId));
  }

  @override
  Stream<List<ReportSummary>> watchMonthlyChart({
    required String userId,
    required String profileId,
  }) {
    return _dataSource
        .watchTransactionsForProfile(userId: userId, profileId: profileId)
        .map((txns) {
      final now = DateTime.now();
      // Last 6 months, oldest first.
      return List.generate(6, (i) {
        final monthStart = DateTime(now.year, now.month - (5 - i), 1);
        return _summaryFor(txns, monthStart, profileId);
      });
    });
  }

  ReportSummary _summaryFor(
    List<Transaction> txns,
    DateTime monthStart,
    String profileId,
  ) {
    final monthEnd = DateTime(monthStart.year, monthStart.month + 1, 1);
    final prevStart = DateTime(monthStart.year, monthStart.month - 1, 1);
    var income = 0;
    var expense = 0;
    var prevIncome = 0;
    var prevExpense = 0;

    for (final t in txns) {
      final d = t.transactionDate;
      if (!d.isBefore(monthStart) && d.isBefore(monthEnd)) {
        if (t.type == TransactionType.income) {
          income += t.amount;
        } else {
          expense += t.amount;
        }
      } else if (!d.isBefore(prevStart) && d.isBefore(monthStart)) {
        if (t.type == TransactionType.income) {
          prevIncome += t.amount;
        } else {
          prevExpense += t.amount;
        }
      }
    }

    final net = income - expense;
    final prevNet = prevIncome - prevExpense;
    final changePercent =
        prevNet == 0 ? 0.0 : ((net - prevNet) / prevNet.abs()) * 100;

    return ReportSummary(
      totalIncome: income,
      totalExpense: expense,
      netProfit: net,
      changePercent: changePercent,
      month: monthStart,
      profileId: profileId,
    );
  }
}
