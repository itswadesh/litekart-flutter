import 'package:flutter/cupertino.dart';
import '../../model/product.dart';
import '../../repository/products_repository.dart';
import '../../utility/query_mutation.dart';

class ProductDetailViewModel with ChangeNotifier {
  var status = "loading";

  QueryMutation addMutation = QueryMutation();
  ProductsRepository productsRepository = ProductsRepository();
  ProductDetailData _productDetailResponse;
  ProductDetailData get productDetailResponse {
    return _productDetailResponse;
  }

  Future<void> fetchProductDetailData(productId) async {
    var resultData = await productsRepository.fetchProductDetailApi(productId);
    status = resultData["status"];
    if (status == "completed") {
      _productDetailResponse = ProductDetailData.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

  changeStatus(statusData) {
    status = statusData;
  }
}
