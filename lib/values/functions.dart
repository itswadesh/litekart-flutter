import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double getAspectRatio(BuildContext context, {double? matchValue}) {
  if (matchValue != null) {
    return MediaQuery.of(context).size.width /
        (MediaQuery.of(context).size.height -
            (MediaQuery.of(context).padding.top + matchValue));
  } else {
    return MediaQuery.of(context).size.width /
        (MediaQuery.of(context).size.height -
            (MediaQuery.of(context).padding.top));
  }
}

String formatString(String source) {
  String _string = source.trim().toLowerCase().replaceAll(' ', '');
  return _string[0].toUpperCase() + _string.substring(1);
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

Widget getVideoAction(
    {required String title,
    required IconData icon,
    required bool isShare,
    Color? color}) {
  return Container(
    margin: EdgeInsets.only(top: 15.0),
    width: 60,
    height: 50,
    child: Column(children: [
      Icon(icon, size: 25.0, color: color ?? Colors.white),
      Padding(
        padding: EdgeInsets.only(top: 3.5),
        child: Text(title,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            )),
      )
    ]),
  );
}

String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

Color hexToColor(String code) {
  //if (code != null) {
    return Color(int.parse(code.replaceAll('#', '0xFF')));
  // } else {
  //   return null;
  // }
}

String getStartEndTime(String start, String end) {
  String courseTime;
  DateFormat dateFormat = DateFormat("HH:mm:ss");
  DateTime startDateTime = dateFormat.parse(start);
  var startTime = DateFormat("h:mm").format(startDateTime);

  String endTime = getTime(end);

  courseTime = startTime + '-' + endTime;
  return courseTime;
}

String getStartEndDate(String start, String end) {
  String courseDate;
  String startDate = getDay(start);
  String endDate = getDay(end);
  String month = getMonth(end);
  courseDate = startDate + '-' + endDate + " " + month;
  return courseDate;
}

String getDates(String start) {
  return getDay(start) + ' ' + getMonth(start);
}

String getDay(String date) {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateTime dy = dateFormat.parse(date);
  var day = DateFormat("dd").format(dy);
  return day;
}

String getMonth(String date) {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateTime mnt = dateFormat.parse(date);
  var mon = DateFormat("MMM").format(mnt);
  return mon;
}

String getTime(String time) {
  DateFormat dateFormat = DateFormat("HH:mm:ss");
  DateTime timeValue = dateFormat.parse(time);
  var tm = DateFormat("h:mma").format(timeValue);
  return tm;
}
