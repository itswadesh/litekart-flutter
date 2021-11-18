
import 'package:anne/utility/api_provider.dart';

class ScheduleRepository{
  ApiProvider _apiProvider = ApiProvider();

  fetchMyScheduleDemos() {
    return _apiProvider.fetchMyScheduleDemos();
  }

  saveScheduleDemo(id, pid, scheduleDateTime,title){
    return _apiProvider.saveScheduleDemos(id, pid, scheduleDateTime,title);
  }

  deleteScheduleDemo(id){
    return _apiProvider.deleteScheduleDemo(id);
  }

  neteaseToken(id){
    return _apiProvider.neteaseToken(id);
  }
}