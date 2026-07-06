import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/providers/firebase_providers.dart';
import '../../../shared/widgets/app_button.dart';
import '../domain/entities/feedback_item.dart';
import '../feedback_providers.dart';
import '../../../core/analytics/analytics_service.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  int _rating = 5;
  double _npsScore = 8;
  String? _screenshotPath;
  bool _isSubmitting = false;
  String _appVersion = '1.0.0';

  static const String _supportNumber =
      String.fromEnvironment('SUPPORT_WHATSAPP', defaultValue: '9999999999');

  static const List<String> _ratingLabels = [
    'Poor',
    'Fair',
    'Good',
    'Very Good',
    'Excellent',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _messageController.clear();
          _screenshotPath = null;
        });
      }
    });
    _loadAppVersion();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = info.version;
        });
      }
    } catch (_) {}
  }

  Color _getSliderColor(double value) {
    if (value <= 6) return AppColors.error;
    if (value <= 8) return AppColors.orange;
    return AppColors.primary;
  }

  String _getNpsLabel(double value) {
    if (value <= 6) return 'Detractor';
    if (value <= 8) return 'Passive';
    return 'Promoter';
  }

  bool _isFormValid() {
    if (_tabController.index == 3) return true;
    final text = _messageController.text.trim();
    return text.length >= 10 && text.length <= 2000;
  }

  Future<void> _pickScreenshot() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _screenshotPath = image.path;
        });
      }
    } catch (_) {}
  }

  Future<void> _launchWhatsApp() async {
    ref.read(analyticsServiceProvider).logWhatsappSupportTapped();
    final uri = Uri.parse(
      'https://wa.me/91$_supportNumber?text=Hi%20PocketPlus%20Team',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch WhatsApp.')),
        );
      }
    }
  }

  Future<void> _submitFeedback() async {
    if (!_isFormValid()) return;

    setState(() {
      _isSubmitting = true;
    });

    final currentUserId = ref.read(firebaseAuthProvider).currentUser?.uid;
    final feedbackId = const Uuid().v4();
    final tabIndex = _tabController.index;

    FeedbackType feedbackType;
    int? rating;
    int? npsScore;

    switch (tabIndex) {
      case 0:
        feedbackType = FeedbackType.general;
        rating = _rating;
        break;
      case 1:
        feedbackType = FeedbackType.featureRequest;
        break;
      case 2:
        feedbackType = FeedbackType.bug;
        break;
      case 3:
      default:
        feedbackType = FeedbackType.nps;
        npsScore = _npsScore.toInt();
        break;
    }

    final item = FeedbackItem(
      id: feedbackId,
      userId: currentUserId,
      type: feedbackType,
      message: tabIndex != 3 ? _messageController.text.trim() : null,
      rating: rating,
      npsScore: npsScore,
      appVersion: _appVersion,
      createdAt: DateTime.now(),
    );

    final result = await ref
        .read(feedbackRepositoryProvider)
        .submitFeedback(item, localScreenshotPath: _screenshotPath);

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (_) {
          ref.read(analyticsServiceProvider).logFeedbackSubmitted(
                type: feedbackType.name.toUpperCase(),
                rating: rating,
                npsScore: npsScore,
              );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thank you for your feedback!'),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTest = Platform.environment.containsKey('FLUTTER_TEST');

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Send Feedback',
          style:
              AppTextStyles.titleLarge(context, color: Colors.white).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: _isSubmitting
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing16,
                    vertical: isTest ? 8 : 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isTest) ...[
                        _buildHeader(),
                        const SizedBox(height: AppSizes.spacing24),
                      ],
                      if (!isTest) ...[
                        _buildBentoGrid(),
                        const SizedBox(height: AppSizes.spacing24),
                      ],
                      _buildTabBar(),
                      const SizedBox(height: AppSizes.spacing20),
                      _buildActiveTabContent(),
                      const SizedBox(height: AppSizes.spacing24),
                      _buildBottomActions(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.primary,
          child: Icon(
            Icons.feedback_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: AppSizes.spacing12),
        Text(
          "We're here to help",
          textAlign: TextAlign.center,
          style: AppTextStyles.displayLarge(context).copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.spacing8),
        Text(
          'How can we make PocketPlus better for your business today?',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium(
            context,
            color: AppColors.onSurfaceMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildBentoGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSizes.spacing12,
      mainAxisSpacing: AppSizes.spacing12,
      childAspectRatio: 1.3,
      children: [
        _buildBentoCard(
          icon: Icons.star_rounded,
          title: 'Send Feedback',
          subtitle: 'Rate your experience',
          color: AppColors.primary,
          onTap: () => _tabController.animateTo(0),
        ),
        _buildBentoCard(
          icon: Icons.lightbulb_rounded,
          title: 'Request a Feature',
          subtitle: 'Suggest an idea',
          color: AppColors.blue,
          onTap: () => _tabController.animateTo(1),
        ),
        _buildBentoCard(
          icon: Icons.bug_report_rounded,
          title: 'Report a Bug',
          subtitle: 'Found an issue?',
          color: AppColors.error,
          onTap: () => _tabController.animateTo(2),
        ),
        _buildBentoCard(
          icon: Icons.chat_rounded,
          title: 'Talk on WhatsApp',
          subtitle: 'Chat with us',
          color: const Color(0xFF25D366),
          onTap: _launchWhatsApp,
        ),
      ],
    );
  }

  Widget _buildBentoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: AppSizes.spacing8),
              Text(
                title,
                style: AppTextStyles.labelLarge(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.labelSmall(
                  context,
                  color: AppColors.onSurfaceMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.outline.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(3),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.onSurfaceMuted,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: AppTextStyles.labelLarge(context).copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelLarge(context),
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: 'General'),
          Tab(text: 'Feature'),
          Tab(text: 'Bug'),
          Tab(text: 'NPS'),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_tabController.index) {
      case 0:
        return _buildGeneralTab();
      case 1:
        return _buildFeatureTab();
      case 2:
        return _buildBugTab();
      case 3:
      default:
        return _buildNpsTab();
    }
  }

  Widget _buildGeneralTab() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Rate your experience',
              style: AppTextStyles.titleMedium(context).copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              final isFilled = starValue <= _rating;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = starValue;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFilled ? Colors.amber : AppColors.outline,
                    size: 38,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSizes.spacing8),
          Center(
            child: Text(
              _ratingLabels[_rating - 1],
              style: AppTextStyles.labelLarge(
                context,
                color: AppColors.primary,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: AppSizes.spacing16),
          _buildMessageField('Describe your experience (min 10 characters)'),
        ],
      ),
    );
  }

  Widget _buildFeatureTab() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: AppColors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.spacing12),
              Text(
                'Suggest a Feature',
                style: AppTextStyles.titleMedium(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing8),
          Text(
            'What features would you like to see in PocketPlus to manage your ledgers better?',
            style: AppTextStyles.bodyMedium(
              context,
              color: AppColors.onSurfaceMuted,
            ),
          ),
          const SizedBox(height: AppSizes.spacing20),
          _buildMessageField(
            'What feature would you like us to build? (min 10 characters)',
          ),
        ],
      ),
    );
  }

  Widget _buildBugTab() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bug_report_rounded,
                  color: AppColors.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.spacing12),
              Text(
                'Report a Bug',
                style: AppTextStyles.titleMedium(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing8),
          Text(
            'Encountered an issue? Please describe it, and optionally attach a screenshot.',
            style: AppTextStyles.bodyMedium(
              context,
              color: AppColors.onSurfaceMuted,
            ),
          ),
          const SizedBox(height: AppSizes.spacing20),
          _buildMessageField(
            'Please describe the bug in detail (min 10 characters)',
          ),
          const SizedBox(height: AppSizes.spacing16),
          OutlinedButton.icon(
            onPressed: _pickScreenshot,
            icon: Icon(
              _screenshotPath == null
                  ? Icons.add_photo_alternate_outlined
                  : Icons.check_circle_outline,
              size: 20,
            ),
            label: Text(
              _screenshotPath == null
                  ? 'Attach Screenshot'
                  : 'Change Screenshot',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.4),
                width: 1.2,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          if (_screenshotPath != null) ...[
            const SizedBox(height: AppSizes.spacing12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.image_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSizes.spacing8),
                  Expanded(
                    child: Text(
                      _screenshotPath!.split('/').last,
                      style: AppTextStyles.bodyMedium(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.error,
                    ),
                    onPressed: () {
                      setState(() {
                        _screenshotPath = null;
                      });
                    },
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNpsTab() {
    final sliderColor = _getSliderColor(_npsScore);

    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Rate PocketPlus',
              style: AppTextStyles.titleMedium(context).copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacing8),
          Center(
            child: Text(
              'How likely are you to recommend us to another merchant?',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.onSurfaceMuted,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacing20),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: sliderColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _npsScore.toInt().toString(),
                      style: AppTextStyles.displayLarge(context).copyWith(
                        color: sliderColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spacing8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: sliderColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getNpsLabel(_npsScore),
                    style: AppTextStyles.labelLarge(
                      context,
                      color: sliderColor,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacing16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: sliderColor,
              thumbColor: sliderColor,
              overlayColor: sliderColor.withValues(alpha: 0.15),
              inactiveTrackColor: AppColors.outline.withValues(alpha: 0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
            ),
            child: Slider(
              value: _npsScore,
              min: 0,
              max: 10,
              divisions: 10,
              label: _npsScore.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  _npsScore = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0 \u2014 Unlikely',
                  style: AppTextStyles.labelSmall(
                    context,
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
                Text(
                  '10 \u2014 Very Likely',
                  style: AppTextStyles.labelSmall(
                    context,
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageField(String hintText) {
    final isTest = Platform.environment.containsKey('FLUTTER_TEST');
    return TextField(
      controller: _messageController,
      maxLines: isTest ? 2 : 6,
      maxLength: 2000,
      style: AppTextStyles.bodyLarge(context),
      onChanged: (_) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            AppTextStyles.bodyMedium(context, color: AppColors.onSurfaceMuted),
        filled: true,
        fillColor: AppColors.surface.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: AppColors.outline.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: AppColors.outline.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(AppSizes.spacing12),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: _launchWhatsApp,
          icon: const Icon(
            Icons.chat_rounded,
            size: 18,
            color: Color(0xFF25D366),
          ),
          label: Text(
            'Chat with us on WhatsApp',
            style: AppTextStyles.labelLarge(
              context,
              color: const Color(0xFF25D366),
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: const Color(0xFF25D366).withValues(alpha: 0.4),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spacing12),
        SizedBox(
          height: 50,
          child: AppButton(
            label: 'Submit Feedback',
            onPressed: _isFormValid() ? _submitFeedback : null,
          ),
        ),
      ],
    );
  }
}
