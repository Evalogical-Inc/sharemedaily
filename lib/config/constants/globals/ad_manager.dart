import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager with ChangeNotifier {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();
  OverlayEntry? _overlayEntry;
  // RewardedInterstitialAd? _rewardedAd;
  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;
  bool _isAdLoaded = false;
  bool get isAdLoading => _isAdLoading;

  void _showLoader(BuildContext context) {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _hideLoader() {
    log('still loading  ......');
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Load Ad Method
  void loadAd() {
    log('loadAd initiated');
    if (_isAdLoading) return; // Prevent multiple requests

    // const adUnitId = 'ca-app-pub-1111618730902679/6629503470';
    // const adUnitId = 'ca-app-pub-1111618730902679/4172835257';
    const adUnitId = 'ca-app-pub-1111618730902679/7819488106';
    // const adUnitId = 'ca-app-pub-3940256099942544/5354046379';
    // RewardedInterstitialAd.load(
    //   adUnitId: adUnitId,
    //   request: const AdRequest(),
    //   rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
    //     onAdLoaded: (RewardedInterstitialAd ad) {
    //       debugPrint('RewardedAd loaded.');
    //       debugPrint("loaded still loading... $_isAdLoaded");
    //       _rewardedAd = ad;
    //       _isAdLoaded = true;
    //     },
    //     onAdFailedToLoad: (LoadAdError error) {
    //       debugPrint('RewardedAd failed to load: $error');
    //       _isAdLoading = false;
    //       _isAdLoaded = false;
    //       _rewardedAd = null;
    //     },
    //   ),
    // );

    RewardedAd.load(adUnitId: adUnitId, 
      request: const AdRequest(), 
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
           _rewardedAd = ad;
          _isAdLoaded = true;
        }, 
        onAdFailedToLoad: (LoadAdError error) { 
          debugPrint('RewardedAd failed to load: $error');
          _isAdLoading = false;
          _isAdLoaded = false;
          _rewardedAd = null;
         }
      ));
  }

  // Show Ad Method
  Future<void> showAd(BuildContext context, VoidCallback onRewardEarned) async {
    _showLoader(context);
    // if (_rewardedAd == null) {
      debugPrint("Ad is still loading... $_isAdLoaded");
      while (!_isAdLoaded) {
        (!isAdLoading) ? loadAd() : null;
        await Future.delayed(const Duration(milliseconds: 500));
        log('still loading');
      }
      _hideLoader();
      _rewardedAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        onRewardEarned(); // Call the reward callback
      });

      

      // return;
    // }


    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint("Ad dismissed.");
        ad.dispose();
        _rewardedAd = null;
        _hideLoader();
        _isAdLoaded = false;
        loadAd(); // Load new ad after dismissing
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint("Ad failed to show: $error");
        ad.dispose();
        _rewardedAd = null;
        _hideLoader();
        _isAdLoaded = false;
        loadAd();
      },
    );


    


    // _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
    //   onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
    //     debugPrint("Ad dismissed.");
    //     ad.dispose();
    //     _rewardedAd = null;
    //     _hideLoader();
    //     _isAdLoaded = false;
    //     loadAd(); // Load new ad after dismissing
    //   },
    //   onAdFailedToShowFullScreenContent: (RewardedInterstitialAd ad, AdError error) {
    //     debugPrint("Ad failed to show: $error");
    //     ad.dispose();
    //     _rewardedAd = null;
    //     _hideLoader();
    //     _isAdLoaded = false;
    //     loadAd();
    //   },
    // );

    // _rewardedAd?.show(
    //     onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
    //   onRewardEarned(); // Call the reward callback
    // });

    _rewardedAd = null; // Clear ad after showing
  }
}
