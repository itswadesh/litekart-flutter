import 'package:flutter/cupertino.dart';
import '../../repository/banner_repository.dart';
import '../../response_handler/bannerResponse.dart';
import '../../utility/query_mutation.dart';

class BannerViewModel with ChangeNotifier {
  QueryMutation addMutation = QueryMutation();
  var statusSlider = "loading";
  var statusBanner = "loading";
  BannerRepository bannerRepository = BannerRepository();
  SliderResponse _sliderResponse;
  SliderResponse get sliderResponse {
    return _sliderResponse;
  }

  BannerResponse _bannerResponse;
  BannerResponse get bannerResponse {
    return _bannerResponse;
  }

  Future<void> fetchBannerData() async {
    var resultData = await bannerRepository.fetchBannerData();
    statusBanner = resultData["status"];
    if (statusBanner == "completed") {
      print(resultData["value"].toString());
      _bannerResponse = BannerResponse.fromJson(resultData["value"]);
      print(_bannerResponse.groupByBanner[0]);
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
}
