import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import '../../values/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAlert {
  Future versionCheck(BuildContext context) async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));
    final RemoteConfig remoteConfig = RemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      double newVersionAndroid = double.parse(remoteConfig
          .getString('app_version_android')
          .trim()
          .replaceAll(".", ""));
      double newVersionIos = double.parse(
          remoteConfig.getString('app_version_ios').trim().replaceAll(".", ""));

      String appStoreUrl, playStoreUrl;
      appStoreUrl = remoteConfig.getString('app_store_url').trim();
      playStoreUrl = remoteConfig.getString('play_store_url').trim();

      if (appStoreUrl.isEmpty) appStoreUrl = APP_STORE_URL;

      if (appStoreUrl.isEmpty) playStoreUrl = PLAY_STORE_URL;

      bool dismiss = Platform.isAndroid
          ? remoteConfig.getBool('android_dismiss')
          : Platform.isIOS
              ? remoteConfig.getBool('ios_dismiss')
              : true;
      if (Platform.isAndroid) {
        if (newVersionAndroid > currentVersion) {
          _showVersionDialog(context, dismiss, playStoreUrl);
          debugPrint('Have an update');
        }
      } else {
        if (newVersionIos > currentVersion) {
          _showVersionDialog(context, dismiss, appStoreUrl);
          debugPrint('Have an update');
        }
      }
    } on PlatformException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      debugPrint(
          'Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  _showVersionDialog(context, bool dismiss, String url) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: dismiss,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        return WillPopScope(
            child: Platform.isIOS
                ? new CupertinoAlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      TextButton(
                        child: Text(btnLabel),
                        onPressed: () => _launchURL(url),
                      ),
                    ],
                  )
                : new AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: Text(title,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    content: Text(message),
                    actions: <Widget>[
                      TextButton(
                        child: Text(btnLabel),
                        onPressed: () => _launchURL(url),
                      ),
                    ],
                  ),
            onWillPop: () async {
              return dismiss;
            });
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
