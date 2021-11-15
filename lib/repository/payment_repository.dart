import '../../utility/api_provider.dart';

class PaymentRepository {
  ApiProvider _apiProvider = ApiProvider();

  fetchPaymentMethods() {
    return _apiProvider.paymentMethods();
  }
}