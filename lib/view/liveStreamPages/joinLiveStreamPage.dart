
import 'package:anne/response_handler/channelResponse.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';


class JoinLiveStreamPlayerPage extends StatefulWidget{
  final ChannelData? channelData;
  JoinLiveStreamPlayerPage(this.channelData);
  @override
  State<StatefulWidget> createState() {
    return _JoinLiveStreamPlayerPage();
  }

}

class _JoinLiveStreamPlayerPage extends State<JoinLiveStreamPlayerPage>{

  ChannelData? channelData;
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
                    channelData!.title!,
                    style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: ScreenUtil().setSp(
                          21,
                        ),
                    ),
                    textAlign: TextAlign.center,
                  )
          ),
          body: Container(
              width: MediaQuery.of(context).size.width,
              child: StreamPlayerPage(
            videoPlayerController: VideoPlayerController.network(channelData!.httpPullUrl!),
          ))
        );
  }
}

class StreamPlayerPage extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool? looping;

  const StreamPlayerPage(
      {Key? key, required this.videoPlayerController, this.looping})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StreamPlayerState();
  }

}

class _StreamPlayerState extends State<StreamPlayerPage> {
  late ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      //aspectRatio: widget.videoPlayerController.value.size.aspectRatio,
      aspectRatio: 20 / 9,
      autoInitialize: true,
      autoPlay: true,
     isLive: true,
     // looping: widget.looping,
    //  showControls: false,
     // showControlsOnInitialize: false,
    //  showOptions: false,
      errorBuilder: (context, errorMessage){
        return Center(
          child: Text(
            errorMessage,style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
   // _chewieController.setVolume(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _chewieController,);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }

}