import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/onboarding/presentation/business_name_screen.dart';
import '../../features/onboarding/presentation/onboarding_done_screen.dart';
import '../../features/onboarding/presentation/role_selection_screen.dart';
import '../../features/onboarding/presentation/sms_permission_screen.dart';
import '../../features/onboarding/presentation/user_info_screen.dart';
import '../../features/shell/presentation/main_shell.dart';
import '../../shared/providers/auth_state_provider.dart';
import '../../shared/providers/user_provider.dart';
import '../../features/security/presentation/app_lock_provider.dart';
import '../../features/security/presentation/lock_screen.dart';
import '../../features/security/presentation/pin_setup_screen.dart';
import '../../core/config/remote_config_service.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/pocketplus_loader.dart';
import '../../core/monitoring/maintenance_screen.dart';
import 'route_names.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/transactions/presentation/add_transaction_screen.dart';
import '../../features/transactions/presentation/transaction_history_screen.dart';
import '../../features/khata/presentation/khata_list_screen.dart';
import '../../features/khata/presentation/khata_customer_detail_screen.dart';
import '../../features/invoices/presentation/invoice_list_screen.dart';
import '../../features/invoices/presentation/create_invoice_screen.dart';
import '../../features/invoices/presentation/invoice_detail_screen.dart';
import '../../features/transactions/presentation/transaction_detail_screen.dart';
import '../../features/feedback/presentation/feedback_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/sms_capture/domain/entities/parsed_sms.dart';
import '../../features/sms_capture/presentation/capture_confirmation_screen.dart';
import '../../features/sms_capture/presentation/sms_diagnostics_screen.dart';
import '../../features/analytics/presentation/analytics_screen.dart';
import '../../features/savings/presentation/savings_list_screen.dart';
import '../../features/savings/presentation/create_dream_screen.dart';
import '../../features/savings/presentation/dream_detail_screen.dart';
import '../../features/savings/presentation/goal_reward_screen.dart';
import '../../features/budgets/presentation/screens/budget_list_screen.dart';
import '../../features/budgets/presentation/screens/create_budget_screen.dart';
import '../../features/budgets/presentation/screens/budget_detail_screen.dart';

class _SlideRightPage extends CustomTransitionPage<void> {
  _SlideRightPage({required super.child, super.key})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.35, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 250),
        );
}

class _FadePage extends CustomTransitionPage<void> {
  _FadePage({required super.child, super.key})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration: const Duration(milliseconds: 200),
        );
}

class _ReplaceFadePage extends CustomTransitionPage<void> {
  _ReplaceFadePage({required super.child, super.key})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
        );
}

class _ModalBottomPage extends CustomTransitionPage<void> {
  _ModalBottomPage({required super.child, super.key})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.15),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutQuart,
                ),
              ),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn,
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 250),
        );
}

class RouterRefreshListenable extends ChangeNotifier {
  RouterRefreshListenable(Ref ref) {
    _subscription = ref.listen(authStateProvider, (_, __) => notifyListeners());
    _userDocSubscription =
        ref.listen(userDocProvider, (_, __) => notifyListeners());
    _lockSubscription =
        ref.listen(appLockControllerProvider, (_, __) => notifyListeners());
  }

  late final ProviderSubscription _subscription;
  late final ProviderSubscription _userDocSubscription;
  late final ProviderSubscription _lockSubscription;

  @override
  void dispose() {
    _subscription.close();
    _userDocSubscription.close();
    _lockSubscription.close();
    super.dispose();
  }
}

