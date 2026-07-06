import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:pocket_plus/core/errors/error_localizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';
import 'auth_view_model.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _isCheckingUsername = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateUsername(String value) {
    final vm = ref.read(authViewModelProvider.notifier);
    if (value.isEmpty) {
      setState(() => _usernameError = null);
      return;
    }
    if (!vm.isValidUsername(value)) {
      setState(() {
        _usernameError =
            'Username must be 3-30 characters, start with a letter, and use only letters, numbers, underscores, and dots.';
      });
      return;
    }
    setState(() => _usernameError = null);
  }

  Future<void> _checkUsernameAvailability() async {
    final value = _usernameController.text.trim();
    if (value.isEmpty || _usernameError != null) return;
    setState(() => _isCheckingUsername = true);
    final taken = await ref
        .read(authViewModelProvider.notifier)
        .checkUsernameAvailability(value);
    if (mounted) {
      setState(() {
        _isCheckingUsername = false;
        _usernameError =
            taken != null ? 'This username is already taken.' : null;
      });
    }
  }

  void _validateEmail(String value) {
    final vm = ref.read(authViewModelProvider.notifier);
    if (value.isEmpty) {
      setState(() => _emailError = null);
      return;
    }
    if (!vm.isValidEmail(value)) {
      setState(() => _emailError = 'Enter a valid email address.');
    } else {
      setState(() => _emailError = null);
    }
  }

  void _validatePassword(String value) {
    final vm = ref.read(authViewModelProvider.notifier);
    if (value.isEmpty) {
      setState(() => _passwordError = null);
      return;
    }
    if (!vm.isStrongPassword(value)) {
      setState(() {
        _passwordError =
            'Password must be at least 8 characters with uppercase, lowercase, and a number.';
      });
    } else {
      setState(() => _passwordError = null);
    }
    _validateConfirmPassword(_confirmPasswordController.text);
  }

  void _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      setState(() => _confirmPasswordError = null);
      return;
    }
    if (value != _passwordController.text) {
      setState(() => _confirmPasswordError = 'Passwords do not match.');
    } else {
      setState(() => _confirmPasswordError = null);
    }
  }

  bool get _isFormValid {
    return _usernameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _usernameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  Future<void> _handleSignup() async {
    final viewModel = ref.read(authViewModelProvider.notifier);
    await viewModel.signUp(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Go back',
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacing24,
                      vertical: AppSizes.spacing8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l.createAccount,
                          style: AppTextStyles.displayLarge(context),
                        ),
                        const SizedBox(height: AppSizes.spacing4),
                        Text(
                          l.createAccountSubtitle,
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: AppColors.onSurfaceMuted,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacing24),

                        // Signup form card
                        AppCard(
                          padding: const EdgeInsets.all(AppSizes.spacing20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AppTextField(
                                label: l.usernameLabel,
                                hint: l.usernameHint,
                                controller: _usernameController,
                                onChanged: _validateUsername,
                                onEditingComplete: _checkUsernameAvailability,
                                errorText: _usernameError,
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: AppColors.onSurfaceMuted,
                                  size: 20,
                                ),
                                suffixIcon: _isCheckingUsername
                                    ? const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      )
                                    : null,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: AppSizes.spacing16),
                              AppTextField(
                                label: l.emailAddress,
                                hint: l.emailHint,
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                onChanged: _validateEmail,
                                errorText: _emailError,
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: AppColors.onSurfaceMuted,
                                  size: 20,
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: AppSizes.spacing16),
                              AppTextField(
                                label: l.passwordLabel,
                                hint: l.passwordHint,
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                onChanged: _validatePassword,
                                errorText: _passwordError,
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.onSurfaceMuted,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.onSurfaceMuted,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: AppSizes.spacing16),
                              AppTextField(
                                label: l.confirmPasswordLabel,
                                hint: l.confirmPasswordHint,
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                onChanged: _validateConfirmPassword,
                                errorText: _confirmPasswordError,
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.onSurfaceMuted,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.onSurfaceMuted,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                textInputAction: TextInputAction.done,
                              ),
                              if (authState.errorCode != null) ...[
                                const SizedBox(height: AppSizes.spacing12),
                                Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    localizeError(context, authState.errorCode),
                                    style: AppTextStyles.bodyMedium(context)
                                        .copyWith(
                                      color: AppColors.error,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                              const SizedBox(height: AppSizes.spacing20),
                              AppButton(
                                label: l.createAccountButton,
                                onPressed: _isFormValid && !authState.isLoading
                                    ? _handleSignup
                                    : null,
                                isLoading: authState.isLoading,
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Login link
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.spacing16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l.haveAccount,
                                style:
                                    AppTextStyles.bodyMedium(context).copyWith(
                                  color: AppColors.onSurfaceMuted,
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.pop(),
                                child: Text(
                                  l.loginLink,
                                  style: AppTextStyles.labelSmall(context)
                                      .copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
