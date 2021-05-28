import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/view_model/auth_view_model.dart';
import 'package:anne/view_model/banner_view_model.dart';
import 'package:anne/view_model/brand_view_model.dart';
import 'package:anne/view_model/category_view_model.dart';
import 'package:anne/view_model/home_view_model.dart';
import 'package:anne/view_model/list_details_view_model.dart';
import 'package:anne/view_model/product_view_model.dart';
import 'package:anne/utility/theme.dart';
import 'package:anne/view/menu.dart';
import 'cart_logo.dart';
import 'product_list.dart';
import 'package:anne/components/widgets/loading.dart';
import 'package:anne/components/widgets/productViewColor2Card.dart';
import 'package:anne/components/widgets/productViewColor3Card.dart';
import 'package:anne/components/widgets/productViewColorCard.dart';
import 'package:anne/components/widgets/productViewSpecialCard.dart';
import 'package:anne/values/route_path.dart' as routes;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (BuildContext context) => HomeViewModel(context),
        child: Consumer<HomeViewModel>(
          builder: (context, model, child) {
            return Stack(
              children: [HomeBackground(model), HomeForeground(model)],
            );
          },
        ),
      ),
    );
  }
}

class HomeBackground extends StatefulWidget {
  final HomeViewModel model;

  HomeBackground(this.model);

  @override
  _HomeBackgroundState createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.model.isDrawerOpen) {
          widget.model.resize();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Menu(widget.model),
      ),
    );
  }
}

class HomeForeground extends StatefulWidget {
  final HomeViewModel model;

  HomeForeground(this.model);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Home();
  }
}

