import 'package:flutter/cupertino.dart';
import '../../repository/cart_repository.dart';
import '../../response_handler/cartResponse.dart';
import '../../response_handler/couponResponse.dart';
import '../../utility/query_mutation.dart';

class CartViewModel with ChangeNotifier {
  QueryMutation addMutation = QueryMutation();
  var status = "loading";
  var statusPromo = "loading";
  int cartCount = 0;
  CartResponse _cartResponse;
  CouponResponse _couponResponse;
  bool promocodeStatus = false;
  String promocode = "";
  CartRepository cartRepository = CartRepository();
  CartResponse get cartResponse {
    return _cartResponse;
  }

  CouponResponse get couponResponse {
    return _couponResponse;
  }

  fetchCartData() async {
    var resultData = await cartRepository.fetchCartData();
    status = resultData["status"];
    if (status == "completed") {
      _cartResponse = CartResponse.fromJson(resultData["value"]);
      cartCount = _cartResponse.qty;
      if (_cartResponse.discount != null) {
        promocode = _cartResponse.discount.code ?? "";
        if (promocode != "") {
          promocodeStatus = true;
        }
      }
    }
    notifyListeners();
  }

  cartAddItem(pid, vid, qty, replace) async {
    var resultData = await cartRepository.cartAddItem(pid, vid, qty, replace);
    status = resultData["status"];
    if (status == "empty") {
      _cartResponse = null;
      cartCount = 0;
    }
    if (status == "completed") {
      _cartResponse = CartResponse.fromJson(resultData["value"]);
      cartCount = _cartResponse.qty;
      if (_cartResponse.discount != null) {
        promocode = _cartResponse.discount.code ?? "";
        if (promocode != "") {
          promocodeStatus = true;
        }
      }
    }
    notifyListeners();
  }

  // cartDeleteItem(id) async {
  //   try {
  //     GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  //     GraphQLClient _client = graphQLConfiguration.clientToQuery();
  //     QueryResult result = await _client.mutate(
  //       MutationOptions(
  //           document: gql(addMutation.deleteCart()), variables: {'id': id}),
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  //   fetchCartData();
  //   notifyListeners();
  // }

  changeStatus(statusData) {
    promocodeStatus = false;
    promocode = "";
    status = statusData;
    cartCount = 0;
    notifyListeners();
  }

  refreshCart() {
    status = "loading";
    notifyListeners();
  }

  changePromoStatus(statusData) {
    statusPromo = statusData;
    notifyListeners();
  }

  applyCoupon() async {
    var resultData = await cartRepository.applyCoupon(promocode);
    if (resultData["status"]) {
      await fetchCartData();
      promocodeStatus = resultData["promocodeStatus"];
    }
    notifyListeners();
    return resultData["status"];
  }

  listCoupons() async {
    var resultData = await cartRepository.listCoupons();
    statusPromo = resultData["status"];
    if (statusPromo == "completed") {
      _couponResponse = CouponResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

  selectPromoCode(code) {
    promocode = code;
    notifyListeners();
  }
}
