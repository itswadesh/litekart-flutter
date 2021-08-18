import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../model/base/dynamic_routes.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/api_provider.dart';
import '../../utility/home_route_handler.dart';
import '../../utility/locator.dart';
import '../../utility/platform_version.dart';
import '../../values/route_path.dart' as routes;

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class PushNotificationService {
  //
  String platform;
  String deviceId;

  PushNotificationService() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      await serialiseAndNavigate(message);
    });

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await serialiseAndNavigate(message);
    });
  }

  Future<bool> initialise() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    if (Platform.isIOS) {
      _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
    Map<String, dynamic> device =
        await (PlatformVersion()).getPlatformVersion();
    platform = device['platform'];
    deviceId = device['id'];

    String fcmToken;
    try {
      fcmToken = await _fcm.getToken();
      bool tokenPresent = await (ApiProvider().myToken(0, "", 0, ""));
      if (!tokenPresent) {
        if (fcmToken != null && fcmToken.isNotEmpty) {
          QueryResult response = await (ApiProvider()
              .saveFcmToken("new", fcmToken, platform, deviceId, true));

          if (!response.hasException) {
            debugPrint('Notification enabled');
            return true;
          } else {
            debugPrint('Fails notification enabling');
            return false;
          }
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('e => $e');
      return false;
    }
  }
//

}

Future<void> serialiseAndNavigate(RemoteMessage message) async {
  print("message : " + message.data.toString());
  var target, type, args;
  if (Platform.isAndroid) {
    var notificationData = message.data;
    target = notificationData['target'];
    type = notificationData['type'];
    args = notificationData['args'];
  } else {
    target = message.data['target'];
    type = message.data['type'];
    args = message.data['args'];
  }

  if (target != null && type != null) {
    try {
      Map<String, dynamic> _args;

      if (args is String) {
        _args = jsonDecode(args);
      } else {
        _args = args;
      }

      Map<String, dynamic> params = {'target': target, 'type': type};

      if (_args != null) {
        params['args'] = _args;
      }

      DynamicRoute homeRoute = DynamicRoute.fromMap(params);
      await dynamicRouteHandler(homeRoute);
    } catch (e) {
      locator<NavigationService>()?.pushNamed(routes.HomeRoute);
    }
  }
}
