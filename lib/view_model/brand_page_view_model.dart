import 'package:flutter/foundation.dart';
import '../../repository/brand_page_repository.dart';
import '../../response_handler/bannerResponse.dart';
import '../../response_handler/brandResponse.dart';
import '../../utility/query_mutation.dart';
import "package:collection/collection.dart";

class BrandPageViewModel extends ChangeNotifier {
  final BrandData brand;

  BrandPageViewModel(this.brand);

  QueryMutation addMutation = QueryMutation();
  BrandPageRepository brandRepository = BrandPageRepository();

  Future<List<BannerData>> fetchSliderBannerData() async {
    List<BannerData> _data;
    try {
      var responseData =
          await brandRepository.fetchSliderData(pageId: brand.id);
      _data = (responseData['value']['data'] as List).map((e) {
        BannerData _bannerData = BannerData.fromJson(e);
        return _bannerData;
      }).toList();
    } catch (e) {}
    return _data;
  }

  Future<Map<String, List<BannerData>>> fetchPickedBannerData() async {
    List<BannerData> _data;
    Map<String, List<BannerData>> processedMap;
    try {
      var responseData =
          await brandRepository.fetchPickedData(pageId: brand.id);
      _data = (responseData['value']['data'] as List).map((e) {
        BannerData _bannerData = BannerData.fromJson(e);
        return _bannerData;
      }).toList();

      if (_data != null) processedMap = groupBy(_data, (obj) => obj.groupTitle);
    } catch (e) {

    }

    return processedMap;
  }

  Future<BrandResponse> fetchSubBrandData() async {
    BrandResponse response;
    try {
      var responseData =
          await brandRepository.fetchSubBrandData(pageId: brand.id);


      response =  BrandResponse.fromJson(responseData['value']);
    } catch (e) {}
    return response;
  }

  Future<BannerData> fetchVideoBannerData() async {
    List<BannerData> _data;
    try {
      var responseData =
      await brandRepository.fetchVideoData(pageId: brand.id);
      _data = (responseData['value']['data'] as List).map((e) {
        BannerData _bannerData = BannerData.fromJson(e);
        return _bannerData;
      }).toList();
    } catch (e) {}
    return _data?.first;
  }
}
