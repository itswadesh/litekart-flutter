

import '../../utility/api_provider.dart';

class ReviewRepository {
  ApiProvider _apiProvider = ApiProvider();

  saveReview(id,pid,rating, message) {
    return _apiProvider.saveReview(id,pid,rating,message);
  }
}