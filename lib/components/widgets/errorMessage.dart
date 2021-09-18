import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

errorMessage() {
  return Center(
    child: Container(
      color: Colors.grey.shade300,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 140,
          ),
          Image.asset(
            "assets/images/no-network.png",
            height: 280,
            width: 280,
          ),
          SizedBox(
            height: ScreenUtil().setWidth(20),
          ),
          Text(
            "Something went wrong !!",
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontFamily: 'Inter'),
          ),
        ],
      ),
    ),
  );
}
