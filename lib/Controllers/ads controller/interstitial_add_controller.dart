import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pix_hunt_project/core/Utils/ads_unitID_utils.dart';

final interstitialAdProvider =
    StateNotifierProvider<InterstitialAddNotifier, InterstitialAdsState>((ref) {
      return InterstitialAddNotifier();
    });

class InterstitialAddNotifier extends StateNotifier<InterstitialAdsState> {
  InterstitialAddNotifier() : super(InitialInterstitialAdsState());

  Future<void> initInterstitialAds() async {
    state = LoadingInterstitialAdsState();

    await InterstitialAd.load(
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          state = LoadedInterstitialAdsState(interstitialAd: ad);
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdClicked: (ad) {
              print('On clicked');
            },
            onAdDismissedFullScreenContent: (ad) {
              state = OnCloseInterstitialAdsState();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Failed');
            },
            onAdShowedFullScreenContent: (ad) {
              print('On ad show full screen content');
            },
          );
        },
        onAdFailedToLoad: (error) {
          log(error.message);
          state = ErrorInterstitialAdsState(error: error.message);
        },
      ),

      adUnitId: AdsUnitIdUtils.interstitialAddUnitId,

      request: const AdRequest(),
    );
  }

  @override
  void dispose() {
    if (state is LoadedInterstitialAdsState) {
      var loaded = state as LoadedInterstitialAdsState;
      loaded.interstitialAd.dispose();
    }
    super.dispose();
  }
}

sealed class InterstitialAdsState {
  const InterstitialAdsState();
}

class InitialInterstitialAdsState extends InterstitialAdsState {
  const InitialInterstitialAdsState();
}

class LoadingInterstitialAdsState extends InterstitialAdsState {
  const LoadingInterstitialAdsState();
}

class LoadedInterstitialAdsState extends InterstitialAdsState {
  final InterstitialAd interstitialAd;
  const LoadedInterstitialAdsState({required this.interstitialAd});
}

class OnCloseInterstitialAdsState extends InterstitialAdsState {
  const OnCloseInterstitialAdsState();
}

class ErrorInterstitialAdsState extends InterstitialAdsState {
  final String error;
  const ErrorInterstitialAdsState({required this.error});
}
