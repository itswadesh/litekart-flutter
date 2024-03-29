
import 'package:flutter/cupertino.dart';
import '../../model/product.dart';
import '../../repository/products_repository.dart';
import '../../utility/query_mutation.dart';

class ProductDetailViewModel with ChangeNotifier {

  String? status = "loading";
  var _buttonStatus  = "ADD TO BAG";
  QueryMutation addMutation = QueryMutation();
  ProductsRepository productsRepository = ProductsRepository();
  ProductDetailData? _productDetailResponse;



  ProductDetailData? get productDetailResponse {
    return _productDetailResponse;
  }



  String?  get buttonStatus {
    return _buttonStatus;
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

  changeButtonStatus(statusData){
    _buttonStatus = statusData;

  }

  changeButtonStatusAndLoad(statusData){
    _buttonStatus = statusData;
    notifyListeners();
  }
}
