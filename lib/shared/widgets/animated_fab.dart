import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../features/onboarding/data/tutorial_steps_provider.dart';

/// Premium animated FAB with:
/// • Idle: breathing pulse (scale 1.0 → 1.03, 2s loop)
/// • Press down: scale → 0.90 + icon rotates 45°
/// • Release: spring overshoot → 1.12 → settle at 1.0 (300ms)
/// • Haptic: mediumImpact on press down
class AnimatedFab extends StatefulWidget {
  const AnimatedFab({
    required this.onPressed,
    this.isTutorialTarget = false,
    super.key,
  });

  final VoidCallback onPressed;

  /// When true, this FAB carries the onboarding tutorial's GlobalKey so the
  /// tutorial overlay can highlight it. Only ONE FAB in the tree may set this
  /// (the Home screen's) — otherwise the shared GlobalKey appears twice and
  /// Flutter throws "Duplicate GlobalKey detected".
  final bool isTutorialTarget;

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with TickerProviderStateMixin {
  // Breathing idle pulse
  late AnimationController _breathController;
  late Animation<double> _breathScale;

  // Press choreography
  late AnimationController _pressController;
  late Animation<double> _pressScale;
  late Animation<double> _pressRotation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    // Idle breathing
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _breathScale = _breathController.drive(
      Tween<double>(begin: 1.0, end: 1.03).chain(
        CurveTween(curve: Curves.easeInOut),
      ),
    );

    // Press animation
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _pressScale = _pressController.drive(
      Tween<double>(begin: 1.0, end: 1.0),
    );

    _pressRotation = _pressController.drive(
      Tween<double>(begin: 0.0, end: 1.0),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (_isPressed) return;
    _isPressed = true;
    HapticFeedback.mediumImpact();

    // Pause breathing during press
    _breathController.stop();

    // Press-down: shrink + rotate
    _pressController.stop();
    _pressScale = _pressController.drive(
      Tween<double>(begin: 1.0, end: 0.90).chain(
        CurveTween(curve: Curves.easeInOut),
      ),
    );
    _pressRotation = _pressController.drive(
      Tween<double>(begin: 0.0, end: 0.125), // 45° / 360° = 0.125 turns
    );
    _pressController.forward(from: 0.0);
  }

  void _handleTapUp(TapUpDetails _) {
    _release();
  }

  void _handleTapCancel() {
    _release();
  }

  void _release() {
    if (!_isPressed) return;
    _isPressed = false;

    // Release: spring overshoot 0.90 → 1.12 → 1.0
    _pressController.stop();
    _pressScale = _pressController.drive(
      TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.90, end: 1.12)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 40,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.12, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 60,
        ),
      ]),
    );
    _pressRotation = _pressController.drive(
      Tween<double>(begin: 0.125, end: 0.0).chain(
        CurveTween(curve: Curves.easeOutCubic),
      ),
    );
    _pressController.forward(from: 0.0).then((_) {
      // Resume breathing after spring settles
      if (mounted) _breathController.repeat(reverse: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final disable = MediaQuery.disableAnimationsOf(context);

    return Builder(
      key: widget.isTutorialTarget ? TutorialKeys.addTxnFab : null,
      builder: (context) {
        if (disable) {
          return FloatingActionButton(
            backgroundColor: AppColors.primary,
            onPressed: widget.onPressed,
            child: const Icon(Icons.add_rounded, color: Colors.white),
          );
        }

        return GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: widget.onPressed,
          child: AnimatedBuilder(
            animation: Listenable.merge([_breathController, _pressController]),
            builder: (context, child) {
              final scale = _isPressed || _pressController.isAnimating
                  ? _pressScale.value
                  : _breathScale.value;
              final rotation = _pressRotation.value;

              return Transform.scale(
                scale: scale,
                child: FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  onPressed: null,
                  elevation: 4,
                  child: Transform.rotate(
                    angle: rotation * 2 * 3.14159265,
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
