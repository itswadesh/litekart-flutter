import 'dart:developer';
import 'package:anne/components/widgets/productCard.dart';
import 'package:anne/utility/api_endpoint.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';
import 'package:anne/utility/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:anne/components/base/tz_dialog.dart';
import 'package:anne/enum/tz_dialog_type.dart';
import 'package:anne/values/colors.dart';
import 'package:anne/view_model/settings_view_model.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../../components/widgets/cartEmptyMessage.dart';
import '../../model/product.dart';
import '../../response_handler/productGroupResponse.dart';
import '../../service/event/tracking.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import '../../utility/query_mutation.dart';
import '../../components/widgets/errorMessage.dart';
import '../../values/event_constant.dart';
import '../../view/cart_logo.dart';
import '../../view_model/auth_view_model.dart';
import '../../view_model/cart_view_model.dart';
import '../../utility/graphQl.dart';
import '../../components/widgets/loading.dart';
import '../../values/route_path.dart' as routes;
import '../../view_model/product_detail_view_model.dart';
import '../../view_model/wishlist_view_model.dart';
import 'package:flutter_html/flutter_html.dart';
import '../main.dart';
import 'package:anne/view_model/product_view_model.dart';
import 'package:vibration/vibration.dart';

class ProductDetail extends StatefulWidget {
  final productId;

  ProductDetail(this.productId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductDetail();
  }
}

