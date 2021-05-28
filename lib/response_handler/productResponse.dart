import 'package:anne/model/product.dart';

class ProductResponse {
  int count;
  int pageSize;
  int noOfPage;
  int page;
  List<ProductData> data;

  ProductResponse(
      {this.data, this.pageSize, this.page, this.count, this.noOfPage});

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
          count: json["count"],
          pageSize: json["pageSize"],
          noOfPage: json["noOfPage"],
          page: json["page"],
          data: List<ProductData>.from(
              json["data"].map((x) => ProductData.fromJson(x))));
}
