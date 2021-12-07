import 'dart:developer';

import 'package:anne/repository/schedule_repository.dart';
import 'package:anne/response_handler/scheduleResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../utility/query_mutation.dart';

class ScheduleViewModel with ChangeNotifier {
  String? status = "loading";
  bool saveStatus = false;
  QueryMutation addMutation = QueryMutation();
  ScheduleRepository scheduleRepository = ScheduleRepository();
  final PagingController _pagingController = PagingController(firstPageKey: 0);
  PagingController get pagingController {
    return _pagingController;
  }
  ScheduleListResponse? _scheduleListResponse;

  ScheduleListResponse? get scheduleListResponse {
    return _scheduleListResponse;
  }

  Future<void> fetchMyScheduleDemo() async {
    var resultData = await scheduleRepository.fetchMyScheduleDemos();
    status = resultData["status"];
    if (status == "completed") {

      _scheduleListResponse = ScheduleListResponse.fromJson(resultData["value"]);
      _pagingController.appendLastPage(_scheduleListResponse!.data!);
    }
    notifyListeners();
  }

  saveScheduleDemo(id,pid,scheduleDateTime,title) async {

    bool resultData = await scheduleRepository.saveScheduleDemo(id, pid, scheduleDateTime,title);
    if (resultData) {
      await changeStatus("loading");
      saveStatus = true;
    }
    else {
      saveStatus = false;
    }
    notifyListeners();
  }

  cancelScheduleCall(id) async {
    bool resultData = await scheduleRepository.deleteScheduleDemo(id);
    changeStatus("loading");
    notifyListeners();
  }

  changeStatus(statusData) {
    status = statusData;
    notifyListeners();
  }
}
