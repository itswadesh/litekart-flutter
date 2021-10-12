import 'dart:developer';

import 'package:flutter/cupertino.dart';
import '../../model/store.dart';
import '../../repository/store_repository.dart';
import '../../utility/query_mutation.dart';
import '../main.dart';

class StoreViewModel with ChangeNotifier {
  var status = "loading";
  QueryMutation addMutation = QueryMutation();
  StoreRepository storeRepository = StoreRepository();
  StoreData _storeResponse;
  StoreData get storeResponse {
    return _storeResponse;
  }

   fetchStore() async {
    var resultData = await storeRepository.store();
    status = resultData["status"];

    if (status == "completed") {

      _storeResponse = StoreData.fromJson(resultData["value"]);

      store = _storeResponse;
      return _storeResponse;
    }
  else return null;
  }

  changeStatus(statusData) {
    status = statusData;
  }

}
