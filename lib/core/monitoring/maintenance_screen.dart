import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

/// Full-screen maintenance overlay shown during kill switch or forced update.
class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen._({
    required this.title,
    required this.message,
    this.showUpdateButton = false,
  });

  /// Kill switch: app disabled remotely.
  factory MaintenanceScreen.killSwitch(String message) {
    return MaintenanceScreen._(
      title: 'App Unavailable',
      message: message,
      showUpdateButton: false,
    );
  }

  /// Force update: app version too old.
  factory MaintenanceScreen.forceUpdate(String requiredVersion) {
    return MaintenanceScreen._(
      title: 'Update Required',
      message:
          'Please update to version $requiredVersion or later to continue using ${AppStrings.appName}.',
      showUpdateButton: true,
    );
  }

  final String title;
  final String message;
  final bool showUpdateButton;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  showUpdateButton
                      ? Icons.system_update_rounded
                      : Icons.build_circle_outlined,
                  size: 40,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceMuted,
                    ),
                textAlign: TextAlign.center,
              ),
              if (showUpdateButton) ...[
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _openStore,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Update Now'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openStore() async {
    final uri = Platform.isAndroid
        ? Uri.parse(
            'market://details?id=in.pocketplus.app',
          )
        : Uri.parse(
            'https://apps.apple.com/app/pocketplus/id0000000000',
          );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(
        Uri.parse(
          'https://play.google.com/store/apps/details?id=in.pocketplus.app',
        ),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
