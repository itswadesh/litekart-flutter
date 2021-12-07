import '../../model/product.dart';

class ProductResponse {
  List<ProductData>? data;

  ProductResponse({this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
          data: List<ProductData>.from(
              json["trending"].map((x) => ProductData.fromJson(x))));
}

class RecommendedProductResponse {
  List<ProductData>? data;

  RecommendedProductResponse({this.data});

  factory RecommendedProductResponse.fromJson(Map<String, dynamic> json) =>
      RecommendedProductResponse(
          data: List<ProductData>.from(
              json["data"].map((x) => ProductData.fromJson(x))));
}
