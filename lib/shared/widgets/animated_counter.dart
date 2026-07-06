import 'package:flutter/material.dart';

import '../../core/utils/currency_formatter.dart';

/// Displays a monetary amount and morphs gently when the value changes.
///
/// [value] is the amount in the smallest unit (paise) — formatting is
/// paise-accurate via [CurrencyFormatter]. Money is precise and never flashy:
/// there is no count-up-from-zero on first paint; only a calm tween between the
/// previous and the new value when it actually changes.
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    required this.value,
    required this.style,
    super.key,
    this.duration = const Duration(milliseconds: 450),
    this.prefix = '',
    this.suffix = '',
  });

  /// Amount in the smallest currency unit (paise).
  final int value;
  final TextStyle style;
  final Duration duration;
  final String prefix;
  final String suffix;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;
  late int _from;
  late int _to;

  @override
  void initState() {
    super.initState();
    // Start already settled on the real value — no slot-machine intro.
    _from = widget.value;
    _to = widget.value;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _anim = _controller.drive(
      Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOutQuart)),
    );
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _from = _to;
      _to = widget.value;
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disable = MediaQuery.disableAnimationsOf(context);

    if (disable) {
      return Text(
        '${widget.prefix}${_format(_to)}${widget.suffix}',
        style: widget.style,
      );
    }

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        final current = _from + ((_to - _from) * _anim.value).round();
        return Text(
          '${widget.prefix}${_format(current)}${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }

  String _format(int paise) => CurrencyFormatter.format(paise, symbol: '');
}

/// Displays a monetary amount and crossfades between values when it changes.
///
/// [value] is the amount in the smallest unit (paise). The transition is a
/// quiet crossfade — direction-agnostic, no rolling digits.
class AnimatedDigitFlip extends StatelessWidget {
  const AnimatedDigitFlip({
    required this.value,
    required this.style,
    super.key,
  });

  /// Amount in the smallest currency unit (paise).
  final int value;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final textStr = CurrencyFormatter.format(value, symbol: '');

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOutQuart,
      switchOutCurve: Curves.easeOutQuart,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Text(
        textStr,
        key: ValueKey('$value-$textStr'),
        style: style,
      ),
    );
  }
}
