import '../../model/product.dart';

class ListDealsResponse {
  int count;
  int page;
  int pageSize;
  List<DealsData> data;

  ListDealsResponse({this.count, this.page, this.data, this.pageSize});

  factory ListDealsResponse.fromJson(Map<String, dynamic> json) =>
      ListDealsResponse(
          count: json["count"],
          page: json["page"],
          pageSize: json["pageSize"],
          data: List<DealsData>.from(
            json["data"].map((x) => DealsData.fromJson(x)),
          ));
}

class DealsData {
  String id;
  String name;
  String startTime;
  String endTime;
  String startTimeISO;
  String endTimeISO;
  List<ProductData> products;
  bool active;

  DealsData(
      {this.id,
      this.name,
      this.active,
      this.products,
      this.endTime,
      this.endTimeISO,
      this.startTime,
      this.startTimeISO});

  factory DealsData.fromJson(Map<String, dynamic> json) => DealsData(
      id: json["id"],
      name: json["name"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      startTimeISO: json["startTimeISO"],
      endTimeISO: json["endTimeISO"],
      active: json["active"],
      products: List<ProductData>.from(
          json["products"].map((x) => ProductData.fromJson(x))));
}
