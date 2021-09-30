import 'dart:developer';

import 'package:flutter/cupertino.dart';
import '../../repository/channel_repository.dart';
import '../../response_handler/channelResponse.dart';
import '../../utility/query_mutation.dart';

class ChannelViewModel with ChangeNotifier {
  var status = "loading";
  QueryMutation addMutation = QueryMutation();
  ChannelRepository channelRepository = ChannelRepository();
  ChannelResponse _channelResponse;

  ChannelResponse get channelResponse {
    return _channelResponse;
  }

  Future<void> fetchChannelData(page, skip, limit, search, sort, user, q) async {
    var resultData = await channelRepository.fetchChannelData(page, skip, limit, search, sort, user, q);
    status = resultData["status"];
    log(resultData["value"].toString());
    if (status == "completed") {
      log("in here");

        _channelResponse = ChannelResponse.fromJson(resultData["value"]);

      log(_channelResponse.toString());
    }
    notifyListeners();
  }
}
