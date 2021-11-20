import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../repository/channel_repository.dart';
import '../../response_handler/channelResponse.dart';
import '../../utility/query_mutation.dart';

class ChannelViewModel with ChangeNotifier {
  String? status = "loading";
  QueryMutation addMutation = QueryMutation();
  ChannelRepository channelRepository = ChannelRepository();
  ChannelResponse? _channelResponse;
  final PagingController _pagingController = PagingController(firstPageKey: 0);
  PagingController get pagingController {
    return _pagingController;
  }
  ChannelResponse? get channelResponse {
    return _channelResponse;
  }

  Future<void> fetchChannelData(page, skip, limit, search, sort, user, q) async {
    var resultData = await channelRepository.fetchChannelData(page, skip, limit, search, sort, user, q);
    status = resultData["status"];

    if (status == "completed") {
        _channelResponse = ChannelResponse.fromJson(resultData["value"]);
        _pagingController.appendLastPage(_channelResponse!.data!);
    }
    notifyListeners();
  }

  refresh(){
    _pagingController.refresh();
    status = "loading";
    notifyListeners();
  }

}
