import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../components/base/tz_dialog.dart';
import '../../enum/tz_dialog_type.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../values/colors.dart';
import '../../view_model/rating_view_model.dart';

import 'cart_logo.dart';

class AddReviewPage extends StatefulWidget {
  final productId;
  AddReviewPage(this.productId);
  @override
  State<StatefulWidget> createState() {
    return _AddReviewPage();
  }
}

class _AddReviewPage extends State<AddReviewPage> {
  int? rating;
  TextEditingController _description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black54,
              size: ScreenUtil().setWidth(28),
            ),
          ),
          title: Center(
              // width: MediaQuery.of(context).size.width * 0.39,
              child: Text(
            "Add Review",
            style: TextStyle(
                color: Color(0xff616161),
                fontSize: ScreenUtil().setSp(
                  21,
                )),
            textAlign: TextAlign.center,
          )),
          actions: [
            Container(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                // width: MediaQuery.of(context).size.width * 0.35,
                child: CartLogo(25))
          ],
        ),
        body:  Consumer<RatingViewModel>(
            builder: (BuildContext context, value, Widget? child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    "Rate This Product",
                    style: TextStyle(
                      color: Color(0xff212529),
                      fontSize: ScreenUtil().setSp(18),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                RatingBar.builder(
                  itemSize: ScreenUtil().setWidth(45),
                  initialRating: 4,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Color(0xfff2b200),
                  ),
                  onRatingUpdate: (double value) {
                    rating = value.toInt();
                  },
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setWidth(20), ScreenUtil().setWidth(20), ScreenUtil().setWidth(20)),
                  child: Text(
                    "Review This Product",
                    style: TextStyle(
                      color: Color(0xff212529),
                      fontSize: ScreenUtil().setSp(18),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(25), 0, ScreenUtil().setWidth(20), 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25)),
                      border: Border(
                          top: BorderSide(color: Color(0x996c757d)),
                          bottom: BorderSide(color: Color(0x996c757d)),
                          left: BorderSide(color: Color(0x996c757d)),
                          right: BorderSide(color: Color(0x996c757d)))),
                  height: ScreenUtil().setWidth(150),
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, 0, 0),
                  child: Container(
                    child: TextFormField(
                      controller: _description,
                      decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Description"),
                      maxLines: 7,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(30),
                ),
                GestureDetector(
                  onTap: () async {
                    TzDialog _dialog = TzDialog(context, TzDialogType.progress);
                    _dialog.show();
                    await value.saveReview(
                            "new", widget.productId, rating, _description.text);
                    _dialog.close();
                    if (value.success) {
                      final snackBar = SnackBar(
                        backgroundColor: Colors.white,
                        content: Text(
                          'Review Added Successfully !!',
                          style: TextStyle(
                              color: AppColors.primaryElement,
                              fontSize: ScreenUtil().setSp(14)),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      locator<NavigationService>().pop();
                    } else {
                      final snackBar = SnackBar(
                        backgroundColor: Colors.white,
                        content: Text(
                          value.message,
                          style: TextStyle(
                              color: AppColors.primaryElement,
                              fontSize: ScreenUtil().setSp(14)),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setWidth(50),
                    margin: EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryElement,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Save Review",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil().setSp(16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
