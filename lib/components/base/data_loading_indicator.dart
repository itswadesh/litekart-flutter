import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../values/colors.dart';

void onLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Platform.isAndroid
          ? Dialog(
              child: Container(
                height: 100.0,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: new Text(
                        "Please wait...",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    new CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          AppColors.primaryElement),
                    ),
                  ],
                ),
              ),
            )
          : CupertinoAlertDialog(
              title: Text('Please Wait...'),
              content: CupertinoActivityIndicator(
                animating: true,
                radius: 20,
              ),
            );
    },
  );
}
