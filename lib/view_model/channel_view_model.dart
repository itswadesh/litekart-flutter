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
    if (status == "completed") {
      _channelResponse = ChannelResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }
}
