import 'package:flutter/cupertino.dart';
import '../../repository/category_repository.dart';
import '../../response_handler/categoryResponse.dart';
import '../../utility/query_mutation.dart';

class CategoryViewModel with ChangeNotifier {
  String? status = "loading";
  QueryMutation addMutation = QueryMutation();
  CategoryRepository categoryRepository = CategoryRepository();
  CategoriesResponse? _categoriesResponse;

  CategoriesResponse? get categoryResponse {
    return _categoriesResponse;
  }

  Future<void> fetchCategoryData() async {
    var resultData = await categoryRepository.fetchCategoryData();
    status = resultData["status"];
    if (status == "completed") {
      _categoriesResponse = CategoriesResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }
}
