
import 'dart:io';
import '../../enum/streamOptions.dart';
import '../liveStreamPages/joinStream.dart';
import 'package:permission_handler/permission_handler.dart';
import 'createStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class LiveStreamSetUp {


  Future<void> startRTC(BuildContext context,String cid, int uid,String joinStatus) async {

    final permissions = [Permission.camera, Permission.microphone];
    if (Platform.isAndroid) {
      permissions.add(Permission.storage);
    }
    List<Permission> missed = [];
    for (var permission in permissions) {
      PermissionStatus status = await permission.status;
      if (status != PermissionStatus.granted) {
        missed.add(permission);
      }
    }

    bool allGranted = missed.isEmpty;
    if (!allGranted) {
      List<Permission> showRationale = [];
      for (var permission in missed) {
        bool isShown = await permission.shouldShowRequestRationale;
        if (isShown) {
          showRationale.add(permission);
        }
      }

      if (showRationale.isNotEmpty) {
        ConfirmAction action = await showDialog<ConfirmAction>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text('You need to allow some permissions'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(ConfirmAction.CANCEL);
                    },
                  ),
                  FlatButton(
                    child: const Text('Accept'),
                    onPressed: () {
                      Navigator.of(context).pop(ConfirmAction.ACCEPT);
                    },
                  )
                ],
              );
            });
        if (action == ConfirmAction.ACCEPT) {
          Map<Permission, PermissionStatus> allStatus = await missed.request();
          allGranted = true;
          for (var status in allStatus.values) {
            if (status != PermissionStatus.granted) {
              allGranted = false;
            }
          }
        }
      } else {
        Map<Permission, PermissionStatus> allStatus = await missed.request();
        allGranted = true;
        for (var status in allStatus.values) {
          if (status != PermissionStatus.granted) {
            allGranted = false;
          }
        }
      }
    }

    if (!allGranted) {
      openAppSettings();
    } else {
      if (joinStatus == "start") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CallPage(
                      cid: cid,
                      uid: uid,
                    )));
      }
      else{
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    JoinStreamPage(
                      cid: cid,
                      uid: uid,
                    )));
      }
    }
  }
}