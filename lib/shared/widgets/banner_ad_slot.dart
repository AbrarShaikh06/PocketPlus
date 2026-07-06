import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants/app_colors.dart';

/// A persistent AdMob banner. Banner ads are the app's only revenue source.
///
/// Renders nothing until the ad loads (and nothing if it fails), so it never
/// reserves blank space. Uses Google's official **test** ad unit in debug
/// builds; replace [_productionAdUnitId] with your real AdMob banner unit
/// before a Play Store release. `MobileAds.instance.initialize()` is already
/// called once in `main()`.
class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({super.key});

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  BannerAd? _ad;
  bool _loaded = false;

  // Google's official Android test banner unit — safe to use during dev.
  static const String _testAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  // TODO: replace with the real AdMob banner ad unit id before release.
  static const String _productionAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  static String get _adUnitId =>
      kDebugMode ? _testAdUnitId : _productionAdUnitId;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final ad = BannerAd(
      size: AdSize.banner,
      adUnitId: _adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _ad = ad;
    ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();
    return Semantics(
      label: 'Advertisement',
      container: true,
      child: Container(
        width: double.infinity,
        height: ad.size.height.toDouble(),
        color: AppColors.card,
        alignment: Alignment.center,
        child: SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}
