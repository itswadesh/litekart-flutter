
import 'package:anne/response_handler/channelResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../brand_page.dart';

class JoinLiveStreamPlayerPage extends StatefulWidget{
  final ChannelData channelData;
  JoinLiveStreamPlayerPage(this.channelData);
  @override
  State<StatefulWidget> createState() {
    return _JoinLiveStreamPlayerPage();
  }

}

class _JoinLiveStreamPlayerPage extends State<JoinLiveStreamPlayerPage>{

  ChannelData channelData;
  @override
  void initState() {
    channelData = widget.channelData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              title:  Text(
                    channelData.title,
                    style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: ScreenUtil().setSp(
                          21,
                        ),
                    ),
                    textAlign: TextAlign.center,
                  )
          ),
          body: ChewieClass(
            videoPlayerController: VideoPlayerController.network(channelData.httpPullUrl),
            looping: true,
          )
        );
  }
}