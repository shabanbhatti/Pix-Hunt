import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pix_hunt_project/core/Utils/ads_unitID_utils.dart';

final bannerAdsProvider =
    StateNotifierProvider.autoDispose<AdsNotifier, BannerAdsState>((ref) {
      return AdsNotifier();
    });

class AdsNotifier extends StateNotifier<BannerAdsState> {
  AdsNotifier() : super(InitialBannerAdsState());

  Future<void> initBannerAds() async {
    state = LoadingBannerAdsState();
    var banner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdsUnitIdUtils.bannerAddUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          state = LoadedBannerAdsState(bannerAd: ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          log(error.message);
          state = ErrorBannerAdsState(error: error.message);
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );

    await banner.load();
  }

  @override
  void dispose() {
    if (state is LoadedBannerAdsState) {
      var loaded = state as LoadedBannerAdsState;
      loaded.bannerAd.dispose();
    }
    super.dispose();
  }
}

sealed class BannerAdsState {
  const BannerAdsState();
}

class InitialBannerAdsState extends BannerAdsState {
  const InitialBannerAdsState();
}

class LoadingBannerAdsState extends BannerAdsState {
  const LoadingBannerAdsState();
}

class LoadedBannerAdsState extends BannerAdsState {
  final BannerAd bannerAd;
  const LoadedBannerAdsState({required this.bannerAd});
}

class ErrorBannerAdsState extends BannerAdsState {
  final String error;
  const ErrorBannerAdsState({required this.error});
}
