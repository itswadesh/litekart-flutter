import 'dart:developer';
import 'package:anne/components/widgets/productCard.dart';
import 'package:anne/values/colors.dart';
import 'package:anne/view/common/login.dart';
import 'package:anne/view/search.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../response_handler/bannerResponse.dart';
import '../../../response_handler/brandResponse.dart';
import '../../../service/event/tracking.dart';
import '../../../service/navigation/navigation_service.dart';
import '../../../utility/api_endpoint.dart';
import '../../../utility/locator.dart';
import '../../../utility/query_mutation.dart';
import '../../../values/event_constant.dart';
import '../../../utility/update_alert.dart';
import '../../../view_model/auth_view_model.dart';
import '../../../view_model/banner_view_model.dart';
import '../../../view_model/brand_view_model.dart';
import '../../../view_model/category_view_model.dart';
import '../../../view_model/list_details_view_model.dart';
import '../../../view_model/product_view_model.dart';
import '../../../utility/theme.dart';
import '../../../view/drawer.dart';
import '../cart_logo.dart';
import '../product_list.dart';
import '../../../components/widgets/loading.dart';
import '../../../components/widgets/productViewColorCard.dart';
import '../../../values/route_path.dart' as routes;

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> with TickerProviderStateMixin{
  var counter = 4;
  var searchVisible = false;
  QueryMutation addMutation = QueryMutation();
  Animation<Offset> _transTween;
  AnimationController _TextAnimationController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
 // double bottomAppSize = ScreenUtil().setWidth(130);
  ScrollController scrollController = ScrollController();
 bool bottomVisible = true;
  @override
  void initState() {
    skipStatus = false;
    _TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _transTween = Tween(begin: Offset(0, 77), end: Offset(0, -40))
        .animate(_TextAnimationController);
    this.initDynamicLinks();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      try {
        (UpdateAlert()).versionCheck((context));
      } catch (e) {
        print(e);
      }
    });
    scrollController.addListener((){_scrollListener();});
    super.initState();
  }

  bool _scrollListener() {
    if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      _TextAnimationController.animateTo(105);
      return true;
    }
    if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
      _TextAnimationController.animateTo(-105);
      return true;
    }
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            log("vhbbj"+deepLink.path);
            locator<NavigationService>().pushNamed(routes.ProductDetailRoute,args: deepLink.path.replaceAll("/", ""));
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      log("yhhhhh"+deepLink.path);
      locator<NavigationService>().pushNamed(routes.ProductDetailRoute,args: deepLink.path.replaceAll("/", ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      key: scaffoldKey,
          drawer: HomeDrawer(),
          // appBar: AppBar(
          //     backgroundColor: Colors.white,
          //     leading: InkWell(
          //         onTap: () {
          //           scaffoldKey.currentState.openDrawer();
          //         },
          //         child: Icon(
          //           Icons.menu,
          //           color: Colors.black54,
          //         )),
          //     title: Container(
          //         height: 45,
          //         child: Image.asset(
          //           'assets/images/logo.png',
          //         )),
          //     bottom:  PreferredSize(
          //       preferredSize: Size(MediaQuery.of(context).size.width,bottomVisible? bottomAppSize:0),
          //       child: bottomVisible? SearchCategoriesClass():Container(),
          //     ),
          //     actions: [
          //       InkWell(
          //           onTap: () {
          //             locator<NavigationService>().pushNamed(routes.SearchPage);
          //           },
          //           child: Icon(
          //             FontAwesomeIcons.search,
          //             size: 20,
          //             color: Colors.black54,
          //           )),
          //       SizedBox(
          //         width: ScreenUtil().setWidth(24),
          //       ),
          //       InkWell(
          //           onTap: () {
          //            if (Provider.of<ProfileModel>(context, listen: false).user == null)
          //                   {
          //                     locator<NavigationService>().pushNamed(routes.LoginRoute);
          //             }
          //            else {
          //              locator<NavigationService>().pushNamedAndRemoveUntil(
          //                  routes.ManageOrder);
          //            }
          //           },
          //           child: Icon(
          //             FontAwesomeIcons.shoppingBag,
          //             size: 20,
          //             color: Colors.black54,
          //           )),
          //       SizedBox(
          //         width: ScreenUtil().setWidth(24),
          //       ),
          //       InkWell(
          //           onTap: () {
          //             if (Provider.of<ProfileModel>(context, listen: false).user == null)
          //             {
          //               locator<NavigationService>().pushNamed(routes.LoginRoute);
          //             }
          //             else {
          //               locator<NavigationService>().pushNamedAndRemoveUntil(
          //                   routes.Wishlist);
          //             }
          //           },
          //           child: Icon(
          //             FontAwesomeIcons.heart,
          //             size: 20,
          //             color: Colors.black54,
          //           )),
          //       SizedBox(width: ScreenUtil().setWidth(24),),
          //       CartLogo(),
          //       SizedBox(width: ScreenUtil().setWidth(20),),
          //     ],
          // ),
          body:
               Stack(children: [
                 Container(
                   color: Color(0xffffffff),
                   child:
                   SingleChildScrollView(
                     controller: scrollController,
                     child: Column(
                       children: [
                         SizedBox(height: ScreenUtil().setWidth(240),),
                         //  SearchCategoriesClass(),
                         BannersSliderClass(),
                         ListDealsClass(),
                         YouMayLikeClass(),
                         BannersClass(),
                         SuggestedClass(),
                         TrendingClass(),
                         BrandClass()
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
                   child: Container(
                     height: ScreenUtil().setWidth(90),
                     color: Color(0xffffffff),
                     padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setWidth(25), ScreenUtil().setWidth(20), ScreenUtil().setWidth(0)),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             InkWell(
                                       onTap: () {
                                         scaffoldKey.currentState.openDrawer();
                                       },
                                       child: Icon(
                                         Icons.menu,
                                         size: 25,
                                         color: Color(0xff616161),
                                       )),
                             SizedBox(width: ScreenUtil().setWidth(25),),
                             Container(
                                       height: 45,
                                       child: Image.asset(
                                         'assets/images/logo.png',
                                       )),
                           ],
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             Container(
                                 padding: EdgeInsets.only(top: 2),
                                 child:
                                   InkWell(
                                       onTap: () {
                                         locator<NavigationService>().pushNamed(routes.SearchPage);
                                       },
                                       child: Icon(
                                         Icons.search,
                                         size: 25,
                                         color: Color(0xff616161),
                                       ))),
                                   SizedBox(
                                     width: ScreenUtil().setWidth(24),
                                   ),
                                   InkWell(
                                       onTap: () {
                                        if (Provider.of<ProfileModel>(context, listen: false).user == null)
                                               {
                                                 locator<NavigationService>().pushNamed(routes.LoginRoute);
                                         }
                                        else {
                                          locator<NavigationService>().pushNamed(
                                              routes.ManageOrder);
                                        }
                                       },
                                       child: Icon(
                                         Icons.shopping_bag_outlined,
                                         size: 25,
                                         color: Color(0xff616161),
                                       )),
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
                                         size: 25,
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
        );
  }
}








class SuggestedClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SuggestedClass();
  }
}

class _SuggestedClass extends State<SuggestedClass> {
  QueryMutation addMutation = QueryMutation();

  // ProductResponse productResponse;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          child: getProductList(),
        )
      ],
    );
  }

  Widget getProductList() {
    return Consumer<ProductViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.suggestedStatus == "loading") {
        Provider.of<ProductViewModel>(context, listen: false)
            .fetchSuggestedData();
        return Container();
      } else if (value.suggestedStatus == "empty") {
        return SizedBox.shrink();
      } else if (value.suggestedStatus == "error") {
        return SizedBox.shrink();
      }
      return Column(children: [
        Container(
          height: ScreenUtil().setWidth(15),
        ),
        Container(
          height: ScreenUtil().setWidth(25),
          color: Color(0xfff3f3f3),),
        Container(
          height: ScreenUtil().setWidth(15),
        ),
        Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
          width: double.infinity,
          // padding: EdgeInsets.only(
          //   bottom: ScreenUtil().setWidth(
          //       7.5), // This can be the space you need betweeb text and underline
          // ),
          // decoration: BoxDecoration(
          //     border: Border(
          //         bottom: BorderSide(
          //   color: Color(0xff32AFC8),
          //   width: 2.0, // This would be the width of the underline
          // ))),
          child: Text(
            "SUGGESTED PRODUCTS FOR YOU",
            style: ThemeApp()
                .homeHeaderThemeText(Color(0xff616161), ScreenUtil().setSp(18), true),
          ),
        ),
        Container(
          height: ScreenUtil().setWidth(15),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(7), 0, ScreenUtil().setWidth(7), 0),
          height: ScreenUtil().setWidth(303),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: value.productSuggestedResponse.data.length,
              itemBuilder: (BuildContext context, index) {
                return Column(
                  children: [
                    ProductCard(
                        value.productSuggestedResponse.data[index])
                  ],
                );
              }),
        )
      ]);
    });
  }
}

class YouMayLikeClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _YouMayLikeClass();
  }
}

class _YouMayLikeClass extends State<YouMayLikeClass> {
  QueryMutation addMutation = QueryMutation();

  // ProductResponse productResponse;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          child: getProductList(),
        )
      ],
    );
  }

  Widget getProductList() {
    return Consumer<ProductViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.youMayLikeStatus == "loading") {
        Provider.of<ProductViewModel>(context, listen: false)
            .fetchYouMayLikeData();
        return Container();
      } else if (value.youMayLikeStatus == "empty") {
        log("heere empt");

        return SizedBox.shrink();
      } else if (value.youMayLikeStatus == "error") {
        log("heere");
        return SizedBox.shrink();
      }
      return Column(children: [
        Container(
          height: ScreenUtil().setWidth(15),
        ),
        Container(
          height: ScreenUtil().setWidth(25),
          color: Color(0xfff3f3f3),),
        Container(
          height: ScreenUtil().setWidth(15),
        ),
        Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
          width: double.infinity,
          // padding: EdgeInsets.only(
          //   bottom: ScreenUtil().setWidth(
          //       7.5), // This can be the space you need betweeb text and underline
          // ),
          // decoration: BoxDecoration(
          //     border: Border(
          //         bottom: BorderSide(
          //   color: Color(0xff32AFC8),
          //   width: 2.0, // This would be the width of the underline
          // ))),
          child: Text(
            "PRODUCTS YOU MAY LIKE",
            style: ThemeApp()
                .homeHeaderThemeText(Color(0xff616161), ScreenUtil().setSp(18), true),
          ),
        ),
        Container(
          color: Color(0xffffffff),
          height: ScreenUtil().setWidth(15),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(7), 0, ScreenUtil().setWidth(7), 0),
          height: ScreenUtil().setWidth(303),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: value.productYouMayLikeResponse.data.length,
              itemBuilder: (BuildContext context, index) {
                return InkWell(
                  onTap: () {
                    Map<String, dynamic> data = {
                      "id": EVENT_YOU_MAY_LIKE,
                      "itemId":
                          value.productYouMayLikeResponse.data[index].barcode,
                      "event": "tap"
                    };
                    Tracking(event: EVENT_YOU_MAY_LIKE, data: data);
                  },
                  child: Column(children: [
                    ProductCard(
                        value.productYouMayLikeResponse.data[index])
                  ]),
                );
              }),
        )
      ]);
    });
  }
}

class TrendingClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TrendingClass();
  }
}

class _TrendingClass extends State<TrendingClass> {
  QueryMutation addMutation = QueryMutation();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: getProductList(),
        )
      ],
    );
  }

  Widget getProductList() {
    return Consumer<ProductViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.trendingStatus == "loading") {
        Provider.of<ProductViewModel>(context, listen: false).fetchHotData();
        return Container();
      } else if (value.trendingStatus == "empty") {
        return SizedBox.shrink();
      } else if (value.trendingStatus == "error") {
        return SizedBox.shrink();
      }
      return Column(children: [
        Container(
          height: ScreenUtil().setWidth(15),
        ),
        Container(
          height: ScreenUtil().setWidth(25),
          color: Color(0xfff3f3f3),),
        Container(
          height: ScreenUtil().setWidth(15),
        ),
        Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
          width: double.infinity,
          // padding: EdgeInsets.only(
          //   bottom: ScreenUtil().setWidth(
          //       7.5), // This can be the space you need betweeb text and underline
          // ),
          // decoration: BoxDecoration(
          //     border: Border(
          //         bottom: BorderSide(
          //   color: Color(0xff32AFC8),
          //   width: 2.0, // This would be the width of the underline
          // ))),
          child: Text(
            "TRENDING PRODUCTS FOR YOU",
            style: ThemeApp()
                .homeHeaderThemeText(Color(0xff616161), ScreenUtil().setSp(18), true),
          ),
        ),
        Container(
          height: ScreenUtil().setWidth(15),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(7), 0, ScreenUtil().setWidth(7), 0),
          height: ScreenUtil().setWidth(303),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: value.productTrendingResponse.data.length,
              itemBuilder: (BuildContext context, index) {
                return InkWell(
                  onTap: () {
                    Map<String, dynamic> data = {
                      "id": EVENT_TRENDING,
                      "itemId":
                          value.productTrendingResponse.data[index].barcode,
                      "event": "tap"
                    };
                    Tracking(event: EVENT_TRENDING, data: data);
                  },
                  child: Column(children: [
                    ProductCard(
                        value.productTrendingResponse.data[index])
                  ]),
                );
              }),
        )
      ]);
    });
  }
}

class BannersSliderClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BannersSliderClass();
  }
}

class _BannersSliderClass extends State<BannersSliderClass> {
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
        builder: (BuildContext context, BannerViewModel value, Widget child) {
      if (value.statusSlider == "loading") {
        Provider.of<BannerViewModel>(context, listen: false).fetchSliderData();
        return Container();
      } else if (value.statusSlider == "empty") {
        return Container();
      } else if (value.statusSlider == "error") {
        return Container();
      } else {
        log("This is Slider length"+value.sliderResponse.data.length.toString());
        return value.sliderResponse.data.length>0? Container(
          child: CarouselSlider.builder(
            itemCount: value.sliderResponse.data.length,
            options: CarouselOptions(
              viewportFraction: 1,
              aspectRatio: 20 / 9,
              enlargeCenterPage: true,
              autoPlay: true,
            ),
            itemBuilder: (ctx, index, _index) {
              if (value.sliderResponse?.data[index] != null) {
                log(index.toString());
                log(value.sliderResponse.data[index].img);
                return InkWell(
                  onTap: () async {
                    Map<String, dynamic> data = {
                      "id": EVENT_HOME_MAIN_SLIDER,
                      "imageUrl":
                          value.sliderResponse?.data[index].img.toString(),
                      "position": index,
                      "event": "tap",
                    };
                    Tracking(event: EVENT_HOME_MAIN_SLIDER, data: data);
print("link ${value.sliderResponse.data[index].link}");

                    if (value.sliderResponse.data[index].link == null ||
                        value.sliderResponse.data[index].link == "") {

                    }
                   else if(value.sliderResponse.data[index].link.contains(ApiEndpoint().brandLink)){
                      log("here");
                     for(int i=0; i<Provider.of<BrandViewModel>(context,listen: false).brandResponse.data.length;i++)
                     {
                       print(Provider.of<BrandViewModel>(context,listen: false).brandResponse.data[i].name);
                       if(Provider.of<BrandViewModel>(context,listen: false).brandResponse.data[i].name.toLowerCase()==value.sliderResponse.data[index].link.split(ApiEndpoint().brandLink)[1]){
                       print("here ytii");
                         locator<NavigationService>().pushNamed(routes.BrandPage,args: {"brandData":Provider.of<BrandViewModel>(context,listen: false).brandResponse.data[i]});
                       }
                     }
                    }
                   else{
                      locator<NavigationService>().push(MaterialPageRoute(
                          builder: (context) => ProductList("", "", "", "", "",
                              value.sliderResponse.data[index].link)));
                    }

                  },
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().radius(5))),
                      child: Container(
                        width: ScreenUtil().setWidth(414),
                         height: MediaQuery.of(context).size.height * 0.10,
                        child: Image.network(
                          value.sliderResponse?.data[index].img.toString(),
                          width: ScreenUtil().setWidth(414),
                           height: MediaQuery.of(context).size.height * 0.10,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ):Container();
      }
    });
  }
}

class BannersClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BannersClass();
  }
}

