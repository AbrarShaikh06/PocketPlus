import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import 'app_lock_provider.dart';
import 'widgets/pin_pad.dart';

/// Two-step PIN creation: enter a new PIN, then confirm it. On success the PIN
/// is stored, the lock is enabled, and (if available) biometric unlock is
/// offered. Pushed from Settings when the user turns App Lock on.
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

enum _Step { enter, confirm }

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  static const _pinLength = 4;
  _Step _step = _Step.enter;
  String _first = '';
  String _entry = '';
  bool _error = false;

  void _onDigit(String d) {
    if (_entry.length >= _pinLength) return;
    setState(() {
      _error = false;
      _entry += d;
    });
    if (_entry.length == _pinLength) _advance();
  }

  void _onBackspace() {
    if (_entry.isEmpty) return;
    setState(() {
      _error = false;
      _entry = _entry.substring(0, _entry.length - 1);
    });
  }

  Future<void> _advance() async {
    if (_step == _Step.enter) {
      setState(() {
        _first = _entry;
        _entry = '';
        _step = _Step.confirm;
      });
      return;
    }

    // Confirm step.
    if (_entry != _first) {
      setState(() {
        _error = true;
        _entry = '';
        _first = '';
        _step = _Step.enter;
      });
      return;
    }

    await ref.read(appLockServiceProvider).setPin(_first);

    // Offer biometric enrolment if the device supports it.
    final canBiometric =
        await ref.read(appLockServiceProvider).canUseBiometric();
    var biometric = false;
    if (canBiometric && mounted) {
      biometric = await _askEnableBiometric() ?? false;
      await ref.read(appLockServiceProvider).setBiometricEnabled(biometric);
    }

    ref
        .read(appLockControllerProvider.notifier)
        .markEnabled(biometric: biometric);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('App lock enabled.'),
          backgroundColor: AppColors.primary,
        ),
      );
      context.pop();
    }
  }

  Future<bool?> _askEnableBiometric() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enable biometric unlock?'),
        content: const Text(
          'Use your fingerprint or face to unlock PocketPlus instead of '
          'typing your PIN each time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isConfirm = _step == _Step.confirm;
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Cancel',
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('Set app PIN'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing32),
          child: Column(
            children: [
              const Spacer(),
              Text(
                isConfirm ? 'Confirm your PIN' : 'Choose a 4-digit PIN',
                style: AppTextStyles.titleMedium(context),
              ),
              const SizedBox(height: AppSizes.spacing8),
              SizedBox(
                height: 20,
                child: _error
                    ? Text(
                        "PINs didn't match. Start again.",
                        style: AppTextStyles.labelSmall(
                          context,
                          color: AppColors.error,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSizes.spacing16),
              PinDots(
                length: _pinLength,
                filled: _entry.length,
                hasError: _error,
              ),
              const Spacer(),
              PinPad(onDigit: _onDigit, onBackspace: _onBackspace),
              const SizedBox(height: AppSizes.spacing24),
            ],
          ),
        ),
      ),
    );
  }
}
