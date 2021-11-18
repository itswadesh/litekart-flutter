import '../../utility/api_provider.dart';

class StripeRepository {
  ApiProvider _apiProvider = ApiProvider();

  stripe(selectedAddressId) {
    return _apiProvider.stripeMobile(selectedAddressId);
  }

}