class _ProductDetail extends State<ProductDetail>
    with TickerProviderStateMixin {
  late AnimationController _ColorAnimationController;
  late AnimationController _TextAnimationController;
  late Animation _colorTween, _iconColorTween;
  Animation<Offset>? _transTween;
  QueryMutation addMutation = QueryMutation();
  final NavigationService? _navigationService = locator<NavigationService>();
  var indexImage = 0;
  var icon;
  var _numPages = 0;
  var _currentPage = 0;
  String? productId;
  PageController? pageController;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Color(0xFFf3f3f3))
        .animate(_ColorAnimationController);
    // _iconColorTween = ColorTween(begin: Colors.grey, end: Colors.white)
    //     .animate(_ColorAnimationController);

    _TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _transTween = Tween(begin: Offset(-ScreenUtil().setWidth(10), ScreenUtil().setWidth(40)), end: Offset(-ScreenUtil().setWidth(10), 0))
        .animate(_TextAnimationController);

    productId = widget.productId;
   // productId = "61644dceaf07bf876d2c9f72";
    Provider.of<ProductDetailViewModel>(context, listen: false)
        .changeStatus("loading");
    Provider.of<ProductViewModel>(context, listen: false).changeRecommendedStatus("loading");
    pageController =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
    scrollController.addListener(() {
      _scrollListener();
    });
    super.initState();
  }

   _scrollListener() {
    if (scrollController.position.axis == Axis.vertical) {
      _ColorAnimationController.animateTo(
          scrollController.position.pixels / ScreenUtil().setWidth(350));

      _TextAnimationController.animateTo(
          (scrollController.position.pixels - ScreenUtil().setWidth(350)) / ScreenUtil().setWidth(50));
      return true;
    }
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
      height: ScreenUtil().setWidth(8),
      width: ScreenUtil().setWidth(8),
      decoration: BoxDecoration(
        color: isActive ? Color(0Xff454545) : Color(0X4d000000),
        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12))),
      ),
    );
  }

  _createDynamicLink(bool short, id,slug) async {
    var _linkMessage;
    var dynamicUrl;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://annebiz.page.link/',
      link: Uri.parse('https://www.anne.biz/$slug?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'biz.anne.app',
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(bundleId: 'biz.anne.app'),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    //Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      dynamicUrl = shortLink.shortUrl;
    } else {
      dynamicUrl = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = dynamicUrl.toString();
    });

    return dynamicUrl;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Color(0xfff3f3f3),
        body: SafeArea(
        bottom: false,
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: Consumer<ProductDetailViewModel>(
                builder: (BuildContext context, value, Widget? child) {
              if (value.status == "loading") {
                Provider.of<ProductDetailViewModel>(context, listen: false)
                    .changeButtonStatus("ADD TO BAG");
                Provider.of<ProductDetailViewModel>(context, listen: false)
                    .fetchProductDetailData(productId);
                return Loading();
              }
              if (value.status == "empty") {
                return Stack(children:[ cartEmptyMessage(
                    "search", "Product Not Found !!"),
                  Align(
                      alignment: Alignment.topCenter,
                      child: AnimatedBuilder(
                          animation: _ColorAnimationController,
                          builder: (context, child) => Container(
                            color: _colorTween.value,
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(20, ScreenUtil().setWidth(15),
                                ScreenUtil().setWidth(20), ScreenUtil().setWidth(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      locator<NavigationService>().pop();
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
                                          Icons.arrow_back,
                                          size: ScreenUtil().setWidth(18),
                                        ))),
                                /*InkWell(
                    onTap: () async {
                      TzDialog _dialog =
                      TzDialog(context, TzDialogType.progress);
                      _dialog.show();
                     var dynamicLink = await _createDynamicLink(true, productData.id);
                     _dialog.close();
                      final RenderBox box = context.findRenderObject();
                      await Share.share(
                          "Hi, Check out this awesome product on anne : $dynamicLink \n\n Weblink : ${ApiEndpoint().url}/${productData.slug}?id=$productId",
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    },
                    child: Icon(
                      Icons.share,
                      size: 20,
                    )),*/
                                // SizedBox(
                                //   width: ScreenUtil().setWidth(15),
                                // ),
                                Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        InkWell(
                                          onTap: () {
                                            Map<String, dynamic> data = {
                                              "id": EVENT_PRODUCT_DETAILS_ADD_TO_WISHLIST,
                                              "itemId": productId,
                                              "event": "tap"
                                            };
                                            Tracking(
                                                event:
                                                EVENT_PRODUCT_DETAILS_ADD_TO_WISHLIST,
                                                data: data);
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
                                              child: InkWell(
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
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(15),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, ScreenUtil().setWidth(0), 0),
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
                                          child:
                                          // Transform.translate(
                                          //   offset: Offset(-10, 0),
                                          //   child:
                                          CartLogo(24),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ))),
                ]);
              }
              if (value.status == "error") {
                return Stack(children: [
                  errorMessage(),
                  Align(
                      alignment: Alignment.topCenter,
                      child: AnimatedBuilder(
                          animation: _ColorAnimationController,
                          builder: (context, child) => Container(
                            color: _colorTween.value,
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(20, ScreenUtil().setWidth(15),
                                ScreenUtil().setWidth(20), ScreenUtil().setWidth(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               InkWell(
                                    onTap: () {
                                      locator<NavigationService>().pop();
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
                                          Icons.arrow_back,
                                          size: ScreenUtil().setWidth(18),
                                        ))),


                                /*InkWell(
                    onTap: () async {
                      TzDialog _dialog =
                      TzDialog(context, TzDialogType.progress);
                      _dialog.show();
                     var dynamicLink = await _createDynamicLink(true, productData.id);
                     _dialog.close();
                      final RenderBox box = context.findRenderObject();
                      await Share.share(
                          "Hi, Check out this awesome product on anne : $dynamicLink \n\n Weblink : ${ApiEndpoint().url}/${productData.slug}?id=$productId",
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    },
                    child: Icon(
                      Icons.share,
                      size: 20,
                    )),*/
                                // SizedBox(
                                //   width: ScreenUtil().setWidth(15),
                                // ),
                                Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        InkWell(
                                          onTap: () {
                                            Map<String, dynamic> data = {
                                              "id": EVENT_PRODUCT_DETAILS_ADD_TO_WISHLIST,
                                              "itemId": productId,
                                              "event": "tap"
                                            };
                                            Tracking(
                                                event:
                                                EVENT_PRODUCT_DETAILS_ADD_TO_WISHLIST,
                                                data: data);
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
                                              child: InkWell(
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
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(15),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, ScreenUtil().setWidth(0), 0),
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
                                          child:
                                          // Transform.translate(
                                          //   offset: Offset(-10, 0),
                                          //   child:
                                          CartLogo(24),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ))),
                ],) ;
              }
              if (value.productDetailResponse!.stock! <= 0) {
                Provider.of<ProductDetailViewModel>(context, listen: false)
                    .changeButtonStatus("Not Available");
              }
              if (Provider.of<CartViewModel>(context).cartResponse != null) {
                for (int i = 0;
                    i <
                        Provider.of<CartViewModel>(context)
                            .cartResponse!
                            .items!
                            .length;
                    i++) {
                  if (Provider.of<CartViewModel>(context)
                          .cartResponse!
                          .items![i]
                          .pid ==
                      productId) {
                    Provider.of<ProductDetailViewModel>(context, listen: false)
                        .changeButtonStatus("GO TO CART");
                  }
                }
              }
              _numPages = value.productDetailResponse!.images!.length;
              return getProductDetails(value.productDetailResponse!);
            }))));
  }

  Widget getProductDetails(ProductDetailData productData) {
    icon = Icons.favorite_border;
    var count = productData.images!.length;

    return
        // NotificationListener<ScrollNotification>(
        //
        //   onNotification: _scrollListener,
        //   child: Container(
        //   height: double.infinity,
        //   child:
        Stack(children: <Widget>[
      Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
    Container(
      color: Color(0xfff3f3f3),
    width: MediaQuery.of(context).size.width,
    height: ScreenUtil().setWidth(600),
    child: Stack(children:[ Container(
                      width: MediaQuery.of(context).size.width,
                      height: ScreenUtil().setWidth(600),
                      child: PageView.builder(
                        onPageChanged: (v){
                          setState(() {
                            _currentPage = v;

                          });
                        },
                        itemCount: productData.images!.length,
                        itemBuilder: (_, int index) {
                          log(productData.images![index]);
                          return InkWell(
                              onTap: () {
                                locator<NavigationService>()
                                    .pushNamed(routes.ZoomImageRoute, args: {
                                  "imageLinks": productData.images,
                                  "index": index
                                });
                              },
                              child: productData.images![index].contains("https://www.youtube.com/")?
                                  Column(children: [
                                    SizedBox(height: ScreenUtil().setWidth(175),),
                                    YoutubeVideoPlayClass(productData.images![index]),


                                  ],)

                                  :PinchZoom(
                                child:
                                // CachedNetworkImage(
                                //   fit: BoxFit.contain,
                                //     width: MediaQuery.of(context).size.width,
                                //     height: ScreenUtil().setWidth(600),
                                //   imageUrl: productData.images![index]
                                //           .toString()
                                //           .trim()+"?tr=w-414,fo-auto",
                                //   imageBuilder: (context, imageProvider) => Container(
                                //     decoration: BoxDecoration(
                                //       image: DecorationImage(
                                //         onError: (object,stackTrace)=>Image.asset("assets/images/logo.png",   width: MediaQuery.of(context).size.width,
                                //           height: ScreenUtil().setWidth(600),
                                //           fit: BoxFit.contain,),
                                //
                                //         image: imageProvider,
                                //         fit: BoxFit.contain,
                                //
                                //       ),
                                //     ),
                                //   ),
                                //   placeholder: (context, url) => Image.asset("assets/images/loading.gif",   width: MediaQuery.of(context).size.width,
                                //     height: ScreenUtil().setWidth(600),
                                //     fit: BoxFit.contain,),
                                //   errorWidget: (context, url, error) =>  Image.asset("assets/images/logo.png",   width: MediaQuery.of(context).size.width,
                                //     height: ScreenUtil().setWidth(600),
                                //     fit: BoxFit.contain,),
                                // ),
                                FadeInImage.assetNetwork(
                                  imageErrorBuilder: ((context,object,stackTrace){
                                    return Image.asset("assets/images/logo.png");
                                  }),
                                  placeholder: 'assets/images/loading.gif',
                                  image: productData.images![index]
                                      .toString()
                                      .trim(),
                                  width: MediaQuery.of(context).size.width,
                                  height: ScreenUtil().setWidth(600),
                                  fit: BoxFit.contain,
                                ),
                                resetDuration:
                                    const Duration(milliseconds: 100),
                                maxScale: 2.5,
                                onZoomStart: () {

                                },
                                onZoomEnd: () {

                                },
                              ));
                        },
                        controller: pageController,
                      )),
                     // Align(
                     //   alignment: Alignment.bottomRight,
                     //   child: Container(
                     //     margin: EdgeInsets.only(right: ScreenUtil().setWidth(8),bottom: ScreenUtil().setWidth(8)),
                     //     child: RatingClass(productData.id),
                     //   ))
                     ])),
                  // SizedBox(
                  //   height: ScreenUtil().setWidth(27),
                  // ),
                  Container(
                    color: Colors.white,
                    padding:
                    EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(15), 0, 0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),),

                  Container(
                    color: Colors.white,
                    padding:
                        EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(10), 0, 0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(20),
                              0,
                              ScreenUtil().setWidth(20),
                              0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                productData.brand == null
                                    ? ""
                                    : (productData.brand!.name ?? ""),
                                style: TextStyle(
                                    color: AppColors.primaryElement,
                                    fontSize: ScreenUtil().setSp(
                                      21,
                                    ),fontWeight: FontWeight.w600
                                ),
                              ),
                              //   data["brand"]!=null? Text("${productData.}",style: TextStyle(color: Color(0xffee7625),fontWeight: FontWeight.w600,fontSize: 13),):Container(),

                              Container()
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(10),
                        ),

                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(20),
                                right: ScreenUtil().setWidth(20)),
                            width: double.maxFinite,
                            child: Text(
                              productData.name ?? "",
                              style: TextStyle(
                                  color: Color(0xff4a4a4a),
                                  fontSize: ScreenUtil().setSp(
                                    19,
                                  ),
                                  fontWeight: FontWeight.w500),
                            )),
                        SizedBox(
                          height: ScreenUtil().setWidth(10),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(20)),
                            width: double.maxFinite,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${store!.currencySymbol} " + productData.price!.toStringAsFixed(store!.currencyDecimals!) + " ",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(
                                        18,
                                      ),
                                      fontWeight: FontWeight.w600),
                                ),
                                productData.price! < productData.mrp!
                                    ? Text(
                                        " ${store!.currencySymbol} " + productData.mrp!.toStringAsFixed(store!.currencyDecimals!),
                                        style: TextStyle(
                                            color: Color(0xffb0b0b0),
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: ScreenUtil().setSp(
                                              17,
                                            )),
                                      )
                                    : Container(),
                                productData.price! < productData.mrp!
                                    ? Flexible(child: Text(
                                  " (${(100 - ((productData.price! / productData.mrp!) * 100)).toInt()} % off)",
                                  style: TextStyle(
                                    color: AppColors.primaryElement2,
                                    fontSize: ScreenUtil().setSp(
                                      18,
                                    ),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )):Container()
                              ],
                            )),
                        SizedBox(
                          height: ScreenUtil().setWidth(10),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(20)),
                            width: double.maxFinite,
                            child: RichText(
                              text: TextSpan(
                                  text: "Availability : ",
                                  style: TextStyle(
                                      color: Color(0xff4a4a4a),
                                      fontSize: ScreenUtil().setSp(
                                        15,
                                      )),
                                  children: [
                                    productData.stock! > 0
                                        ? TextSpan(
                                            text:
                                              productData.stock!>5?"In Stock":  "${productData.stock} in Stock",
                                            style: TextStyle(
                                                color:
                                                    AppColors.primaryElement2,
                                                fontSize: ScreenUtil().setSp(
                                                  15,
                                                )))
                                        : TextSpan(
                                            text: "Out of Stock",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: ScreenUtil().setSp(
                                                  15,
                                                )))
                                  ]),
                            )),
                     productData.stock! > 0 ?  SizedBox(
                          height: ScreenUtil().setWidth(10),
                        ):Container(),
                     productData.stock! > 0 ?  Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(20)),
                            width: double.maxFinite,
                            child: Text(
                              "Delivery by : " +
                                  DateFormat('dd/MM/yyyy').format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          (DateTime.now()
                                                      .millisecondsSinceEpoch *
                                                  1000) +
                                              (86400000000 * 7))),
                              style: TextStyle(
                                  color: Color(0xff4a4a4a),
                                  fontSize: ScreenUtil().setSp(
                                    13,
                                  )),
                            )):Container(),
                        // SizedBox(
                        //   height: ScreenUtil().setWidth(15),
                        // ),
                        // Container(
                        //     margin: EdgeInsets.only(left: ScreenUtil().setWidth(27)),
                        //     width: double.maxFinite,
                        //     child: InkWell(
                        //         onTap: () async {
                        //           await locator<NavigationService>().pushNamed(
                        //               routes.AddReviewRoute,
                        //               args: productId);
                        //         },
                        //         child: Text(
                        //           "Rate This Product",
                        //           style: TextStyle(
                        //               color: AppColors.primaryElement,
                        //               fontWeight: FontWeight.w600,
                        //               fontSize: ScreenUtil().setSp(
                        //                 14,
                        //               )),
                        //         ))),
                        SizedBox(
                          height: ScreenUtil().setWidth(15),
                        ),

                        Query(
                          options: QueryOptions(
                              document: gql(addMutation.productGroup()),
                              variables: {"id": productId}),
                          builder: (QueryResult result,
                              {VoidCallback? refetch, FetchMore? fetchMore}) {
                            if (result.hasException) {

                              return Container();
                            } else if (result.isLoading) {
                              return Container();
                            } else if (result.data!["product_group"] == null) {
                              return Container();
                            } else {
                              var productGroup = ProductGroup.fromJson(
                                  result.data!["product_group"]);

                              return Column(
                                children: [
                                  productGroup.colorGroup!.length > 0
                                      ? Container(
                                    color: Color(0xfff3f3f3),
                                    height: ScreenUtil().setWidth(25),
                                  ):Container(),
                                  productGroup.colorGroup!.length > 0
                                      ? SizedBox(
                                          height: ScreenUtil().setWidth(15),
                                        )
                                      : Container(),
                                  productGroup.colorGroup!.length > 0
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(20),
                                              bottom:
                                                  ScreenUtil().setWidth(10)),
                                          width: double.infinity,
                                          child: Text("Select Color",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: ScreenUtil()
                                                      .setWidth(18))))
                                      : Container(),
                                  productGroup.colorGroup!.length > 0
                                      ? Container(
                                          height: ScreenUtil().setWidth(50),
                                          width: double.infinity,
                                          padding: EdgeInsets.fromLTRB(
                                              ScreenUtil().setWidth(27),
                                              0,
                                              ScreenUtil().setWidth(27),
                                              0),
                                          child: ListView.builder(
                                              itemCount: productGroup
                                                  .colorGroup!.length,
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext build, index) {
                                                return InkWell(
                                                    onTap: () async {
                                                      if (productGroup
                                                              .colorGroup![index]
                                                              .color!
                                                              .name !=
                                                          productData
                                                              .color!.name) {
                                                        await locator<
                                                                NavigationService>()
                                                            .pushReplacementNamed(
                                                                routes
                                                                    .ProductDetailRoute,
                                                                args: productGroup
                                                                    .colorGroup![
                                                                        index]
                                                                    .id);
                                                      }
                                                    },
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            right: ScreenUtil()
                                                                .radius(15)),
                                                        padding:EdgeInsets.only(
                                                            right: ScreenUtil()
                                                                .setWidth(8),left:ScreenUtil()
                                                            .setWidth(8)),
                                                        height: ScreenUtil()
                                                            .radius(40),
                                                        child: Center(
                                                          child: Text(
                                                            productGroup
                                                                .colorGroup![index]
                                                                .color!
                                                                .name!,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    productGroup
                                                                        .colorGroup![
                                                                    index]
                                                                        .color!
                                                                        .colorCode!),
                                                                fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                                    15)),
                                                          ),
                                                        ),
                                                        decoration:
                                                            new BoxDecoration(
                                                          // color: Color(
                                                          //     productGroup
                                                          //         .colorGroup![
                                                          //             index]
                                                          //         .color!
                                                          //         .colorCode!),
                                                          border: Border.all(
                                                              color: productGroup
                                                                          .colorGroup![
                                                                              index]
                                                                          .color!
                                                                          .name ==
                                                                      productData
                                                                          .color!
                                                                          .name
                                                                  ? AppColors
                                                                      .primaryElement
                                                                  : Colors.grey,
                                                              width: productGroup
                                                                          .colorGroup![
                                                                              index]
                                                                          .color!
                                                                          .name ==
                                                                      productData
                                                                          .color!
                                                                          .name
                                                                  ? ScreenUtil()
                                                                      .setWidth(
                                                                          2)
                                                                  : ScreenUtil()
                                                                      .setWidth(
                                                                          1)),
                                                                borderRadius: BorderRadius.circular(12)
                                                          // shape:
                                                          //     BoxShape.circle,
                                                        )));
                                              }))
                                      : SizedBox.shrink(),
                                  productGroup.sizeGroup!.length > 0
                                      ? SizedBox(
                                          height: ScreenUtil().setWidth(15),
                                        )
                                      : SizedBox.shrink(),
                                  productGroup.sizeGroup!.length > 0
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(20),
                                              bottom:
                                                  ScreenUtil().setWidth(10)),
                                          width: double.infinity,
                                          child: Text("Select Size",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: ScreenUtil()
                                                      .setWidth(18))))
                                      : Container(),
                                  productGroup.sizeGroup!.length > 0
                                      ? Container(
                                          height: ScreenUtil().setWidth(50),
                                          width: double.infinity,
                                          padding: EdgeInsets.fromLTRB(
                                              ScreenUtil().setWidth(27),
                                              0,
                                              ScreenUtil().setWidth(27),
                                              0),
                                          child: ListView.builder(
                                              itemCount:
                                                  productGroup.sizeGroup!.length,
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext build, index) {
                                                return InkWell(
                                                    onTap: () async {
                                                      if (productGroup
                                                              .sizeGroup![index]
                                                              .size!
                                                              .name !=
                                                          productData
                                                              .size!.name) {
                                                        await locator<
                                                                NavigationService>()
                                                            .pushReplacementNamed(
                                                                routes
                                                                    .ProductDetailRoute,
                                                                args: productGroup
                                                                    .sizeGroup![
                                                                        index]
                                                                    .id);
                                                      }
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: ScreenUtil()
                                                              .radius(15)),
                                                      padding:EdgeInsets.only(
                                                          right: ScreenUtil()
                                                              .setWidth(8),left:ScreenUtil()
                                                          .setWidth(8)),
                                                      height: ScreenUtil()
                                                          .radius(40),
                                                      decoration:
                                                          new BoxDecoration(
                                                        border: Border.all(
                                                            color: productGroup
                                                                        .sizeGroup![
                                                                            index]
                                                                        .size!
                                                                        .name ==
                                                                    productData
                                                                        .size!
                                                                        .name
                                                                ? AppColors
                                                                    .primaryElement
                                                                : Colors.grey,
                                                            width: productGroup
                                                                        .sizeGroup![
                                                                            index]
                                                                        .size!
                                                                        .name ==
                                                                    productData
                                                                        .size!
                                                                        .name
                                                                ? ScreenUtil()
                                                                    .setWidth(2)
                                                                : ScreenUtil()
                                                                    .setWidth(
                                                                        1)),
                                                        borderRadius: BorderRadius.circular(12)
                                                        // shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          productGroup
                                                              .sizeGroup![index]
                                                              .size!
                                                              .name!,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff707070),
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          15)),
                                                        ),
                                                      ),
                                                    ));
                                              }))
                                      : SizedBox.shrink(),
                                  productGroup.sizeGroup!.length > 0 ||  productGroup.colorGroup!.length > 0
                                      ?   SizedBox(
                                    height: ScreenUtil().setWidth(15),
                                  ):SizedBox.shrink(),
                                ],
                              );
                            }
                          },
                        ),

                        // Consumer<SettingViewModel>(builder:
                        //     (BuildContext context, value, Widget child) {
                        //   if (value.status == "loading") {
                        //     Provider.of<SettingViewModel>(context,
                        //             listen: false)
                        //         .fetchSettings();
                        //     return Container();
                        //   }
                        //   if (value.status == "empty") {
                        //     return Container();
                        //   }
                        //   if (value.status == "error") {
                        //     return Container();
                        //   }
                        //   if (value.settingResponse.liveCommerce) {
                        //     return Container(
                        //       margin: EdgeInsets.only(top: ScreenUtil().setWidth(34),bottom: ScreenUtil().setWidth(34)),
                        //       width: ScreenUtil().setWidth(150),
                        //       height: ScreenUtil().setHeight(42),
                        //       child: OutlinedButton(
                        //         style: OutlinedButton.styleFrom(
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(40.0),
                        //           ),
                        //           side: BorderSide(
                        //               width: 2,
                        //               color: AppColors.primaryElement),
                        //         ),
                        //         onPressed: () async {
                        //           // LiveStreamSetUp()
                        //           //     .startRTC(context, "1234", 123, 'join');
                        //         },
                        //         child: Text(
                        //           "Join Stream",
                        //           style: TextStyle(
                        //               fontSize: ScreenUtil().setSp(
                        //                 16,
                        //               ),
                        //               fontWeight: FontWeight.w500,
                        //               color: AppColors.primaryElement,
                        //               fontFamily: 'Montserrat'),
                        //         ),
                        //       ),
                        //     );
                        //   } else {
                        //     return Container();
                        //   }
                        // }),
                        // SizedBox(
                        //   height: ScreenUtil().setWidth(34),
                        // ),
                        productData.description != null
                            ? Container(
                                color: Color(0xfff3f3f3),
                                height: ScreenUtil().setWidth(25),
                              )
                            : Container(),
                        productData.description != null
                            ? Container(
                                width: double.infinity,
                                color: Color(0xffffffff),
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(20),
                                    ScreenUtil().setWidth(0),
                                    ScreenUtil().setWidth(20),
                                    ScreenUtil().setWidth(5)),
                                child: Column(
                                  children: [
                                    Container(
                                      color: Color(0xffffffff),
                                      height: ScreenUtil().setWidth(15),
                                    ),
                                    Container(
                                        color: Color(0xffffffff),
                                        width: double.infinity,
                                        child:
                                        Text(
                                          "Description",
                                          style: TextStyle(
                                              color: Color(0xff4a4a4a),
                                              fontSize: ScreenUtil().setSp(20),
                                              ),
                                          textAlign: TextAlign.left,
                                        )
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(10),
                                    ),
                                    Html(
                                      data: productData.description,
                                        style: {
                                        "li":Style(
                                          fontSize: FontSize(ScreenUtil().setSp(14))
                                        )
                                        }
                                    ),
                                    // Text(productData.description,
                                    //     textAlign: TextAlign.left,
                                    //     style: TextStyle(
                                    //         color: Color(0xff4a4a4a),
                                    //         fontSize: ScreenUtil().setSp(13))),
                                  ],
                                ),
                              )
                            : Container(),

                        productData.keyFeature != null &&
                                productData.keyFeature!.length > 0
                            ? Container(
                                width: double.infinity,
                                child: Column(
                                    children: getKeyFeatureChildren(
                                        productData.keyFeature!)),
                              )
                            : Container(),
                        SizedBox(
                          height: productData.keyFeature != null ||
                                  productData.keyFeature!.length != 0
                              ? ScreenUtil().setWidth(20)
                              : 0,
                        ),
                        getProductDetailChildren(productData).length > 0
                            ? Container(
                          color: Color(0xfff3f3f3),
                          height: ScreenUtil().setWidth(20),
                        ): SizedBox.shrink(),
                        getProductDetailChildren(productData).length > 0
                            ? Container(
                                width: double.infinity,
                                child: Column(
                                    children:
                                        getProductDetailChildren(productData)),
                              )
                            : SizedBox.shrink(),
                        Container(
                          color: Color(0xfff3f3f3),
                          height:
                              getProductDetailChildren(productData).length > 0
                                  ? ScreenUtil().setWidth(20)
                                  : 0,
                        ),
                        productData.specifications != null ||
                                productData.specifications!.length != 0
                            ? Container(
                                width: double.infinity,
                                child: Column(
                                    children: getSpecificationChildren(
                                        productData.specifications!)),
                              )
                            : Container(),
                        SizedBox(
                          height: productData.specifications != null ||
                                  productData.specifications!.length != 0
                              ? ScreenUtil().setWidth(20)
                              : 0,
                        ),
                      ],
                    ),
                  ),
                  RecommendedClass(),
                  SizedBox(
                    height: ScreenUtil().setWidth(51),
                  )
                ],
              ))),
      Align(
          alignment: Alignment.topCenter,
          child: AnimatedBuilder(
              animation: _ColorAnimationController,
              builder: (context, child) => Container(
                    color: _colorTween.value,
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setWidth(15),
                        ScreenUtil().setWidth(20), ScreenUtil().setWidth(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                     Container(child: Row(children:[  InkWell(
                            onTap: () {
                              locator<NavigationService>().pop();
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
                                  Icons.arrow_back,
                                  size: ScreenUtil().setWidth(18),
                                ))), 
                       
                     //  Container(
                     //    width: ScreenUtil().setWidth(140),
                     //     padding: EdgeInsets.fromLTRB(
                     //         ScreenUtil().setWidth(5),
                     //         0,
                     //         ScreenUtil().setWidth(5),
                     //         0),
                     //     child:  Text(
                     //      productData.brand  == null
                     //           ? ""
                     //           : (productData.brand!.name ?? ""),
                     //       style: TextStyle(
                     //         color: AppColors.primaryElement,
                     //         fontSize: ScreenUtil().setSp(
                     //           21,
                     //         ),),
                     //       maxLines: 2,
                     //       overflow: TextOverflow.ellipsis,
                     //     ),
                          //   data["brand"]!=null? Text("${productData.}",style: TextStyle(color: Color(0xffee7625),fontWeight: FontWeight.w600,fontSize: 13),):Container()
                     //   ),
                                                   ])),
                        /*InkWell(
                    onTap: () async {
                      TzDialog _dialog =
                      TzDialog(context, TzDialogType.progress);
                      _dialog.show();
                     var dynamicLink = await _createDynamicLink(true, productData.id);
                     _dialog.close();
                      final RenderBox box = context.findRenderObject();
                      await Share.share(
                          "Hi, Check out this awesome product on anne : $dynamicLink \n\n Weblink : ${ApiEndpoint().url}/${productData.slug}?id=$productId",
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    },
                    child: Icon(
                      Icons.share,
                      size: 20,
                    )),*/
                        // SizedBox(
                        //   width: ScreenUtil().setWidth(15),
                        // ),
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Map<String, dynamic> data = {
                                  "id": EVENT_PRODUCT_DETAILS_ADD_TO_WISHLIST,
                                  "itemId": productId,
                                  "event": "tap"
                                };
                                Tracking(
                                    event:
                                    EVENT_PRODUCT_DETAILS_ADD_TO_WISHLIST,
                                    data: data);
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
                                  child: InkWell(
                                      onTap: () async{
                                        TzDialog _dialog =
                                        TzDialog(context, TzDialogType.progress);
                                        _dialog.show();
                                        var dynamicLink = await _createDynamicLink(true, productData.id, productData.slug);
                                        _dialog.close();
                                        // final RenderObject? box = context.findRenderObject();
                                        await Share.share(
                                            "Hi, Check out this awesome product  : $dynamicLink ",
                                           );
                                      },
                                      child: Icon(
                                        Icons.share,
                                        size: ScreenUtil().setWidth(28),
                                        color: Color(0xff616161),
                                      ))),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(15),
                            ),
                            InkWell(
                              onTap: () {
                                Map<String, dynamic> data = {
                                  "id": EVENT_PRODUCT_DETAILS_ADD_TO_WISHLIST,
                                  "itemId": productId,
                                  "event": "tap"
                                };
                                Tracking(
                                    event:
                                        EVENT_PRODUCT_DETAILS_ADD_TO_WISHLIST,
                                    data: data);
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
                                  child: InkWell(
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
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(15),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0, 0, ScreenUtil().setWidth(0), 0),
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
                              child:
                                  // Transform.translate(
                                  //   offset: Offset(-10, 0),
                                  //   child:
                                  CartLogo(24),
                            )
                          ],
                        )),
                      ],
                    ),
                  ))),
      Consumer<ProductDetailViewModel>(
          builder: (BuildContext context, value, Widget? child) {
        return value.buttonStatus == "Not Available"
            ? SizedBox.shrink()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: ScreenUtil().setWidth(65),
                    color: Color(0xffffffff),
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(10),
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20),
                        bottom: ScreenUtil().setWidth(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: ScreenUtil().setWidth(172),
                            height: ScreenUtil().setHeight(45),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                side: BorderSide(
                                    width: 1, color: Color(0xffe3e3e3)),
                              ),
                              onPressed: () async {
                                TzDialog _dialog =
                                TzDialog(context, TzDialogType.progress);
                                _dialog.show();
                                if (Provider.of<ProfileModel>(context,
                                            listen: false)
                                        .user !=
                                    null) {
                                  await Provider.of<WishlistViewModel>(context,
                                          listen: false)
                                      .toggleItem(productData.id);
                                  _dialog.close();
                                  setState(() {});
                                } else {
                                  if (settingData!.otpLogin!) { locator<NavigationService>().pushNamed(routes.LoginRoute);}
                                  else{
                                    locator<NavigationService>().pushNamed(routes.EmailLoginRoute);
                                  }
                                }
                              },
                              child: Container(
                                // padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CheckWishListClass(
                                        productData.id, productData.id),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(12),
                                    ),
                                    Text(
                                      "WISHLIST",
                                      style: TextStyle(
                                          color: Color(0xff414141),
                                          fontSize: ScreenUtil().setSp(
                                            16,
                                          ),
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            )),
    Consumer<CartViewModel>(
    builder: (BuildContext context, cartValue, Widget? child) { return   Container(
                          decoration: BoxDecoration(
                              color: value.buttonStatus == "GO TO CART"?Color(0xff000000): AppColors.primaryElement,
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(5))),
                          width: ScreenUtil().setWidth(172),
                          height: ScreenUtil().setHeight(45),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              onPressed: () async {
                                Map<String, dynamic> data = {
                                  "id": EVENT_PRODUCT_DETAILS_ADD_TO_CART,
                                  "itemId": productId,
                                  "event": "click"
                                };
                                Tracking(
                                    event: EVENT_PRODUCT_DETAILS_ADD_TO_CART,
                                    data: data);
                                if (value.buttonStatus == "Not Available") {
                                } else {
                                  if (value.buttonStatus == "ADD TO BAG") {
                                   // // final NavigationService _navigationService = locator<NavigationService>();
                                   //  TzDialog _dialog =
                                   //  TzDialog(context, TzDialogType.progress);
                                   //  _dialog.show();
                                    if (await Vibration.hasVibrator()??false) {
                                     Vibration.vibrate();
                                   }
                                    Provider.of<ProductDetailViewModel>(context,
                                            listen: false)
                                        .changeButtonStatusAndLoad("GO TO CART");
                                    cartValue.cartAddItem(productData.id,
                                            productData.id, 1, false);
                                 //   _dialog.close();
                                  } else {
                                    _navigationService!
                                        .pushNamed(routes.CartRoute);
                                  }
                                }
                              },
                              child: Container(
                                //padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                                color: value.buttonStatus == "GO TO CART"
                                    ? Color(0xff000000)
                                    : AppColors.primaryElement,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    value.buttonStatus == "Not Available"
                                        ? SizedBox.shrink()
                                        : Icon(
                                            Icons.shopping_cart,
                                            color: Color(0xffffffff),
                                            size: ScreenUtil().setWidth(22),
                                          ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(12),
                                    ),
                                    Text(
                                      value.buttonStatus!,
                                      style: TextStyle(
                                          color: Color(0xffffffff),
                                          fontSize: ScreenUtil().setSp(
                                            16,
                                          ),
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              )),
                        );})
                      ],
                    )));
      }),
    ]);
  }

  getSpecificationChildren(List<Specifications> specifications) {
    List<Widget> children = [];
    if (specifications.length != 0) {
      children.add(
        Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                top: ScreenUtil().setWidth(15)),
            height: ScreenUtil().setWidth(50),
            color: Color(0xffffffff),
            width: double.infinity,
            child: Text(
              "Product Specification",
              style: TextStyle(
                color: Color(0xff4a4a4a),
                fontSize: ScreenUtil().setSp(20),
              ),
              textAlign: TextAlign.left,
            )),
      );
    }
    for (int i = 0; i < specifications.length; i++) {
      children.add(Container(
          color: i % 2 == 0 ? Color(0xfff8f8f8) : Color(0xffffffff),
          //height: ScreenUtil().setWidth(32),
          width: double.infinity,
          padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(10),
              bottom: ScreenUtil().setWidth(10),
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20)),
          child: Center(
            child: Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                        width: ScreenUtil().setWidth(150),
                        child: Column(
                          children: [
                            Container(
                                width: ScreenUtil().setWidth(150),
                                child: Text(
                                  specifications[i].name!,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Color(0xff000000,),fontSize: ScreenUtil().setSp(16)),
                                ))
                          ],
                        )),
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: Text(
                        specifications[i].value!,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xffa4a4a4),fontSize: ScreenUtil().setSp(16)),
                      ),
                    )
                  ],
                )),
          )));
    }
    return children;
  }

  List<Widget> getProductDetailChildren(productData) {
    List<Widget> children = [];

    //for(int i=0;i<specifications.length;i++){
    if (productData?.countryOfOrigin != null) {
      children.add(Container(
          color: Color(0xfff8f8f8),
          //height: ScreenUtil().setWidth(32),
          width: double.infinity,
          padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(10),
              bottom: ScreenUtil().setWidth(10),
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20)),
          child: Center(
            child: Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                        width: ScreenUtil().setWidth(150),
                        child: Column(
                          children: [
                            Container(
                                width: ScreenUtil().setWidth(150),
                                child: Text(
                                  "Country of Origin ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Color(0xff000000),fontSize: ScreenUtil().setSp(16)),
                                ))
                          ],
                        )),
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: Text(
                        "${productData?.countryOfOrigin}",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xffa4a4a4),fontSize: ScreenUtil().setSp(16)),
                      ),
                    )
                  ],
                )),
          )));
    }
    if (productData?.warranty != null) {
      children.add(Container(
          color: Color(0xffffffff),
          //height: ScreenUtil().setWidth(32),
          width: double.infinity,
          padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(10),
              bottom: ScreenUtil().setWidth(10),
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20)),
          child: Center(
            child: Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                        width: ScreenUtil().setWidth(150),
                        child: Column(
                          children: [
                            Container(
                                width: ScreenUtil().setWidth(150),
                                child: Text(
                                  "Warranty ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Color(0xff000000),fontSize: ScreenUtil().setSp(16)),
                                ))
                          ],
                        )),
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: Text(
                        productData?.warranty ?? '',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xffa4a4a4),fontSize: ScreenUtil().setSp(16)),
                      ),
                    )
                  ],
                )),
          )));
    }

    if (children.length > 0) {
      children.insert(
        0,
        Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                top: ScreenUtil().setWidth(15)),
            height: ScreenUtil().setWidth(50),
            color: Color(0xffffffff),
            width: double.infinity,
            child: Text(
              "Product Details",
              style: TextStyle(
                  color: Color(0xff4a4a4a),
                  fontSize: ScreenUtil().setSp(20),
                  ),
              textAlign: TextAlign.left,
            )),
      );
    }
    return children;
  }

  getKeyFeatureChildren(List<String> keyFeature) {
    List<Widget> children = [];
    if (keyFeature.length != 0) {
      children.add(
        Container(
          color: Color(0xfff3f3f3),
          height: ScreenUtil().setWidth(25),
        ),
      );
      children.add(
        Container(
          color: Color(0xffffffff),
          height: ScreenUtil().setWidth(20),
        ),
      );
      children.add(Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
          color: Color(0xffffffff),
          width: double.infinity,
          child: Text(
            "Key Features",
            style: TextStyle(
                color: Color(0xff4a4a4a),
                fontSize: ScreenUtil().setSp(20),
            ),
            textAlign: TextAlign.left,
          )));
    }
    for (int i = 0; i < keyFeature.length; i++) {
      children.add(Container(
        color: Color(0xffffffff),
        //height: ScreenUtil().setWidth(32),
        width: double.infinity,
        padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(10),
            bottom: ScreenUtil().setWidth(15),
            left: ScreenUtil().setWidth(11),
            right: ScreenUtil().setWidth(20)),
        child:
            //Center(child:
            Container(
                // width: double.infinity,
                child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  width: ScreenUtil().setWidth(35),
                  child: Icon(
                    FontAwesomeIcons.checkCircle,
                    color: Colors.grey,
                    size: ScreenUtil().setWidth(18),
                  )),
              Container()
            ]),
            SizedBox(
              width: 3,
            ),
            Container(
              width: ScreenUtil().setWidth(305),
              child: Text(
                keyFeature[i],
                textAlign: TextAlign.left,
              ),
            )
          ],
        )),
      ));
    }
    return children;
  }
}

