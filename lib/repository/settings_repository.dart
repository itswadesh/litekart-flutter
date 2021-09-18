import '../../utility/api_provider.dart';

class SettingsRepository {
  ApiProvider _apiProvider = ApiProvider();

  settings() {
    return _apiProvider.settings();
  }
}
