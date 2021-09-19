import 'package:anne/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SpinKitRing(
              lineWidth: 1,
              color: Color(0xff858585),
              size: 40.0,
            )
            // SpinKitSquareCircle(
            //   color: AppColors.primaryElement,
            //   size: 40.0,
            // ),
          ],
        ),
      ),
    );
  }
}
