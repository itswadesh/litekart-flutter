import '../../utility/api_provider.dart';

class CheckoutRepository {
  ApiProvider _apiProvider = ApiProvider();

  checkout(addressId, paymentMode) {
    return _apiProvider.checkout(addressId, paymentMode);
  }

  order(id) {
    return _apiProvider.order(id);
  }

  paySuccessPageHit(id){
    return _apiProvider.paySuccessPageHit(id);
  }
}
