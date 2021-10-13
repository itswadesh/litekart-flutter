import '../../utility/api_provider.dart';

class StripeRepository {
  ApiProvider _apiProvider = ApiProvider();

  stripe(selectedAddressId,paymentMethodId) {
    return _apiProvider.stripe(selectedAddressId,paymentMethodId);
  }

}