class _BannersClass extends State<BannersClass> {
  QueryMutation addMutation = QueryMutation();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [Container(child: getBannersList())],
    );
  }

  Widget getBannersList() {
    return Consumer<BannerViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.statusBanner == "loading") {
        Provider.of<BannerViewModel>(context, listen: false).fetchBannerData();
        return Container();
      } else if (value.statusBanner == "empty") {
        return SizedBox.shrink();
      } else if (value.statusBanner == "error") {
        return SizedBox.shrink();
      } else {
        return Column(children: getColumn(value.bannerResponse));
      }
    });
  }

  getColumn(BannerResponse bannerResponse) {
    List<Widget> children = [];
    for (int i = 0; i < bannerResponse.groupByBanner.length; i++) {
      children.add(
        SizedBox(
          height: 10,
        ),
      );
      children.add(InkWell(
          onTap: () async {

            if (bannerResponse.groupByBanner[i].data[0].link == null ||
                bannerResponse.groupByBanner[i].data[0].link == "") {

            }
            else if(bannerResponse.groupByBanner[i].data[0].link.contains(ApiEndpoint().brandLink)){
              for(int i=0; i<Provider.of<BrandViewModel>(context,listen: false).brandResponse.data.length;i++)
              {
                if(Provider.of<BrandViewModel>(context,listen: false).brandResponse.data[i].name.toLowerCase()==bannerResponse.groupByBanner[i].data[0].link.split(ApiEndpoint().brandLink)[1]){
                  locator<NavigationService>().pushNamed(routes.BrandPage,args: {"brandData":Provider.of<BrandViewModel>(context,listen: false).brandResponse.data[i]});
                }
              }
            }
            else{
              locator<NavigationService>().push(MaterialPageRoute(
                  builder: (context) => ProductList("", "", "", "", "",
                      bannerResponse.groupByBanner[i].data[0].link)));
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/loading.gif',
                image: bannerResponse.groupByBanner[i].data[0].img),
          )));
      children.add(
        SizedBox(
          height: 10,
        ),
      );
      children.add(Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        height: 185,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bannerResponse.groupByBanner[i].data.length,
            itemBuilder: (BuildContext context, index) {
              if (bannerResponse.groupByBanner[0].data != null) {
                return InkWell(
                  onTap: () {},
                  child: Column(children: [
                    InkWell(
                      onTap: () async {
                        Map<String, dynamic> data = {
                          "id": EVENT_HOME_PROMO_BANNER,
                          "position": index,
                          "event": "tap"
                        };
                        Tracking(event: EVENT_HOME_PROMO_BANNER, data: data);


                        if (bannerResponse.groupByBanner[i].data[index].link == null ||
                            bannerResponse.groupByBanner[i].data[index].link == "") {

                        }
                        else if(bannerResponse.groupByBanner[i].data[index].link.contains(ApiEndpoint().brandLink)){
                          log("here");
                          for(int i=0; i<Provider.of<BrandViewModel>(context,listen: false).brandResponse.data.length;i++)
                          {
                            log(i.toString());
                            if(Provider.of<BrandViewModel>(context,listen: false).brandResponse.data[i].name.toLowerCase()==bannerResponse.groupByBanner[i].data[index].link.split(ApiEndpoint().brandLink)[1]){
                              locator<NavigationService>().pushNamed(routes.BrandPage,args: {"brandData":Provider.of<BrandViewModel>(context,listen: false).brandResponse.data[i]});
                            }
                          }
                        }
                        else{
                          locator<NavigationService>().push(MaterialPageRoute(
                              builder: (context) => ProductList("", "", "", "", "",
                                  bannerResponse.groupByBanner[i].data[index].link)));
                        }
                      },
                      child: index == 0
                          ? Container()
                          : Container(
                              height: 160,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/loading.gif',
                                image: bannerResponse
                                    .groupByBanner[i].data[index].img,
                              ),
                              margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                            ),
                    ),
                  ]),
                );
              } else {
                return SizedBox.shrink();
              }
            }),
      ));
    }
    return children;
  }
}

class ListDealsClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListDealsClass();
  }
}

