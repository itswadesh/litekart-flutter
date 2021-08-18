import '../../model/category.dart';

class CategoriesResponse {
  int count;
  int page;
  int pageSize;
  List<CategoryData> data;

  CategoriesResponse({this.count, this.page, this.data, this.pageSize});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      CategoriesResponse(
        count: json["count"],
        page: json["page"],
        pageSize: json["pageSize"],
        data: List<CategoryData>.from(
            json["data"].map((x) => CategoryData.fromJson(x))),
      );
}
