import '../../utility/api_provider.dart';

class DealsRepository {
  ApiProvider _apiProvider = ApiProvider();

  fetchDealsData() {
    return _apiProvider.fetchDealsData();
  }
}
