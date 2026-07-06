abstract final class RouteNames {
  static const String splash = '/splash';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String onboardingRole = '/onboarding/role';
  static const String onboardingInfo = '/onboarding/info';
  static const String onboardingName = '/onboarding/name';
  static const String onboardingSms = '/onboarding/sms';
  static const String onboardingDone = '/onboarding/done';
  static const String home = '/home';
  static const String analytics = '/analytics';
  static const String reports = '/reports';
  static const String addTransaction = '/add-transaction';
  static const String history = '/history';
  static const String invoices = '/invoices';
  static const String invoicesNew = '/invoices/new';
  static String invoiceDetail(String id) => '/invoices/$id';
  static const String khata = '/khata';
  static String khataCustomerDetail(String id) => '/khata/$id';
  static const String settings = '/settings';
  static const String feedback = '/feedback';

  static const String budgets = '/budgets';
  static const String budgetsNew = '/budgets/new';
  static String budgetDetail(String id) => '/budgets/$id';
  static String budgetsEdit(String id) => '/budgets/edit/$id';

  static const String savings = '/savings';
  static const String savingsNew = '/savings/new';
  static String savingsDetail(String id) => '/savings/$id';
  static String savingsReward(String id) => '/savings/reward/$id';

  static String transactionDetail(String id) => '/transaction/$id';
  static String captureConfirm(String smsId) => '/capture/$smsId';
  static const String smsDiagnostics = '/sms-diagnostics';
  static const String maintenance = '/maintenance';
  static const String lock = '/lock';
  static const String pinSetup = '/settings/pin-setup';
}
