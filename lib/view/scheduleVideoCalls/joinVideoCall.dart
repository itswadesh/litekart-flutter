import 'dart:io';

import 'package:anne/repository/channel_repository.dart';
import 'package:anne/repository/schedule_repository.dart';
import 'package:anne/response_handler/channelResponse.dart';
import 'package:anne/response_handler/scheduleResponse.dart';
import 'package:anne/values/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'settings.dart';
import 'utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nertc/nertc.dart';


class JoinVideoCallPage extends StatefulWidget {
  final String? cid;
  final ScheduleData? channelData;

  JoinVideoCallPage({Key? key, required this.cid, this.channelData});

  @override
  _JoinVideoCallPageState createState() {
    return _JoinVideoCallPageState();
  }
}

class _JoinVideoCallPageState extends State<JoinVideoCallPage>
    with
        NERtcChannelEventCallback,
        NERtcStatsEventCallback,
        NERtcDeviceEventCallback {
  late Settings _settings;
  ScheduleData? scheduleData;
  NERtcEngine _engine = NERtcEngine();
  List<_UserSession> _remoteSessions =[];
  _UserSession _localSession = _UserSession();

  bool _showControlPanel = false;
  late var neteaseData ;
  // Control 1
  bool isAudioEnabled = false;
  bool isVideoEnabled = false;
  bool isFrontCamera = true;
  bool isFrontCameraMirror = true;
  bool isSpeakerphoneOn = false;

  // Control 2
  bool isAudioDumpEnabled = false;
  bool isEarBackEnabled = false;
  bool isScreenRecordEnabled = false;

  // Control 3
  bool isLeaveChannel = false;
  bool isAudience = false;
  bool isAudioMixPlaying = false;
  bool isAudioEffectPlaying = false;

  // Control 4
  bool isMuteAudio = false;
  bool isMuteVideo = false;
  bool isMuteMic = false;
  bool isMuteSpeaker = false;
  bool isSubAllAudio = true;

  @override
  void initState() {
    scheduleData = widget.channelData;
    super.initState();
    _initSettings().then((value) => _initRtcEngine());
  }

  Future<void> _initSettings() async {
    _settings = await Settings.getInstance();
    isAudioEnabled = _settings.autoEnableAudio;
    isVideoEnabled = _settings.autoEnableVideo;
    isFrontCamera = _settings.frontFacingCamera;
    isFrontCameraMirror = _settings.frontFacingCameraMirror;
  }

  Future<void> updateSettings() async {
    isSpeakerphoneOn = await _engine.deviceManager.isSpeakerphoneOn();
    _showControlPanel = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(scheduleData!.title!),
        ),
        body: buildCallingWidget(context),
      ),
      // ignore: missing_return
      onWillPop: () =>
        _requestPop()
      ,
    );
  }

  Widget buildControlButton(VoidCallback onPressed, Widget child) {
    return RaisedButton(
      onPressed: onPressed,
      child: child,
    );
  }

  Widget buildCallingWidget(BuildContext context) {
    return Stack(children: <Widget>[
      buildVideoViews(context),
      if (_showControlPanel) buildControlPanel(context)
    ]);
  }

  Widget buildControlPanel(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
       // buildControlPanel1(context),
        // buildControlPanel2(context),
        buildControlPanel3(context),
        SizedBox(height: 10,),
        buildControlPanel4(context),
        SizedBox(height: 30,)
      ],
    );
  }

  Widget buildControlPanel3(BuildContext context) {
    List<Widget> children = [];
    children.add(Expanded(
        child:
        InkWell(
            onTap: () {
              bool muteAudio = !isMuteAudio;
              _engine.muteLocalAudioStream(muteAudio).then((value) {
                if (value == 0) {
                  setState(() {
                    isMuteAudio = muteAudio;
                  });
                }
              });
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(
                    0, 0, ScreenUtil().setWidth(8), 0),
                width: ScreenUtil().radius(45),
                height: ScreenUtil().radius(45),
                decoration: new BoxDecoration(
                  color: Color(0xffffffff),
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0xffffffff),
                          width: ScreenUtil().setWidth(0.4)),
                      top: BorderSide(
                          color: Color(0xffffffff),

                          width: ScreenUtil().setWidth(0.4)),
                      left: BorderSide(
                          color: Color(0xffffffff),

                          width: ScreenUtil().setWidth(0.4)),
                      right: BorderSide(
                          color: Color(0xffffffff),

                          width: ScreenUtil().setWidth(0.4))),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isMuteAudio ? Icons.headset_off : Icons.headset,
                  color: Color(0xff454545),
                  size: ScreenUtil().setWidth(18),
                ))),

        ));
    children.add(Expanded(
        child:
        InkWell(
            onTap: () {
              bool muteVideo = !isMuteVideo;
              _engine.muteLocalVideoStream(muteVideo).then((value) {
                if (value == 0) {
                  setState(() {
                    isMuteVideo = muteVideo;
                  });
                }
              });
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(
                    0, 0, ScreenUtil().setWidth(8), 0),
                width: ScreenUtil().radius(45),
                height: ScreenUtil().radius(45),
                decoration: new BoxDecoration(
                  color: Color(0xffffffff),
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0xffffffff),
                          width: ScreenUtil().setWidth(0.4)),
                      top: BorderSide(
                          color: Color(0xffffffff),

                          width: ScreenUtil().setWidth(0.4)),
                      left: BorderSide(
                          color: Color(0xffffffff),

                          width: ScreenUtil().setWidth(0.4)),
                      right: BorderSide(
                          color: Color(0xffffffff),

                          width: ScreenUtil().setWidth(0.4))),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isMuteVideo ? Icons.videocam_off_outlined : Icons.videocam_outlined,
                  color: Color(0xff454545),
                  size: ScreenUtil().setWidth(18),
                ))),
       ));
    children.add(Expanded(
        child:
        InkWell(
            onTap: () {
              bool muteMic = !isMuteMic;
              _engine.deviceManager.setRecordDeviceMute(muteMic).then((value) {
                if (value == 0) {
                  setState(() {
                    isMuteMic = muteMic;
                  });
                }
              });
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(
                    0, 0, ScreenUtil().setWidth(8), 0),
                width: ScreenUtil().radius(45),
                height: ScreenUtil().radius(45),
                decoration: new BoxDecoration(
                  color: Color(0xffffffff),
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0xffffffff),
                          width: ScreenUtil().setWidth(0.4)),
                      top: BorderSide(
                          color: Color(0xffffffff),

                          width: ScreenUtil().setWidth(0.4)),
                      left: BorderSide(
                          color: Color(0xffffffff),

                          width: ScreenUtil().setWidth(0.4)),
                      right: BorderSide(
                          color: Color(0xffffffff),

                          width: ScreenUtil().setWidth(0.4))),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isMuteMic ? Icons.mic_off_outlined : Icons.mic_none,
                  color: Color(0xff454545),
                  size: ScreenUtil().setWidth(18),
                ))),
        ));
   children.add( Expanded(
        child:
        InkWell(
            onTap: () {
              _engine.deviceManager.switchCamera().then((value) {
                if (value == 0) {
                  isFrontCamera = !isFrontCamera;
                  _localSession.renderer!
                      .setMirror(isFrontCamera && isFrontCameraMirror);
                }
              });
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(
                    0, 0, ScreenUtil().setWidth(8), 0),
                width: ScreenUtil().radius(45),
                height: ScreenUtil().radius(45),
                decoration: new BoxDecoration(
                  color: Color(0xffffffff),
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0xffffffff),
                          width: ScreenUtil().setWidth(0.4)),
                      top: BorderSide(
                          color: Color(0xffffffff),

                          width: ScreenUtil().setWidth(0.4)),
                      left: BorderSide(
                          color: Color(0xffffffff),

                          width: ScreenUtil().setWidth(0.4)),
                      right: BorderSide(
                          color: Color(0xffffffff),

                          width: ScreenUtil().setWidth(0.4))),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cameraswitch_outlined,
                  color: Color(0xff454545),
                  size: ScreenUtil().setWidth(18),
                ))),));

    // children.add(Expanded(
    //     child: buildControlButton(
    //           () {
    //         bool muteSpeaker = !isMuteSpeaker;
    //         _engine.deviceManager.setPlayoutDeviceMute(muteSpeaker).then((value) {
    //           if (value == 0) {
    //             setState(() {
    //               isMuteSpeaker = muteSpeaker;
    //             });
    //           }
    //         });
    //       },
    //       Text(
    //         isMuteSpeaker ? 'UnMute Speaker' : 'Mute Speaker',
    //         style: TextStyle(fontSize: 10),
    //       ),
    //     )));

    return Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ));
  }

  Widget buildControlPanel4(BuildContext context) {
    List<Widget> children = [];

      children.add(Expanded(
          child:
          InkWell(
              onTap: () {
                _engine.leaveChannel().then((value) {

                });
                _requestPop();
              },
              child: Container(
                  margin: EdgeInsets.fromLTRB(
                      0, 0, ScreenUtil().setWidth(8), 0),
                  width: ScreenUtil().radius(45),
                  height: ScreenUtil().radius(45),
                  decoration: new BoxDecoration(
                    color: AppColors.primaryElement,
                    border: Border(
                        bottom: BorderSide(
                            color: AppColors.primaryElement,
                            width: ScreenUtil().setWidth(0.4)),
                        top: BorderSide(
                            color: AppColors.primaryElement,

                            width: ScreenUtil().setWidth(0.4)),
                        left: BorderSide(
                            color: AppColors.primaryElement,

                            width: ScreenUtil().setWidth(0.4)),
                        right: BorderSide(
                            color: AppColors.primaryElement,

                            width: ScreenUtil().setWidth(0.4))),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: ScreenUtil().setWidth(18),
                  ))),

          ));

    // children.add(Expanded(
    //     child: buildControlButton(
    //           () {
    //         bool leaveChannel = !isLeaveChannel;
    //         if (leaveChannel) {
    //           _engine.leaveChannel().then((value) {
    //             if (value == 0) {
    //               setState(() {
    //                 isLeaveChannel = leaveChannel;
    //               });
    //             }
    //           });
    //         } else {
    //           _initCallbacks()
    //              .then((value) => _initAudio())
    //              .then((value) => _initVideo())
    //               .then((value) => _initRenderer())
    //               .then((value) => _engine.joinChannel('', widget.cid!, neteaseData["value"]["uid"]))
    //               .then((value) {
    //             if (value == 0) {
    //               setState(() {
    //                 isLeaveChannel = leaveChannel;
    //               });
    //             }
    //           });
    //         }
    //       },
    //       Text(
    //         isLeaveChannel ? 'Join Room' : 'Leave Room',
    //         style: TextStyle(fontSize: 12),
    //       ),
    //     )));
    // children.add(Expanded(
    //     child: buildControlButton(
    //           () {
    //         bool audience = !isAudience;
    //         _engine
    //             .setClientRole(
    //             audience ? NERtcUserRole.audience : NERtcUserRole.broadcaster)
    //             .then((value) {
    //           if (value == 0) {
    //             setState(() {
    //               isAudience = audience;
    //             });
    //           }
    //         });
    //       },
    //       Text(
    //         isAudience ? 'Cut Anchor' : 'Cut The Audience',
    //         style: TextStyle(fontSize: 12),
    //       ),
    //     )));

    // children.add(Expanded(
    //     child: buildControlButton(
    //           () {
    //         bool playAudioMixing = !isAudioMixPlaying;
    //         if (playAudioMixing) {
    //           String path = _settings.audioMixingFileUrl.isNotEmpty
    //               ? _settings.audioMixingFileUrl
    //               : _settings.audioEffectFilePath;
    //           NERtcAudioMixingOptions options = NERtcAudioMixingOptions(
    //               path: path,
    //               sendEnabled: _settings.audioMixingSendEnabled,
    //               playbackEnabled: _settings.audioMixingPlayEnabled);
    //           _engine.audioMixingManager.startAudioMixing(options).then((value) {
    //             if (value == 0) {
    //               setState(() {
    //                 isAudioMixPlaying = playAudioMixing;
    //               });
    //             }
    //           });
    //         } else {
    //           _engine.audioMixingManager.stopAudioMixing().then((value) {
    //             if (value == 0) {
    //               setState(() {
    //                 isAudioMixPlaying = playAudioMixing;
    //               });
    //             }
    //           });
    //         }
    //       },
    //       Text(
    //         isAudioMixPlaying ? 'End Sound' : 'Start Sound',
    //         style: TextStyle(fontSize: 12),
    //       ),
    //     )));
    // if (Platform.isAndroid) {
    //   children.add(Expanded(
    //       child: buildControlButton(
    //             () {
    //           bool playAudioEffect = !isAudioEffectPlaying;
    //           if (playAudioEffect) {
    //             NERtcAudioEffectOptions options =
    //             NERtcAudioEffectOptions(path: _settings.audioEffectFilePath);
    //             _engine.audioEffectManager.playEffect(1, options).then((value) {
    //               if (value == 0) {
    //                 setState(() {
    //                   isAudioEffectPlaying = playAudioEffect;
    //                 });
    //               }
    //             });
    //           } else {
    //             _engine.audioEffectManager.stopEffect(1).then((value) {
    //               if (value == 0) {
    //                 setState(() {
    //                   isAudioEffectPlaying = playAudioEffect;
    //                 });
    //               }
    //             });
    //           }
    //         },
    //         Text(
    //           isAudioEffectPlaying ? 'End Sound' : 'Start Sound',
    //           style: TextStyle(fontSize: 12),
    //         ),
    //       )));
    // }
    return Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ));
  }

  // Widget buildControlPanel1(BuildContext context) {
  //   return Container(
  //       height: 40,
  //       child: Row(
  //         children: [
  //           // Expanded(
  //           //     child: buildControlButton(
  //           //           () {
  //           //         bool audioEnabled = !isAudioEnabled;
  //           //         _engine.enableLocalAudio(audioEnabled).then((value) {
  //           //           if (value == 0) {
  //           //             setState(() {
  //           //               isAudioEnabled = audioEnabled;
  //           //             });
  //           //           }
  //           //         });
  //           //       },
  //           //       Text(
  //           //         isAudioEnabled ? 'Turn Off Voice' : 'Turn On Voice',
  //           //         style: TextStyle(fontSize: 12),
  //           //       ),
  //           //     )),
  //           // Expanded(
  //           //     child: buildControlButton(
  //           //           () {
  //           //         bool videoEnabled = !isVideoEnabled;
  //           //         _engine.enableLocalVideo(videoEnabled).then((value) {
  //           //           if (value == 0) {
  //           //             setState(() {
  //           //               isVideoEnabled = videoEnabled;
  //           //             });
  //           //           }
  //           //         });
  //           //       },
  //           //       Text(
  //           //         isVideoEnabled ? 'Close Video' : 'Open Video',
  //           //         style: TextStyle(fontSize: 12),
  //           //       ),
  //           //     )),
  //           // Expanded(
  //           //     child: buildControlButton(
  //           //           () {
  //           //         _engine.deviceManager.switchCamera().then((value) {
  //           //           if (value == 0) {
  //           //             isFrontCamera = !isFrontCamera;
  //           //             _localSession.renderer!
  //           //                 .setMirror(isFrontCamera && isFrontCameraMirror);
  //           //           }
  //           //         });
  //           //       },
  //           //       Text(
  //           //         'Switch Camera',
  //           //         style: TextStyle(fontSize: 12),
  //           //       ),
  //           //     )),
  //           // Expanded(
  //           //     child: buildControlButton(
  //           //           () {
  //           //         bool speakerphoneOn = !isSpeakerphoneOn;
  //           //         _engine.deviceManager
  //           //             .setSpeakerphoneOn(speakerphoneOn)
  //           //             .then((value) {
  //           //           if (value == 0) {
  //           //             setState(() {
  //           //               isSpeakerphoneOn = speakerphoneOn;
  //           //             });
  //           //           }
  //           //         });
  //           //       },
  //           //       Text(
  //           //         isSpeakerphoneOn ? 'Turn Off The Speaker' : 'Turn On The Speaker',
  //           //         style: TextStyle(fontSize: 12),
  //           //       ),
  //           //     )),
  //         ],
  //       ));
  // }

  // Widget buildControlPanel2(BuildContext context) {
  //   List<Widget> children = [];
  //   children.add(Expanded(
  //       child: buildControlButton(
  //             () {
  //           bool audioDumpEnabled = !isAudioDumpEnabled;
  //           if (audioDumpEnabled) {
  //             _engine.startAudioDump().then((value) {
  //               if (value == 0) {
  //                 setState(() {
  //                   isAudioDumpEnabled = audioDumpEnabled;
  //                 });
  //               }
  //             });
  //           } else {
  //             _engine.stopAudioDump().then((value) {
  //               if (value == 0) {
  //                 setState(() {
  //                   isAudioDumpEnabled = audioDumpEnabled;
  //                 });
  //               }
  //             });
  //           }
  //         },
  //         Text(
  //           isAudioDumpEnabled ? 'Recording Off' : 'Recording On',
  //           style: TextStyle(fontSize: 12),
  //         ),
  //       )));
  //   children.add(Expanded(
  //       child: buildControlButton(
  //             () {
  //           bool earBackEnabled = !isEarBackEnabled;
  //           _engine.deviceManager.enableEarBack(earBackEnabled, 100).then((value) {
  //             if (value == 0) {
  //               setState(() {
  //                 isEarBackEnabled = earBackEnabled;
  //               });
  //             }
  //           });
  //         },
  //         Text(
  //           isEarBackEnabled ? 'Ear Return' : 'Ear Back Off',
  //           style: TextStyle(fontSize: 12),
  //         ),
  //       )));
  //   if (Platform.isAndroid) {
  //     children.add(Expanded(
  //         child: buildControlButton(
  //               () {
  //             bool screenRecordEnabled = !isScreenRecordEnabled;
  //             if (screenRecordEnabled) {
  //               NERtcScreenConfig config = NERtcScreenConfig();
  //               config.contentPrefer = _settings.screenContentPrefer;
  //               _engine.startScreenCapture(config).then((value) {
  //                 if (value == 0) {
  //                   setState(() {
  //                     isScreenRecordEnabled = screenRecordEnabled;
  //                   });
  //                 }
  //               });
  //             } else {
  //               _engine.stopScreenCapture().then((value) {
  //                 if (value == 0) {
  //                   setState(() {
  //                     isScreenRecordEnabled = screenRecordEnabled;
  //                   });
  //                 }
  //               });
  //             }
  //           },
  //           Text(
  //             isScreenRecordEnabled ? 'Screen Recording Off' : 'Screen Recording On',
  //             style: TextStyle(fontSize: 12),
  //           ),
  //         )));
  //   }
  //   children.add(Expanded(
  //       child: buildControlButton(
  //             () {
  //           _engine.uploadSdkInfo().then((value) {
  //             Fluttertoast.showToast(
  //                 msg: 'upload sdk info result:$value',
  //                 gravity: ToastGravity.CENTER);
  //           });
  //         },
  //         Text(
  //           'Upload Log',
  //           style: TextStyle(fontSize: 12),
  //         ),
  //       )));
  //   return Container(
  //       height: 40,
  //       child: Row(
  //         children: children,
  //       ));
  // }

  Widget buildVideoViews(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: _remoteSessions.length!=0?buildVideoView(context, _remoteSessions.first):buildVideoView(context, _localSession),
    );
      // GridView.builder(
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 3,
      //       childAspectRatio: 9 / 16,
      //       crossAxisSpacing: 2.0,
      //       mainAxisSpacing: 2.0),
      //   itemCount: _remoteSessions.length + 1,
      //   itemBuilder: (BuildContext context, int index) {
      //     if (index == 0) {
      //       return buildVideoView(context, _localSession);
      //     } else {
      //       return buildVideoView(context, _remoteSessions[index - 1]);
      //     }
      //   });
  }

  Widget buildVideoView(BuildContext context, _UserSession session) {
    return Container(
      child: Stack(
        children: [
          session.renderer != null
              ? NERtcVideoView(session.renderer!)
              : Container(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       session.subStream ? '${session.uid} @ Sub' : '${session.uid}',
          //       style: TextStyle(color: Colors.red, fontSize: 10),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }

   _requestPop() {
    Navigator.pop(context);
  }

  void _initRtcEngine() async {
    ScheduleRepository scheduleRepository = ScheduleRepository();

     neteaseData = await scheduleRepository.neteaseToken(scheduleData!.id);

    _localSession.uid = neteaseData["value"]["uid"];
    NERtcOptions options = NERtcOptions(
        audioAutoSubscribe: _settings.autoSubscribeAudio,
        serverRecordSpeaker: _settings.serverRecordSpeaker,
        serverRecordAudio: _settings.serverRecordAudio,
        serverRecordVideo: _settings.serverRecordVideo,
        serverRecordMode:
        NERtcServerRecordMode.values[_settings.serverRecordMode],
        videoSendMode: NERtcVideoSendMode.values[_settings.videoSendMode],
        videoEncodeMode:
        NERtcMediaCodecMode.values[_settings.videoEncodeMediaCodecMode],
        videoDecodeMode:
        NERtcMediaCodecMode.values[_settings.videoDecodeMediaCodecMode]);
    // 错误异常需要处理
   // _engine.joinChannel('', widget.cid, widget.uid);
    _engine
        .create(
        appKey: neteaseData["value"]["appkey"],
        channelEventCallback: this,
        options: options)
        .then((value) => _initCallbacks())
        .then((value) => _initAudio())
        .then((value) => _initVideo())
        .then((value) => _initRenderer())
        .then((value) => _engine.joinChannel(neteaseData["value"]["token"], widget.cid!, neteaseData["value"]["uid"]))
        .catchError((e) {
      Fluttertoast.showToast(
          msg: 'catchError:' + e, gravity: ToastGravity.CENTER);
    });
  }

  Future<int> _initCallbacks() async {
    await _engine.setStatsEventCallback(this);
    return _engine.deviceManager.setEventCallback(this);
  }

    Future<int> _initAudio() async {
    await _engine.enableLocalAudio(isAudioEnabled);
    return _engine.setAudioProfile(
        NERtcAudioProfile.values[_settings.audioProfile],
        NERtcAudioScenario.values[_settings.audioScenario]);
  }

  Future<int> _initVideo() async {
    await _engine.enableLocalVideo(isVideoEnabled);
    await _engine.enableDualStreamMode(_settings.enableDualStreamMode);
    NERtcVideoConfig config = NERtcVideoConfig();
    config.videoProfile = _settings.videoProfile;
    config.frameRate = _settings.videoFrameRate;
    config.degradationPrefer = _settings.degradationPreference;
    config.frontCamera = _settings.frontFacingCamera;
    config.videoCropMode = _settings.videoCropMode;
    return _engine.setLocalVideoConfig(config);
  }

  Future<void> _initRenderer() async {
    _localSession.renderer = await VideoRendererFactory.createVideoRenderer();
    _localSession.renderer!.setMirror(isFrontCamera && isFrontCameraMirror);
    _localSession.renderer!.attachToLocalVideo();
    setState(() {});
  }


  void _releaseRtcEngine() {
    _engine.release();
  }

  void _leaveChannel() {
    _engine.enableLocalVideo(false);
    _engine.enableLocalAudio(false);
    _engine.stopVideoPreview();
    if (_localSession.renderer != null) {
      _localSession.renderer!.dispose();
      _localSession.renderer = null;
    }
    for (_UserSession session in _remoteSessions) {
      session.renderer?.dispose();
      session.renderer = null;
    }
    _engine.leaveChannel();
  }

  @override
  void dispose() {
    _leaveChannel();
    _releaseRtcEngine();
    super.dispose();
  }

  @override
  void onConnectionTypeChanged(int newConnectionType) {
    // Fluttertoast.showToast(
    //     msg:
    //     'onConnectionTypeChanged#${Utils.connectionType2String(newConnectionType)}',
    //     gravity: ToastGravity.CENTER);
  }

  @override
  void onDisconnect(int reason) {
    Fluttertoast.showToast(
        msg: 'Disconnected', gravity: ToastGravity.CENTER);
  }

  @override
  void onFirstAudioDataReceived(int uid) {
    Fluttertoast.showToast(
        msg: 'Audio Check', gravity: ToastGravity.CENTER);
  }

  @override
  void onFirstVideoDataReceived(int uid) {
    Fluttertoast.showToast(
        msg: 'Video Check', gravity: ToastGravity.CENTER);
  }

  @override
  void onLeaveChannel(int result) {
    Fluttertoast.showToast(
        msg: 'Disconnected', gravity: ToastGravity.CENTER);
  }

  @override
  void onUserAudioMute(int uid, bool muted) {
    Fluttertoast.showToast(
        msg: 'Muted',
        gravity: ToastGravity.CENTER);
  }

  @override
  void onUserAudioStart(int uid) {
    Fluttertoast.showToast(
        msg: 'Audio Start', gravity: ToastGravity.CENTER);
  }

  @override
  void onUserAudioStop(int uid) {
    Fluttertoast.showToast(
        msg: 'Audio Stopped ', gravity: ToastGravity.CENTER);
  }

  @override
  void onUserJoined(int uid) {
    Fluttertoast.showToast(
        msg: 'New User Joined', gravity: ToastGravity.CENTER);
    _UserSession session = _UserSession();
    session.uid = uid;
    session.subStream = false;
    _remoteSessions.add(session);
    setState(() {});
  }

  @override
  void onUserLeave(int uid, int reason) {
    Fluttertoast.showToast(
        msg: 'User left',
        gravity: ToastGravity.CENTER);
    for (_UserSession session in _remoteSessions) {
      if (session.uid == uid) {
        NERtcVideoRenderer? renderer = session.renderer;
        renderer?.dispose();
        _remoteSessions.remove(session);
      }
    }
    setState(() {});
  }

  @override
  void onUserVideoMute(int uid, bool muted) {
    // Fluttertoast.showToast(
    //     msg: 'onUserVideoProfileUpdate#uid:$uid, muted:$muted',
    //     gravity: ToastGravity.CENTER);
  }

  @override
  void onUserVideoProfileUpdate(int uid, int maxProfile) {
    // Fluttertoast.showToast(
    //     msg:
    //     'onUserVideoProfileUpdate#uid:$uid, maxProfile:${Utils.videoProfile2String(maxProfile)}',
    //     gravity: ToastGravity.CENTER);
  }

  @override
  void onUserVideoStart(int uid, int maxProfile) {
    // Fluttertoast.showToast(
    //     msg:
    //     'onUserVideoStart#uid:$uid, maxProfile:${Utils.videoProfile2String(maxProfile)}',
    //     gravity: ToastGravity.CENTER);
    setupVideoView(uid, maxProfile, false);
  }

  Future<void> setupVideoView(int uid, int maxProfile, bool subStream) async {
    NERtcVideoRenderer renderer =
    await VideoRendererFactory.createVideoRenderer();
    for (_UserSession session in _remoteSessions) {
      if (session.uid == uid && subStream == session.subStream) {
        session.renderer = renderer;
        if (subStream) {
          session.renderer!.attachToRemoteSubStreamVideo(uid);
          if (_settings.autoSubscribeVideo) {
            _engine.subscribeRemoteSubStreamVideo(uid, true);
          }
        } else {
          session.renderer!.attachToRemoteVideo(uid);
          if (_settings.autoSubscribeVideo) {
            _engine.subscribeRemoteVideo(
                uid, NERtcRemoteVideoStreamType.high, true);
          }
        }
        break;
      }
    }
    setState(() {});
  }

  Future<void> releaseVideoView(int uid) async {
    for (_UserSession session in _remoteSessions) {
      if (session.uid == uid) {
        NERtcVideoRenderer? renderer = session.renderer;
        session.renderer = null;
        renderer?.dispose();
        break;
      }
    }
    setState(() {});
  }

  @override
  void onUserVideoStop(int uid) {
    // Fluttertoast.showToast(
    //     msg: 'onUserVideoStop#$uid', gravity: ToastGravity.CENTER);
    releaseVideoView(uid);
  }

  @override
  void onRemoteVideoStats(List<NERtcVideoRecvStats> statsList) {}

  @override
  void onLocalVideoStats(NERtcVideoSendStats stats) {}

  @override
  void onRemoteAudioStats(List<NERtcAudioRecvStats> statsList) {}

  @override
  void onLocalAudioStats(NERtcAudioSendStats stats) {}

  @override
  void onRtcStats(NERtcStats stats) {}

  @override
  void onReJoinChannel(int result) {
    // Fluttertoast.showToast(
    //     msg: 'onReJoinChannel#$result', gravity: ToastGravity.CENTER);
  }

  @override
  void onError(int code) {
    // Fluttertoast.showToast(msg: 'onError#$code', gravity: ToastGravity.CENTER);
  }

  @override
  void onFirstAudioFrameDecoded(int uid) {
    // Fluttertoast.showToast(
    //     msg: 'onFirstAudioFrameDecoded#$uid', gravity: ToastGravity.CENTER);
  }

  @override
  void onFirstVideoFrameDecoded(int uid, int width, int height) {
    // Fluttertoast.showToast(
    //     msg: 'onFirstVideoFrameDecoded#uid:$uid, width:$width, height:$height',
    //     gravity: ToastGravity.CENTER);
  }

  @override
 void onJoinChannel(int result, int channelId, int elapsed, int uid) {
    // Fluttertoast.showToast(
    //     msg:
    //     'onJoinChannel#result:$result, channelId:$channelId, elapsed:$elapsed',
    //     gravity: ToastGravity.CENTER);
    updateSettings().then((value) {
      setState(() {});
    });
  }


  @override
  void onLocalAudioVolumeIndication(int volume) {}

  @override
  void onRemoteAudioVolumeIndication(
      List<NERtcAudioVolumeInfo> volumeList, int totalVolume) {}

  @override
  void onWarning(int code) {
    // Fluttertoast.showToast(
    //     msg: 'onWarning#$code', gravity: ToastGravity.CENTER);
  }

  @override
  void onNetworkQuality(List<NERtcNetworkQualityInfo> statsList) {}

  @override
  void onReconnectingStart() {
    // Fluttertoast.showToast(
    //     msg: 'onReconnectingStart', gravity: ToastGravity.CENTER);
  }

  @override
  void onConnectionStateChanged(int state, int reason) {
    // Fluttertoast.showToast(
    //     msg:
    //     'onConnectionStateChanged#state:${Utils.connectionState2String(state)}, '
    //         'reason:${Utils.connectionStateChangeReason2String(reason)}',
    //     gravity: ToastGravity.CENTER);
    print(
        'onConnectionStateChanged#state:${Utils.connectionState2String(state)}, '
            'reason:${Utils.connectionStateChangeReason2String(reason)}');
  }

  @override
  void onLiveStreamState(String taskId, String pushUrl, int liveState) {
    // Fluttertoast.showToast(
    //     msg:
    //     'onLiveStreamState#taskId:$taskId, liveState:${Utils.liveStreamState2String(liveState)}',
    //     gravity: ToastGravity.CENTER);
  }

  @override
  void onAudioDeviceChanged(int selected) {
    // Fluttertoast.showToast(
    //     msg: 'onAudioDeviceChanged#${Utils.audioDevice2String(selected)}',
    //     gravity: ToastGravity.CENTER);
  }

  @override
  void onAudioDeviceStateChange(int deviceType, int deviceState) {
    // Fluttertoast.showToast(
    //     msg:
    //     'onAudioDeviceStateChange#deviceType:${Utils.audioDeviceType2String(deviceType)}, '
    //         'deviceState:${Utils.audioDeviceState2String(deviceState)}',
    //     gravity: ToastGravity.CENTER);
  }

  @override
  void onVideoDeviceStageChange(int deviceState) {
    // Fluttertoast.showToast(
    //     msg:
    //     'onVideoDeviceStageChange#${Utils.videoDeviceState2String(deviceState)}',
    //     gravity: ToastGravity.CENTER);
  }

  @override
  void onClientRoleChange(int oldRole, int newRole) {
    // Fluttertoast.showToast(
    //     msg: 'onClientRoleChange#oldRole:$oldRole, newRole:$newRole',
    //     gravity: ToastGravity.CENTER);
  }

  @override
  void onUserSubStreamVideoStart(int uid, int maxProfile) {
    // Fluttertoast.showToast(
    //     msg:
    //     'onUserSubStreamVideoStart#uid:$uid, maxProfile:${Utils.videoProfile2String(maxProfile)}',
    //     gravity: ToastGravity.CENTER);

    _UserSession session = _UserSession();
    session.uid = uid;
    session.subStream = true;
    _remoteSessions.add(session);
    setupVideoView(uid, maxProfile, true);
  }

  @override
  void onUserSubStreamVideoStop(int uid) {
    // Fluttertoast.showToast(
    //     msg: 'onUserSubStreamVideoStop#$uid', gravity: ToastGravity.CENTER);
    for (_UserSession session in _remoteSessions) {
      if (session.uid == uid && session.subStream) {
        NERtcVideoRenderer? renderer = session.renderer;
        renderer?.dispose();
        _remoteSessions.remove(session);
        break;
      }
    }
    setState(() {});
  }

  @override
  void onAudioHasHowling() {
    // Fluttertoast.showToast(
    //     msg: 'onAudioHasHowling', gravity: ToastGravity.CENTER);
  }

  @override
  void onAudioRecording(int code, String filePath) {
    // TODO: implement onAudioRecording
  }

  @override
  void onLocalPublishFallbackToAudioOnly(bool isFallback, int streamType) {
    // TODO: implement onLocalPublishFallbackToAudioOnly
  }

  @override
  void onMediaRelayReceiveEvent(int event, int code, String channelName) {
    // TODO: implement onMediaRelayReceiveEvent
  }

  @override
  void onMediaRelayStatesChange(int state, String channelName) {
    // TODO: implement onMediaRelayStatesChange
  }

  @override
  void onReceiveSEIMsg(int userID, String seiMsg) {
    // TODO: implement onReceiveSEIMsg
  }

  @override
  void onRemoteSubscribeFallbackToAudioOnly(int uid, bool isFallback, int streamType) {
    // TODO: implement onRemoteSubscribeFallbackToAudioOnly
  }
}

class _UserSession {
  int? uid;
  NERtcVideoRenderer? renderer;
  bool subStream = false;
}