class YoutubeVideoPlayClass extends StatefulWidget{
  final link;
  YoutubeVideoPlayClass(this.link);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _YoutubeVideoPlayClass();
  }
}

class _YoutubeVideoPlayClass extends State<YoutubeVideoPlayClass>{

   late YoutubePlayerController _controller;
   String?  _id;
   late TextEditingController _seekToController;
   PlayerState? _playerState;
   bool _isPlayerReady = false;
  var link;
  @override
  void initState() {
    link = widget.link;
   _id = YoutubePlayer.convertUrlToId(widget.link);
    _controller = YoutubePlayerController(
      initialVideoId: _id!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: true,
        isLive: false,
        forceHD: false,
       // enableCaption: true,
      ),
    )..addListener(listener);

    _playerState = PlayerState.unknown;

    super.initState();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
    //  setState(() {
        _playerState = _controller.value.playerState;
    //  });
    }
  }
   @override
   void deactivate() {
     // Pauses video while navigating to next page.
     _controller.pause();
     super.deactivate();
   }

   @override
   void dispose() {
     _controller.dispose();
     _seekToController.dispose();
     super.dispose();
   }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: AppColors.primaryElement,
      // progressColors: ProgressColors(
      //   playedColor: AppColors.primaryElement,
      //   handleColor: AppColors.primaryElement,
      // ),
      onReady : () {
        setState(() {
          _isPlayerReady = true;
        });

      },
    );
  }
}

