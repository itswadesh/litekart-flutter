import 'package:flutter/cupertino.dart';
import '../../utility/api_provider.dart';
import '../../values/constant.dart';

class BrandPageRepository {
  ApiProvider _apiProvider = ApiProvider();

  fetchSliderData({required String? pageId}) {
    return _apiProvider.fetchBanners(type: BANNER_TYPE_SLIDER, pageId: pageId);
  }

  fetchPickedData({required String? pageId}) {
    return _apiProvider.fetchBanners(type: BANNER_TYPE_PICKED, pageId: pageId);
  }

  fetchSubBrandData({required String? pageId}) {
    return _apiProvider.fetchSubBrand(pageId: pageId);
  }

  fetchVideoData({required String? pageId}) {
    return _apiProvider.fetchBanners(type: BANNER_TYPE_VIDEO, pageId: pageId);
  }
}
