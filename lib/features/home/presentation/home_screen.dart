import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';

import '../../../core/constants/app_colors.dart';
import '../../budgets/presentation/widgets/budget_card.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/network/connectivity_checker.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/chart_formatter.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/logger.dart';
import '../../categories/domain/entities/category.dart';
import '../../profiles/domain/entities/profile.dart';
import '../../profiles/presentation/active_profile_provider.dart';
import '../../profiles/profiles_providers.dart';
import '../../reports/domain/entities/report_summary.dart';
import '../../transactions/domain/entities/transaction.dart';
import '../../transactions/transactions_providers.dart';
import '../../../shared/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import 'home_providers.dart';
import '../../../shared/providers/firebase_providers.dart';
import '../../../shared/providers/user_provider.dart';
import '../../savings/presentation/savings_providers.dart';
import '../../onboarding/domain/tutorial_step.dart';
import '../../onboarding/presentation/tutorial_controller.dart';
import '../../onboarding/presentation/widgets/tutorial_overlay.dart';

Color parseColor(String? hex) {
  if (hex == null) return AppColors.primary;
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

IconData getIconData(String iconName) {
  switch (iconName) {
    case 'local_gas_station':
      return Icons.local_gas_station;
    case 'restaurant':
      return Icons.restaurant;
    case 'work':
      return Icons.work;
    case 'home':
      return Icons.home;
    case 'inventory':
      return Icons.inventory_2;
    case 'bolt':
      return Icons.bolt;
    case 'directions_bus':
      return Icons.directions_bus;
    case 'medical_services':
      return Icons.medical_services;
    case 'people':
      return Icons.people;
    case 'monetization_on':
      return Icons.monetization_on;
    case 'add_circle':
      return Icons.add_circle;
    case 'remove_circle':
      return Icons.remove_circle;
    default:
      return Icons.receipt_long;
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _chartTabIndex = 0; // 0 = Net Profit, 1 = Income, 2 = Expense
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Guards the one-time default-profile creation for brand-new accounts and
  // records when that creation fails (e.g. write rejected / offline) so the
  // body can show a retry state instead of an endless skeleton.
  bool _creatingDefaultProfile = false;
  bool _defaultProfileCreationFailed = false;

  // Guards the one-time auto-start of the onboarding tutorial.
  bool _tutorialTriggered = false;

  /// Starts the onboarding tutorial once for a brand-new user whose
  /// `tutorialCompleted` flag is still false. Resets the guard if the flag
  /// flips back to false (e.g. the user replays the tutorial from settings).
  void _maybeStartTutorial() {
    final userDoc = ref.read(userDocProvider).value;
    if (userDoc == null) return;
    final data = userDoc.data();
    if (data == null) return;

    final completed = data['tutorialCompleted'] as bool? ?? false;
    if (completed) {
      _tutorialTriggered = false;
      return;
    }
    if (_tutorialTriggered) return;
    _tutorialTriggered = true;

    final role =
        TutorialRoleX.fromString(data['role'] as String? ?? 'PERSONAL');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        if (ref.read(tutorialControllerProvider).isActive) return;
        if (ref.read(tutorialControllerProvider).isCompleted) return;
        ref.read(tutorialControllerProvider.notifier).startTutorial(role);
      });
    });
  }

  void _handleRetry() {
    _creatingDefaultProfile = false;
    setState(() => _defaultProfileCreationFailed = false);
    ref.invalidate(connectivityStatusProvider);
    ref.invalidate(userProfilesProvider);
  }

  Future<void> _handleRefresh() async {
    ref.invalidate(userProfilesProvider);
    ref.invalidate(recentTransactionsProvider);
    ref.invalidate(transactionsTodayProvider);
    ref.invalidate(homeMonthlyChartProvider);
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    ref.invalidate(reportSummaryProvider(currentMonth));
  }

  void _showProfileSwitcher(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final profilesAsync = ref.watch(userProfilesProvider);
            final currentProfile = ref.watch(currentProfileProvider);

            return Container(
              padding: const EdgeInsets.all(AppSizes.spacing24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.switchProfile,
                    style: AppTextStyles.titleMedium(context),
                  ),
                  const SizedBox(height: AppSizes.spacing16),
                  profilesAsync.when(
                    data: (profiles) {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: profiles.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSizes.spacing12),
                        itemBuilder: (context, index) {
                          final profile = profiles[index];
                          final isSelected = profile.id == currentProfile?.id;
                          final color = parseColor(profile.colorHex);

                          return InkWell(
                            onTap: () {
                              ref
                                  .read(activeProfileProvider.notifier)
                                  .switchProfile(profile.id);
                              Navigator.pop(context);
                            },
                            borderRadius:
                                BorderRadius.circular(AppSizes.spacing12),
                            child: Container(
                              padding: const EdgeInsets.all(AppSizes.spacing16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppSizes.spacing12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.outline
                                          .withValues(alpha: 0.3),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        color.withValues(alpha: 0.2),
                                    child: Icon(
                                      profile.type == ProfileType.personal
                                          ? Icons.person
                                          : Icons.business,
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.spacing16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profile.name,
                                          style: AppTextStyles.bodyLarge(
                                            context,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.onSurface,
                                          ),
                                        ),
                                        Text(
                                          profile.type.name.toUpperCase(),
                                          style:
                                              AppTextStyles.labelSmall(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text(
                      AppLocalizations.of(context)!
                          .errorWithMessage(e.toString()),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentProfile = ref.watch(currentProfileProvider);
    final profilesAsync = ref.watch(userProfilesProvider);
    // Treat "unknown" connectivity (still resolving) as online to avoid flashing
    // an error before the first check completes.
    final isOffline = ref.watch(connectivityStatusProvider).value == false;

    // Re-evaluate tutorial auto-start whenever the user doc resolves/changes.
    ref.watch(userDocProvider);
    _maybeStartTutorial();

    ref.listen<AsyncValue<List<Profile>>>(userProfilesProvider,
        (previous, next) {
      next.whenData((profiles) async {
        if (profiles.isNotEmpty || _creatingDefaultProfile) return;
        final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
        if (userId == null) return;

        _creatingDefaultProfile = true;
        final result = await ref
            .read(profileRepositoryProvider)
            .createDefaultProfile(userId);
        if (!mounted) return;
        result.fold(
          (failure) {
            AppLogger.error(
              'Failed to create default profile',
              error: failure.message,
            );
            setState(() => _defaultProfileCreationFailed = true);
            _creatingDefaultProfile = false;
          },
          (_) {
            // Stream will re-emit with the new profile; clear the failure flag.
            setState(() => _defaultProfileCreationFailed = false);
            _creatingDefaultProfile = false;
          },
        );
      });
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'Open menu',
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: InkWell(
          onTap: () => _showProfileSwitcher(context),
          borderRadius: BorderRadius.circular(AppSizes.spacing8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing8,
              vertical: AppSizes.spacing4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentProfile?.name ?? AppLocalizations.of(context)!.loading,
                  style:
                      AppTextStyles.titleMedium(context, color: Colors.white),
                ),
                const SizedBox(width: AppSizes.spacing4),
                const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        ),
        actions: const [],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              margin: EdgeInsets.zero,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(
                        (currentProfile?.name ?? 'I')
                            .substring(0, 1)
                            .toUpperCase(),
                        style: AppTextStyles.titleLarge(
                          context,
                          color: Colors.white,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing12),
                    Text(
                      currentProfile?.name ?? 'PocketPlus',
                      style: AppTextStyles.titleMedium(
                        context,
                        color: Colors.white,
                      ).copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          currentProfile?.type != ProfileType.personal
                              ? 'Business'
                              : 'Personal',
                          style: AppTextStyles.labelSmall(
                            context,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerNavItem(
                    icon: Icons.home_rounded,
                    label: AppLocalizations.of(context)!.home,
                    onTap: () => Navigator.pop(context),
                  ),
                  if (currentProfile?.type != ProfileType.personal)
                    _DrawerNavItem(
                      icon: Icons.book_rounded,
                      label: AppLocalizations.of(context)!.khataLedger,
                      onTap: () {
                        Navigator.pop(context);
                        context.push(RouteNames.khata);
                      },
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(height: 1),
                  ),
                  _DrawerNavItem(
                    icon: Icons.feedback_outlined,
                    label: 'Feedback',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RouteNames.feedback);
                    },
                  ),
                  _DrawerNavItem(
                    icon: Icons.settings_rounded,
                    label: AppLocalizations.of(context)!.settings,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RouteNames.settings);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: _buildBody(
              context,
              currentProfile: currentProfile,
              profilesAsync: profilesAsync,
              isOffline: isOffline,
            ),
          ),
          const TutorialOverlay(),
        ],
      ),
      floatingActionButton: AnimatedFab(
        isTutorialTarget: true,
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.push(RouteNames.addTransaction);
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required Profile? currentProfile,
    required AsyncValue<List<Profile>> profilesAsync,
    required bool isOffline,
  }) {
    // A resolved profile always wins — render the dashboard (works offline once
    // Firestore has cached data).
    if (currentProfile != null) {
      return _HomeDashboardBody(
        key: ValueKey(currentProfile.id),
        profile: currentProfile,
        chartTabIndex: _chartTabIndex,
        onChartTabChanged: (idx) {
          setState(() {
            _chartTabIndex = idx;
          });
        },
        onRefresh: _handleRefresh,
      );
    }

    return profilesAsync.when(
      // While genuinely loading: skeleton when online, retry when offline (an
      // offline first-login has no cache to fall back on, so it can never load).
      loading: () => isOffline
          ? _HomeConnectionError(
              key: const ValueKey('home-error'),
              onRetry: _handleRetry,
            )
          : const _HomeSkeletonLoading(key: ValueKey('home-skeleton')),
      error: (_, __) => _HomeConnectionError(
        key: const ValueKey('home-error'),
        onRetry: _handleRetry,
      ),
      data: (profiles) {
        // Empty list: a default profile is being created. Firestore's offline
        // persistence lets that write land in the local cache even with no
        // network, and the profiles stream then re-emits with it — so the app
        // stays usable offline from first launch. Show the skeleton while that
        // happens; only fall back to the retry screen if creation actually
        // failed.
        if (_defaultProfileCreationFailed) {
          return _HomeConnectionError(
            key: const ValueKey('home-error'),
            onRetry: _handleRetry,
          );
        }
        return const _HomeSkeletonLoading(key: ValueKey('home-skeleton'));
      },
    );
  }
}

class _HomeConnectionError extends StatelessWidget {
  const _HomeConnectionError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.spacing24),
        child: EmptyState(
          illustration: const Icon(
            Icons.cloud_off_rounded,
            size: 64,
            color: AppColors.onSurfaceMuted,
          ),
          message: AppLocalizations.of(context)!.cantConnect,
          ctaLabel: AppLocalizations.of(context)!.retry,
          onCtaPressed: onRetry,
        ),
      ),
    );
  }
}

class _HomeSkeletonLoading extends StatelessWidget {
  const _HomeSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacing24),
      child: Column(
        children: [
          LoadingShimmer.card(height: 120),
          const SizedBox(height: AppSizes.spacing24),
          Row(
            children: [
              Expanded(child: LoadingShimmer.card(height: 80)),
              const SizedBox(width: AppSizes.spacing16),
              Expanded(child: LoadingShimmer.card(height: 80)),
            ],
          ),
          const SizedBox(height: AppSizes.spacing24),
          LoadingShimmer.card(height: 250),
          const SizedBox(height: AppSizes.spacing24),
          const LoadingShimmerList(itemCount: 3),
        ],
      ),
    );
  }
}

class _HomeDashboardBody extends ConsumerWidget {
  const _HomeDashboardBody({
    super.key,
    required this.profile,
    required this.chartTabIndex,
    required this.onChartTabChanged,
    required this.onRefresh,
  });

  final Profile profile;
  final int chartTabIndex;
  final ValueChanged<int> onChartTabChanged;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    final reportAsync = ref.watch(reportSummaryProvider(currentMonth));
    final todayTxnsAsync = ref.watch(transactionsTodayProvider);
    final recentTxnsAsync = ref.watch(recentTransactionsProvider);
    final chartDataAsync = ref.watch(homeMonthlyChartProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    final isLoading = reportAsync.isLoading ||
        todayTxnsAsync.isLoading ||
        recentTxnsAsync.isLoading ||
        chartDataAsync.isLoading ||
        categoriesAsync.isLoading;

    if (isLoading) {
      return const _HomeSkeletonLoading();
    }

    final report = reportAsync.asData?.value;
    final todayTxns = todayTxnsAsync.asData?.value ?? [];
    final recentTxns = recentTxnsAsync.asData?.value ?? [];
    final chartData = chartDataAsync.asData?.value ?? [];
    final categories = categoriesAsync.asData?.value ?? [];

    int todayIncome = 0;
    int todayExpense = 0;
    for (final t in todayTxns) {
      if (t.type == TransactionType.income) {
        todayIncome += t.amount;
      } else {
        todayExpense += t.amount;
      }
    }

    final hasNoTransactions = recentTxns.isEmpty &&
        chartData.every(
          (s) => s.totalIncome == 0 && s.totalExpense == 0 && s.netProfit == 0,
        );

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Net Profit Card
            NetProfitCard(
              totalIncome: report?.totalIncome ?? 0,
              totalExpense: report?.totalExpense ?? 0,
              netProfit: report?.netProfit ?? 0,
              changePercent: report?.changePercent ?? 0.0,
            ),
            const SizedBox(height: AppSizes.spacing24),

            // Today's StatCards Row
            StatCardsRow(
              todayIncome: todayIncome,
              todayExpense: todayExpense,
            ),
            const SizedBox(height: AppSizes.spacing24),

            if (profile.type != ProfileType.personal) ...[
              Card(
                elevation: 0,
                color: AppColors.blue.withValues(alpha: 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side:
                      BorderSide(color: AppColors.blue.withValues(alpha: 0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing16,
                    vertical: AppSizes.spacing12,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sms_outlined, color: AppColors.blue),
                      const SizedBox(width: AppSizes.spacing12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .smsAutoCaptureActive,
                              style: AppTextStyles.bodyMedium(context).copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .autoLoggingBankAlerts,
                              style: AppTextStyles.labelSmall(context).copyWith(
                                color: AppColors.blue.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacing24),
            ],

            // Savings summary card
            Consumer(
              builder: (context, ref, child) {
                final activeGoals = ref.watch(activeGoalsProvider);
                if (activeGoals.isEmpty) {
                  return Card(
                    elevation: 0,
                    color: AppColors.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: AppColors.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => context.push(RouteNames.savings),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.spacing16),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: Icon(Icons.star, color: AppColors.primary),
                            ),
                            const SizedBox(width: AppSizes.spacing16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .planYourFinancialDreams,
                                    style: AppTextStyles.bodyLarge(context)
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .setGoalsSubtitle,
                                    style: AppTextStyles.labelSmall(context),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.onSurfaceMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final latestGoal = activeGoals.first;
                final double percentage = latestGoal.targetAmount > 0
                    ? (latestGoal.savedAmount / latestGoal.targetAmount)
                        .clamp(0.0, 1.0)
                    : 0.0;
                final int percentInt = (percentage * 100).round();

                return Card(
                  elevation: 0,
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: AppColors.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.spacing16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: AppSizes.spacing8),
                                Text(
                                  AppLocalizations.of(context)!.savingsGoal,
                                  style: AppTextStyles.labelSmall(context),
                                ),
                              ],
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () => context.push(RouteNames.savings),
                              child: Text(
                                AppLocalizations.of(context)!.viewAll,
                                style:
                                    AppTextStyles.labelSmall(context).copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.spacing12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              latestGoal.name,
                              style: AppTextStyles.bodyLarge(context).copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$percentInt%',
                              style: AppTextStyles.bodyMedium(context).copyWith(
                                fontWeight: FontWeight.bold,
                                color: percentage > 0.90
                                    ? AppColors.orange
                                    : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.spacing8),
                        // Animated liquid progress bar
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: percentage),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) {
                            final barColor = value > 0.90
                                ? AppColors.orange
                                : AppColors.primary;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Stack(
                                children: [
                                  // Track
                                  Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: AppColors.outline
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  // Animated fill
                                  FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: value,
                                    child: Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: barColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSizes.spacing8),
                        Text(
                          AppLocalizations.of(context)!.savedOfTarget(
                            CurrencyFormatter.formatRupees(
                              latestGoal.savedAmount,
                            ),
                            CurrencyFormatter.formatRupees(
                              latestGoal.targetAmount,
                            ),
                          ),
                          style: AppTextStyles.labelSmall(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSizes.spacing24),

            // Budget Overview
            Consumer(
              builder: (context, ref, child) {
                final budgetOverview = ref.watch(budgetOverviewProvider);
                if (!budgetOverview.hasBudgets) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spacing24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Budget Overview',
                              style: Theme.of(context).textTheme.titleMedium),
                          TextButton(
                            onPressed: () => context.go('/budgets'),
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...budgetOverview.topBudgets
                          .map((budget) => BudgetCard(budget: budget)),
                    ],
                  ),
                );
              },
            ),

            // Performance Chart
            if (chartData.isNotEmpty) ...[
              PerformanceChart(
                summaries: chartData,
                activeTabIndex: chartTabIndex,
                onTabChanged: onChartTabChanged,
              ),
              const SizedBox(height: AppSizes.spacing24),
            ],

            // Recent Entries
            RecentEntriesSection(
              transactions: recentTxns,
              categories: categories,
              hasNoTransactions: hasNoTransactions,
            ),
          ],
        ),
      ),
    );
  }
}

class NetProfitCard extends StatefulWidget {
  const NetProfitCard({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.netProfit,
    required this.changePercent,
  });

  final int totalIncome;
  final int totalExpense;
  final int netProfit;
  final double changePercent;

  @override
  State<NetProfitCard> createState() => _NetProfitCardState();
}

class _NetProfitCardState extends State<NetProfitCard>
    with TickerProviderStateMixin {
  late AnimationController _counterController;
  late AnimationController _pillController;

  late Animation<int> _counterAnim;
  late Animation<double> _pillSlide;
  late Animation<double> _pillFade;

  int _displayedProfit = 0;

  @override
  void initState() {
    super.initState();

    _counterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _pillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _pillSlide = _pillController.drive(
      Tween<double>(begin: 24.0, end: 0.0).chain(
        CurveTween(curve: Curves.easeOutCubic),
      ),
    );
    _pillFade = _pillController.drive(
      Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Curves.easeOut),
      ),
    );

    _startCounterAnimation(0, widget.netProfit);
  }

  @override
  void didUpdateWidget(NetProfitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.netProfit != widget.netProfit) {
      _startCounterAnimation(_displayedProfit, widget.netProfit);
    }
  }

  void _startCounterAnimation(int from, int to) {
    _counterAnim = _counterController.drive(
      IntTween(begin: from, end: to).chain(
        CurveTween(curve: Curves.easeOutCubic),
      ),
    );
    _counterController.forward(from: 0.0);

    // Pill slides in after counter is 60% done
    Future.delayed(const Duration(milliseconds: 420), () {
      if (mounted) _pillController.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _counterController.dispose();
    _pillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPositive = widget.netProfit >= 0;
    final cardBgColor = isPositive ? AppColors.primary : AppColors.error;
    final disable = MediaQuery.disableAnimationsOf(context);

    // Announce a single stable figure to screen readers — the on-screen
    // number animates, and excludeSemantics stops the counter from being
    // read out digit-by-digit as it ticks.
    final profitLabel = AppLocalizations.of(context)!.currentMonthNetProfit;
    final profitAmount = CurrencyFormatter.formatRupees(widget.netProfit.abs());
    final semanticValue =
        '$profitLabel: ${isPositive ? '' : 'negative '}$profitAmount';

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: semanticValue,
      child: Card(
        elevation: 0,
        color: cardBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius16),
        ),
        child: Stack(
          children: [
            // Decorative circle
            Positioned(
              right: -32,
              top: -32,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSizes.spacing24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.currentMonthNetProfit,
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing12),
                  // Animated counter row
                  disable
                      ? _buildAmountRow(
                          context,
                          widget.netProfit,
                          isPositive,
                          cardBgColor,
                        )
                      : AnimatedBuilder(
                          animation: _counterAnim,
                          builder: (context, _) {
                            _displayedProfit = _counterAnim.value;
                            return _buildAmountRow(
                              context,
                              _counterAnim.value,
                              isPositive,
                              cardBgColor,
                            );
                          },
                        ),
                  const SizedBox(height: AppSizes.spacing12),
                  // Animated change-percent pill
                  disable
                      ? _buildChangePill(context)
                      : AnimatedBuilder(
                          animation: _pillController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_pillSlide.value, 0),
                              child: Opacity(
                                opacity: _pillFade.value,
                                child: child,
                              ),
                            );
                          },
                          child: _buildChangePill(context),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(
    BuildContext context,
    int amount,
    bool isPositive,
    Color cardBgColor,
  ) {
    final formattedAmount = CurrencyFormatter.formatRupees(amount.abs())
        .replaceFirst('₹', '')
        .trim();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isPositive ? '₹' : '-₹',
          style: AppTextStyles.displayLarge(context).copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: AppSizes.spacing8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing16,
              vertical: AppSizes.spacing4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formattedAmount,
                style: AppTextStyles.displayLarge(context).copyWith(
                  color: cardBgColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChangePill(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing12,
        vertical: AppSizes.spacing4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.changePercent >= 0 ? Icons.trending_up : Icons.trending_down,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: AppSizes.spacing4),
          Text(
            AppLocalizations.of(context)!.changePercentVsLastMonth(
              '${widget.changePercent >= 0 ? '+' : ''}${widget.changePercent.toStringAsFixed(1)}',
            ),
            style: AppTextStyles.labelSmall(context).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCardsRow extends StatelessWidget {
  const StatCardsRow({
    super.key,
    required this.todayIncome,
    required this.todayExpense,
  });

  final int todayIncome;
  final int todayExpense;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: AppLocalizations.of(context)!.todaysIncome,
            amount: todayIncome,
            icon: Icons.arrow_downward,
            iconColor: AppColors.income,
            backgroundColor: AppColors.primaryLight,
            onTap: () => context.push(RouteNames.history),
            slideFromLeft: true,
            appearDelay: const Duration(milliseconds: 100),
          ),
        ),
        const SizedBox(width: AppSizes.spacing16),
        Expanded(
          child: StatCard(
            title: AppLocalizations.of(context)!.todaysExpense,
            amount: todayExpense,
            icon: Icons.arrow_upward,
            iconColor: AppColors.expense,
            backgroundColor: AppColors.errorLight,
            onTap: () => context.push(RouteNames.history),
            slideFromLeft: false,
            appearDelay: const Duration(milliseconds: 150),
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatefulWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
    this.slideFromLeft = true,
    this.appearDelay = Duration.zero,
  });

  final String title;
  final int amount;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;
  final bool slideFromLeft;
  final Duration appearDelay;

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _appearController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fade = _appearController.drive(
      Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Curves.easeOut),
      ),
    );
    final startOffset =
        widget.slideFromLeft ? const Offset(-0.18, 0) : const Offset(0.18, 0);
    _slide = _appearController.drive(
      Tween<Offset>(begin: startOffset, end: Offset.zero).chain(
        CurveTween(curve: Curves.easeOutCubic),
      ),
    );
    Future.delayed(widget.appearDelay, () {
      if (mounted) _appearController.forward();
    });
  }

  @override
  void dispose() {
    _appearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disable = MediaQuery.disableAnimationsOf(context);
    final card = InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(AppSizes.radius16),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.radius16),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: widget.backgroundColor,
                  child: Icon(widget.icon, size: 16, color: widget.iconColor),
                ),
                const SizedBox(width: AppSizes.spacing8),
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppTextStyles.labelLarge(context).copyWith(
                      color: widget.iconColor,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing12),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                CurrencyFormatter.formatRupees(widget.amount),
                style: AppTextStyles.titleLarge(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (disable) return card;
    return SlideTransition(
      position: _slide,
      child: FadeTransition(opacity: _fade, child: card),
    );
  }
}

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({
    super.key,
    required this.summaries,
    required this.activeTabIndex,
    required this.onTabChanged,
  });

  final List<ReportSummary> summaries;
  final int activeTabIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final List<double> values = summaries.map((s) {
      if (activeTabIndex == 0) return s.netProfit / 100.0;
      if (activeTabIndex == 1) return s.totalIncome / 100.0;
      return s.totalExpense / 100.0;
    }).toList();

    final double maxVal = values.fold(0.0, (p, v) => v > p ? v : p);
    final double minVal = values
        .fold(0.0, (p, v) => v < p ? v : p)
        .clamp(double.negativeInfinity, 0.0);
    final double yRange = (maxVal - minVal).clamp(100.0, double.infinity);

    return Semantics(
      label: AppLocalizations.of(context)!.chartAccessibilityLabel(
        '${activeTabIndex == 0 ? "net profit" : activeTabIndex == 1 ? "income" : "expense"} over the last six months.',
      ),
      child: Card(
        elevation: 0,
        color: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.outline.withValues(alpha: 0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.performanceTrend,
                style:
                    AppTextStyles.labelSmall(context, color: AppColors.primary),
              ),
              const SizedBox(height: AppSizes.spacing16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(AppSizes.spacing4),
                child: Row(
                  children: [
                    _buildTabButton(
                      context,
                      0,
                      AppLocalizations.of(context)!.netProfit,
                    ),
                    _buildTabButton(
                      context,
                      1,
                      AppLocalizations.of(context)!.income,
                    ),
                    _buildTabButton(
                      context,
                      2,
                      AppLocalizations.of(context)!.expense,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spacing24),
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    minY: minVal,
                    maxY: maxVal + yRange * 0.15,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => AppColors.onSurface,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '₹${_formatAmount(rod.toY)}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 48,
                          getTitlesWidget: (value, meta) {
                            if (value == 0 && minVal == 0) {
                              return const SizedBox();
                            }
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                '₹${_formatAmount(value)}',
                                style: AppTextStyles.labelSmall(context)
                                    .copyWith(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final int index = value.toInt();
                            if (index < 0 || index >= summaries.length) {
                              return const SizedBox();
                            }
                            final String label = DateFormat('MMM')
                                .format(summaries[index].month);
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                label,
                                maxLines: 1,
                                style: AppTextStyles.labelSmall(context)
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: yRange / 4,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: AppColors.outline.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.outline.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    barGroups: _buildBarGroups(context),
                  ),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAmount(double value) => formatChartAmount(value);

  Widget _buildTabButton(BuildContext context, int index, String title) {
    final bool isSelected = activeTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => onTabChanged(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall(
              context,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceMuted,
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(BuildContext context) {
    return List.generate(summaries.length, (index) {
      final summary = summaries[index];
      double value = 0;
      if (activeTabIndex == 0) {
        value = summary.netProfit / 100.0;
      } else if (activeTabIndex == 1) {
        value = summary.totalIncome / 100.0;
      } else {
        value = summary.totalExpense / 100.0;
      }

      final bool hasData = value != 0;
      final bool isCurrentMonth = index == summaries.length - 1;

      Color barColor;
      if (value >= 0) {
        barColor = isCurrentMonth
            ? AppColors.primary
            : AppColors.primary.withValues(alpha: 0.45);
      } else {
        barColor = AppColors.error;
      }

      final borderRadius = value >= 0
          ? const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            )
          : const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            );

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: hasData ? value : 0.5,
            color: hasData ? barColor : Colors.transparent,
            width: 28,
            borderRadius: borderRadius,
          ),
        ],
      );
    });
  }
}

class RecentEntriesSection extends ConsumerWidget {
  const RecentEntriesSection({
    super.key,
    required this.transactions,
    required this.categories,
    required this.hasNoTransactions,
  });

  final List<Transaction> transactions;
  final List<Category> categories;
  final bool hasNoTransactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.recentEntries,
              style:
                  AppTextStyles.labelSmall(context, color: AppColors.primary),
            ),
            TextButton(
              onPressed: () => context.push(RouteNames.history),
              child: Text(
                AppLocalizations.of(context)!.viewAll,
                style:
                    AppTextStyles.labelSmall(context, color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacing8),
        if (hasNoTransactions)
          _buildEmptyState(context)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSizes.spacing12),
            itemBuilder: (context, index) {
              final txn = transactions[index];
              final category = categories.firstWhere(
                (c) => c.id == txn.categoryId,
                orElse: () => Category(
                  id: 'unknown',
                  name: 'Unknown',
                  icon: 'receipt_long',
                  colorHex: '#607D8B',
                  type: txn.type,
                ),
              );

              return Dismissible(
                key: ValueKey(txn.id),
                direction: DismissDirection.endToStart,
                resizeDuration: Duration.zero,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: AppSizes.spacing24),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  HapticFeedback.lightImpact();
                  final repo = ref.read(transactionRepositoryProvider);
                  final result = await repo.softDeleteTransaction(txn.id);
                  return result.isRight();
                },
                onDismissed: (direction) async {
                  if (!context.mounted) return;
                  final repo = ref.read(transactionRepositoryProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.transactionDeleted,
                      ),
                      duration: const Duration(seconds: 5),
                      action: SnackBarAction(
                        label: AppLocalizations.of(context)!.undo,
                        onPressed: () async {
                          await repo.restoreTransaction(txn.id);
                        },
                      ),
                    ),
                  );
                },
                child: TransactionListTile(
                  transaction: txn,
                  category: category,
                  index: index,
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return _AnimatedEmptyState(
      message: AppLocalizations.of(context)!.noTransactionsYet,
      subMessage: AppLocalizations.of(context)!.addTxnsForReportSummary,
    );
  }
}

/// Empty-state widget shown when no transactions exist.
class _AnimatedEmptyState extends StatelessWidget {
  const _AnimatedEmptyState({
    required this.message,
    required this.subMessage,
  });
  final String message;
  final String subMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing32),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: AppColors.onSurfaceMuted,
          ),
          const SizedBox(height: AppSizes.spacing16),
          Text(
            message,
            style: AppTextStyles.bodyLarge(context),
          ),
          const SizedBox(height: AppSizes.spacing4),
          Text(
            subMessage,
            style: AppTextStyles.labelSmall(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spacing12),
          Text(
            'Tap + to log your first entry today →',
            style: AppTextStyles.labelSmall(context).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 22, color: AppColors.onSurfaceMuted),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: AppTextStyles.bodyLarge(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
