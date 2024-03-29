import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../enum/tz_dialog_type.dart';
import '../../values/colors.dart';

class TzDialog extends ChangeNotifier {
  BuildContext? context;
  TzDialogType type;
  String? _message;
  bool notificationHandleStatus = false;

  TzDialog(this.context, this.type, [this._message = 'Please wait..']);

  String? get message => _message;

  set message(String? value) {
    this._message = value;
    notifyListeners();
  }

  show() async {
    await showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (context) {
        switch (type) {
          case TzDialogType.progress:
            return loadProgress();
            break;
          case TzDialogType.alert:
            return loadAlert();
            break;
          case TzDialogType.notification:
            return notificationAlert();
            break;
          default:
            return loadProgress();
        }
      },
    );
    return notificationHandleStatus;
  }

  Widget loadProgress() {
    if (Platform.isAndroid) {
      return Dialog(
        child: Container(
          height: 100,
          child:
          new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: new Text(
                  message!,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              new CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(AppColors.primaryElement),
              ),
            ],
          ),
        ),
      );
    } else {
      return CupertinoAlertDialog(
        title: Text(message!),
        content: CupertinoActivityIndicator(
          animating: true,
          radius: 20,
        ),
      );
    }
  }

  Widget loadAlert() {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          height: 150.0,
          width: 200.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      message!,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
              InkWell(
                onTap: close,
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: AppColors.primaryElement,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(
                    child: Text(
                      'Ok',
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget notificationAlert() {
    return WillPopScope(
      child: Platform.isIOS
          ? new CupertinoAlertDialog(
              title: Text("You have a new Notification from $message"),
              content: Text(message!),
              actions: <Widget>[
                TextButton(
                  child: Text('View'),
                  onPressed: () {
                    notificationHandleStatus = true;
                    this.close();
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    notificationHandleStatus = false;
                    this.close();
                  },
                ),
              ],
            )
          : new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: Text("You have a new Notification from $message",
                  style: TextStyle(fontWeight: FontWeight.w500)),
              content: Text(message!),
              actions: <Widget>[
                TextButton(
                  child: Text('View'),
                  onPressed: () {
                    notificationHandleStatus = true;
                    this.close();
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    notificationHandleStatus = false;
                    this.close();
                  },
                ),
              ],
            ),
      onWillPop: () => Future.value(false),
    );
  }

  void close() {
    Navigator.pop(context!);
  }
}
