import '../../utility/api_provider.dart';

class PaypalRepository {
  ApiProvider _apiProvider = ApiProvider();

  paypalPayNow(selectedAddressId) {
    return _apiProvider.paypalPayNow(selectedAddressId);
  }
  //
  // paypalExecute(data) {
  //   return _apiProvider.paypalExecute(data);
  // }
}
