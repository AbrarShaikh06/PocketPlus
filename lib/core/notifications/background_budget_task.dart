import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import '../../features/budgets/domain/budget_calculator.dart';
import '../../features/budgets/domain/entities/budget.dart';
import '../../features/transactions/domain/entities/transaction.dart';
import '../../firebase_options.dart';
import 'local_notification_service.dart';

const String _taskName = 'budgetBackgroundCheck';

@pragma('vm:entry-point')
void budgetCheckCallback() {
  Workmanager().executeTask((task, inputData) async {
    if (task != _taskName) return true;

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await LocalNotificationService.init();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return true;

    final firestore = FirebaseFirestore.instance;

    final profilesSnap = await firestore
        .collection('profiles')
        .where('userId', isEqualTo: user.uid)
        .where('isDeleted', isEqualTo: false)
        .get(const GetOptions(source: Source.cache));

    for (final profileDoc in profilesSnap.docs) {
      final profileId = profileDoc.id;

      final budgetsSnap = await firestore
          .collection('budgets')
          .where('userId', isEqualTo: user.uid)
          .where('profileId', isEqualTo: profileId)
          .where('isDeleted', isEqualTo: false)
          .get(const GetOptions(source: Source.cache));

      if (budgetsSnap.docs.isEmpty) continue;

      final budgets = budgetsSnap.docs
          .map((d) => Budget.fromJson(d.data()))
          .where((b) => !b.isPaused && b.notificationsEnabled)
          .toList();

      if (budgets.isEmpty) continue;

      final txnsSnap = await firestore
          .collection('transactions')
          .where('userId', isEqualTo: user.uid)
          .where('profileId', isEqualTo: profileId)
          .where('isDeleted', isEqualTo: false)
          .get(const GetOptions(source: Source.cache));

      final transactions =
          txnsSnap.docs.map((d) => Transaction.fromJson(d.data())).toList();

      final calculator = BudgetCalculator();
      final calculatedBudgets = calculator.calculate(
        budgets: budgets,
        transactions: transactions,
      );

      for (final budget in calculatedBudgets) {
        final percentage = calculator.computePercentage(budget);
        final status = calculator.computeStatus(budget);

        if (percentage >= budget.alertThreshold && budget.alertThreshold > 0) {
          LocalNotificationService.show(
            'Budget Alert',
            "You've used $percentage% of your ${budget.name} budget.",
            'budget_${budget.id}',
          );
        }

        if (status == BudgetStatus.exceeded) {
          final exceededAmount = budget.spentAmount - budget.amount;
          final formatted = (exceededAmount / 100).toStringAsFixed(2);
          LocalNotificationService.show(
            'Budget Exceeded',
            "You've exceeded your ${budget.name} budget by \u20b9$formatted.",
            'budget_${budget.id}',
          );
        }
      }
    }

    return true;
  });
}
