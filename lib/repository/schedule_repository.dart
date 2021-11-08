
import 'package:anne/utility/api_provider.dart';

class ScheduleRepository{
  ApiProvider _apiProvider = ApiProvider();

  fetchMyScheduleDemos() {
    return _apiProvider.fetchMyScheduleDemos();
  }

  neteaseToken(id){
    return _apiProvider.neteaseToken(id);
  }
}