import 'package:flutter/cupertino.dart';
import 'package:anne/repository/brandRepository.dart';
import 'package:anne/response_handler/brandResponse.dart';
import 'package:anne/utility/query_mutation.dart';

class BrandViewModel with ChangeNotifier {
  QueryMutation addMutation = QueryMutation();
  BrandResponse _brandResponse;
  var status = "loading";
  BrandRepository brandRepository = BrandRepository();
  BrandResponse get brandResponse {
    return _brandResponse;
  }

  Future<void> fetchBrandData() async {
    var resultData = await brandRepository.fetchBrandData();
    status = resultData["status"];
    if(status=="completed"){
      _brandResponse = BrandResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }
}
