import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_names.dart';
import '../../security/presentation/app_lock_provider.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/firebase_providers.dart';
import '../../../l10n/app_localizations.dart';
import 'settings_view_model.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoadingSettings = true;
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _packageInfo = info);
  }

  Future<void> _loadSettings() async {
    if (mounted) setState(() => _isLoadingSettings = false);
  }

  void _showLanguagePicker() {
    final currentLang = ref.read(settingsViewModelProvider).language;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.spacing16),
              child: Text(
                AppLocalizations.of(context)!.selectLanguage,
                style: AppTextStyles.titleLarge(context).copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ),
            _langTile(ctx, LanguageCode.en, currentLang),
            _langTile(ctx, LanguageCode.hi, currentLang),
            _langTile(ctx, LanguageCode.mr, currentLang),
            _langTile(ctx, LanguageCode.ar, currentLang),
            _langTile(ctx, LanguageCode.sw, currentLang),
          ],
        ),
      ),
    );
  }

  Widget _langTile(BuildContext ctx, LanguageCode code, LanguageCode current) {
    return ListTile(
      title: Text(code.displayLabel),
      trailing: code == current
          ? const Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: () {
        Navigator.of(ctx).pop();
        ref.read(settingsViewModelProvider.notifier).updateLanguage(code);
      },
    );
  }

  void _showCountryPicker() {
    final current = ref.read(settingsViewModelProvider).country;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.spacing16),
              child: Text(
                AppLocalizations.of(context)!.selectCountry,
                style: AppTextStyles.titleLarge(context).copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ),
            ...SupportedRegion.all.map((region) {
              return ListTile(
                leading:
                    Text(region.flag, style: const TextStyle(fontSize: 24)),
                title: Text('${region.displayName} (${region.dialCode})'),
                trailing: region.currencyCode == current
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  Navigator.of(ctx).pop();
                  ref
                      .read(settingsViewModelProvider.notifier)
                      .updateCountry(region.currencyCode);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showFiscalYearPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.spacing16),
              child: Text(
                'Fiscal Year Start',
                style: AppTextStyles.titleLarge(context).copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ),
            _fiscalTile(ctx, FiscalYearStart.apr, 'April'),
            _fiscalTile(ctx, FiscalYearStart.jan, 'January'),
          ],
        ),
      ),
    );
  }

  Widget _fiscalTile(BuildContext ctx, FiscalYearStart value, String label) {
    return ListTile(
      title: Text(label),
      trailing: const Icon(Icons.check, color: AppColors.primary),
      onTap: () {
        Navigator.of(ctx).pop();
        final auth = ref.read(firebaseAuthProvider);
        final uid = auth.currentUser?.uid;
        if (uid != null) {
          ref.read(firestoreProvider).collection('users').doc(uid).update({
            'fiscalYearStart': value.firestoreValue,
          });
        }
      },
    );
  }

  Future<void> _handleDeleteAccount() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete your account?'),
        content: const Text(
          'Your data will be soft-deleted with a 30-day grace period. '
          'During this time, you can contact support to restore your account. '
          'After 30 days, all data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showConfirmDeleteDialog();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDeleteDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Type DELETE to confirm'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Type DELETE',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.trim() != 'DELETE') return;
              Navigator.of(ctx).pop();
              if (!mounted) return;
              await ref
                  .read(settingsViewModelProvider.notifier)
                  .initiateAccountDeletion();
              if (mounted) {
                context.go(RouteNames.login);
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Confirm Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsViewModelProvider);
    final auth = ref.watch(firebaseAuthProvider);
    final user = auth.currentUser;
    final phone = user?.phoneNumber ?? '';
    final maskedPhone = phone.length >= 10
        ? '+91 XXXXX ${phone.substring(phone.length - 4)}'
        : phone;

    if (_isLoadingSettings) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        children: [
          _buildSectionTitle('Account'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(maskedPhone),
                  subtitle: Row(
                    children: [
                      _planBadge(settings.plan),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacing24),
          _buildSectionTitle('Preferences'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.primary),
                  title: const Text('Language'),
                  subtitle: Text(settings.language.displayLabel),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showLanguagePicker,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.public, color: AppColors.primary),
                  title: const Text('Region'),
                  subtitle: Text(_countryLabel(settings.country)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showCountryPicker,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.calendar_month,
                    color: AppColors.primary,
                  ),
                  title: const Text('Fiscal Year Start'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showFiscalYearPicker,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacing24),
          _buildSectionTitle('SMS Capture'),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.sms, color: AppColors.primary),
              title: const Text('SMS Auto-Capture'),
              subtitle: const Text('Auto-log bank transaction alerts'),
              value: settings.smsEnabled,
              onChanged: (v) {
                ref
                    .read(settingsViewModelProvider.notifier)
                    .toggleSmsCapture(v);
              },
            ),
          ),
          const SizedBox(height: AppSizes.spacing24),
          _buildSectionTitle('Security'),
          _buildAppLockSection(),
          const SizedBox(height: AppSizes.spacing24),
          _buildSectionTitle('Support'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.replay, color: AppColors.primary),
                  title: const Text('Replay Onboarding Tutorial'),
                  subtitle: const Text(
                    'Reset onboarding tips and run the tour again',
                  ),
                  onTap: () async {
                    final authUid =
                        ref.read(firebaseAuthProvider).currentUser?.uid;
                    if (authUid != null) {
                      await ref
                          .read(firestoreProvider)
                          .collection('users')
                          .doc(authUid)
                          .update({'tutorialCompleted': false});
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Onboarding tutorial reset.'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.feedback, color: AppColors.primary),
                  title: const Text('Send Feedback'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(RouteNames.feedback),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(Icons.privacy_tip, color: AppColors.primary),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () =>
                      launchUrl(Uri.parse('https://pocketplus.in/privacy')),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(Icons.description, color: AppColors.primary),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () =>
                      launchUrl(Uri.parse('https://pocketplus.in/terms')),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star, color: AppColors.primary),
                  title: const Text('Rate PocketPlus on Play Store'),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () async {
                    await ref
                        .read(analyticsServiceProvider)
                        .logAppRated(trigger: 'settings');
                    await launchUrl(
                      Uri.parse(
                        'https://play.google.com/store/apps/details?id=in.pocketplus.app',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacing24),
          _buildSectionTitle('Data & Privacy'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download, color: AppColors.primary),
                  title: const Text('Export My Data'),
                  subtitle: const Text('Download all your data as JSON'),
                  trailing: settings.isExporting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: settings.isExporting
                      ? null
                      : () => ref
                          .read(settingsViewModelProvider.notifier)
                          .exportData(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(Icons.delete_forever, color: AppColors.error),
                  title: const Text('Delete Account'),
                  subtitle: const Text('Soft delete with 30-day grace period'),
                  textColor: AppColors.error,
                  onTap: settings.isDeleting ? null : _handleDeleteAccount,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacing24),
          _buildSectionTitle('App Info'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: AppColors.primary),
              title: const Text('App Version'),
              subtitle: Text(
                _packageInfo != null
                    ? '${_packageInfo!.version} (${_packageInfo!.buildNumber})'
                    : 'Loading...',
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacing32),
        ],
      ),
    );
  }

  String _countryLabel(String currencyCode) {
    final region = SupportedRegion.fromCurrencyCode(currencyCode);
    return '${region.displayName} (${region.dialCode})';
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacing8),
      child: Text(
        title,
        style: AppTextStyles.titleMedium(context),
      ),
    );
  }

  Widget _buildAppLockSection() {
    final lock = ref.watch(appLockControllerProvider);
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.lock_outline, color: AppColors.primary),
            title: const Text('App Lock'),
            subtitle: const Text('Require a PIN or biometric to open the app'),
            value: lock.isEnabled,
            onChanged: (enable) {
              if (enable) {
                context.push(RouteNames.pinSetup);
              } else {
                _confirmDisableAppLock();
              }
            },
          ),
          if (lock.isEnabled) ...[
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.pin_outlined, color: AppColors.primary),
              title: const Text('Change PIN'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RouteNames.pinSetup),
            ),
          ],
        ],
      ),
    );
  }

  /// Turning the lock off requires the current PIN (CLAUDE.md: the lock cannot
  /// be disabled without it).
  Future<void> _confirmDisableAppLock() async {
    final controller = TextEditingController();
    final pin = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter PIN to turn off App Lock'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 6,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Current PIN'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Turn off'),
          ),
        ],
      ),
    );
    if (pin == null || pin.isEmpty) return;

    final ok = await ref.read(appLockServiceProvider).disableLock(pin);
    if (!mounted) return;
    if (ok) {
      ref.read(appLockControllerProvider.notifier).markDisabled();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('App lock turned off.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect PIN.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Widget _planBadge(PlanType plan) {
    final label = switch (plan) {
      PlanType.free => 'FREE',
      PlanType.basic => 'BASIC',
      PlanType.pro => 'PRO',
    };
    final color = switch (plan) {
      PlanType.free => AppColors.onSurfaceMuted,
      PlanType.basic => AppColors.primary,
      PlanType.pro => Colors.amber,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall(context, color: color),
      ),
    );
  }
}
