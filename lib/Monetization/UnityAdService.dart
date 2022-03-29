import 'package:unity_ads_flutter/unity_ads_flutter.dart';

class UnityAdService {
  //Unity Ads
  static const String videoPlacementId = 'video';
  static const String rewardedVideoPlacementId = 'rewardedVideo';
  static const String gameIdAndroid = '3835903';
  static const String gameIdIOS = '';

  static unityAd() {
    UnityAdsFlutter.isReady(videoPlacementId).then((value) {
      UnityAdsFlutter.show(videoPlacementId);
    });
  }

  static unityRewardedAd() {
    UnityAdsFlutter.isReady(rewardedVideoPlacementId).then((value) {
      UnityAdsFlutter.show(rewardedVideoPlacementId);
    });
  }

  static iniUnityAd(UnityAdsListener listener) {
    UnityAdsFlutter.initialize(gameIdAndroid, gameIdIOS, listener, false);
  }
}
