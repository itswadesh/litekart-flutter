import 'dart:developer';

import 'package:flutter/cupertino.dart';
import '../../repository/megamenu_repository.dart';
import '../../response_handler/megaMenuResponse.dart';
import '../../utility/query_mutation.dart';

class MegaMenuViewModel with ChangeNotifier {
  QueryMutation addMutation = QueryMutation();
  int selectedTopIndex = 0;
  String status = "loading";
  TopMegaMenuResponse _topMegaMenuResponse;
  final MegaMenuRepository megaMenuRepository = MegaMenuRepository();
  TopMegaMenuResponse get topMegaMenuResponse {
    return _topMegaMenuResponse;
  }

  fetchMegaMenu() async {
    var resultData = await megaMenuRepository.fetchMegaMenu();
    status = resultData["status"];
    log("Status of mega menu is "+status);
    log("value from mega menu"+resultData["value"].toString());
    if (status == "completed") {
      _topMegaMenuResponse = TopMegaMenuResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

  selectTopIndex(index) {
    selectedTopIndex = index;
    notifyListeners();
  }

  changeStatus(statusData) {
    status = statusData;
    notifyListeners();
  }
}
