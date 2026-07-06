import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/tutorial_step.dart';

class TutorialKeys {
  static final dashboard = GlobalKey(debugLabel: 'tutorial_dashboard');
  static final addTxnFab = GlobalKey(debugLabel: 'tutorial_addTxnFab');
  static final txnList = GlobalKey(debugLabel: 'tutorial_txnList');
  static final reportsTab = GlobalKey(debugLabel: 'tutorial_reportsTab');
  static final settingsOption =
      GlobalKey(debugLabel: 'tutorial_settingsOption');
  static final smsPill = GlobalKey(debugLabel: 'tutorial_smsPill');
  static final analyticsTab = GlobalKey(debugLabel: 'tutorial_analyticsTab');
  static final khataOption = GlobalKey(debugLabel: 'tutorial_khataOption');
  static final notificationBell =
      GlobalKey(debugLabel: 'tutorial_notificationBell');
  static final profileSwitcher =
      GlobalKey(debugLabel: 'tutorial_profileSwitcher');
}

final tutorialStepsProvider =
    Provider.family<List<TutorialStep>, TutorialRole>((ref, role) {
  switch (role) {
    case TutorialRole.personal:
      return [
        TutorialStep(
          key: TutorialKeys.dashboard,
          title: 'Dashboard',
          description: 'Your net profit at a glance',
          stepNumber: 1,
        ),
        TutorialStep(
          key: TutorialKeys.addTxnFab,
          title: 'Add Transaction FAB',
          description: 'Tap here to log any transaction instantly',
          stepNumber: 2,
        ),
        TutorialStep(
          key: TutorialKeys.txnList,
          title: 'Transaction list',
          description: 'All your entries, searchable and filterable',
          stepNumber: 3,
        ),
        TutorialStep(
          key: TutorialKeys.reportsTab,
          title: 'Reports tab',
          description: 'See your monthly summary and export to PDF',
          stepNumber: 4,
        ),
        TutorialStep(
          key: TutorialKeys.settingsOption,
          title: 'Settings',
          description: 'Customize PocketPlus for your needs',
          stepNumber: 5,
        ),
      ];

    case TutorialRole.business:
      return [
        TutorialStep(
          key: TutorialKeys.dashboard,
          title: 'Dashboard',
          description: 'Your business profit dashboard',
          stepNumber: 1,
        ),
        TutorialStep(
          key: TutorialKeys.addTxnFab,
          title: 'Add Transaction FAB',
          description: 'Log sales, expenses, and more',
          stepNumber: 2,
        ),
        TutorialStep(
          key: TutorialKeys.smsPill,
          title: 'SMS auto-capture pill',
          description: 'PocketPlus reads bank SMSes to auto-log transactions',
          stepNumber: 3,
        ),
        TutorialStep(
          key: TutorialKeys.analyticsTab,
          title: 'Analytics tab',
          description: 'Track 6-month trends',
          stepNumber: 4,
        ),
        TutorialStep(
          key: TutorialKeys.reportsTab,
          title: 'Reports tab',
          description: 'Export monthly reports as PDF',
          stepNumber: 5,
        ),
        TutorialStep(
          key: TutorialKeys.khataOption,
          title: 'Khata option',
          description: "Track credit you've given to customers",
          stepNumber: 6,
        ),
      ];
  }
});
