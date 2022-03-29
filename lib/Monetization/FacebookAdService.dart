import 'package:facebook_audience_network/ad/ad_interstitial.dart';

class FacebookAdService {
  //Facebook Ad
  static const interstitialAdId1 = "314951399545243_388378892202493";
  static const interstitialAdId2 = "314951399545243_407878933585822";

  static facebookAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: interstitialAdId1,
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd(delay: 500);
      },
    );
  }

  static facebookAd2() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: interstitialAdId2,
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd(delay: 500);
      },
    );
  }
}
