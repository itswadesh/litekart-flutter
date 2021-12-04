

import 'dart:developer';

import 'package:anne/components/base/tz_dialog.dart';
import 'package:anne/components/widgets/cartEmptyMessage.dart';
import 'package:anne/components/widgets/errorMessage.dart';
import 'package:anne/components/widgets/loading.dart';
import 'package:anne/response_handler/channelResponse.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/graphQl.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/values/colors.dart';
import 'package:anne/view/liveStreamPages/joinLiveStreamPage.dart';
import 'package:anne/view/scheduleVideoCalls/live_video_call_setup.dart';
import 'package:anne/view_model/channel_view_model.dart';
import 'package:anne/view_model/settings_view_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../values/route_path.dart' as routes;

// class LiveCommercePage extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     return _LiveCommerceState();
//   }
//
// }
//
// class _LiveCommerceState extends State<LiveCommercePage>{
//   TextEditingController searchText = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle.dark.copyWith(
//         statusBarColor: Colors.transparent
//     ),
//     child: SafeArea(
//     child: Container(
//         height: MediaQuery.of(context).size.height,
//         color: Color(0xffffffff),
//         child: Stack(
//         children: [
//           SingleChildScrollView(
//             child:  Column(
//               children: [
//                 Container(
//                     color: AppColors.primaryElement,
//                     width: double.infinity,
//                     height: ScreenUtil().setWidth(130)
//                 ),
//         Transform.translate(offset: Offset(0,ScreenUtil().setWidth(-60)),
//           child: Column(children :[
//                 Container(
//                   height: ScreenUtil().setWidth(450),
//                   child: StreamList(),)
//             ])),
//             ]),
//           ),
//           Align(
//             alignment: Alignment.topCenter,
//             child : Container(
//               color: AppColors.primaryElement,
//               width: double.infinity,
//               height: ScreenUtil().setWidth(80),
//               child: Container(
//                 margin: EdgeInsets.only(top: 10),
//                 child: Text("Live Sales",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(20)),)
//                 // TextFormField(
//                 //
//                 //   // onSubmitted: ,
//                 //   controller: searchText,
//                 //   onChanged: (search) {
//                 //     setState(() {});
//                 //   },
//                 //   style: TextStyle(color: Color(0xffffffff)),
//                 //
//                 //   decoration: InputDecoration(
//                 //     prefixIcon: Icon(Icons.search,color: Color(0xffffffff),),
//                 //     fillColor: AppColors.primaryElement,
//                 //     filled: true,
//                 //     hintText: "What are you looking for?",
//                 //     hintStyle: TextStyle(color: Color(0xffffffff)),
//                 //
//                 //     border: OutlineInputBorder(
//                 //       borderSide: BorderSide.none,
//                 //     ),
//                 //   ),
//                 // ),
//               )
//             )
//           )
//         ],
//       ),),
//     )));
//   }
// }
//
//
//
//
// class StreamList extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _StreamList();
//   }
// }
//
// class _StreamList extends State<StreamList>{
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ChannelViewModel>(
//         builder: (BuildContext context, value, Widget? child) {
//       if (value.status == "loading") {
//         Provider.of<ChannelViewModel>(context, listen: false)
//             .fetchChannelData(null,null,null,"","","","");
//         if(Provider.of<SettingViewModel>(context).status=="loading"||Provider.of<SettingViewModel>(context).status=="error"){
//           Provider.of<SettingViewModel>(context,
//             listen: false)
//             .fetchSettings();
//         }
//         return Loading();
//       } else if (value.status == "empty") {
//
//         return SizedBox.shrink();
//       } else if (value.status == "error") {
//
//         return SizedBox.shrink();
//       } else {
//     return Container(
//       height: ScreenUtil().setWidth(450),
//       child:
//       ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: value.channelResponse!.data!.length,
//           itemBuilder: (BuildContext context, index){
//           return StreamCard(value.channelResponse!.data![index]);
//       }),
//     );}});
//   }
// }
//
//
//
class LiveCommercePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LiveCommercePage();
  }
}



