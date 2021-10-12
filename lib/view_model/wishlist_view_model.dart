import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../repository/wishlist_repository.dart';
import '../../response_handler/wishlistResponse.dart';
import '../../utility/query_mutation.dart';

class WishlistViewModel with ChangeNotifier {
  var status = "loading";
  QueryMutation addMutation = QueryMutation();
  WishlistResponse _wishlistResponse;
  WishListRepository wishListRepository = WishListRepository();
  final PagingController _pagingController = PagingController(firstPageKey: 0);
  PagingController get pagingController {
    return _pagingController;
  }
  WishlistResponse get wishlistResponse {
    return _wishlistResponse;
  }

  Future<void> fetchData() async {
    var resultData = await wishListRepository.fetchWishListData();
    status = resultData["status"];
    if (status == "completed") {
      _wishlistResponse = WishlistResponse.fromJson(resultData["value"]);
      _pagingController.appendLastPage(_wishlistResponse.data);
    }

    notifyListeners();
  }

  toggleItem(id) async {
    await wishListRepository.toggleWishList(id);
   // _pagingController.refresh();
    await fetchData();
    notifyListeners();
  }

  changeStatus(statusData) {
    status = statusData;
    notifyListeners();
  }
}
