import '../../utility/api_provider.dart';

class StripeRepository {
  ApiProvider _apiProvider = ApiProvider();

  stripe(selectedAddressId,token) {
    return _apiProvider.stripe(selectedAddressId,token);
  }

}
