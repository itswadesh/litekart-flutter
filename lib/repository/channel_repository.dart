import '../../utility/api_provider.dart';

class ChannelRepository {
  ApiProvider _apiProvider = ApiProvider();

  fetchChannelData(page, skip, limit, search, sort, user, q) {
    return _apiProvider.fetchChannelData(page, skip, limit, search, sort, user, q);
  }

  neteaseToken(id){
    return _apiProvider.neteaseToken(id);
  }

}