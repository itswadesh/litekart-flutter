import 'package:flutter/material.dart';
import '../../model/user.dart';
import 'firebase_event.dart';

class Tracking {
  String event;
  Map<String, dynamic> data;
  User user;

  Tracking({@required this.event, this.data, this.user}) {
    try {
      (FirebaseEvent()).sendAnalyticsEvent(
          name: event.trim().toLowerCase().replaceAll(' ', '_'),
          data: data,
          user: user);
    } catch (e) {
      print(e);
    }
  }
}