class _LiveCommercePage extends State<LiveCommercePage>{
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  final List gradientColors = [
    AppColors.primaryElement,
    Color(0xffffffff)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //     backgroundColor: Colors.white,
      //     title:  Text(
      //       "Live Sales",
      //       style: TextStyle(
      //           color: Color(0xff616161),
      //           fontSize: ScreenUtil().setSp(
      //             21,
      //           )),
      //       textAlign: TextAlign.center,
      //     )
      // ),
      body:AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppColors.primaryElement
    ),
    child:
    SafeArea(
    child:   Stack(children:[ GraphQLProvider(
        client: graphQLConfiguration.initailizeClient(),
        child: CacheProvider(
          child: Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(80)),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
           // color: Color(0xfff3f3f3),
            child: SingleChildScrollView(child: Column(children:[

              getScheduleList()])),
          ),
        ),
      ),
      Align(alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setWidth(15)),
        width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryElement,
                // gradientColors[
                // Random().nextInt(gradientColors.length)],
                Colors.white
              ],
            ),),
        height: ScreenUtil().setWidth(80),
        child: Text(
          "Live Sales",
          style: TextStyle(
           // fontWeight: FontWeight.w600,
              color: Color(0xff000000),
              fontSize: ScreenUtil().setSp(
                23,
              )),
      ),
      ))
      ])))
    );
  }
  getScheduleList() {
    return Consumer<ChannelViewModel>(
        builder: (BuildContext context, value, Widget? child) {

          if (value.status == "loading") {
            Provider.of<ChannelViewModel>(context, listen: false).fetchChannelData(null,null,null,"","","","");
            return Loading();
          } else if (value.status == "empty") {
            return  cartEmptyMessage("search", "No Live Steam");
          } else if (value.status == "error") {
            return errorMessage();
          }

          return
            Container(
                height: ScreenUtil().setWidth(500),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
                child:  Consumer<ChannelViewModel>(
                    builder: (BuildContext context, value, Widget? child) {
                      return
                            ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: value.channelResponse!.data!.length,
          itemBuilder: (BuildContext context, index){
          return StreamCard(value.channelResponse!.data![index]);});
                      // child: PagedGridView(
                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //       childAspectRatio:
                      //       ScreenUtil().setWidth(183) / ScreenUtil().setWidth(290),
                      //       crossAxisCount: 2),
                      //   pagingController: value.pagingController,
                      //   builderDelegate: PagedChildBuilderDelegate(
                      //       itemBuilder: (context, dynamic item, index) => StreamCard(item),
                      //       // firstPageErrorIndicatorBuilder: (_) => FirstPageErrorIndicator(
                      //       //   error: _pagingController.error,
                      //       //   onTryAgain: () => _pagingController.refresh(),
                      //       // ),
                      //       // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
                      //       //   error: _pagingController.error,
                      //       //   onTryAgain: () => _pagingController.retryLastFailedRequest(),
                      //       // ),
                      //       firstPageProgressIndicatorBuilder: (_) => Loading(),
                      //       newPageProgressIndicatorBuilder: (_) => Loading(),
                      //       noItemsFoundIndicatorBuilder: (_) =>
                      //           cartEmptyMessage("search", "No Live Stream Found")),
                      //   // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
                      // )

                    }));
        });
  }

}

class StreamCard extends StatefulWidget {
  final item;
  StreamCard(this.item);
  State<StatefulWidget> createState() {
    return _StreamCard();
  }
}