class _Home extends State<HomeForeground> {
  var counter = 4;
  var searchVisible = false;
  QueryMutation addMutation = QueryMutation();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedContainer(
      curve: Curves.easeIn,
      transform: Matrix4.translationValues(
          widget.model.xOffset, widget.model.yOffset, widget.model.zOffset)
        ..scale(widget.model.scaleFactor)
        ..rotateY(widget.model.isDrawerOpen ? 0.5 : 0),
      duration: Duration(milliseconds: 300),
      child: ClipRRect(
        borderRadius: widget.model.isDrawerOpen
            ? BorderRadius.circular(20)
            : BorderRadius.circular(0),
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: InkWell(
                  onTap: () => widget.model.resize(),
                  child: Icon(
                    Icons.menu,
                    color: Colors.black54,
                  )),
              title: Container(
                  height: 35,
                  child: Image.asset(
                    'assets/images/anne.png',
                  )),
              actions: [
                InkWell(
                    onTap: () {
                      locator<NavigationService>().pushNamed(routes.SearchPage);
                    },
                    child: Icon(
                      Icons.search,
                      size: 24,
                      color: Colors.black54,
                    )),
                SizedBox(
                  width: 8,
                ),
                CartLogo()
              ]),
          body: Container(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Container(
                      //     margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //     Container(
                      //       padding: EdgeInsets.only(
                      //         bottom:
                      //             3, // This can be the space you need betweeb text and underline
                      //       ),
                      //       decoration: BoxDecoration(
                      //           border: Border(
                      //               bottom: BorderSide(
                      //         color: counter == 1
                      //             ? Color(0xffee7625)
                      //             : Colors.transparent,
                      //         width: counter == 1
                      //             ? 2.0
                      //             : 0.0, // This would be the width of the underline
                      //       ))),
                      //       child: InkWell(
                      //         onTap: () {
                      //           setState(() {
                      //             counter = 1;
                      //           });
                      //         },
                      //         child: Text("Fashion",
                      //             style: ThemeApp().underlineThemeText(
                      //                 Color(0xffee7625),
                      //                 15.0,
                      //                 counter == 1 ? true : false)),
                      //       ),
                      //     ),
                      //     Container(
                      //       padding: EdgeInsets.only(
                      //         bottom:
                      //             3, // This can be the space you need betweeb text and underline
                      //       ),
                      //       decoration: BoxDecoration(
                      //           border: Border(
                      //               bottom: BorderSide(
                      //         color: counter == 2
                      //             ? Color(0xffee7625)
                      //             : Colors.transparent,
                      //         width: counter == 2
                      //             ? 2.0
                      //             : 0.0, // This would be the width of the underline
                      //       ))),
                      //       child: InkWell(
                      //         onTap: () {
                      //           setState(() {
                      //             counter = 2;
                      //           });
                      //         },
                      //         child: Text("Toys",
                      //             style: ThemeApp().underlineThemeText(
                      //                 Color(0xffee7625),
                      //                 15.0,
                      //                 counter == 2 ? true : false)),
                      //       ),
                      //     ),
                      //     Container(
                      //       padding: EdgeInsets.only(
                      //         bottom:
                      //             3, // This can be the space you need betweeb text and underline
                      //       ),
                      //       decoration: BoxDecoration(
                      //           border: Border(
                      //               bottom: BorderSide(
                      //         color: counter == 3
                      //             ? Color(0xffee7625)
                      //             : Colors.transparent,
                      //         width: counter == 3
                      //             ? 2.0
                      //             : 0.0, // This would be the width of the underline
                      //       ))),
                      //       child: InkWell(
                      //         onTap: () {
                      //           setState(() {
                      //             counter = 3;
                      //           });
                      //         },
                      //         child: Text("Baby Care",
                      //             style: ThemeApp().underlineThemeText(
                      //                 Color(0xffee7625),
                      //                 15.0,
                      //                 counter == 3 ? true : false)),
                      //       ),
                      //     ),
                      //     Container(
                      //       padding: EdgeInsets.only(
                      //         bottom:
                      //             3, // This can be the space you need betweeb text and underline
                      //       ),
                      //       decoration: BoxDecoration(
                      //           border: Border(
                      //               bottom: BorderSide(
                      //         color: counter == 4
                      //             ? Color(0xffee7625)
                      //             : Colors.transparent,
                      //         width: counter == 4
                      //             ? 2.0
                      //             : 0.0, // This would be the width of the underline
                      //       ))),
                      //       child: InkWell(
                      //         onTap: () {
                      //           setState(() {
                      //             counter = 4;
                      //           });
                      //         },
                      //         child: Text("All",
                      //             style: ThemeApp().underlineThemeText(
                      //                 Color(0xffee7625),
                      //                 15.0,
                      //                 counter == 4 ? true : false)),
                      //       ),
                      //     ),
                      //   ],
                      // )),
                      BannersSliderClass(),
                      SizedBox(
                        height: 10,
                      ),
                      CategoriesClass(),
                      ListDealsClass(),
                      YouMayLikeClass(),
                      BannersClass(),
                      SuggestedClass(),
                      TrendingClass(),
                      BrandClass()
                    ],
                  ),
                ),
                widget.model.isDrawerOpen
                    ? InkWell(
                        onTap: () {
                          if (widget.model.isDrawerOpen) {
                            widget.model.resize();
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
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
        SizedBox(
          height: ScreenUtil().setWidth(51),
        ),
        Container(
          padding: EdgeInsets.only(
            bottom: ScreenUtil().setWidth(
                3), // This can be the space you need betweeb text and underline
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Color(0xff32AFC8),
            width: ScreenUtil()
                .setWidth(2), // This would be the width of the underline
          ))),
          child: Text(
            "Suggested For You",
            style: ThemeApp().underlineThemeText(Color(0xff32AFC8), 18.0, true),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(43.5),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(7), 0, ScreenUtil().setWidth(7), 0),
          height: ScreenUtil().setWidth(190),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: value.productSuggestedResponse.data.length,
              itemBuilder: (BuildContext context, index) {
                return Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(29)),
                    child: ProductViewSpecialCard(
                        value.productSuggestedResponse.data[index]));
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
        return SizedBox.shrink();
      } else if (value.youMayLikeStatus == "error") {
        return SizedBox.shrink();
      }
      return Column(children: [
        SizedBox(
          height: ScreenUtil().setWidth(38),
        ),
        Container(
          padding: EdgeInsets.only(
            bottom: ScreenUtil().setWidth(
                3), // This can be the space you need betweeb text and underline
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Color(0xffC53193),
            width: ScreenUtil()
                .setWidth(2), // This would be the width of the underline
          ))),
          child: Text(
            "You May Like",
            style: ThemeApp().underlineThemeText(Color(0xffC53193), 18.0, true),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(40),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(7), 0, ScreenUtil().setWidth(7), 0),
          height: ScreenUtil().setWidth(254),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: value.productYouMayLikeResponse.data.length,
              itemBuilder: (BuildContext context, index) {
                return Column(children: [
                  ProductViewColor2Card(
                      value.productYouMayLikeResponse.data[index])
                ]);
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
        SizedBox(
          height: ScreenUtil().setWidth(54),
        ),
        Container(
          padding: EdgeInsets.only(
            bottom: ScreenUtil().setWidth(
                3), // This can be the space you need betweeb text and underline
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Color(0xffA1CF5F),
            width: ScreenUtil()
                .setWidth(2), // This would be the width of the underline
          ))),
          child: Text(
            "Trending",
            style: ThemeApp().underlineThemeText(Color(0xffA1CF5F), 18.0, true),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(40),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(7), 0, ScreenUtil().setWidth(7), 0),
          height: ScreenUtil().setWidth(260),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: value.productTrendingResponse.data.length,
              itemBuilder: (BuildContext context, index) {
                return Column(children: [
                  ProductViewColor3Card(
                      value.productTrendingResponse.data[index])
                ]);
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
        SizedBox(
          height: 10,
        ),
        Container(child: getBannersList())
      ],
    );
  }

  Widget getBannersList() {
    return Consumer<BannerViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.statusSlider == "loading") {
        Provider.of<BannerViewModel>(context, listen: false).fetchSliderData();
        return Container();
      } else if (value.statusSlider == "empty") {
        return Container();
      } else if (value.statusSlider == "error") {
        return Container();
      } else {
        return Container(
          child: CarouselSlider.builder(
            itemCount: value.bannerSliderResponse.data.length,
            options: CarouselOptions(
              viewportFraction: 1,
              aspectRatio: 20 / 9,
              enlargeCenterPage: true,
              autoPlay: true,
            ),
            itemBuilder: (ctx, index, _index) {
              if (value.bannerSliderResponse?.data[index] != null) {
                return Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().radius(5))),
                    child: Container(
                      width: ScreenUtil().setWidth(380),
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: Image.network(
                        value.bannerSliderResponse?.data[index].img.toString(),
                        width: ScreenUtil().setWidth(380),
                        height: MediaQuery.of(context).size.height * 0.10,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        );
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
        return Column(children: [
          SizedBox(
            height: 10,
          ),
          InkWell(
              onTap: () {
                locator<NavigationService>()
                    .pushNamed(routes.ProductList, args: {
                  "searchKey": value.bannerBannerResponse.data[0].link,
                  "category": "",
                  "brandName": ""
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(9, 10, 9, 10),
                child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: value.bannerBannerResponse.data[0].img),
              )),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
            height: 185,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: value.bannerBannerResponse.data.length,
                itemBuilder: (BuildContext context, index) {
                  if (value.bannerBannerResponse.data != null) {
                    return Column(children: [
                      InkWell(
                        onTap: () {
                          locator<NavigationService>().push(MaterialPageRoute(
                              builder: (context) => ProductList(
                                  value.bannerBannerResponse.data[index].link,
                                  "",
                                  "")));
                        },
                        child: index == 0
                            ? Container()
                            : Container(
                                height: 160,
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/loading.gif',
                                  image: value
                                      .bannerBannerResponse.data[index].img,
                                ),
                                margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                              ),
                      ),
                    ]);
                  } else {
                    return SizedBox.shrink();
                  }
                }),
          ),
        ]);
      }
    });
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
                height: ScreenUtil().setWidth(38),
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
                          onTap: () {
                            locator<NavigationService>()
                                .pushNamed(routes.ProductList, args: {
                              "searchKey": "",
                              "category":
                                  value.categoryResponse.data[index].slug,
                              "brandName": ""
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
                                              bottom: BorderSide(
                                                  color: Color(0xff32AFC8),
                                                  width: ScreenUtil().setWidth(2)),
                                              top: BorderSide(color: Color(0xff32AFC8), width: ScreenUtil().setWidth(2)),
                                              left: BorderSide(color: Color(0xff32AFC8), width: ScreenUtil().setWidth(2)),
                                              right: BorderSide(color: Color(0xff32AFC8), width: ScreenUtil().setWidth(2))),
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
              SizedBox(
                height: ScreenUtil().setWidth(56),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: ScreenUtil().setWidth(
                      7.5), // This can be the space you need betweeb text and underline
                ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Color(0xff32AFC8),
                  width: 2.0, // This would be the width of the underline
                ))),
                child: Text(
                  "Brands",
                  style: ThemeApp()
                      .underlineThemeText(Color(0xff32AFC8), 18.0, true),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(44.5),
              ),
              Container(
                  //  color: Colors.white,
                  height: 61,
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(52), 0,
                      ScreenUtil().setWidth(51), 0),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: value.brandResponse.data.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext build, index) {
                        print(value.brandResponse.data[index].name);
                        return Container(
                            //  color: Colors.white,
                            child: InkWell(
                                onTap: () {
                                  locator<NavigationService>()
                                      .pushNamed(routes.ProductList, args: {
                                    "searchKey": "",
                                    "category": "",
                                    "brandName":
                                        value.brandResponse.data[index].name
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(30)),
                                    width: ScreenUtil().setWidth(83),
                                    height: ScreenUtil().setWidth(61),
                                    decoration: new BoxDecoration(
                                        //  color: Color(0xffffffff),
                                        image: new DecorationImage(
                                            fit: BoxFit.contain,
                                            image: value.brandResponse
                                                        .data[index].img !=
                                                    null
                                                ? NetworkImage(value
                                                    .brandResponse
                                                    .data[index]
                                                    .img)
                                                : NetworkImage(
                                                    'https://next.anne.com/icon.png'))))));
                      })),
              SizedBox(
                height: ScreenUtil().setWidth(30),
              )
            ],
          );
        }
      },
    );
  }
}
