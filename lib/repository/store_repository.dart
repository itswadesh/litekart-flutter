import '../../utility/api_provider.dart';

class StoreRepository {
  ApiProvider _apiProvider = ApiProvider();

  store() {
    return _apiProvider.store();
  }
}
