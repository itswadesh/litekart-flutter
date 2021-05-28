// import 'dart:io' show Platform;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:tablez/enum/pk_dialog_type.dart';
// import 'package:tablez/values/colors.dart';
//
// class PkDialog extends ChangeNotifier {
//   BuildContext context;
//   PkDialogType type;
//   String _message;
//
//   PkDialog(this.context, this.type, [this._message = 'Please wait..']);
//
//   String get message => _message;
//
//   set message(String value) {
//     this._message = value;
//     notifyListeners();
//   }
//
//   void show() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         switch (type) {
//           case PkDialogType.progress:
//             return loadProgress();
//             break;
//           case PkDialogType.alert:
//             return loadAlert();
//             break;
//           default:
//             return loadProgress();
//         }
//       },
//     );
//   }
//
//   Widget loadProgress() {
//     if (Platform.isAndroid) {
//       return Dialog(
//         child: Container(
//           height: 100.0,
//           child: new Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(15.0),
//                 child: new Text(
//                   message,
//                   style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                 ),
//               ),
//               new CircularProgressIndicator(
//                 valueColor: new AlwaysStoppedAnimation<Color>(
//                     AppColors.secondaryElement),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return CupertinoAlertDialog(
//         title: Text(message),
//         content: CupertinoActivityIndicator(
//           animating: true,
//           radius: 20,
//         ),
//       );
//     }
//   }
//
//   Widget loadAlert() {
//     return WillPopScope(
//       onWillPop: () => Future.value(false),
//       child: Dialog(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//         child: Container(
//           height: 150.0,
//           width: 200.0,
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: Center(
//                     child: Text(
//                       message,
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   )),
//               InkWell(
//                 onTap: close,
//                 child: Container(
//                   width: 100,
//                   height: 40,
//                   decoration: BoxDecoration(
//                       color: AppColors.secondaryElement,
//                       borderRadius: BorderRadius.all(Radius.circular(20))),
//                   child: Center(
//                     child: Text(
//                       'Ok',
//                       style: TextStyle(fontSize: 14.0, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget loadInstagramFollow(Function onFollow) {
//     return WillPopScope(
//       onWillPop: () => Future.value(false),
//       child: Dialog(
//         shape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//         child: Container(
//           height: 150.0,
//           width: 200.0,
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: Center(
//                     child: Text(
//                       message,
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   )),
//               InkWell(
//                 onTap: onFollow,
//                 child: Container(
//                   width: 100,
//                   height: 40,
//                   decoration: BoxDecoration(
//                       color: AppColors.secondaryElement,
//                       borderRadius: BorderRadius.all(Radius.circular(20))),
//                   child: Center(
//                     child: Text(
//                       'Follow',
//                       style: TextStyle(fontSize: 14.0, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void close() {
//     Navigator.pop(context);
//   }
// }
