


import 'package:anne/utils/zego_config.dart';
import 'package:anne/view/menu/play_stream/play_stream_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class PlayStreamList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlayStreamList();
  }

}

class _PlayStreamList extends State<PlayStreamList>{

  @override
  void initState() {
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();

    // Can destroy the engine when you don't need audio and video calls
    //
    // Destroy engine will automatically logout room and stop publishing/playing stream.
    ZegoExpressEngine.destroyEngine();
  }

  // Step1: Create ZegoExpressEngine
  Future<void> _createEngine() async {
    int appID = ZegoConfig.instance.appID;
    String appSign = ZegoConfig.instance.appSign;
    bool isTestEnv = ZegoConfig.instance.isTestEnv;
    ZegoScenario scenario = ZegoConfig.instance.scenario;
    bool enablePlatformView = ZegoConfig.instance.enablePlatformView;

    await ZegoExpressEngine.createEngine(appID, appSign, isTestEnv, scenario, enablePlatformView: enablePlatformView);
  }

  // Step2 LoginRoom
  Future<void>  _loginRoom() async {
    String roomID = ZegoConfig.instance.roomID;
    ZegoUser user = ZegoUser(ZegoConfig.instance.userID, ZegoConfig.instance.userName);
    await ZegoExpressEngine.instance.loginRoom(roomID, user);
    ZegoConfig.instance.roomID = roomID;
    ZegoConfig.instance.saveConfig();
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {

      int screenWidthPx = MediaQuery.of(context).size.width.toInt() * MediaQuery.of(context).devicePixelRatio.toInt();
      int screenHeightPx = (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 56.0).toInt() * MediaQuery.of(context).devicePixelRatio.toInt();

      return PlayStreamPage(screenWidthPx, screenHeightPx);

    }));

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
        title: Center(
          // width: MediaQuery.of(context).size.width * 0.39,
            child: Text(
              "Live Streams",
              style: TextStyle(
                  color: Color(0xff616161),
                  fontSize: ScreenUtil().setSp(
                    21,
                  )),
              textAlign: TextAlign.center,
            )),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child:getList()
      ),
    );


  }

  Widget getList() {
    return  ListView.builder(
      itemCount:10,
      itemBuilder: (buildContext, index) {
        return Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setWidth(10)),
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(10), 0),
                leading: new Container(
                    width: ScreenUtil().setWidth(40),
                    height: ScreenUtil().setWidth(40),
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage(
                              "assets/images/user.png",
                            )
                        ))),
                title: Text(
                  "lohitbura",
                  style: TextStyle(color: Color(0xff000000),fontFamily: 'Sofia'),
                ),
              ),
             InkWell(
                 onTap: () async {
                   await _createEngine();
                   await _loginRoom();
                 },
                 child: Container(
                  constraints: BoxConstraints(
                    minHeight: ScreenUtil().setWidth(150),),
                  child:
                  index%2==0?Image.asset("assets/images/toyCart.jpeg"):Image.asset("assets/images/toy.jpg")
                // FadeInImage.assetNetwork(
                //   placeholder: 'assets/loading.gif',
                //   image: postList[index]['image'],
                // )
                // CachedNetworkImage(s
                //   imageUrl: postList[index]['image'],
                //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                //       Loading(),
                //   errorWidget: (context, url, error) => Icon(Icons.error),
                // ),
                //Image.network(postList[index]['image']),
              )),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              LikeData()
            ],
          ),
        );
      },
    );
  }
}


class LikeData extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _LikeData();
  }

}


class _LikeData extends State<LikeData>{
  var likeCount;
  var likeStatus;
  var maxLinesCount =2;
  // Dio dio = Dio();
  @override
  void initState() {
    likeCount =5;
    likeStatus = true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: ScreenUtil().setWidth(20),
            ),
            InkWell(
                onTap: ()async{

                  setState(() {
                    likeCount += 1;
                    likeStatus = true;
                  });}
                ,
                child:
                likeStatus==false
                    ?  Icon(FontAwesomeIcons.heart)
                    : Icon(FontAwesomeIcons.heart)
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: (){
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentPage( widget.data['id'])));
              },
              child: Icon(FontAwesomeIcons.comment)
            //  Image.asset("assets/images/review.png", height: ScreenUtil().setWidth(30),),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), 0, ScreenUtil().setWidth(15), 0),
            child: Text(
              likeCount.toString() +
                  (likeCount < 2
                      ? " like"
                      : " likes")+" , "+ likeCount.toString()+(" comments"),
              style: TextStyle(fontFamily: 'Sofia'),
            )
                ),
        SizedBox(
          height: 10,
        ),
        InkWell(
            onTap: (){
              setState(() {
                if(maxLinesCount==2){
                  maxLinesCount=1000;
                }
                else{
                  maxLinesCount=2;
                }
              });
            },
            child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLinesCount,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "lohitbura" + "  ",
                          style: TextStyle(color: Color(0xff000000),fontFamily: 'Sofia',fontSize: ScreenUtil().setSp(15))),
                      TextSpan(
                          text: "Hey There , Watch my stream ... :)",
                          style:TextStyle(color: Color(0xff999999),fontFamily: 'Sofia',fontSize: ScreenUtil().setSp(13))),
                    ],
                  ),
                ))),
        SizedBox(
          height: 10,
        ),
        Divider(height: ScreenUtil().setWidth(3),thickness: ScreenUtil().setWidth(0.8),)
      ],
    );
  }



}