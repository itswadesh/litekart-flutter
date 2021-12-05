import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

errorMessage() {
  return  Container(

      color: Color(0xfff3f3f3),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Image.asset(
            "assets/images/no-data-curate.png",
            height: 280,
            width: 280,
          ),

          Text(
            "Something went wrong !!",
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontFamily: 'Inter'),
          ),
        ],
      ),
  );
}
