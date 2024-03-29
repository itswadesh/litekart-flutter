import 'package:flutter/cupertino.dart';
import '../../repository/products_repository.dart';
import '../../response_handler/productResponse.dart';
import '../../utility/query_mutation.dart';

class ProductViewModel with ChangeNotifier {
  String? trendingStatus = "loading";
  String? youMayLikeStatus = "loading";
  String? suggestedStatus = "loading";
   String? recommendedStatus = "loading";
  QueryMutation addMutation = QueryMutation();
  ProductResponse? _productTrendingResponse;
  ProductsRepository productsRepository = ProductsRepository();

  ProductResponse? get productTrendingResponse {
    return _productTrendingResponse;
  }

  ProductResponse? _productYouMayLikeResponse;

  ProductResponse? get productYouMayLikeResponse {
    return _productYouMayLikeResponse;
  }

  ProductResponse? _productSuggestedResponse;

  ProductResponse? get productSuggestedResponse {
    return _productSuggestedResponse;
  }

  RecommendedProductResponse? _productRecommendedResponse;

  RecommendedProductResponse? get productRecommendedResponse {
    return _productRecommendedResponse;
  }


  
 Future<void> fetchRecommendedProducts() async{
    var resultData = await productsRepository.fetchRecommendedProducts();
    recommendedStatus = resultData["status"];
    if (recommendedStatus == "completed") {
      _productRecommendedResponse = RecommendedProductResponse.fromJson(resultData["value"]);
    }
    notifyListeners(); 
  }
  
  Future<void> fetchHotData() async {
    var resultData = await productsRepository.fetchHotData();
    trendingStatus = resultData["status"];
    if (trendingStatus == "completed") {
      _productTrendingResponse = ProductResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

  Future<void> fetchYouMayLikeData() async {
    var resultData = await productsRepository.fetchYouMayLikeData();
    youMayLikeStatus = resultData["status"];
    if (youMayLikeStatus == "completed") {
      _productYouMayLikeResponse =
          ProductResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

  Future<void> fetchSuggestedData() async {
    var resultData = await productsRepository.fetchSuggestedData();
    suggestedStatus = resultData["status"];
    if (suggestedStatus == "completed") {
      _productSuggestedResponse = ProductResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

changeRecommendedStatus(statusData) {
  recommendedStatus = statusData;

}
}
