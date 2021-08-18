import '../../utility/api_provider.dart';
import '../../utility/locator.dart';
import '../../values/constant.dart';

class BannerRepository {
  ApiProvider _apiProvider = locator<ApiProvider>();

  fetchBannerData() {
    return _apiProvider.fetchBannerData();
  }

  fetchSliderData() {
    return _apiProvider.fetchBanners(type: BANNER_TYPE_SLIDER, pageId: "home", sort: "sort");
  }
}
