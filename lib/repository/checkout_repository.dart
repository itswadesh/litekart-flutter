import 'package:anne/utility/api_provider.dart';

class CheckoutRepository {
  ApiProvider _apiProvider = ApiProvider();

  checkout(addressId,paymentMode){
    return _apiProvider.checkout(addressId, paymentMode);
  }
}