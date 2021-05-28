
import 'package:anne/utility/api_provider.dart';

class ProductsRepository {
  ApiProvider _apiProvider = ApiProvider();

  fetchHotData(){
    return _apiProvider.fetchHotData();
  }

  fetchSuggestedData(){
    return _apiProvider.fetchSuggestedData();
  }

  fetchYouMayLikeData(){
    return _apiProvider.fetchYouMayLikeData();
  }

  fetchProductList(categoryName, searchText, brand, color, size, page){
    return _apiProvider.fetchProductList(categoryName, searchText, brand, color, size, page);
  }
}