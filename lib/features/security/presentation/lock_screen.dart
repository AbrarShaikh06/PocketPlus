import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/pocketplus_loader.dart';
import 'app_lock_provider.dart';
import 'widgets/pin_pad.dart';

/// Full-screen lock shown by the router guard when the app is locked. Accepts a
/// 4–6 digit PIN and, when enabled, a biometric unlock. There is no dismiss —
/// the only way out is a correct PIN or biometric.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  static const _maxPinLength = 6;
  String _pin = '';
  bool _error = false;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    // Offer biometrics immediately when they're enabled.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(appLockControllerProvider).biometricEnabled) {
        _tryBiometric();
      }
    });
  }

  Future<void> _tryBiometric() async {
    if (_checking) return;
    setState(() => _checking = true);
    await ref.read(appLockControllerProvider.notifier).unlockWithBiometric();
    if (mounted) setState(() => _checking = false);
    // On success the router guard swaps this screen out automatically.
  }

  Future<void> _onDigit(String d) async {
    if (_pin.length >= _maxPinLength || _checking) return;
    setState(() {
      _error = false;
      _pin += d;
    });
    // A 4-digit PIN is the common case; auto-submit at 4 and again at 6.
    if (_pin.length == 4 || _pin.length == _maxPinLength) {
      await _submit();
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() {
      _error = false;
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  Future<void> _submit() async {
    setState(() => _checking = true);
    final ok =
        await ref.read(appLockControllerProvider.notifier).unlockWithPin(_pin);
    if (!mounted) return;
    setState(() {
      _checking = false;
      if (!ok) {
        _error = true;
        _pin = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final biometricEnabled =
        ref.watch(appLockControllerProvider).biometricEnabled;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing32),
          child: Column(
            children: [
              const Spacer(),
              const PocketPlusLoader(size: 56, color: AppColors.primary),
              const SizedBox(height: AppSizes.spacing24),
              Text(
                'Enter your PIN',
                style: AppTextStyles.titleMedium(context),
              ),
              const SizedBox(height: AppSizes.spacing8),
              SizedBox(
                height: 20,
                child: _error
                    ? Text(
                        'Incorrect PIN. Try again.',
                        style: AppTextStyles.labelSmall(
                          context,
                          color: AppColors.error,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSizes.spacing16),
              PinDots(
                length: _pin.length <= 4 ? 4 : _maxPinLength,
                filled: _pin.length,
                hasError: _error,
              ),
              const Spacer(),
              PinPad(
                onDigit: _onDigit,
                onBackspace: _onBackspace,
                onBiometric: biometricEnabled ? _tryBiometric : null,
              ),
              const SizedBox(height: AppSizes.spacing24),
            ],
          ),
        ),
      ),
    );
  }
}
