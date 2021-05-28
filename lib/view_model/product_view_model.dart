import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:anne/repository/products_repository.dart';
import 'package:anne/response_handler/productResponse.dart';
import 'package:anne/utility/query_mutation.dart';
import '../utility/graphQl.dart';

class ProductViewModel with ChangeNotifier {
  var trendingStatus = "loading";
  var youMayLikeStatus = "loading";
  var suggestedStatus = "loading";
  QueryMutation addMutation = QueryMutation();
  ProductResponse _productTrendingResponse;
  ProductsRepository productsRepository = ProductsRepository();
  ProductResponse get productTrendingResponse {
    return _productTrendingResponse;
  }

  ProductResponse _productYouMayLikeResponse;
  ProductResponse get productYouMayLikeResponse {
    return _productYouMayLikeResponse;
  }
  ProductResponse _productSuggestedResponse;
  ProductResponse get productSuggestedResponse {
    return _productSuggestedResponse;
  }
  Future<void> fetchHotData() async {
    var resultData = await productsRepository.fetchHotData();
    trendingStatus = resultData["status"];
    if(trendingStatus=="completed"){
      _productTrendingResponse = ProductResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }
  Future<void> fetchYouMayLikeData() async {
    var resultData = await productsRepository.fetchYouMayLikeData();
    youMayLikeStatus = resultData["status"];
    if(youMayLikeStatus=="completed"){
      _productYouMayLikeResponse = ProductResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }
  Future<void> fetchSuggestedData() async {
    var resultData = await productsRepository.fetchSuggestedData();
    suggestedStatus = resultData["status"];
    if(suggestedStatus=="completed"){
      _productSuggestedResponse = ProductResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }


  // changeStatus(statusData) {
  //   status = statusData;
  //   notifyListeners();
  // }
}
