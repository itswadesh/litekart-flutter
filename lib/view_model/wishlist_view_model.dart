import 'package:flutter/cupertino.dart';
import '../../repository/wishlist_repository.dart';
import '../../response_handler/wishlistResponse.dart';
import '../../utility/query_mutation.dart';

class WishlistViewModel with ChangeNotifier {
  var status = "loading";
  QueryMutation addMutation = QueryMutation();
  WishlistResponse _wishlistResponse;
  WishListRepository wishListRepository = WishListRepository();
  WishlistResponse get wishlistResponse {
    return _wishlistResponse;
  }

  Future<void> fetchData() async {
    var resultData = await wishListRepository.fetchWishListData();
    status = resultData["status"];
    if (status == "completed") {
      _wishlistResponse = WishlistResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

  toggleItem(id) async {
    await wishListRepository.toggleWishList(id);
    await fetchData();
    notifyListeners();
  }

  changeStatus(statusData) {
    status = statusData;
    notifyListeners();
  }
}
