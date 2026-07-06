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
                AppLocalizations.of(context)!.fiscalYearStart,
                style: AppTextStyles.titleLarge(context).copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ),
            _fiscalTile(
              ctx,
              FiscalYearStart.apr,
              AppLocalizations.of(context)!.monthApril,
            ),
            _fiscalTile(
              ctx,
              FiscalYearStart.jan,
              AppLocalizations.of(context)!.monthJanuary,
            ),
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
    final l = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteAccountTitle),
        content: Text(l.deleteAccountBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showConfirmDeleteDialog();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l.continueAction),
          ),
        ],
      ),
    );
  }

  void _showConfirmDeleteDialog() {
    final l = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.typeDeleteToConfirm),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l.typeDeleteHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.cancel),
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
            child: Text(l.confirmDelete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
        title: Text(l.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        children: [
          _buildSectionTitle(l.sectionAccount),
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
          _buildSectionTitle(l.sectionPreferences),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.primary),
                  title: Text(l.language),
                  subtitle: Text(settings.language.displayLabel),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showLanguagePicker,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.public, color: AppColors.primary),
                  title: Text(l.region),
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
                  title: Text(l.fiscalYearStart),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showFiscalYearPicker,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacing24),
          _buildSectionTitle(l.sectionSmsCapture),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.sms, color: AppColors.primary),
              title: Text(l.smsAutoCapture),
              subtitle: Text(l.smsAutoCaptureSubtitle),
              value: settings.smsEnabled,
              onChanged: (v) {
                ref
                    .read(settingsViewModelProvider.notifier)
                    .toggleSmsCapture(v);
              },
            ),
          ),
          const SizedBox(height: AppSizes.spacing24),
          _buildSectionTitle(l.security),
          _buildAppLockSection(),
          const SizedBox(height: AppSizes.spacing24),
          _buildSectionTitle(l.sectionSupport),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.replay, color: AppColors.primary),
                  title: Text(l.replayTutorial),
                  subtitle: Text(l.replayTutorialSubtitle),
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
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!
                                  .onboardingTutorialReset,
                            ),
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
                  title: Text(l.sendFeedback),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(RouteNames.feedback),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(Icons.privacy_tip, color: AppColors.primary),
                  title: Text(l.privacyPolicy),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () =>
                      launchUrl(Uri.parse('https://pocketplus.in/privacy')),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(Icons.description, color: AppColors.primary),
                  title: Text(l.termsOfService),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () =>
                      launchUrl(Uri.parse('https://pocketplus.in/terms')),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star, color: AppColors.primary),
                  title: Text(l.rateOnPlayStore),
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
          _buildSectionTitle(l.sectionDataPrivacy),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download, color: AppColors.primary),
                  title: Text(l.exportMyData),
                  subtitle: Text(l.exportMyDataSubtitle),
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
                  title: Text(l.deleteAccount),
                  subtitle: Text(l.deleteAccountSubtitle),
                  textColor: AppColors.error,
                  onTap: settings.isDeleting ? null : _handleDeleteAccount,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacing24),
          _buildSectionTitle(l.sectionAppInfo),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: AppColors.primary),
              title: Text(l.appVersion),
              subtitle: Text(
                _packageInfo != null
                    ? '${_packageInfo!.version} (${_packageInfo!.buildNumber})'
                    : l.loadingLabel,
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
    final l = AppLocalizations.of(context)!;
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.lock_outline, color: AppColors.primary),
            title: Text(l.appLock),
            subtitle: Text(l.appLockSubtitle),
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
              title: Text(l.changePin),
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
    final l = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final pin = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.enterPinToTurnOff),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 6,
          autofocus: true,
          decoration: InputDecoration(hintText: l.currentPin),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text(l.turnOff),
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
        SnackBar(content: Text(l.appLockTurnedOff)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.incorrectPinTryAgain),
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