class _StreamCard extends State<StreamCard> {
  ChannelData? item;
  bool imageStatus = true;
  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25)),
          border: Border.all(color: Color(0xffb1b1b1))
      ),
      child: InkWell(
        onTap: () async {
          //  locator<NavigationService>().pushNamed(routes.LiveStreamPlayer,args: item);
          if(item!.isLive!) {
            locator<NavigationService>().pushNamed(
                routes.LiveStreamPlayer, args: item);
          }
        },
        child: Container(
          width: ScreenUtil().setWidth(300),
          //     height: ScreenUtil().setWidth(269),
          height: ScreenUtil().setWidth(500),
          child:
              Stack(
                children: [
                  Container(
                    // child:CachedNetworkImage(
                    //   fit: BoxFit.contain,
                    //   height: ScreenUtil().setWidth(213),
                    //   width: ScreenUtil().setWidth(193),
                    //   imageUrl: item?.img??""+"?tr=w-193,fo-auto",
                    //   imageBuilder: (context, imageProvider) => Container(
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //         onError: (object,stackTrace)=>Image.asset("assets/images/logo.png",  height: ScreenUtil().setWidth(213),
                    //           width: ScreenUtil().setWidth(193),
                    //           fit: BoxFit.contain,),
                    //
                    //         image: imageProvider,
                    //         fit: BoxFit.contain,
                    //
                    //       ),
                    //     ),
                    //   ),
                    //   placeholder: (context, url) => Image.asset("assets/images/loading.gif",  height: ScreenUtil().setWidth(213),
                    //     width: ScreenUtil().setWidth(193),
                    //     fit: BoxFit.contain,),
                    //   errorWidget: (context, url, error) =>  Image.asset("assets/images/logo.png",  height: ScreenUtil().setWidth(213),
                    //     width: ScreenUtil().setWidth(193),
                    //     fit: BoxFit.contain,),
                    // ),
                      child: FadeInImage.assetNetwork(
                        imageErrorBuilder: ((context,object,stackTrace){

                          return Image.asset("assets/images/logo.png",height: ScreenUtil().setWidth(500),
                            width: ScreenUtil().setWidth(300),
                            fit: BoxFit.contain,);
                        }),
                        placeholder: 'assets/images/loading.gif',
                        image: item!.img!,
                        height: ScreenUtil().setWidth(500),
                        width: ScreenUtil().setWidth(300),
                        fit: BoxFit.contain,
                      )
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(10),
                        right: ScreenUtil().setWidth(10),
                        top: ScreenUtil().setWidth(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: ScreenUtil().setWidth(250),
                            child: Text(
                              item!.title!,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(
                                    18,
                                  ),
                                  color: Color(0xff616161),
                                  fontWeight: FontWeight.w600
                              ),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            )),
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                0, 0, ScreenUtil().setWidth(0), 0),
                            width: ScreenUtil().radius(30),
                            height: ScreenUtil().radius(30),
                            decoration: new BoxDecoration(
                              color: Color(0xffd3d3d3),
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xfff3f3f3),
                                      width: ScreenUtil().setWidth(0.4)),
                                  top: BorderSide(
                                      color: Color(0xfff3f3f3),
                                      width: ScreenUtil().setWidth(0.4)),
                                  left: BorderSide(
                                      color: Color(0xfff3f3f3),
                                      width: ScreenUtil().setWidth(0.4)),
                                  right: BorderSide(
                                      color: Color(0xfff3f3f3),
                                      width: ScreenUtil().setWidth(0.4))),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.live_tv,
                              color: AppColors.primaryElement,
                              size: ScreenUtil().setWidth(18),
                            )),
                      ],
                    ),
                  ),
                Container(
                    height: ScreenUtil().setWidth(500),
                    width: ScreenUtil().setWidth(300),
                    child: Align(
                     alignment: Alignment.bottomCenter,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      // SizedBox(
                      //   height: ScreenUtil().setWidth(9),
                      // ),
                      // Container(
                      //     width: MediaQuery.of(context).size.width,
                      //     padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0,
                      //         ScreenUtil().setWidth(20), 0),
                      //     child: Text(item.product.name,
                      //         style: TextStyle(
                      //             color: Color(0xff5f5f5f),
                      //             fontSize: ScreenUtil().setSp(
                      //               14,
                      //             )),
                      //         overflow: TextOverflow.ellipsis,
                      //         maxLines: 1)),

                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), ScreenUtil().setWidth(10),
                              ScreenUtil().setWidth(10), 0),
                          child: Text(
                            DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).year.toString()+"-"+
                                DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).month.toString()+"-"+
                                DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).day.toString()+"  at "+
                                DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).hour.toString()+":"+
                                (DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).minute<10? DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).minute.toString()+"0":DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).minute.toString()),
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(
                                  20,
                                ),
                                color: Color(0xff616161),
                                fontWeight: FontWeight.w600
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          )),
                      // Container(
                      //     width: MediaQuery.of(context).size.width,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         SizedBox(width: ScreenUtil().setWidth(10),),
                      //         Text(
                      //           "${store!.currencySymbol} " + item!.product!.price.toString() + " ",
                      //           style: TextStyle(
                      //               fontSize: ScreenUtil().setSp(
                      //                 14,
                      //               ),
                      //               fontWeight: FontWeight.w600,
                      //               color: Color(0xff4a4a4a)),
                      //         ),
                      //         item!.product!.price! < item!.product!.mrp!
                      //             ? Text(
                      //           " ${store!.currencySymbol} " + item!.product!.mrp.toString(),
                      //           style: TextStyle(
                      //               decoration: TextDecoration.lineThrough,
                      //               fontSize: ScreenUtil().setSp(
                      //                 12,
                      //               ),
                      //               color: Color(0xff4a4a4a)),
                      //         )
                      //             : Container(),
                      //         item!.product!.price! < item!.product!.mrp!
                      //             ? Flexible(child: Text(
                      //           " (${(100 - ((item!.product!.price! / item!.product!.mrp!) * 100)).toInt()} % off)",
                      //           style: TextStyle(
                      //               color: AppColors.primaryElement2,
                      //               fontSize: ScreenUtil().setSp(
                      //                 12,
                      //               )),
                      //           overflow: TextOverflow.ellipsis,
                      //         ))
                      //             : Container()
                      //       ],
                      //     )),
                      SizedBox(height: ScreenUtil().setWidth(15),),
                    //  Divider(height: ScreenUtil().setWidth(5),),
                      InkWell(
                          onTap: () async {
                            if(item!.isLive!) {
                              locator<NavigationService>().pushNamed(
                                  routes.LiveStreamPlayer, args: item);
                            }
                          },
                          child: Container(
                            width: ScreenUtil().setWidth(190),
                            height: ScreenUtil().setWidth(40),
                            child:
                            Center(
                              child:
                              CountdownTimer(
                                endTime:
                                item!.scheduleDateTime!,
                                widgetBuilder: (_, CurrentRemainingTime? time) {
                                  if (item!.isLive! && time == null) {
                                    return  Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      color: Colors.white,
                                      padding: EdgeInsets.fromLTRB(
                                          ScreenUtil().setWidth(6),
                                          ScreenUtil().setWidth(7),
                                          ScreenUtil().setWidth(6),
                                          ScreenUtil().setWidth(7)),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [ Text("JOIN STREAM",style: TextStyle(color: AppColors.primaryElement,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis)
                                    ]));
                                          //  return Text('Ended');
                                  }
                                  return Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    color: Colors.grey,
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(6),
                                        ScreenUtil().setWidth(7),
                                        ScreenUtil().setWidth(6),
                                        ScreenUtil().setWidth(7)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: ScreenUtil().setWidth(31),
                                            width: ScreenUtil().setWidth(31),
                                            // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                            child: Center(
                                                child: Text(
                                                    "${(time!.days != null ? time!.days : 0)!}",
                                                    style: TextStyle(color: Colors.black38))),
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.rectangle,
                                            )),

                                        Container(
                                            margin: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(3),
                                                right: ScreenUtil().setWidth(3)),
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil().setSp(
                                                    16,
                                                  ),
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        Container(
                                            height: ScreenUtil().setWidth(31),
                                            width: ScreenUtil().setWidth(31),
                                            // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                            child: Center(
                                                child: Text(
                                                    "${(time!.hours != null ? time!.hours : 0)!}",
                                                    style: TextStyle(color: Colors.black38))),
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.rectangle,
                                            )),

                                        Container(
                                            margin: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(3),
                                                right: ScreenUtil().setWidth(3)),
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil().setSp(
                                                    16,
                                                  ),
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        Container(
                                            height: ScreenUtil().setWidth(31),
                                            width: ScreenUtil().setWidth(31),
                                            // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                            child: Center(
                                                child: Text(
                                                    "${(time.min != null ? time.min : 0)! }",
                                                    style: TextStyle(color: Colors.black38))),
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.rectangle,
                                            )),

                                        Container(
                                            margin: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(3),
                                                right: ScreenUtil().setWidth(3)),
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil().setSp(
                                                    16,
                                                  ),
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        Container(
                                            height: ScreenUtil().setWidth(31),
                                            width: ScreenUtil().setWidth(31),
                                            // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                            child: Center(
                                                child: Text(
                                                    "${(time.sec != null ? time.sec : 0)!}",
                                                    style: TextStyle(color: Colors.black38))),
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.rectangle,
                                            )),

                                      ],
                                    ),
                                  );
                                },
                              ),
                              // item!.isLive!? Text("JOIN STREAM",style: TextStyle(color: AppColors.primaryElement,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis):
                              // Text(DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).year.toString()+"-"+
                              //     DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).month.toString()+"-"+
                              ////     DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).day.toString()+"  "+
                              //    DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).hour.toString()+":"+
                              //   (DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).minute<10? DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).minute.toString()+"0":DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).minute.toString()),
                              //   overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.primaryElement,)),
                            ),
                          )),
                      SizedBox(height: ScreenUtil().setWidth(15),),
                      ])))
                ],
              ),

        ),
      ),
    );
  }
}


