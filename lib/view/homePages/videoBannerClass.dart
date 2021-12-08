import 'package:anne/utility/query_mutation.dart';
import 'package:anne/view_model/banner_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../brand_page.dart';

class VideoBannersClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VideoBannersClass();
  }
}

class _VideoBannersClass extends State<VideoBannersClass> {
  QueryMutation addMutation = QueryMutation();
  final List<String> imgList = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [

        Container(child: getBannersList())
      ],
    );
  }

  Widget getBannersList() {
    return Consumer<BannerViewModel>(
        builder: (BuildContext context, BannerViewModel value, Widget? child) {
          if (value.statusVideoBanner == "loading") {
            Provider.of<BannerViewModel>(context, listen: false).fetchVideoBannerData();
            return Container();
          } else if (value.statusVideoBanner == "empty") {
            return Container();
          } else if (value.statusVideoBanner == "error") {
            return Container();
          } else {

            return value.videoBannerResponse!.data!.length>0? Container(
              // color: Colors.indigo,
              width: ScreenUtil().setWidth(380),
              height: ScreenUtil().setWidth(200),
              child: ChewieClass(
                videoPlayerController: VideoPlayerController.network(value.videoBannerResponse!.data![0].img!),
                looping: true,
              ),
              //height: MediaQuery.of(context).size.height * 0.10,
            ) :Container();
          }
        });
  }
}