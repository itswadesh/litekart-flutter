import 'package:flutter/cupertino.dart';
import '../../repository/review_repository.dart';


class RatingViewModel with ChangeNotifier {
  var status = "loading";
  bool success ;
  var message = "You can only add Review the Products which has been delivered to you !!";
  ReviewRepository reviewRepository = ReviewRepository();
   saveReview(id,pid,rating,message) async {
    var resultData = await reviewRepository.saveReview(id,pid,rating, message);
    status = resultData["status"];
    if (status == "completed") {
      success = true;
    }
    else{
      success = false;
    }
    notifyListeners();
  }
}