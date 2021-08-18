import '../../utility/api_provider.dart';

class CashfreeRepository {
  ApiProvider _apiProvider = ApiProvider();

  cashFreePayNow(selectedAddressId) {
    return _apiProvider.cashFreePayNow(selectedAddressId);
  }

  captureCashFree(data) {
    return _apiProvider.captureCashFree(data);
  }
}
