import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_names.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/supported_region.dart';
import '../../../shared/widgets/widgets.dart';
import 'onboarding_view_model.dart';
import 'widgets/progress_dots.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _businessNameController;
  late final TextEditingController _phoneController;
  late SupportedRegion _selectedRegion;
  final _ageController = TextEditingController();
  String? _nameError;
  String? _phoneError;
  String? _businessNameError;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingViewModelProvider);
    _nameController = TextEditingController(text: state.userName);
    _businessNameController = TextEditingController(text: state.businessName);
    _phoneController = TextEditingController(text: state.phone);
    _selectedRegion = SupportedRegion.fromCurrencyCode(state.currencyCode);
    if (state.age != null) {
      _ageController.text = state.age.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessNameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() {
      final l = AppLocalizations.of(context)!;
      _nameError =
          _nameController.text.trim().length < 2 ? l.pleaseEnterName : null;
      final phone = _phoneController.text.trim();
      _phoneError =
          phone.isNotEmpty && phone.length < 10 ? l.enterValidPhone : null;
      final state = ref.read(onboardingViewModelProvider);
      final isBusinessOrCa = state.role == 'BUSINESS' || state.role == 'CA';
      final bizName = _businessNameController.text.trim();
      _businessNameError =
          isBusinessOrCa && (bizName.length < 2 || bizName.length > 200)
              ? l.nameLength
              : null;
    });
    return _nameError == null &&
        _phoneError == null &&
        _businessNameError == null;
  }

  void _onNext() {
    if (!_validate()) return;
    final viewModel = ref.read(onboardingViewModelProvider.notifier);
    viewModel.updateUserName(_nameController.text.trim());
    viewModel.updateBusinessName(_businessNameController.text.trim());
    viewModel.updatePhone(_phoneController.text.trim());
    viewModel.selectRegion(_selectedRegion);
    final ageText = _ageController.text.trim();
    viewModel.updateAge(ageText.isNotEmpty ? int.tryParse(ageText) : null);
    context.push(RouteNames.onboardingSms);
  }

  Widget _buildRegionDropdown() {
    return DropdownButtonFormField<SupportedRegion>(
      initialValue: _selectedRegion,
      isExpanded: true,
      style: AppTextStyles.bodyLarge(context),
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.region,
        labelStyle: AppTextStyles.bodyMedium(
          context,
          color: AppColors.onSurfaceMuted,
        ),
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing16,
          vertical: AppSizes.spacing12,
        ),
        constraints: const BoxConstraints(minHeight: AppSizes.minTouchTarget),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.spacing8),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.spacing8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      items: SupportedRegion.all.map((region) {
        return DropdownMenuItem<SupportedRegion>(
          value: region,
          child: Text(
            '${region.flag}  ${region.displayName}',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (region) {
        if (region == null) return;
        setState(() => _selectedRegion = region);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);
    final isBusinessOrCa = state.role == 'BUSINESS' || state.role == 'CA';
    final isNameFilled = _nameController.text.trim().length >= 2;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: AppLocalizations.of(context)!.goBack,
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ProgressDots(currentStep: 2),
                    const SizedBox(height: AppSizes.spacing16),
                    Center(
                      child: Text(
                        'PocketPlus',
                        style: AppTextStyles.displayLarge(context).copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing24),
                    Center(
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxHeight: 200),
                        padding: const EdgeInsets.all(AppSizes.spacing24),
                        decoration: BoxDecoration(
                          color: AppColors.outline.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radius24,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          size: 80,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing24),
                    Text(
                      AppLocalizations.of(context)!.tellUsAboutYourself,
                      style: AppTextStyles.titleLarge(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spacing8),
                    Text(
                      isBusinessOrCa
                          ? AppLocalizations.of(context)!
                              .enterDetailsBusinessName
                          : AppLocalizations.of(context)!.personalizeExperience,
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.onSurfaceMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spacing24),
                    AppTextField(
                      controller: _nameController,
                      label: AppLocalizations.of(context)!.yourName,
                      hint: AppLocalizations.of(context)!.nameHintExample,
                      errorText: _nameError,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSizes.spacing16),
                    if (isBusinessOrCa) ...[
                      AppTextField(
                        controller: _businessNameController,
                        label:
                            AppLocalizations.of(context)!.businessPracticeName,
                        hint:
                            AppLocalizations.of(context)!.businessNameHintStore,
                        errorText: _businessNameError,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSizes.spacing16),
                    ],
                    AppTextField(
                      controller: _phoneController,
                      label: AppLocalizations.of(context)!.phoneNumber,
                      hint: AppLocalizations.of(context)!.phoneHintExample,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      errorText: _phoneError,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSizes.spacing16),
                    _buildRegionDropdown(),
                    const SizedBox(height: AppSizes.spacing16),
                    AppTextField(
                      controller: _ageController,
                      label: AppLocalizations.of(context)!.ageOptional,
                      hint: AppLocalizations.of(context)!.ageHintExample,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing24,
                vertical: AppSizes.spacing16,
              ),
              child: AppButton(
                label: AppLocalizations.of(context)!.next,
                onPressed: isNameFilled ? _onNext : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
