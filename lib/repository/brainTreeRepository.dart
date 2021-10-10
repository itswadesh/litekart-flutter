import '../../utility/api_provider.dart';

class BrainTreeRepository {
  ApiProvider _apiProvider = ApiProvider();

  brainTreeToken() {
    return _apiProvider.brainTreeToken();
  }

}