import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'khata_view_model.dart';

class AddKhataCustomerBottomSheet extends ConsumerStatefulWidget {
  const AddKhataCustomerBottomSheet({super.key});

  @override
  ConsumerState<AddKhataCustomerBottomSheet> createState() =>
      _AddKhataCustomerBottomSheetState();
}

class _AddKhataCustomerBottomSheetState
    extends ConsumerState<AddKhataCustomerBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addCustomerViewModelProvider);
    final notifier = ref.read(addCustomerViewModelProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spacing24,
        right: AppSizes.spacing24,
        top: AppSizes.spacing24,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spacing24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.addCustomerButton,
            style: AppTextStyles.titleMedium(context),
          ),
          const SizedBox(height: AppSizes.spacing20),
          AppTextField(
            label: AppLocalizations.of(context)!.nameLabel,
            hint: AppLocalizations.of(context)!.customerNameHint,
            errorText: state.nameError,
            onChanged: (value) => notifier.setName(value),
          ),
          const SizedBox(height: AppSizes.spacing16),
          AppTextField(
            label: AppLocalizations.of(context)!.phoneOptionalLabel,
            hint: AppLocalizations.of(context)!.phoneHint,
            errorText: state.phoneError,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            onChanged: (value) => notifier.setPhone(value),
          ),
          const SizedBox(height: AppSizes.spacing24),
          AppButton(
            label: AppLocalizations.of(context)!.save,
            isLoading: state.isSaving,
            onPressed: state.isSaving
                ? null
                : () async {
                    final customer = await notifier.saveCustomer();
                    if (customer != null && context.mounted) {
                      context.pop();
                    }
                  },
          ),
        ],
      ),
    );
  }
}
