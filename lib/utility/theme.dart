import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeApp {
  heading1Theme() {
    return TextStyle(fontSize: 30, fontWeight: FontWeight.w900);
  }

  heading2Theme() {
    return TextStyle(fontSize: 25, fontWeight: FontWeight.w800);
  }

  heading3Theme() {
    return TextStyle(fontSize: 25);
  }

  heading4Theme() {
    return TextStyle(
        color: Colors.purple, fontWeight: FontWeight.w900, fontSize: 22);
  }

  heading5lightTheme() {
    return TextStyle(fontWeight: FontWeight.w400, fontSize: 22);
  }

  heading5SemiTheme() {
    return TextStyle(fontWeight: FontWeight.w600, fontSize: 22);
  }

  heading5BoldTheme() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 22);
  }

  heading5BoldThemeGrey() {
    return TextStyle(
        color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 22);
  }

  heading6Theme() {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18);
  }

  heading6ThemeGrey() {
    return TextStyle(
        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18);
  }

  textTimerHeading() {
    return TextStyle(
        color: Colors.purple, fontWeight: FontWeight.w800, fontSize: 18);
  }

  textTheme() {
    return TextStyle(fontSize: 14);
  }

  textThemeSmall() {
    return TextStyle(fontSize: 11);
  }

  textThemeGrey() {
    return TextStyle(
        color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500);
  }

  textThemeGreySmall() {
    return TextStyle(
        color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500);
  }

  textButtonCard() {
    return TextStyle(
        color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500);
  }

  textThemeSemiGrey() {
    return TextStyle(
        color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600);
  }

  textThemeSemiGreySmall() {
    return TextStyle(
        color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600);
  }

  textWhiteTheme() {
    return TextStyle(
      color: Colors.white,
    );
  }

  appBarTheme() {
    return TextStyle(
        fontSize: ScreenUtil().setWidth(21), color: Color(0xff616161));
  }

  textBoldTheme() {
    return TextStyle(fontWeight: FontWeight.bold);
  }

  textBolderTheme() {
    return TextStyle(fontWeight: FontWeight.w900);
  }

  textSemiBoldTheme() {
    return TextStyle(fontWeight: FontWeight.w600, color: Colors.black);
  }

  textSemiBoldThemeSmall() {
    return TextStyle(
        fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black);
  }

  textBoldWhiteTheme() {
    return TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
  }

  textBoldLinkTheme() {
    return TextStyle(fontWeight: FontWeight.bold, color: Colors.blue);
  }

  imageStackTextTheme() {
    return TextStyle(
        fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15);
  }

  buttonTextTheme() {
    return TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  }

  textThemeClassCardTitle() {
    return TextStyle(color: Colors.amber, fontWeight: FontWeight.bold);
  }

  textThemeOrange() {
    return TextStyle(color: Color(0xffee7625), fontSize: 12);
  }

  textThemePurpleSmall() {
    return TextStyle(color: Colors.purple, fontSize: 12);
  }

  textThemeSemiPurpleSmall() {
    return TextStyle(
        color: Colors.purple, fontSize: 12, fontWeight: FontWeight.w600);
  }

  subsTitle() {
    return TextStyle(
        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16);
  }

  subsSubtitle() {
    return TextStyle(
        color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16);
  }

  subsBottom() {
    return TextStyle(color: Colors.white, fontSize: 12);
  }

  homeHeaderThemeText(colorSelected, size, status) {
    if (status) {
      return TextStyle(
          color: colorSelected,
          fontSize: ScreenUtil().setSp(
            size,
          ));
    } else {
      return TextStyle(
          color: Colors.black54,
          fontSize: ScreenUtil().setSp(
            size,
          ),
          fontWeight: FontWeight.w500);
    }
  }
}
