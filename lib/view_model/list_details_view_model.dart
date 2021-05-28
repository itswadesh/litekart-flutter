import 'package:flutter/cupertino.dart';
import 'package:anne/repository/deals_repository.dart';
import 'package:anne/response_handler/listDealsResponse.dart';
import 'package:anne/utility/query_mutation.dart';


class ListDealsViewModel with ChangeNotifier {
  QueryMutation addMutation = QueryMutation();
  var status = "loading";
  ListDealsResponse _listDealsResponse;

  ListDealsResponse get listDealsResponse {
    return _listDealsResponse;
  }

  DealsRepository dealsRepository = DealsRepository();

  Future<void> fetchDealsData() async {
    var resultData = await dealsRepository.fetchDealsData();
    status = resultData["status"];
    if(status=="completed"){
      _listDealsResponse = ListDealsResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }
}
