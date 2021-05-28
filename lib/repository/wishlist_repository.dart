
import 'package:anne/utility/api_provider.dart';

class WishListRepository {
  ApiProvider _apiProvider = ApiProvider();

  fetchWishListData(){
    return _apiProvider.fetchWishListData();
  }

  toggleWishList(id){
    return _apiProvider.toggleWishList(id);
  }
}