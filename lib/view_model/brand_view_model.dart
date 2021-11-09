import 'package:flutter/cupertino.dart';
import '../../repository/brandRepository.dart';
import '../../response_handler/brandResponse.dart';
import '../../utility/query_mutation.dart';

class BrandViewModel with ChangeNotifier {
  QueryMutation addMutation = QueryMutation();
  BrandResponse? _brandResponse;
  String? status = "loading";
  BrandRepository brandRepository = BrandRepository();
  BrandResponse? get brandResponse {
    return _brandResponse;
  }

  Future<void> fetchBrandData() async {
    var resultData = await brandRepository.fetchParentBrandData();
    status = resultData["status"];
    if (status == "completed") {
      _brandResponse = BrandResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }
}
