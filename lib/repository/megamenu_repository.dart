import '../../utility/api_provider.dart';

class MegaMenuRepository {
  ApiProvider _apiProvider = ApiProvider();

  fetchMegaMenu() {
    return _apiProvider.fetchMegaMenu();
  }
}
