import 'dart:developer';

import 'package:anne/view/common/login.dart';
import 'package:anne/view/homePages/bannersClass.dart';
import 'package:anne/view/homePages/brandClass.dart';
//import 'package:anne/view/homePages/listDealsClass.dart';
import 'package:anne/view/homePages/pickedBannersClass.dart';
import 'package:anne/view/homePages/sliderBannerClasss.dart';
import 'package:anne/view/homePages/suggestedClass.dart';
import 'package:anne/view/homePages/trendingClass.dart';
import 'package:anne/view/homePages/videoBannerClass.dart';
import 'package:anne/view/homePages/youMayLikeClass.dart';
import 'package:anne/view/search.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../service/navigation/navigation_service.dart';
import '../../../utility/locator.dart';
import '../../../utility/query_mutation.dart';
import '../../../utility/update_alert.dart';
import '../../../view_model/auth_view_model.dart';
import '../../../view_model/category_view_model.dart';
import '../../../view/drawer.dart';
import '../cart_logo.dart';
import '../../../values/route_path.dart' as routes;

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> with TickerProviderStateMixin{
  var counter = 4;
  var searchVisible = false;
  QueryMutation addMutation = QueryMutation();
  late Animation<Offset> _transTween;
  late AnimationController _TextAnimationController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
 // double bottomAppSize = ScreenUtil().setWidth(130);
  ScrollController scrollController = ScrollController();
 bool bottomVisible = true;
  @override
  void initState() {
    skipStatus = false;
    _TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _transTween = Tween(begin: Offset(0, ScreenUtil().setWidth(57)), end: Offset(0, ScreenUtil().setWidth(-55)))
        .animate(_TextAnimationController);
    this.initDynamicLinks();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      try {
        (UpdateAlert()).versionCheck((context));
      } catch (e) {

      }
    });
    scrollController.addListener((){_scrollListener();});
    super.initState();
  }

   _scrollListener() {
    if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      _TextAnimationController.animateTo(ScreenUtil().setWidth(105));
      return true;
    }
    if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
      _TextAnimationController.animateTo(ScreenUtil().setWidth(-105));
      return true;
    }
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          final Uri? deepLink = dynamicLink?.link;
          if (deepLink != null) {

            String argID = deepLink.path.split("?id=")[1];
            log("gygu ugug hhb huh "+argID);
            locator<NavigationService>().pushNamed(routes.ProductDetailRoute,args: argID);
          }
        },
        onError: (OnLinkErrorException e) async {


        }
    );
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      String argID = deepLink.path.split("?id=")[1];
      log("gygu ugug hhb huh "+argID);
      locator<NavigationService>().pushNamed(routes.ProductDetailRoute,args: argID);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      key: scaffoldKey,
          drawer: HomeDrawer(),
          body:
          AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent
          ),
          child:
          SafeArea(
          child:  Stack(children: [
                 Container(
                   color: Color(0xffffffff),
                   child:
                   SingleChildScrollView(
                     controller: scrollController,
                     child: Column(
                       children: [
    Consumer<CategoryViewModel>(
    builder: (BuildContext context, value, Widget? child) {
    return value.status=="empty"||value.status=="error"?SizedBox(height: ScreenUtil().setWidth(150)): SizedBox(height: ScreenUtil().setWidth(215));}),
                         //  SearchCategoriesClass(),
                         BannersSliderClass(),
                        // ListDealsClass(),
                         YouMayLikeClass(),
                         BannersClass(),
                         PickedBannersClass(),
                         SuggestedClass(),
                         TrendingClass(),
                         BrandClass(),
                         VideoBannersClass(),
                         SizedBox(height: ScreenUtil().setWidth(15),)
                       ],
                     ),
                   ),
                 ),
          Align(
                   alignment: Alignment.topCenter,
                   child: AnimatedBuilder(
    animation: _TextAnimationController,
    builder: (context, child) => Transform.translate(
                     offset: _transTween.value,
                     child:Container(
      height: ScreenUtil().setWidth(140),
      color: Color(0xffffffff),
     // height: categoryHeight,
      child: SearchCategoriesClass(),
    ),
                 ))),
                 Align(
                   alignment: Alignment.topCenter,
                   child: Transform.translate(
                     offset: Offset(0,ScreenUtil().setWidth(-50)),
                     child:Container(
                       height: ScreenUtil().setWidth(100),
                       color: Color(0xffffffff),
                     ),
                   ),
                 ),
                 Align(
                   alignment: Alignment.topCenter,
                   child: Container(
                     height: ScreenUtil().setWidth(70),
                     color: Color(0xffffffff),
                     padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setWidth(0), ScreenUtil().setWidth(20), ScreenUtil().setWidth(0)),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             InkWell(
                                       onTap: () {
                                         scaffoldKey.currentState!.openDrawer();
                                       },
                                       child: Icon(
                                         Icons.menu,
                                         size: ScreenUtil().setWidth(28),
                                         color: Color(0xff616161),
                                       )),
                             SizedBox(width: ScreenUtil().setWidth(25),),
                             Container(
                                       height: ScreenUtil().setWidth(50),
                                       child: Image.asset(
                                         'assets/images/logo.png',
                                       )),
                           ],
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             Container(
                                 padding: EdgeInsets.only(top: ScreenUtil().setWidth(2)),
                                 child:
                                   InkWell(
                                       onTap: () {
                                         locator<NavigationService>().pushNamed(routes.SearchPage);
                                       },
                                       child: Icon(
                                         Icons.search,
                                         size: ScreenUtil().setWidth(28),
                                         color: Color(0xff616161),
                                       ))),
                                   // SizedBox(
                                   //   width: ScreenUtil().setWidth(24),
                                   // ),
                                   // InkWell(
                                   //     onTap: () {
                                   //      if (Provider.of<ProfileModel>(context, listen: false).user == null)
                                   //             {
                                   //               locator<NavigationService>().pushNamed(routes.LoginRoute);
                                   //       }
                                   //      else {
                                   //        locator<NavigationService>().pushNamed(
                                   //            routes.ManageOrder);
                                   //      }
                                   //     },
                                   //     child: Icon(
                                   //       Icons.shopping_bag_outlined,
                                   //       size: 25,
                                   //       color: Color(0xff616161),
                                   //     )),
                                   SizedBox(
                                     width: ScreenUtil().setWidth(24),
                                   ),
                             Container(
                               padding: EdgeInsets.only(bottom: 0),
                               child:
                                   InkWell(
                                       onTap: () {
                                         if (Provider.of<ProfileModel>(context, listen: false).user == null)
                                         {
                                           locator<NavigationService>().pushNamed(routes.LoginRoute);
                                         }
                                         else {
                                           locator<NavigationService>().pushNamed(
                                               routes.Wishlist);
                                         }
                                       },
                                       child: Icon(
                                         Icons.favorite_border_outlined,
                                         size: ScreenUtil().setWidth(28),
                                         color: Color(0xff616161),
                                       ))),
                                   SizedBox(width: ScreenUtil().setWidth(24),),
                                   CartLogo(25),
                           ],
                         )
                       ],
                     ),
                   ),
                 ),
               ],)
        )));
  }
}


























