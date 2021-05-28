import 'package:flutter/cupertino.dart';
import 'package:anne/repository/banner_repository.dart';
import 'package:anne/response_handler/bannerResponse.dart';
import 'package:anne/utility/query_mutation.dart';


class BannerViewModel with ChangeNotifier {
  QueryMutation addMutation = QueryMutation();
  var statusSlider = "loading";
  var statusBanner = "loading";
  BannerRepository bannerRepository = BannerRepository();
  BannerResponse _bannerSliderResponse;
  BannerResponse get bannerSliderResponse {
    return _bannerSliderResponse;
  }
  BannerResponse _bannerBannerResponse;
  BannerResponse get bannerBannerResponse {
    return _bannerBannerResponse;
  }

  Future<void> fetchBannerData() async {
    var resultData = await bannerRepository.fetchBannerData();
    statusBanner = resultData["status"];
    if(statusBanner=="completed"){
      _bannerBannerResponse = BannerResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

  Future<void> fetchSliderData() async {
    var resultData = await bannerRepository.fetchSliderData();
    statusSlider = resultData["status"];
    if(statusSlider=="completed"){
      _bannerSliderResponse = BannerResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }
}
