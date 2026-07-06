import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/banner_ad_slot.dart';
import '../../onboarding/data/tutorial_steps_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Nav item data
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    this.tutorialKey,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final Key? tutorialKey;
}

final _navItems = [
  const _NavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: 'Home',
    route: RouteNames.home,
  ),
  _NavItem(
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart_rounded,
    label: 'Analytics',
    route: RouteNames.analytics,
    tutorialKey: TutorialKeys.analyticsTab,
  ),
  _NavItem(
    icon: Icons.description_outlined,
    activeIcon: Icons.description_rounded,
    label: 'Reports',
    route: RouteNames.reports,
    tutorialKey: TutorialKeys.reportsTab,
  ),
  const _NavItem(
    icon: Icons.account_balance_wallet_outlined,
    activeIcon: Icons.account_balance_wallet,
    label: 'Budgets',
    route: RouteNames.budgets,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// MainShell
// ─────────────────────────────────────────────────────────────────────────────
class MainShell extends ConsumerWidget {
  const MainShell({required this.child, super.key});

  final Widget child;

  int _getSelectedIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/analytics')) return 1;
    if (location.startsWith('/reports')) return 2;
    if (location.startsWith('/budgets')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String location = GoRouterState.of(context).matchedLocation;
    final int selectedIndex = _getSelectedIndex(location);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (selectedIndex == 0) {
          _onBackAtHome(context);
        } else {
          context.go(RouteNames.home);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(child: child),
            // Persistent banner ad pinned above the bottom nav — the app's
            // only revenue source. Renders nothing until/unless an ad loads.
            const BannerAdSlot(),
          ],
        ),
        bottomNavigationBar: _PremiumNavBar(
          selectedIndex: selectedIndex,
          onTap: (index) {
            HapticFeedback.selectionClick();
            switch (index) {
              case 0:
                context.go(RouteNames.home);
              case 1:
                context.go(RouteNames.analytics);
              case 2:
                context.go(RouteNames.reports);
              case 3:
                context.go(RouteNames.budgets);
            }
          },
        ),
      ),
    );
  }

  void _onBackAtHome(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              SystemNavigator.pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Premium Nav Bar — sliding pill indicator
// ─────────────────────────────────────────────────────────────────────────────
class _PremiumNavBar extends StatefulWidget {
  const _PremiumNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  State<_PremiumNavBar> createState() => _PremiumNavBarState();
}

class _PremiumNavBarState extends State<_PremiumNavBar>
    with TickerProviderStateMixin {
  late AnimationController _pillController;
  late Animation<double> _pillAnim;
  late List<AnimationController> _iconControllers;
  late List<Animation<double>> _iconScales;

  @override
  void initState() {
    super.initState();

    _pillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _pillAnim = _pillController.drive(
      Tween<double>(
        begin: widget.selectedIndex.toDouble(),
        end: widget.selectedIndex.toDouble(),
      ),
    );

    _iconControllers = List.generate(
      _navItems.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 380),
      ),
    );

    _iconScales = _iconControllers.map((c) {
      return c.drive(
        Tween<double>(begin: 1.0, end: 1.0).chain(
          CurveTween(curve: Curves.elasticOut),
        ),
      );
    }).toList();

    // Animate first selected icon on mount
    _triggerIconBounce(widget.selectedIndex);
  }

  @override
  void didUpdateWidget(_PremiumNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      // Slide the pill
      final from = oldWidget.selectedIndex.toDouble();
      final to = widget.selectedIndex.toDouble();
      _pillAnim = _pillController.drive(
        Tween<double>(begin: from, end: to).chain(
          CurveTween(curve: Curves.easeOutCubic),
        ),
      );
      _pillController.forward(from: 0.0);

      // Bounce the new icon
      _triggerIconBounce(widget.selectedIndex);
    }
  }

  void _triggerIconBounce(int index) {
    final c = _iconControllers[index];
    _iconScales[index] = c.drive(
      Tween<double>(begin: 0.9, end: 1.0).chain(
        CurveTween(curve: Curves.easeOut),
      ),
    );
    c.forward(from: 0.0);
  }

  @override
  void dispose() {
    _pillController.dispose();
    for (final c in _iconControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disable = MediaQuery.disableAnimationsOf(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          top: BorderSide(color: AppColors.outline, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / _navItems.length;

              const double pillHeight = 44;
              const double pillTop = (60 - pillHeight) / 2;
              final double pillWidth = itemWidth - 24;

              return Stack(
                children: [
                  // Sliding pill background
                  if (!disable)
                    AnimatedBuilder(
                      animation: _pillAnim,
                      builder: (context, _) {
                        final pillLeft = _pillAnim.value * itemWidth +
                            (itemWidth - pillWidth) / 2;
                        return Positioned(
                          top: pillTop,
                          left: pillLeft,
                          child: Container(
                            width: pillWidth,
                            height: pillHeight,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius:
                                  BorderRadius.circular(pillHeight / 2),
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Positioned(
                      top: pillTop,
                      left: widget.selectedIndex * itemWidth +
                          (itemWidth - pillWidth) / 2,
                      child: Container(
                        width: pillWidth,
                        height: pillHeight,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(pillHeight / 2),
                        ),
                      ),
                    ),

                  // Nav items
                  Row(
                    children: List.generate(_navItems.length, (index) {
                      final item = _navItems[index];
                      final isActive = widget.selectedIndex == index;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => widget.onTap(index),
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            key: item.tutorialKey,
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon with bounce
                                AnimatedBuilder(
                                  animation: disable
                                      ? const AlwaysStoppedAnimation(1.0)
                                      : _iconScales[index],
                                  builder: (context, _) {
                                    final scale = disable
                                        ? 1.0
                                        : _iconScales[index].value;
                                    return Transform.scale(
                                      scale: scale,
                                      child: Icon(
                                        isActive ? item.activeIcon : item.icon,
                                        size: 22,
                                        color: isActive
                                            ? AppColors.primary
                                            : AppColors.onSurfaceMuted,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 2),
                                // Label with animated opacity
                                AnimatedOpacity(
                                  opacity: isActive ? 1.0 : 0.55,
                                  duration: const Duration(milliseconds: 200),
                                  child: Text(
                                    item.label,
                                    style: AppTextStyles.labelSmall(
                                      context,
                                      color: isActive
                                          ? AppColors.primary
                                          : AppColors.onSurfaceMuted,
                                    ).copyWith(
                                      fontWeight: isActive
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
