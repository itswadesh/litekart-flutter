import 'package:flutter/cupertino.dart';
import '../../repository/banner_repository.dart';
import '../../response_handler/bannerResponse.dart';
import '../../utility/query_mutation.dart';

class BannerViewModel with ChangeNotifier {
  QueryMutation addMutation = QueryMutation();
  String? statusSlider = "loading";
  String? statusBanner = "loading";
  String? statusPickedBanner = "loading";
  String? statusVideoBanner = "loading";
  BannerRepository bannerRepository = BannerRepository();
  SliderResponse? _sliderResponse;
  SliderResponse? get sliderResponse {
    return _sliderResponse;
  }

  SliderResponse? _videoBannerResponse;
  SliderResponse? get videoBannerResponse {
    return _videoBannerResponse;
  }

  BannerResponse? _bannerResponse;
  BannerResponse? get bannerResponse {
    return _bannerResponse;
  }

  BannerResponse? _pickedBannerResponse;
  BannerResponse? get pickedBannerResponse {
    return _pickedBannerResponse;
  }

  Future<void> fetchBannerData() async {
    var resultData = await bannerRepository.fetchBannerData();
    statusBanner = resultData["status"];
    if (statusBanner == "completed") {

      _bannerResponse = BannerResponse.fromJson(resultData["value"]);

    }
    notifyListeners();
  }

  Future<void> fetchPickedBannerData() async {
    var resultData = await bannerRepository.fetchPickedBannerData();
    statusPickedBanner = resultData["status"];
    if (statusPickedBanner == "completed") {

      _pickedBannerResponse = BannerResponse.fromJson(resultData["value"]);

    }
    notifyListeners();
  }

  Future<void> fetchSliderData() async {
    var resultData = await bannerRepository.fetchSliderData();
    statusSlider = resultData["status"];
    if (statusSlider == "completed") {
      _sliderResponse = SliderResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

  Future<void> fetchVideoBannerData() async {
    var resultData = await bannerRepository.fetchVideoBannerData();
    statusVideoBanner = resultData["status"];
    if (statusVideoBanner == "completed") {
      _videoBannerResponse = SliderResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }
}