// class StreamCard extends StatefulWidget {
//   final item;
//   StreamCard(this.item);
//   State<StatefulWidget> createState() {
//     return _StreamCard();
//   }
// }
//
// class _StreamCard extends State<StreamCard> {
//   ChannelData? item;
//   bool imageStatus = true;
//   @override
//   void initState() {
//     item = widget.item;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
//           border: Border.all(color: Color(0xffb1b1b1))
//       ),
//       child: InkWell(
//         onTap: () async {
//         //  locator<NavigationService>().pushNamed(routes.LiveStreamPlayer,args: item);
//
//         },
//         child: Container(
//           width: ScreenUtil().setWidth(183),
//           //     height: ScreenUtil().setWidth(269),
//           height: ScreenUtil().setWidth(290),
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   Container(
//                     // child:CachedNetworkImage(
//                     //   fit: BoxFit.contain,
//                     //   height: ScreenUtil().setWidth(213),
//                     //   width: ScreenUtil().setWidth(193),
//                     //   imageUrl: item?.img??""+"?tr=w-193,fo-auto",
//                     //   imageBuilder: (context, imageProvider) => Container(
//                     //     decoration: BoxDecoration(
//                     //       image: DecorationImage(
//                     //         onError: (object,stackTrace)=>Image.asset("assets/images/logo.png",  height: ScreenUtil().setWidth(213),
//                     //           width: ScreenUtil().setWidth(193),
//                     //           fit: BoxFit.contain,),
//                     //
//                     //         image: imageProvider,
//                     //         fit: BoxFit.contain,
//                     //
//                     //       ),
//                     //     ),
//                     //   ),
//                     //   placeholder: (context, url) => Image.asset("assets/images/loading.gif",  height: ScreenUtil().setWidth(213),
//                     //     width: ScreenUtil().setWidth(193),
//                     //     fit: BoxFit.contain,),
//                     //   errorWidget: (context, url, error) =>  Image.asset("assets/images/logo.png",  height: ScreenUtil().setWidth(213),
//                     //     width: ScreenUtil().setWidth(193),
//                     //     fit: BoxFit.contain,),
//                     // ),
//                     child: FadeInImage.assetNetwork(
//                       imageErrorBuilder: ((context,object,stackTrace){
//
//                         return Image.asset("assets/images/logo.png",height: ScreenUtil().setWidth(213),
//                           width: ScreenUtil().setWidth(193),
//                           fit: BoxFit.contain,);
//                       }),
//                       placeholder: 'assets/images/loading.gif',
//                       image: item!.img!,
//                       height: ScreenUtil().setWidth(213),
//                       width: ScreenUtil().setWidth(193),
//                       fit: BoxFit.contain,
//                     )
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(
//                         right: ScreenUtil().setWidth(10),
//                         top: ScreenUtil().setWidth(10)),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//
//                              Container(
//                                 margin: EdgeInsets.fromLTRB(
//                                     0, 0, ScreenUtil().setWidth(0), 0),
//                                 width: ScreenUtil().radius(30),
//                                 height: ScreenUtil().radius(30),
//                                 decoration: new BoxDecoration(
//                                   color: Color(0xffd3d3d3),
//                                   border: Border(
//                                       bottom: BorderSide(
//                                           color: Color(0xfff3f3f3),
//                                           width: ScreenUtil().setWidth(0.4)),
//                                       top: BorderSide(
//                                           color: Color(0xfff3f3f3),
//                                           width: ScreenUtil().setWidth(0.4)),
//                                       left: BorderSide(
//                                           color: Color(0xfff3f3f3),
//                                           width: ScreenUtil().setWidth(0.4)),
//                                       right: BorderSide(
//                                           color: Color(0xfff3f3f3),
//                                           width: ScreenUtil().setWidth(0.4))),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.live_tv,
//                                   color: AppColors.primaryElement,
//                                   size: ScreenUtil().setWidth(18),
//                                 )),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//               Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), ScreenUtil().setWidth(10),
//                       ScreenUtil().setWidth(20), 0),
//                   child: Text(
//                     item!.title!,
//                     style: TextStyle(
//                         fontSize: ScreenUtil().setSp(
//                           14,
//                         ),
//                         color: Color(0xff616161),
//                         fontWeight: FontWeight.w600
//                     ),
//                     textAlign: TextAlign.left,
//                     overflow: TextOverflow.ellipsis,
//                   )),
//               // SizedBox(
//               //   height: ScreenUtil().setWidth(9),
//               // ),
//               // Container(
//               //     width: MediaQuery.of(context).size.width,
//               //     padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0,
//               //         ScreenUtil().setWidth(20), 0),
//               //     child: Text(item.product.name,
//               //         style: TextStyle(
//               //             color: Color(0xff5f5f5f),
//               //             fontSize: ScreenUtil().setSp(
//               //               14,
//               //             )),
//               //         overflow: TextOverflow.ellipsis,
//               //         maxLines: 1)),
//
//               Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), ScreenUtil().setWidth(10),
//                       ScreenUtil().setWidth(20), 0),
//                   child: Text(
//                     DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).year.toString()+"-"+
//                         DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).month.toString()+"-"+
//                         DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).day.toString()+"  "+
//                         DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).hour.toString()+":"+
//     (DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).minute<10? DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).minute.toString()+"0":DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).minute.toString()),
//                     style: TextStyle(
//                         fontSize: ScreenUtil().setSp(
//                           14,
//                         ),
//                         color: Color(0xff616161),
//                         fontWeight: FontWeight.w600
//                     ),
//                     textAlign: TextAlign.left,
//                     overflow: TextOverflow.ellipsis,
//                   )),
//               // Container(
//               //     width: MediaQuery.of(context).size.width,
//               //     child: Row(
//               //       mainAxisAlignment: MainAxisAlignment.start,
//               //       children: [
//               //         SizedBox(width: ScreenUtil().setWidth(10),),
//               //         Text(
//               //           "${store!.currencySymbol} " + item!.product!.price.toString() + " ",
//               //           style: TextStyle(
//               //               fontSize: ScreenUtil().setSp(
//               //                 14,
//               //               ),
//               //               fontWeight: FontWeight.w600,
//               //               color: Color(0xff4a4a4a)),
//               //         ),
//               //         item!.product!.price! < item!.product!.mrp!
//               //             ? Text(
//               //           " ${store!.currencySymbol} " + item!.product!.mrp.toString(),
//               //           style: TextStyle(
//               //               decoration: TextDecoration.lineThrough,
//               //               fontSize: ScreenUtil().setSp(
//               //                 12,
//               //               ),
//               //               color: Color(0xff4a4a4a)),
//               //         )
//               //             : Container(),
//               //         item!.product!.price! < item!.product!.mrp!
//               //             ? Flexible(child: Text(
//               //           " (${(100 - ((item!.product!.price! / item!.product!.mrp!) * 100)).toInt()} % off)",
//               //           style: TextStyle(
//               //               color: AppColors.primaryElement2,
//               //               fontSize: ScreenUtil().setSp(
//               //                 12,
//               //               )),
//               //           overflow: TextOverflow.ellipsis,
//               //         ))
//               //             : Container()
//               //       ],
//               //     )),
//               SizedBox(height: ScreenUtil().setWidth(5),),
//               Divider(height: ScreenUtil().setWidth(5),),
//               InkWell(
//                   onTap: () async {
//                     if(item!.isLive!) {
//                       locator<NavigationService>().pushNamed(
//                           routes.LiveStreamPlayer, args: item);
//                     }
//                     },
//                   child: Container(
//                     width: ScreenUtil().setWidth(190),
//                     height: ScreenUtil().setWidth(35),
//                     child:
//                     Center(
//                       child:
//                       CountdownTimer(
//                         endTime:
//                         item!.scheduleDateTime!,
//                         widgetBuilder: (_, CurrentRemainingTime? time) {
//                           if (item!.isLive! && time == null) {
//                             return Text("JOIN STREAM",style: TextStyle(color: AppColors.primaryElement,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis);
//                           //  return Text('Ended');
//                           }
//                           return Container(
//                             height: double.infinity,
//                             width: double.infinity,
//                             color: AppColors.primaryElement,
//                             // padding: EdgeInsets.fromLTRB(
//                             //     ScreenUtil().setWidth(6),
//                             //     ScreenUtil().setWidth(7),
//                             //     ScreenUtil().setWidth(6),
//                             //     ScreenUtil().setWidth(7)),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                     height: ScreenUtil().setWidth(31),
//                                     width: ScreenUtil().setWidth(31),
//                                     // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
//                                     child: Center(
//                                         child: Text(
//                                             "${(time!.days != null ? time!.days : 0)!}",
//                                             style: TextStyle(color: Colors.black38))),
//                                     decoration: new BoxDecoration(
//                                       color: Colors.white,
//                                       shape: BoxShape.rectangle,
//                                     )),
//
//                                 Container(
//                                     margin: EdgeInsets.only(
//                                         left: ScreenUtil().setWidth(3),
//                                         right: ScreenUtil().setWidth(3)),
//                                     child: Text(
//                                       ":",
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: ScreenUtil().setSp(
//                                             16,
//                                           ),
//                                           fontWeight: FontWeight.w600),
//                                     )),
//                                 Container(
//                                     height: ScreenUtil().setWidth(31),
//                                     width: ScreenUtil().setWidth(31),
//                                     // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
//                                     child: Center(
//                                         child: Text(
//                                             "${(time!.hours != null ? time!.hours : 0)!}",
//                                             style: TextStyle(color: Colors.black38))),
//                                     decoration: new BoxDecoration(
//                                       color: Colors.white,
//                                       shape: BoxShape.rectangle,
//                                     )),
//
//                                 Container(
//                                     margin: EdgeInsets.only(
//                                         left: ScreenUtil().setWidth(3),
//                                         right: ScreenUtil().setWidth(3)),
//                                     child: Text(
//                                       ":",
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: ScreenUtil().setSp(
//                                             16,
//                                           ),
//                                           fontWeight: FontWeight.w600),
//                                     )),
//                                 Container(
//                                     height: ScreenUtil().setWidth(31),
//                                     width: ScreenUtil().setWidth(31),
//                                     // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
//                                     child: Center(
//                                         child: Text(
//                                             "${(time.min != null ? time.min : 0)! }",
//                                             style: TextStyle(color: Colors.black38))),
//                                     decoration: new BoxDecoration(
//                                       color: Colors.white,
//                                       shape: BoxShape.rectangle,
//                                     )),
//
//                                 Container(
//                                     margin: EdgeInsets.only(
//                                         left: ScreenUtil().setWidth(3),
//                                         right: ScreenUtil().setWidth(3)),
//                                     child: Text(
//                                       ":",
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: ScreenUtil().setSp(
//                                             16,
//                                           ),
//                                           fontWeight: FontWeight.w600),
//                                     )),
//                                 Container(
//                                     height: ScreenUtil().setWidth(31),
//                                     width: ScreenUtil().setWidth(31),
//                                     // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
//                                     child: Center(
//                                         child: Text(
//                                             "${(time.sec != null ? time.sec : 0)!}",
//                                             style: TextStyle(color: Colors.black38))),
//                                     decoration: new BoxDecoration(
//                                       color: Colors.white,
//                                       shape: BoxShape.rectangle,
//                                     )),
//
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                      // item!.isLive!? Text("JOIN STREAM",style: TextStyle(color: AppColors.primaryElement,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis):
//                      // Text(DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).year.toString()+"-"+
//                      //     DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).month.toString()+"-"+
//                      ////     DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).day.toString()+"  "+
//                       //    DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).hour.toString()+":"+
//                        //   (DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).minute<10? DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).minute.toString()+"0":DateTime.fromMillisecondsSinceEpoch(item!.scheduleDateTime!).minute.toString()),
//                      //   overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.primaryElement,)),
//                     ),
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class StreamCard extends StatelessWidget{
//   final ChannelData channelData;
//   StreamCard(this.channelData);
//   @override
//   Widget build(BuildContext context) {
//    return InkWell(
//        onTap: (){
//           log(channelData.httpPullUrl.toString()
//           );
//          locator<NavigationService>().pushNamed(routes.LiveStreamPlayer,args: channelData);
//           // locator<NavigationService>().push(MaterialPageRoute(builder: (context)=>JoinLiveStreamPlayerPage(channelData)));
//          // LiveStreamSetUp()
//          //     .startRTC(context, channelData.cid, int.parse(channelData.code), 'join',channelData);
//        },
//        child: Container(
//      height: ScreenUtil().setWidth(450),
//      width: ScreenUtil().setWidth(250),
//      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
//      margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
//      decoration: BoxDecoration(
//        border: Border.all(color: Color(0xfff3f3f3),width: 5),
//        borderRadius: BorderRadius.circular(ScreenUtil().radius(25),),
//      image: DecorationImage(
//          image: (channelData.img!=null? NetworkImage(channelData.img!):AssetImage("assets/images/logo.png")) as ImageProvider<Object>,
//        fit: BoxFit.contain
//      ),
//      ),
//
//    ));
//   }
//
// }
