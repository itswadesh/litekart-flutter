//
//  video_talk_view_object.dart
//  zego-express-example-topics-flutter
//
//  Created by Patrick Fu on 2020/11/19.
//  Copyright © 2020 Zego. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class VideoTalkViewObject {

  final bool isLocal;
  final String streamID;

  int viewID;
  Widget view;

  VideoTalkViewObject(this.isLocal, this.streamID);

  void init(Function() completed) {
    print("createPlatformView start");
    this.view = ZegoExpressEngine.instance.createPlatformView((viewID) {
      print("createPlatformView finish, viewID: $viewID");
      this.viewID = viewID;
      completed();
    });
  }

  void uninit() {
    ZegoExpressEngine.instance.destroyPlatformView(this.viewID);
  }
}