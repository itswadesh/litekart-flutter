
import 'package:anne/utility/api_provider.dart';
import 'package:anne/utility/locator.dart';

class BannerRepository {
  ApiProvider _apiProvider = locator<ApiProvider>();

  fetchBannerData() {
    return _apiProvider.fetchBannerData();
  }

  fetchSliderData(){
    return _apiProvider.fetchSliderData();
  }
}