final routerRefreshListenableProvider =
    Provider<RouterRefreshListenable>((ref) {
  final listenable = RouterRefreshListenable(ref);
  ref.onDispose(() => listenable.dispose());
  return listenable;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(routerRefreshListenableProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      // Kill switch guard — highest priority
      final flags = RemoteConfigService.instance.flags;
      final isGoingToMaintenance =
          state.matchedLocation == RouteNames.maintenance;
      if (flags.killSwitchEnabled && flags.killSwitchMessage.isNotEmpty) {
        if (!isGoingToMaintenance) return RouteNames.maintenance;
        return null;
      }

      final authState = ref.read(authStateProvider);
      final userDocAsync = ref.read(userDocProvider);

      final isAuth = authState.isAuthenticated;
      final isGoingToAuth = state.matchedLocation.startsWith('/auth');
      final isGoingToSplash = state.matchedLocation == RouteNames.splash;

      // Biometric / PIN app lock — gate the authenticated session. Only
      // authenticated users can have configured a lock, so an unauthenticated
      // session falls through to the login redirect below.
      final lock = ref.read(appLockControllerProvider);
      final isGoingToLock = state.matchedLocation == RouteNames.lock;
      if (isAuth && lock.initialized && lock.isEnabled && lock.isLocked) {
        return isGoingToLock ? null : RouteNames.lock;
      }
      if (isGoingToLock) {
        return isAuth ? RouteNames.home : RouteNames.login;
      }

      if (!isAuth && !isGoingToAuth && !isGoingToSplash) {
        return RouteNames.login;
      }

      if (isAuth) {
        if (userDocAsync.isLoading && !userDocAsync.hasValue) {
          return null;
        }

        final userDoc = userDocAsync.asData?.value;

        final role = userDoc?.data()?['role'] as String?;
        final onboardingCompleted =
            userDoc?.data()?['onboardingCompleted'] as bool? ?? false;
        final isOnboarded = role != null && onboardingCompleted;

        final isGoingToOnboarding =
            state.matchedLocation.startsWith('/onboarding');

        if (!isOnboarded && !isGoingToOnboarding) {
          return RouteNames.onboardingRole;
        }

        if (isOnboarded &&
            (isGoingToAuth ||
                (isGoingToOnboarding &&
                    state.matchedLocation != RouteNames.onboardingDone))) {
          return RouteNames.home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.maintenance,
        pageBuilder: (context, state) {
          final flags = RemoteConfigService.instance.flags;
          Widget screen;
          if (flags.killSwitchEnabled && flags.killSwitchMessage.isNotEmpty) {
            screen = MaintenanceScreen.killSwitch(flags.killSwitchMessage);
          } else if (flags.minimumAppVersion != '0.0.0') {
            screen = MaintenanceScreen.forceUpdate(flags.minimumAppVersion);
          } else {
            screen = MaintenanceScreen.killSwitch(
              'App is temporarily unavailable.',
            );
          }
          return _FadePage(key: state.pageKey, child: screen);
        },
      ),
      GoRoute(
        path: RouteNames.splash,
        pageBuilder: (context, state) => _ReplaceFadePage(
          key: state.pageKey,
          child: const _SplashScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.lock,
        pageBuilder: (context, state) => _FadePage(
          key: state.pageKey,
          child: const LockScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.pinSetup,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const PinSetupScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.login,
        pageBuilder: (context, state) => _FadePage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.signup,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const SignupScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.onboardingRole,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const RoleSelectionScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.onboardingInfo,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const UserInfoScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.onboardingName,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const BusinessNameScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.onboardingSms,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const SmsPermissionScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.onboardingDone,
        pageBuilder: (context, state) => _ReplaceFadePage(
          key: state.pageKey,
          child: const OnboardingDoneScreen(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            pageBuilder: (context, state) => _FadePage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.analytics,
            pageBuilder: (context, state) => _FadePage(
              key: state.pageKey,
              child: const AnalyticsScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.reports,
            pageBuilder: (context, state) {
              final monthStr = state.uri.queryParameters['month'];
              final initialMonth =
                  monthStr != null ? DateTime.tryParse(monthStr) : null;
              return _FadePage(
                key: state.pageKey,
                child: ReportsScreen(initialMonth: initialMonth),
              );
            },
          ),
          GoRoute(
            path: RouteNames.budgets,
            pageBuilder: (context, state) => _FadePage(
              key: state.pageKey,
              child: const BudgetListScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.budgetsNew,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const CreateBudgetScreen(),
        ),
      ),
      GoRoute(
        path: '/budgets/:id',
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: BudgetDetailScreen(budgetId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/budgets/edit/:id',
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: CreateBudgetScreen(editBudgetId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: RouteNames.addTransaction,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const AddTransactionScreen(),
        ),
      ),
      GoRoute(
        path: '/transaction/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _SlideRightPage(
            key: state.pageKey,
            child: TransactionDetailScreen(transactionId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.history,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const TransactionHistoryScreen(),
        ),
      ),
      GoRoute(
        path: '/capture/:smsId',
        pageBuilder: (context, state) {
          final parsedSms = state.extra as ParsedSms;
          return _ModalBottomPage(
            key: state.pageKey,
            child: CaptureConfirmationScreen(parsedSms: parsedSms),
          );
        },
      ),
      GoRoute(
        path: '/sms-diagnostics',
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const SmsDiagnosticsScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.invoices,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const InvoiceListScreen(),
        ),
        routes: [
          GoRoute(
            path: 'new',
            pageBuilder: (context, state) => _SlideRightPage(
              key: state.pageKey,
              child: const CreateInvoiceScreen(),
            ),
          ),
          GoRoute(
            path: ':id',
            pageBuilder: (context, state) => _SlideRightPage(
              key: state.pageKey,
              child: InvoiceDetailScreen(
                invoiceId: state.pathParameters['id']!,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.khata,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const KhataListScreen(),
        ),
        routes: [
          GoRoute(
            path: ':customerId',
            pageBuilder: (context, state) => _SlideRightPage(
              key: state.pageKey,
              child: KhataCustomerDetailScreen(
                customerId: state.pathParameters['customerId']!,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.savings,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const SavingsListScreen(),
        ),
        routes: [
          GoRoute(
            path: 'new',
            pageBuilder: (context, state) => _SlideRightPage(
              key: state.pageKey,
              child: const CreateDreamScreen(),
            ),
          ),
          GoRoute(
            path: 'reward/:id',
            pageBuilder: (context, state) => _FadePage(
              key: state.pageKey,
              child: GoalRewardScreen(
                goalId: state.pathParameters['id']!,
              ),
            ),
          ),
          GoRoute(
            path: ':id',
            pageBuilder: (context, state) => _SlideRightPage(
              key: state.pageKey,
              child: DreamDetailScreen(
                goalId: state.pathParameters['id']!,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.settings,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.feedback,
        pageBuilder: (context, state) => _SlideRightPage(
          key: state.pageKey,
          child: const FeedbackScreen(),
        ),
      ),
    ],
  );
});

class _SplashScreen extends ConsumerStatefulWidget {
  const _SplashScreen();

  @override
  ConsumerState<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final isAuth = ref.read(authStateProvider).isAuthenticated;
      context.go(isAuth ? RouteNames.home : RouteNames.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PocketPlusLoader(size: 72, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'PocketPlus',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
