import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import '../../model/user.dart';
import '../../utility/platform_version.dart';

class FirebaseEvent {
  String appVersion;

  FirebaseEvent() {
    getPackage();
  }

  Future<void> sendAnalyticsEvent(
      {@required String name,
      @required Map<String, dynamic> data,
      @required User user}) async {
    FirebaseAnalytics analytics = FirebaseAnalytics();
    await (PlatformVersion()).getPlatformVersion();
    Map<String, dynamic> _data = {
      'data': data.toString(),
      'user': user?.values.toString(),
      'app_version': appVersion.toString(),
    };

    if (true) {
      await analytics.logEvent(name: name, parameters: _data);
    }
  }

  void getPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    this.appVersion = packageInfo.version;
  }
}
