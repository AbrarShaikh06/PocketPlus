import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:pocket_plus/core/errors/error_localizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';
import '../../../core/router/route_names.dart';
import 'auth_view_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isFormValid = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _usernameController.text.trim().isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Future<void> _handleLogin() async {
    final viewModel = ref.read(authViewModelProvider.notifier);
    await viewModel.signInWithUsername(
      username: _usernameController.text,
      password: _passwordController.text,
    );
  }

  Future<void> _handleForgotPassword() async {
    final username = await showDialog<String>(
      context: context,
      builder: (ctx) => _ForgotPasswordDialog(),
    );
    if (username == null || !mounted) return;

    final viewModel = ref.read(authViewModelProvider.notifier);
    final error = await viewModel.sendPasswordResetEmail(username);

    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.error,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.passwordResetSent),
          backgroundColor: AppColors.income,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
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
                      vertical: AppSizes.spacing16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSizes.spacing32),

                        // Brand section
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppSizes.spacing20),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.trending_up_rounded,
                                  color: Colors.white,
                                  size: 44,
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacing16),
                              Text(
                                'PocketPlus',
                                style: AppTextStyles.displayLarge(context)
                                    .copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacing4),
                              Text(
                                l.appTagline,
                                style:
                                    AppTextStyles.bodyMedium(context).copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSizes.spacing4),
                              Text(
                                l.appSubtitle,
                                style:
                                    AppTextStyles.bodyMedium(context).copyWith(
                                  color: AppColors.onSurfaceMuted,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSizes.spacing32),

                        // Login card
                        AppCard(
                          padding: const EdgeInsets.all(AppSizes.spacing20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l.loginTitle,
                                style:
                                    AppTextStyles.titleMedium(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacing4),
                              Text(
                                l.loginInstruction,
                                style:
                                    AppTextStyles.bodyMedium(context).copyWith(
                                  color: AppColors.onSurfaceMuted,
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacing24),

                              AppTextField(
                                label: l.usernameLabel,
                                hint: l.usernameHint,
                                controller: _usernameController,
                                onChanged: (_) => _validateForm(),
                                errorText:
                                    localizeError(context, authState.errorCode),
                                prefixIcon: const Icon(
                                  Icons.person_outline,
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
                                onChanged: (_) => _validateForm(),
                                errorText: null,
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
                                textInputAction: TextInputAction.done,
                              ),

                              const SizedBox(height: AppSizes.spacing4),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: authState.isLoading
                                      ? null
                                      : _handleForgotPassword,
                                  child: Text(
                                    l.forgotPassword,
                                    style: AppTextStyles.labelSmall(context)
                                        .copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: AppSizes.spacing12),

                              AppButton(
                                label: l.loginButton,
                                onPressed: _isFormValid && !authState.isLoading
                                    ? _handleLogin
                                    : null,
                                isLoading: authState.isLoading,
                              ),

                              const SizedBox(height: AppSizes.spacing12),

                              // Google sign-in
                              AppButton(
                                label: l.signInWithGoogle,
                                variant: AppButtonVariant.outline,
                                iconWidget: const GoogleIcon(),
                                onPressed: authState.isLoading
                                    ? null
                                    : () => ref
                                        .read(authViewModelProvider.notifier)
                                        .signInWithGoogle(),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Sign up link
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.spacing8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l.noAccount,
                                style:
                                    AppTextStyles.bodyMedium(context).copyWith(
                                  color: AppColors.onSurfaceMuted,
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    context.push(RouteNames.signup),
                                child: Text(
                                  l.signUpLink,
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

                        // Trust section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spacing8,
                          ),
                          child: Column(
                            children: [
                              Text(
                                l.agreeTerms,
                                style:
                                    AppTextStyles.labelSmall(context).copyWith(
                                  color: AppColors.onSurfaceMuted,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSizes.spacing16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.spacing16,
                                  vertical: AppSizes.spacing12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.spacing12),
                                  border: Border.all(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.security_rounded,
                                      color: AppColors.primary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: AppSizes.spacing8),
                                    Flexible(
                                      child: Text(
                                        l.secureApp,
                                        style: AppTextStyles.labelSmall(context)
                                            .copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacing16),
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

class _ForgotPasswordDialog extends StatefulWidget {
  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.forgotPasswordTitle,
        style: AppTextStyles.titleMedium(context),
      ),
      content: AppTextField(
        label: AppLocalizations.of(context)!.usernameLabel,
        hint: AppLocalizations.of(context)!.usernameHint,
        controller: _controller,
        prefixIcon: const Icon(
          Icons.person_outline,
          color: AppColors.onSurfaceMuted,
          size: 20,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: AppTextStyles.bodyMedium(context),
          ),
        ),
        AppButton(
          label: AppLocalizations.of(context)!.sendResetLink,
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
        ),
      ],
    );
  }
}
