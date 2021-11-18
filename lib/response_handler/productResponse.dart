import '../../model/product.dart';

class ProductResponse {
  List<ProductData>? data;

  ProductResponse({this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
          data: List<ProductData>.from(
              json["trending"].map((x) => ProductData.fromJson(x))));
}
