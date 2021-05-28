import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

buttonValue(value, status) {
  return status
      ? Text(value,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(
            18,
          )))
      : Container(
          child: SpinKitCircle(
          color: Colors.white,
          size: 20,
        ));
}

buttonValueWhite(value, status) {
  return status
      ? Text(value,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(
                18,
              ),
              color: Colors.white))
      : Container(
          child: SpinKitCircle(
          color: Colors.white,
          size: 20,
        ));
}
