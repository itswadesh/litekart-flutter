import 'package:flutter/cupertino.dart';
import '../../repository/cart_repository.dart';
import '../../response_handler/cartResponse.dart';
import '../../response_handler/couponResponse.dart';
import '../../utility/query_mutation.dart';
import 'package:anne/components/base/tz_dialog.dart';
import 'package:anne/enum/tz_dialog_type.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';


class CartViewModel with ChangeNotifier {
  final NavigationService? _navigationService = locator<NavigationService>();
  late TzDialog _dialog;
  QueryMutation addMutation = QueryMutation();
  String? status = "loading";
  String? statusPromo = "loading";
  int? _cartCount = 0;
  CartResponse? _cartResponse;
  CouponResponse? _couponResponse;
  bool? promocodeStatus = false;
  String? promocode = "";

  //CartViewModel() {
  //  _dialog = TzDialog(
  //      _navigationService!.navigationKey.currentContext, TzDialogType.progress);
 // }

  CartRepository cartRepository = CartRepository();
  CartResponse? get cartResponse {
    return _cartResponse;
  }

  int? get cartCount {
    return _cartCount;
  }

  CouponResponse? get couponResponse {
    return _couponResponse;
  }

  fetchCartData() async {
    var resultData = await cartRepository.fetchCartData();
    status = resultData["status"];
    if (status == "completed") {
      _cartResponse = CartResponse.fromJson(resultData["value"]);
      _cartCount = _cartResponse!.qty;
      if (_cartResponse!.discount != null) {
        promocode = _cartResponse!.discount!.code ?? "";
        if (promocode != "") {
          promocodeStatus = true;
        }
      }
    }
    notifyListeners();
  }

  cartAddItem(pid, vid, qty, replace) async {
    _dialog = TzDialog(
        _navigationService!.navigationKey.currentContext, TzDialogType.progress);
    _dialog.show();
    var resultData = await cartRepository.cartAddItem(pid, vid, qty, replace);
    status = resultData["status"];
    if (status == "empty") {
      _cartResponse = null;
      _cartCount = 0;
    }
    if (status == "completed") {
      _cartResponse = CartResponse.fromJson(resultData["value"]);
      _cartCount = _cartResponse!.qty;
      if (_cartResponse!.discount != null) {
        promocode = _cartResponse!.discount!.code ?? "";
        if (promocode != "") {
          promocodeStatus = true;
        }
      }
    }
    _dialog.close();
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

  changeStatus(statusData) async{
    promocodeStatus = false;
    promocode = "";
    status = statusData;
    statusPromo = statusData;
    _cartCount = 0;
    await fetchCartData();
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
