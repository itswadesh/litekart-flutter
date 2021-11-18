import 'package:shared_preferences/shared_preferences.dart';

 addCookieToSF(cookie) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('cookie', cookie);
}

 getCookieFromSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? cookie = prefs.getString('cookie');
  return cookie;
}

 deleteCookieFromSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  return prefs.remove('cookie');
}

Future<bool> showOnBoardingStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('showOnBoard')) {
    if (prefs.getBool('showOnBoard')!) {
      return true;
    } else {
      changeOnBoardingStatus(false);
      return false;
    }
  }
  changeOnBoardingStatus(false);
  return true;
}

Future<bool> changeOnBoardingStatus(status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  return prefs.setBool('showOnBoard', status);
}
