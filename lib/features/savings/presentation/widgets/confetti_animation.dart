import 'dart:math';
import 'package:flutter/material.dart';

enum _Shape { square, circle, ribbon }

class _Particle {
  _Particle({
    required this.color,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.rotation,
    required this.spin,
    required this.shape,
  });

  final Color color;
  double x; // fraction of screen width
  double y; // fraction of screen height
  double vx; // velocity x, fraction of screen / second
  double vy; // velocity y, fraction of screen / second (negative = up)
  final double size;
  double rotation; // radians
  final double spin; // radians / second
  final _Shape shape;
  double opacity = 1.0;
}

/// Burst confetti launched from two side cannons + a centre shower.
/// Place this as the topmost child in a Stack so it renders over everything.
///
/// Physics are integrated against wall-clock time (not frame count), so the
/// burst looks identical on 60 Hz and 120 Hz displays. Honours the platform
/// "reduce motion" accessibility setting by rendering nothing.
class ConfettiAnimation extends StatefulWidget {
  const ConfettiAnimation({required this.isTriggered, super.key});
  final bool isTriggered;

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final _rng = Random();
  final _particles = <_Particle>[];

  // Wall-clock integration state.
  Duration _prevElapsed = Duration.zero;

  // Physics constants, expressed per-second so they are frame-rate independent.
  static const double _kGravity = 0.72; // fraction of screen / second^2
  static const double _kDragPerFrame = 0.992; // reference drag at 60 fps

  // High-contrast palette for the dark-green celebration background.
  static const _palette = [
    Color(0xFFFFD700), // gold
    Color(0xFFFFEB3B), // yellow
    Color(0xFFFF6B35), // orange
    Color(0xFFFF1493), // deep pink
    Color(0xFFFFFFFF), // white
    Color(0xFF40E0D0), // turquoise
    Color(0xFFFF9100), // amber
    Color(0xFFE040FB), // purple
    Color(0xFFFF4081), // hot pink
    Color(0xFF80D8FF), // light blue
    Color(0xFFFF4500), // red-orange
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )
      ..addListener(_tick)
      ..addStatusListener(_onStatus);
    if (widget.isTriggered) _fire();
  }

  @override
  void didUpdateWidget(ConfettiAnimation old) {
    super.didUpdateWidget(old);
    if (widget.isTriggered && !old.isTriggered) _fire();
  }

  void _fire() {
    // Respect the OS "reduce motion" setting — no burst at all.
    final reduceMotion = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    if (reduceMotion) return;

    _particles.clear();
    _prevElapsed = Duration.zero;

    // Left cannon — fires to the right and upward.
    _cannon(
      ox: 0.15,
      oy: 0.06,
      n: 65,
      vxMin: 0.12,
      vxMax: 0.36,
      vyMin: -0.78,
      vyMax: -0.30,
    );
    // Right cannon — fires to the left and upward.
    _cannon(
      ox: 0.85,
      oy: 0.06,
      n: 65,
      vxMin: -0.36,
      vxMax: -0.12,
      vyMin: -0.78,
      vyMax: -0.30,
    );
    // Centre shower — fans out in both directions.
    _cannon(
      ox: 0.50,
      oy: 0.04,
      n: 70,
      vxMin: -0.30,
      vxMax: 0.30,
      vyMin: -0.96,
      vyMax: -0.42,
    );

    // Rebuild once so build() swaps in the CustomPaint; per-frame repaints are
    // then driven by the controller (no setState in the hot path).
    if (mounted) setState(() {});
    _ctrl.forward(from: 0);
  }

  void _cannon({
    required double ox,
    required double oy,
    required int n,
    required double vxMin,
    required double vxMax,
    required double vyMin,
    required double vyMax,
  }) {
    const shapes = _Shape.values;
    for (int i = 0; i < n; i++) {
      _particles.add(
        _Particle(
          color: _palette[_rng.nextInt(_palette.length)],
          x: ox + (_rng.nextDouble() - 0.5) * 0.04,
          y: oy,
          vx: vxMin + _rng.nextDouble() * (vxMax - vxMin),
          vy: vyMin + _rng.nextDouble() * (vyMax - vyMin),
          size: _rng.nextDouble() * 9.0 + 5.0,
          rotation: _rng.nextDouble() * 2 * pi,
          spin: (_rng.nextDouble() - 0.5) * 18.0, // radians / second
          shape: shapes[_rng.nextInt(shapes.length)],
        ),
      );
    }
  }

  void _tick() {
    final elapsed = _ctrl.lastElapsedDuration ?? Duration.zero;
    // Seconds since the previous tick; clamp to absorb stalls / first frame.
    final dt = ((elapsed - _prevElapsed).inMicroseconds / 1e6).clamp(0.0, 0.05);
    _prevElapsed = elapsed;

    // Frame-rate-independent drag: 0.992-per-frame-at-60fps over dt seconds.
    final drag = pow(_kDragPerFrame, dt * 60).toDouble();
    final t = _ctrl.value;

    for (final p in _particles) {
      p.vy += _kGravity * dt;
      p.vx *= drag;
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.rotation += p.spin * dt;
      // Smooth fade-out over the last 30% of the timeline.
      p.opacity = t < 0.70 ? 1.0 : ((1.0 - t) / 0.30).clamp(0.0, 1.0);
    }
    // No setState here — the painter repaints via `repaint: _ctrl`.
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      setState(_particles.clear);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_particles.isEmpty) return const SizedBox.shrink();
    return Positioned.fill(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _ConfettiPainter(_particles, repaint: _ctrl),
          ),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter(this.particles, {required Listenable repaint})
      : super(repaint: repaint);

  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size sz) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      if (p.opacity <= 0) continue;
      final py = p.y * sz.height;
      if (py < -40 || py > sz.height + 40) continue;

      final px = (p.x * sz.width).clamp(-40.0, sz.width + 40.0);
      paint.color = p.color.withValues(alpha: p.opacity);

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rotation);

      switch (p.shape) {
        case _Shape.square:
          canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size),
            paint,
          );
        case _Shape.circle:
          canvas.drawCircle(Offset.zero, p.size * 0.5, paint);
        case _Shape.ribbon:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: p.size * 0.35,
                height: p.size * 2.0,
              ),
              const Radius.circular(2),
            ),
            paint,
          );
      }

      canvas.restore();
    }
  }

  // particles mutate in place each tick, so always repaint while animating.
  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => true;
}
