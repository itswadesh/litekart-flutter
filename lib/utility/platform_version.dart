import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';

class PlatformVersion {
  Future<Map<String, dynamic>> getPlatformVersion() async {
    Map<String, dynamic> result;
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      result = {
        'platform': 'android',
        'version': androidInfo.version.release,
        'manufacturer': androidInfo.manufacturer,
        'model': androidInfo.model,
        'id': androidInfo.androidId
      };
      // Android 9 (SDK 28), Xiaomi Redmi Note 7
    } else {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      result = {
        'platform': 'ios',
        'version': iosInfo.systemVersion,
        'manufacturer': iosInfo.name,
        'model': iosInfo.model,
        'id': iosInfo.identifierForVendor
      };
      // iOS 13.1, iPhone 11 Pro Max iPhone
    }

    return result;
  }
}
