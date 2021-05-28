

import 'package:anne/utility/api_provider.dart';

class BrandRepository {
  ApiProvider _apiProvider = ApiProvider();

  fetchBrandData(){
    return _apiProvider.fetchBrandData();
  }
}