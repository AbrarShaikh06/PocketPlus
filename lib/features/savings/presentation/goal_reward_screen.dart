import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/router/route_names.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import 'savings_providers.dart';
import 'widgets/confetti_animation.dart';
import '../domain/savings_goal.dart';

class GoalRewardScreen extends ConsumerStatefulWidget {
  const GoalRewardScreen({required this.goalId, super.key});

  final String goalId;

  @override
  ConsumerState<GoalRewardScreen> createState() => _GoalRewardScreenState();
}

class _GoalRewardScreenState extends ConsumerState<GoalRewardScreen>
    with TickerProviderStateMixin {
  // Trophy bounce-in (runs once, then hands off to pulse)
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  // Trophy gentle idle pulse (starts after bounce completes)
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Content slide-up + fade (delayed slightly after bounce starts)
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Honour the OS "reduce motion" setting: snap to final state, no haptic.
  late final bool _reduceMotion = WidgetsBinding
      .instance.platformDispatcher.accessibilityFeatures.disableAnimations;

  @override
  void initState() {
    super.initState();

    // ── Trophy bounce entrance ─────────────────────────────────────────
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    // Start the pulse only after the bounce settles
    _bounceController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted && !_reduceMotion) {
        _pulseController.repeat(reverse: true);
      }
    });

    // ── Trophy idle pulse ──────────────────────────────────────────────
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // begin: 1.0 so the trophy rests at full size between bounce and pulse
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.07).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // ── Content slide-up + fade ────────────────────────────────────────
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _slideAnimation = Tween<double>(begin: 55.0, end: 0.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );

    if (_reduceMotion) {
      // Skip all motion + haptic; present the final composed state instantly.
      _bounceController.value = 1.0;
      _slideController.value = 1.0;
      return;
    }

    HapticFeedback.heavyImpact();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bounceController.forward();
      // Content slides in shortly after the trophy starts bouncing
      Future.delayed(const Duration(milliseconds: 380), () {
        if (mounted) _slideController.forward();
      });
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String _getCategoryEmoji(SavingsCategory category) {
    switch (category) {
      case SavingsCategory.CAR:
        return '🚗';
      case SavingsCategory.HOUSE:
        return '🏠';
      case SavingsCategory.EDUCATION:
        return '📚';
      case SavingsCategory.BUSINESS:
        return '🏪';
      case SavingsCategory.TRAVEL:
        return '✈️';
      case SavingsCategory.OTHER:
        return '⭐';
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalsStream = ref.watch(savingsGoalsStreamProvider);

    return goalsStream.when(
      data: (goals) {
        final goal = goals.cast<SavingsGoal?>().firstWhere(
              (g) => g?.id == widget.goalId,
              orElse: () => null,
            );

        if (goal == null) {
          return Scaffold(
            backgroundColor: AppColors.primary,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: AppSizes.spacing16),
                  Text(
                    AppLocalizations.of(context)!.dreamAchieved,
                    style:
                        AppTextStyles.titleLarge(context, color: Colors.white),
                  ),
                  const SizedBox(height: AppSizes.spacing32),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacing24,
                    ),
                    child: AppButton(
                      label: AppLocalizations.of(context)!.viewMyGoals,
                      onPressed: () => context.go(RouteNames.savings),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return _buildRewardContent(context, goal);
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🎉', style: TextStyle(fontSize: 72)),
              SizedBox(height: AppSizes.spacing16),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: AppButton(
            label: AppLocalizations.of(context)!.goBack,
            onPressed: () => context.go(RouteNames.savings),
          ),
        ),
      ),
    );
  }

  Widget _buildRewardContent(BuildContext context, SavingsGoal goal) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Background gradient ───────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D631B),
                  Color(0xFF094d14),
                  Color(0xFF063610),
                ],
              ),
            ),
          ),

          // ── Radial glow behind trophy ────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    Colors.white.withValues(alpha: 0.13),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Main scrollable content ──────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: child,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing24,
                    vertical: AppSizes.spacing32,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSizes.spacing32),

                      // ── Bouncing trophy with idle pulse ────────────
                      AnimatedBuilder(
                        animation: Listenable.merge(
                          [_bounceController, _pulseController],
                        ),
                        builder: (context, child) {
                          final scale =
                              _bounceAnimation.value * _pulseAnimation.value;
                          return Transform.scale(
                            scale: scale.clamp(0.0, 2.0),
                            child: child,
                          );
                        },
                        child: const Text(
                          '🏆',
                          style: TextStyle(fontSize: 96),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing16),

                      // Goal category emoji
                      Text(
                        _getCategoryEmoji(goal.category),
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: AppSizes.spacing24),

                      // Congratulations headline
                      Text(
                        AppLocalizations.of(context)!.youDidIt,
                        style: AppTextStyles.displayLarge(
                          context,
                          color: Colors.white,
                        ).copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.spacing12),

                      Text(
                        goal.name,
                        style: AppTextStyles.titleLarge(
                          context,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSizes.spacing32),

                      // ── Achievement stats card ─────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSizes.spacing24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22),
                          ),
                        ),
                        child: Column(
                          children: [
                            _StatRow(
                              icon: Icons.savings_rounded,
                              label: AppLocalizations.of(context)!.amountSaved,
                              value: CurrencyFormatter.formatRupees(
                                goal.savedAmount,
                              ),
                            ),
                            const SizedBox(height: AppSizes.spacing16),
                            Divider(
                              color: Colors.white.withValues(alpha: 0.2),
                              height: 1,
                            ),
                            const SizedBox(height: AppSizes.spacing16),
                            _StatRow(
                              icon: Icons.calendar_today_rounded,
                              label: AppLocalizations.of(context)!.goalCreated,
                              value:
                                  '${goal.createdAt.day}/${goal.createdAt.month}/${goal.createdAt.year}',
                            ),
                            if (goal.achievedAt != null) ...[
                              const SizedBox(height: AppSizes.spacing16),
                              Divider(
                                color: Colors.white.withValues(alpha: 0.2),
                                height: 1,
                              ),
                              const SizedBox(height: AppSizes.spacing16),
                              _StatRow(
                                icon: Icons.emoji_events_rounded,
                                label: AppLocalizations.of(context)!.achievedOn,
                                value:
                                    '${goal.achievedAt!.day}/${goal.achievedAt!.month}/${goal.achievedAt!.year}',
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing12),

                      Text(
                        AppLocalizations.of(context)!.yourDisciplineMsg,
                        style: AppTextStyles.bodyMedium(
                          context,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.spacing48),

                      // ── CTA buttons ────────────────────────────────
                      _GlassButton(
                        label: AppLocalizations.of(context)!.startANewDream,
                        onPressed: () => context.go(RouteNames.savingsNew),
                        isPrimary: true,
                      ),
                      const SizedBox(height: AppSizes.spacing12),
                      _GlassButton(
                        label: AppLocalizations.of(context)!.viewMyGoals,
                        onPressed: () => context.go(RouteNames.savings),
                        isPrimary: false,
                      ),
                      const SizedBox(height: AppSizes.spacing32),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Confetti LAST so it renders on top of everything ─────────
          // Fires on build; the widget itself also no-ops under reduce-motion.
          ConfettiAnimation(isTriggered: !_reduceMotion),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 20),
        const SizedBox(width: AppSizes.spacing12),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium(
              context,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge(context, color: Colors.white)
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.label,
    required this.onPressed,
    required this.isPrimary,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing16),
            decoration: BoxDecoration(
              color: isPrimary
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: isPrimary ? 0.0 : 0.3),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: AppTextStyles.labelLarge(
                  context,
                  color: isPrimary ? AppColors.primary : Colors.white,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
