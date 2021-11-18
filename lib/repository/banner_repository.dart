import '../../utility/api_provider.dart';
import '../../utility/locator.dart';
import '../../values/constant.dart';

class BannerRepository {
  ApiProvider? _apiProvider = locator<ApiProvider>();

  fetchBannerData() {
    return _apiProvider!.fetchBannerData();
  }

  fetchPickedBannerData() {
    return _apiProvider!.fetchPickedBannerData();
  }

  fetchSliderData() {
    return _apiProvider!.fetchBanners(type: BANNER_TYPE_SLIDER, pageId: "home", sort: "sort");
  }
  fetchVideoBannerData(){
    return _apiProvider!.fetchBanners(type: BANNER_TYPE_VIDEO, pageId: "home", sort: "sort");
  }
}