class RatingClass extends StatefulWidget {
  final id;

  RatingClass(this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RatingClass();
  }
}

class _RatingClass extends State<RatingClass> {
  QueryMutation addMutation = QueryMutation();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Query(
        options: QueryOptions(
            document: gql(addMutation.reviewSummary()),
            variables: {
              "pid": widget.id,
            }),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {

            return Container();
          }
          if (result.isLoading) {
            return Container();
          }

          if (result.data == null) {
            return Container(

                height: ScreenUtil().setWidth(27),
                width: ScreenUtil().setWidth(55),
                decoration: BoxDecoration(
                    color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xfff3f3f3),width: 0.3)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                    padding: EdgeInsets.only(top: ScreenUtil().setWidth(3)),
                    child: Text(
                      "0",
                      style: TextStyle(
                          color: Color(0xff6d6d6d),
                          fontSize: ScreenUtil().setWidth(15)),
                    )),
                SizedBox(
                  width: ScreenUtil().setWidth(4.5),
                ),
                Icon(
                  FontAwesomeIcons.star,
                  size: ScreenUtil().setWidth(14),
                  color: AppColors.primaryElement2,
                ),
              ],
            ));
          }
          if (result.data!["reviewSummary"] == null) {
            return Container(

                height: ScreenUtil().setWidth(27),
                width: ScreenUtil().setWidth(55),
                decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
                    border: Border.all(color: Color(0xfff3f3f3),width: 0.3)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                        padding: EdgeInsets.only(top: ScreenUtil().setWidth(3)),
                        child: Text(
                          "0",
                          style: TextStyle(
                              color: Color(0xff6d6d6d),
                              fontSize: ScreenUtil().setWidth(15)),
                        )),
                    SizedBox(
                      width: ScreenUtil().setWidth(4.5),
                    ),
                    Icon(
                      FontAwesomeIcons.star,
                      size: ScreenUtil().setWidth(14),
                      color: AppColors.primaryElement2,
                    ),

                  ],
                ));
          }
          return
            Container(

                height: ScreenUtil().setWidth(27),
                width: ScreenUtil().setWidth(55),
                decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
                    border: Border.all(color: Color(0xfff3f3f3),width: 0.3)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                        padding: EdgeInsets.only(top: ScreenUtil().setWidth(3)),
                        child: Text(
                          result.data!["reviewSummary"]["avg"].toString()??"0",
                          style: TextStyle(
                              color: Color(0xff6d6d6d),
                              fontSize: ScreenUtil().setWidth(15)),
                        )),
                    SizedBox(
                      width: ScreenUtil().setWidth(4.5),
                    ),
                    Icon(
                      FontAwesomeIcons.star,
                      size: ScreenUtil().setWidth(14),
                      color: AppColors.primaryElement2,
                    ),
                  ],
                ));

        });
  }
}

