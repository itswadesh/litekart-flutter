
import 'package:anne/utility/api_provider.dart';

class CategoryRepository {
  ApiProvider _apiProvider = ApiProvider();

  fetchCategoryData(){
    return _apiProvider.fetchCategoryData();
  }
}