class _ListDealsClass extends State<ListDealsClass> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [getDealsList()],
    );
  }

  Widget getDealsList() {
    return Consumer<ListDealsViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.status == "loading") {
        Provider.of<ListDealsViewModel>(context, listen: false)
            .fetchDealsData();
        return Container();
      } else if (value.status == "empty") {
        return SizedBox.shrink();
      } else if (value.status == "error") {
        return SizedBox.shrink();
      } else {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("assets/images/dealListBackground.gif"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtil().setWidth(20),
              ),
              Text(
                "Deals of",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(
                      44,
                    )),
              ),
              Text(
                "the Week",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(
                      44,
                    )),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(32),
              ),
              Text("Sales are expiring in",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(
                        16,
                      ))),
              SizedBox(
                height: ScreenUtil().setWidth(19),
              ),
              Container(
                child: CountdownTimer(
                  endTime:
                      int.parse(value.listDealsResponse.data[0].endTimeISO),
                  widgetBuilder: (_, CurrentRemainingTime time) {
                    if (time == null) {
                      return Text('Ended');
                    }
                    return Container(
                      height: ScreenUtil().setWidth(44),
                      width: ScreenUtil().setWidth(241),
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
                                      "${(time.hours != null ? time.hours : 0) ~/ 10}",
                                      style: TextStyle(color: Colors.black38))),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                              )),
                          SizedBox(
                            width: ScreenUtil().setWidth(4),
                          ),
                          Container(
                              height: 31,
                              width: 31,
                              // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                              child: Center(
                                  child: Text(
                                      "${(time.hours != null ? time.hours : 0) % 10}",
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
                                      "${(time.min != null ? time.min : 0) ~/ 10}",
                                      style: TextStyle(color: Colors.black38))),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                              )),
                          SizedBox(
                            width: ScreenUtil().setWidth(4),
                          ),
                          Container(
                              height: ScreenUtil().setWidth(31),
                              width: ScreenUtil().setWidth(31),
                              // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                              child: Center(
                                  child: Text(
                                      "${(time.min != null ? time.min : 0) % 10}",
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
                                      "${(time.sec != null ? time.sec : 0) ~/ 10}",
                                      style: TextStyle(color: Colors.black38))),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                              )),
                          SizedBox(
                            width: ScreenUtil().setWidth(4),
                          ),
                          Container(
                              height: ScreenUtil().setWidth(31),
                              width: ScreenUtil().setWidth(31),
                              // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                              child: Center(
                                  child: Text(
                                      "${(time.sec != null ? time.sec : 0) % 10}",
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
              ),
              SizedBox(
                height: ScreenUtil().setWidth(48),
              ),
              Container(
                padding:
                    EdgeInsets.fromLTRB(ScreenUtil().setWidth(40), 0, 0, 0),
                height: ScreenUtil().setWidth(254),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: value.listDealsResponse.data[0].products.length,
                    itemBuilder: (BuildContext context, index) {
                      return ProductViewColorCard(
                          value.listDealsResponse.data[0].products[index]);
                    }),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(40),
              )
            ],
          ),
        );
      }
    });
  }
}

class CategoriesClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CategoriesClass();
  }
}

class _CategoriesClass extends State<CategoriesClass> {
  QueryMutation addMutation = QueryMutation();

  // CategoriesResponse categoryResponse;

  @override
  Widget build(BuildContext context) {
    // ApiResponse apiResponse = Provider.of<CategoryViewModel>(context).response;
    // categoryResponse = apiResponse.data as CategoriesResponse;
    // TODO: implement build
    return Column(
      children: [
        Container(
          // This can be the space you need between text and underline
          padding: EdgeInsets.only(bottom: 3, top: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Color(0xff32AFC8),
            width: ScreenUtil()
                .setWidth(3), // This would be the width of the underline
          ))),
          child: Text(
            "Categories",
            style: TextStyle(
                color: Color(0xff32AFC8),
                fontWeight: FontWeight.w500,
                fontSize: 18.0),
            // style: ThemeApp().underlineThemeText(Color(0xff32AFC8), 18.0, true),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(30),
        ),
        getCategoriesList()
      ],
    );
  }

  Widget getCategoriesList() {
    return Consumer<CategoryViewModel>(
      builder: (BuildContext context, value, Widget child) {
        if (value.status == "loading") {
          Provider.of<CategoryViewModel>(context, listen: false)
              .fetchCategoryData();
          if (Provider.of<ProfileModel>(context).user == null) {
            Provider.of<ProfileModel>(context, listen: false).getProfile();
          }
          return Loading();
        } else if (value.status == "empty") {
          return SizedBox.shrink();
        } else if (value.status == "error") {
          return SizedBox.shrink();
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * 0.35,
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(10), 0),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 2.6),
                    crossAxisCount: 2),
                itemCount: value.categoryResponse.data.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext build, index) {
                  return Container(
                      child: InkWell(
                          onTap: () {},
                          child: InkWell(
                            onTap: () {
                              Map<String, dynamic> data = {
                                "id": EVENT_HOME_CATEGORIES,
                                "title":
                                    value.categoryResponse.data[index].name,
                                "url": value.categoryResponse.data[index].slug,
                                "event": "tap"
                              };
                              Tracking(
                                  event: EVENT_HOME_CATEGORIES, data: data);
                              locator<NavigationService>()
                                  .pushNamed(routes.ProductList, args: {
                                "searchKey": "",
                                "category":
                                    value.categoryResponse.data[index].slug,
                                "brandName": "",
                                "parentBrand": ""
                              });
                            },
                            child: Column(
                              children: [
                                Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(
                                                ScreenUtil().radius(40)),
                                            topRight: Radius.circular(
                                                ScreenUtil().radius(40)),
                                            bottomLeft: Radius.circular(
                                                ScreenUtil().radius(40)),
                                            topLeft: Radius.circular(
                                                ScreenUtil().radius(40)))),
                                    child: Container(
                                        width: ScreenUtil().radius(95),
                                        height: ScreenUtil().radius(95),
                                        decoration: new BoxDecoration(
                                            border: Border(
                                                bottom:
                                                    BorderSide(color: Color(0xff32AFC8), width: ScreenUtil().setWidth(1)),
                                                top: BorderSide(color: Color(0xff32AFC8), width: ScreenUtil().setWidth(1)),
                                                left: BorderSide(color: Color(0xff32AFC8), width: ScreenUtil().setWidth(1)),
                                                right: BorderSide(color: Color(0xff32AFC8), width: ScreenUtil().setWidth(1))),
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(fit: BoxFit.cover, image: new NetworkImage(value.categoryResponse.data[index].img ?? 'https://next.anne.com/icon.png'))))),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  value.categoryResponse.data[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(
                                        14,
                                      ),
                                      color: Color(0xff616161)),
                                ),
                              ],
                            ),
                          )));
                }),
          );
        }
      },
    );
  }
}

class BrandClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BrandClass();
  }
}

class _BrandClass extends State<BrandClass> {
  QueryMutation addMutation = QueryMutation();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getBrandsList();
  }

  Widget getBrandsList() {
    return Consumer<BrandViewModel>(
      builder: (BuildContext context, value, Widget child) {
        if (value.status == "loading") {
          Provider.of<BrandViewModel>(context, listen: false).fetchBrandData();
          return Container();
        } else if (value.status == "empty") {
          return SizedBox.shrink();
        } else if (value.status == "error") {
          return SizedBox.shrink();
        } else {
          return Column(
            children: [
              Container(
                color:Color(0xffffffff),
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                height: ScreenUtil().setWidth(25),
                color: Color(0xfff3f3f3),),
              Container(
                color:Color(0xffffffff),
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                color:Color(0xffffffff),
                width: double.infinity,
                // padding: EdgeInsets.only(
                //   bottom: ScreenUtil().setWidth(
                //       7.5), // This can be the space you need betweeb text and underline
                // ),
                // decoration: BoxDecoration(
                //     border: Border(
                //         bottom: BorderSide(
                //   color: Color(0xff32AFC8),
                //   width: 2.0, // This would be the width of the underline
                // ))),
                child: Text(
                  "TOP BRANDS FOR YOU",
                  style: ThemeApp()
                      .homeHeaderThemeText(Color(0xff616161), ScreenUtil().setSp(18), true),
                ),
              ),
              Container(
                color: Color(0xffffffff),
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                color: Color(0xffffffff),
                //  color: Colors.white,
                height: ScreenUtil().setWidth(61),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(25), 0, ScreenUtil().setWidth(25), 0),
                child: ListView.builder(

                    scrollDirection: Axis.horizontal,
                    itemCount: value.brandResponse.data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext build, index) {
                      BrandData data = value.brandResponse.data[index];
                      return Container(
                        color: Color(0xffffffff),
                        //  color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            locator<NavigationService>().pushNamed(
                                routes.BrandPage,
                                args: {"brandData": data});
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(15)),
                            width: ScreenUtil().setWidth(103),
                            height: ScreenUtil().setWidth(61),
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              image: new DecorationImage(
                                fit: BoxFit.contain,
                                image: data.img != null
                                    ? NetworkImage(data.img)
                                    : NetworkImage(
                                        'https://next.anne.com/icon.png'),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Container(
                color: Color(0xffffffff),
                height: ScreenUtil().setWidth(30),
              )
            ],
          );
        }
      },
    );
  }
}