class CheckWishListClass extends StatefulWidget {
  final productID;
  final variantID;

  CheckWishListClass(this.productID, this.variantID);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CheckWishListClass();
  }
}

class _CheckWishListClass extends State<CheckWishListClass> {
  QueryMutation addMutation = QueryMutation();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  bool? status;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GraphQLProvider(
      client: graphQLConfiguration.initailizeClient(),
      child: CacheProvider(
        child: Query(
            options: QueryOptions(
                document: gql(addMutation.checkWishList()),
                variables: {
                  "product": widget.productID,
                  "variant": widget.variantID
                }),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {

                return Container();
              }
              if (result.isLoading) {
                return Icon(Icons.workspaces_outline,
                    color: Color(0xffd3d3d3), size: 20);
              }
              if (result.isConcrete) {
                status = result.data!["checkWishlist"];
                return Center(
                  // margin: EdgeInsets.only(left: ScreenUtil().setWidth(0.4)),
                  child: InkWell(
                    child: status == false
                        ? Icon(
                            FontAwesomeIcons.heart,
                            color: Color(0xff616161),
                            size: ScreenUtil().setWidth(22),
                          )
                        : Icon(
                            FontAwesomeIcons.solidHeart,
                            color: AppColors.primaryElement,
                            size: ScreenUtil().setWidth(22),
                          ),
                    onTap: () async {
                      if (Provider.of<ProfileModel>(context, listen: false)
                              .user !=
                          null) {
                        await Provider.of<WishlistViewModel>(context,
                                listen: false)
                            .toggleItem(widget.productID);
                        setState(() {
                          status = !status!;
                        });
                      } else {
                        locator<NavigationService>()
                            .pushNamed(routes.LoginRoute);
                      }

                      // setState(() {
                      //
                      // });
                    },
                  ),
                );
              }
              return Container();
            }),
      ),
    );
  }
}




class RecommendedClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RecommendedClass();
  }
}

class _RecommendedClass extends State<RecommendedClass> {
  QueryMutation addMutation = QueryMutation();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          color: Colors.white,
          child: getProductList(),
        ),

      ],
    );
  }

  Widget getProductList() {
    return Consumer<ProductViewModel>(
        builder: (BuildContext context, value, Widget? child) {
          if (value.recommendedStatus == "loading") {
            value.fetchRecommendedProducts();
            return Container();
          } else if (value.recommendedStatus == "empty") {
            return SizedBox.shrink();
          } else if (value.recommendedStatus == "error") {
            return SizedBox.shrink();
          }
          return Column(children: [
            // Container(
            //   height: ScreenUtil().setWidth(15),
            // ),
            // Container(
            //   height: ScreenUtil().setWidth(25),
            //   color: Color(0xfff3f3f3),),
            // Container(
            //   height: ScreenUtil().setWidth(15),
            // ),
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
                "RECOMMENDED FOR YOU",
                style: ThemeApp()
                    .homeHeaderThemeText(AppColors.primaryElement, 18, true),
              ),
            ),
            Container(
              height: ScreenUtil().setWidth(15),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(0), 0, ScreenUtil().setWidth(0), 0),
              height: ScreenUtil().setWidth(289),
              child: ListView.builder(
                cacheExtent: 100,
                  scrollDirection: Axis.horizontal,
                  itemCount: value.productRecommendedResponse!.data!.length,
                  itemBuilder: (BuildContext context, index) {
                    return InkWell(
                      onTap: () {
                        Map<String, dynamic> data = {
                          "id": EVENT_TRENDING,
                          "itemId":
                          value.productRecommendedResponse!.data![index].barcode,
                          "event": "tap"
                        };
                        Tracking(event: EVENT_TRENDING, data: data);
                      },
                      child: Column(children: [
                        ProductCard(
                            value.productRecommendedResponse!.data![index])
                      ]),
                    );
                  }),
            ),
            SizedBox(height: 20,)
          ]);
        });
  }
}

