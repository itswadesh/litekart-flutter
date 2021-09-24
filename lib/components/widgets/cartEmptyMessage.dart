import 'package:anne/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

cartEmptyMessage(key, msg) {
  String imageAsset = "";
  if (key == "cart") {
    imageAsset = "assets/images/empty-cart.png";
  } else if (key == "search") {
    imageAsset = "assets/images/no-search-result.png";
  } else if (key == "wishlist") {
    imageAsset = "assets/images/empty-wish-list.png";
  } else if (key == "noNetwork") {
    imageAsset = "assets/images/no-network.png";
  } else {
    imageAsset = "assets/images/noData.png";
  }
  return Center(child: Container(
    color: Color(0xfff3f3f3),
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // SizedBox(
        //   height: 120,
        // ),
        Image.asset(
          imageAsset,
          height: 250,
          width: 250,
        ),

        Text(
          msg,
          style: TextStyle(
            color: Color(0xff212529),
            fontSize: 14,
          ),
        ),

      ],
    ),
  ));
}


class CouponEmpty extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Container(
       height: ScreenUtil().setHeight(340),
       width: ScreenUtil().setWidth(386),
        child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ Text("No Coupon Code")])));
  }
}

class CouponError extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(340),
        width: ScreenUtil().setWidth(386),
        child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ Text("Something went wrong !!",style: TextStyle(color: AppColors.primaryElement),)])));
  }
}