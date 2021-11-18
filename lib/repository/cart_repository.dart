import '../../utility/api_provider.dart';
import '../../utility/locator.dart';

class CartRepository {
  ApiProvider? _apiProvider = locator<ApiProvider>();

  fetchCartData() {
    return _apiProvider!.fetchCartData();
  }

  cartAddItem(pid, vid, qty, replace) {
    return _apiProvider!.cartAddItem(pid, vid, qty, replace);
  }

  applyCoupon(promocode) {
    return _apiProvider!.applyCoupon(promocode);
  }

  listCoupons() {
    return _apiProvider!.listCoupons();
  }
}
