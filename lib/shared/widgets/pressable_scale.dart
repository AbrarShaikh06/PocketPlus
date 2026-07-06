import 'package:flutter/material.dart';

/// Animated press feedback respecting [MediaQuery.disableAnimations].
/// Press: scale 1.0 → [pressedScale], 80ms easeOut
/// Release: ease-out-quart settle back to 1.0 (calm, no overshoot)
class PressableScale extends StatefulWidget {
  const PressableScale({
    required this.child,
    required this.onTap,
    this.pressedScale = 0.96,
    this.duration = const Duration(milliseconds: 80),
    this.enabled = true,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final Duration duration;
  final bool enabled;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = _controller.drive(Tween<double>(begin: 1.0, end: 1.0));
  }

  void _setPressed(bool value) {
    if (!widget.enabled || widget.onTap == null) return;
    if (_pressed == value) return;
    _pressed = value;

    final disable = MediaQuery.disableAnimationsOf(context);

    if (value) {
      _controller.duration = disable ? Duration.zero : widget.duration;
      _scaleAnim = _controller.drive(
        Tween<double>(begin: _controller.value, end: widget.pressedScale)
            .chain(CurveTween(curve: Curves.easeOutQuart)),
      );
      _controller.forward();
    } else {
      _controller.duration =
          disable ? Duration.zero : const Duration(milliseconds: 220);
      _scaleAnim = _controller.drive(
        Tween<double>(begin: _controller.value, end: 1.0).chain(
          CurveTween(curve: Curves.easeOutQuart),
        ),
      );
      _controller.forward(from: 0.0);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () {
        if (_pressed) _setPressed(false);
      },
      onTap: widget.enabled ? widget.onTap : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) {
          final scale = disableAnimations ? 1.0 : _scaleAnim.value;
          if (scale == 1.0) return child!;
          return Transform.scale(scale: scale, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
