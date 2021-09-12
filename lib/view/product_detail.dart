import 'dart:convert';
import 'package:anne/values/colors.dart';
import 'package:anne/view/liveStreamPages/live_stream_setup.dart';
import 'package:anne/view/menu/wishlist.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

class ProductDetail extends StatefulWidget {
  final productId;

  ProductDetail(this.productId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductDetail();
  }
}

class _ProductDetail extends State<ProductDetail> {
  QueryMutation addMutation = QueryMutation();
  final NavigationService _navigationService = locator<NavigationService>();
  var indexImage = 0;
  var cartStatusButton = "Add to cart";
  var icon;

  // ProductDetailData productData;
  String productId;
  PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    productId = widget.productId;
    Provider.of<ProductDetailViewModel>(context, listen: false)
        .changeStatus("loading");
    pageController =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
    super.initState();
  }

  _createDynamicLink(bool short, id) async {
    var _linkMessage;
    var dynamicUrl;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://anne.com/',
      link: Uri.parse('https://www.anne.com/$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.anne.ind',
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(bundleId: 'com.anne.ind'),
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
    print(_linkMessage);
    print(dynamicUrl);
    return dynamicUrl;
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<CartViewModel>(context).cartResponse != null) {
      for (int i = 0;
          i < Provider.of<CartViewModel>(context).cartResponse.items.length;
          i++) {
        if (Provider.of<CartViewModel>(context).cartResponse.items[i].pid ==
            productId) {
          setState(() {
            cartStatusButton = "Go to cart";
          });
        }
      }
    }
    // TODO: implement build
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Color(0xfff3f3f3),
            child: Consumer<ProductDetailViewModel>(
                builder: (BuildContext context, value, Widget child) {
              if (value.status == "loading") {
                Provider.of<ProductDetailViewModel>(context, listen: false)
                    .fetchProductDetailData(productId);
                return Loading();
              }
              if (value.status == "empty") {
                return cartEmptyMessage(
                    "noNetwork", "Nothing here . Something went wrong !!");
              }
              if (value.status == "error") {
                return errorMessage();
              }
              if (value.productDetailResponse.stock <= 0) {
                cartStatusButton = "Not Available";
              }
              return getProductDetails(value.productDetailResponse);
            })));
  }

  Widget getProductDetails(ProductDetailData productData) {
    icon = Icons.favorite_border;
    var count = productData.images.length;

    return Stack(children: [
      SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: ScreenUtil().setWidth(105),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: ScreenUtil().setWidth(550),
              child: PageView.builder(
                itemCount: productData.images.length,
                itemBuilder: (_, int index) {
                  return InkWell(
                      onTap: () {
                        locator<NavigationService>()
                            .pushNamed(routes.ZoomImageRoute, args: {
                          "imageLinks": productData.images,
                          "index": index
                        });
                      },
                      child: PinchZoom(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/loading.gif',
                          image: productData.images[index].toString().trim(),
                          width: MediaQuery.of(context).size.width,
                          height: ScreenUtil().setWidth(550),
                          fit: BoxFit.contain,
                        ),
                        resetDuration: const Duration(milliseconds: 100),
                        maxScale: 2.5,
                        onZoomStart: () {
                          print('Start zooming');
                        },
                        onZoomEnd: () {
                          print('Stop zooming');
                        },
                      ));
                },
                controller: pageController,
              )),
          SizedBox(
            height: ScreenUtil().setWidth(27),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(22), 0, 0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(28), 0,
                      ScreenUtil().setWidth(28), 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productData.brand == null
                            ? ""
                            : (productData.brand.name ?? ""),
                        style: TextStyle(
                            color: AppColors.primaryElement,
                            fontSize: ScreenUtil().setSp(
                              14,
                            )),
                      ),
                      //   data["brand"]!=null? Text("${productData.}",style: TextStyle(color: Color(0xffee7625),fontWeight: FontWeight.w600,fontSize: 13),):Container(),

                      RatingClass(productData.id)
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(25),
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(27),
                        right: ScreenUtil().setWidth(27)),
                    width: double.maxFinite,
                    child: Text(
                      productData.name ?? "",
                      style: TextStyle(
                          color: Color(0xff4a4a4a),
                          fontSize: ScreenUtil().setSp(
                            21,
                          ),
                          fontWeight: FontWeight.w500),
                    )),
                SizedBox(
                  height: ScreenUtil().setWidth(25),
                ),
                Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(27)),
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "₹ " + productData.price.toString() + " ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(
                                20,
                              ),
                              fontWeight: FontWeight.w500),
                        ),
                        productData.price < productData.mrp
                            ? Text(
                                " ₹ " + productData.mrp.toString(),
                                style: TextStyle(
                                    color: Color(0xffb0b0b0),
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: ScreenUtil().setSp(
                                      15,
                                    )),
                              )
                            : Container()
                      ],
                    )),
                SizedBox(
                  height: ScreenUtil().setWidth(15),
                ),
                Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(27)),
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
                            productData.stock > 0
                                ? TextSpan(
                                    text: "${productData.stock} in Stock",
                                    style: TextStyle(
                                        color: AppColors.primaryElement2,
                                        fontSize: ScreenUtil().setSp(
                                          15,
                                        )))
                                : TextSpan(
                                    text: "Not in Stock",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: ScreenUtil().setSp(
                                          15,
                                        )))
                          ]),
                    )),
                SizedBox(
                  height: ScreenUtil().setWidth(15),
                ),
                Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(27)),
                    width: double.maxFinite,
                    child: Text(
                      "Delivery by : " +
                          DateFormat('dd/MM/yyyy').format(
                              DateTime.fromMicrosecondsSinceEpoch(
                                  (DateTime.now().millisecondsSinceEpoch *
                                          1000) +
                                      (86400000000 * 7))),
                      style: TextStyle(
                          color: Color(0xff4a4a4a),
                          fontSize: ScreenUtil().setSp(
                            13,
                          )),
                    )),
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
                Container(
                  color: Color(0xfff3f3f3),
                  height: ScreenUtil().setWidth(25),
                ),
                Query(
                  options: QueryOptions(
                      document: gql(addMutation.productGroup()),
                      variables: {"id": productId}),
                  builder: (QueryResult result,
                      {VoidCallback refetch, FetchMore fetchMore}) {
                    if (result.hasException) {
                      print(result.exception.toString());
                      return Container();
                    } else if (result.isLoading) {
                      return Container();
                    } else if (result.data["product_group"] == null) {
                      return Container();
                    } else {
                      var productGroup =
                          ProductGroup.fromJson(result.data["product_group"]);
                      print(result.data["product_group"]["colorGroup"]);
                      return Column(
                        children: [
                          productGroup.colorGroup.length > 0
                              ? SizedBox(
                                  height: ScreenUtil().setWidth(15),
                                )
                              : Container(),
                          productGroup.colorGroup.length > 0
                              ? Container(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(20),
                                      bottom: ScreenUtil().setWidth(10)),
                                  width: double.infinity,
                                  child: Text("Select Color",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setWidth(18))))
                              : Container(),
                          productGroup.colorGroup.length > 0
                              ? Container(
                                  height: ScreenUtil().setWidth(50),
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(27),
                                      0,
                                      ScreenUtil().setWidth(27),
                                      0),
                                  child: ListView.builder(
                                      itemCount: productGroup.colorGroup.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext build, index) {
                                        return InkWell(
                                            onTap: () async {
                                              if (productGroup.colorGroup[index]
                                                      .color.name !=
                                                  productData.color.name) {
                                                await locator<
                                                        NavigationService>()
                                                    .pushReplacementNamed(
                                                        routes
                                                            .ProductDetailRoute,
                                                        args: productGroup
                                                            .colorGroup[index]
                                                            .id);
                                              }
                                            },
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    right: ScreenUtil()
                                                        .radius(15)),
                                                width: ScreenUtil().radius(45),
                                                height: ScreenUtil().radius(45),
                                                decoration: new BoxDecoration(
                                                  color: Color(productGroup
                                                      .colorGroup[index]
                                                      .color
                                                      .colorCode),
                                                  border: Border.all(
                                                      color: productGroup
                                                                  .colorGroup[
                                                                      index]
                                                                  .color
                                                                  .name ==
                                                              productData
                                                                  .color.name
                                                          ? AppColors
                                                              .primaryElement
                                                          : Colors.grey,
                                                      width: productGroup
                                                                  .colorGroup[
                                                                      index]
                                                                  .color
                                                                  .name ==
                                                              productData
                                                                  .color.name
                                                          ? ScreenUtil()
                                                              .setWidth(2)
                                                          : ScreenUtil()
                                                              .setWidth(1)),
                                                  shape: BoxShape.circle,
                                                )));
                                      }))
                              : SizedBox.shrink(),
                          productGroup.colorGroup.length > 0
                              ? SizedBox(
                                  height: ScreenUtil().setWidth(15),
                                )
                              : SizedBox.shrink(),
                          productGroup.sizeGroup.length > 0
                              ? Container(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(20),
                                      bottom: ScreenUtil().setWidth(10)),
                                  width: double.infinity,
                                  child: Text("Select Size",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setWidth(18))))
                              : Container(),
                          productGroup.sizeGroup.length > 0
                              ? Container(
                                  height: ScreenUtil().setWidth(50),
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(27),
                                      0,
                                      ScreenUtil().setWidth(27),
                                      0),
                                  child: ListView.builder(
                                      itemCount: productGroup.sizeGroup.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext build, index) {
                                        return InkWell(
                                            onTap: () async {
                                              if (productGroup.sizeGroup[index]
                                                      .size.name !=
                                                  productData.size.name) {
                                                await locator<
                                                        NavigationService>()
                                                    .pushReplacementNamed(
                                                        routes
                                                            .ProductDetailRoute,
                                                        args: productGroup
                                                            .sizeGroup[index]
                                                            .id);
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  right:
                                                      ScreenUtil().radius(15)),
                                              width: ScreenUtil().radius(45),
                                              height: ScreenUtil().radius(45),
                                              decoration: new BoxDecoration(
                                                border: Border.all(
                                                    color: productGroup
                                                                .sizeGroup[
                                                                    index]
                                                                .size
                                                                .name ==
                                                            productData
                                                                .size.name
                                                        ? AppColors
                                                            .primaryElement
                                                        : Colors.grey,
                                                    width: productGroup
                                                                .sizeGroup[
                                                                    index]
                                                                .size
                                                                .name ==
                                                            productData
                                                                .size.name
                                                        ? ScreenUtil()
                                                            .setWidth(2)
                                                        : ScreenUtil()
                                                            .setWidth(1)),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  productGroup.sizeGroup[index]
                                                      .size.name,
                                                  style: TextStyle(
                                                      color: Color(0xff707070),
                                                      fontSize: ScreenUtil()
                                                          .setSp(15)),
                                                ),
                                              ),
                                            ));
                                      }))
                              : SizedBox.shrink()
                        ],
                      );
                    }
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(34),
                ),
                Container(
                  width: ScreenUtil().setWidth(150),
                  height: ScreenUtil().setHeight(42),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      side:
                          BorderSide(width: 2, color: AppColors.primaryElement),
                    ),
                    onPressed: () async {
                      LiveStreamSetUp().startRTC(context, "1234", 123, 'join');
                    },
                    child: Text(
                      "Join Stream",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            16,
                          ),
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryElement,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(34),
                ),
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
                            ScreenUtil().setWidth(22),
                            ScreenUtil().setWidth(0),
                            ScreenUtil().setWidth(28),
                            ScreenUtil().setWidth(28)),
                        child: Column(
                          children: [
                            Container(
                              color: Color(0xffffffff),
                              height: ScreenUtil().setWidth(25),
                            ),
                            Container(
                                color: Color(0xffffffff),
                                width: double.infinity,
                                child: Text(
                                  "Description",
                                  style: TextStyle(
                                      color: Color(0xff4a4a4a),
                                      fontSize: ScreenUtil().setSp(20),
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.left,
                                )),
                            SizedBox(
                              height: ScreenUtil().setWidth(10),
                            ),
                            Text(productData.description,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color(0xff4a4a4a),
                                    fontSize: ScreenUtil().setSp(13))),
                          ],
                        ),
                      )
                    : Container(),

                productData.keyFeature != null &&
                        productData.keyFeature.length > 0
                    ? Container(
                        width: double.infinity,
                        child: Column(
                            children:
                                getKeyFeatureChildren(productData.keyFeature)),
                      )
                    : Container(),
                SizedBox(
                  height: productData.keyFeature != null ||
                          productData.keyFeature.length != 0
                      ? ScreenUtil().setWidth(20)
                      : 0,
                ),
                Container(
                  color: Color(0xfff3f3f3),
                  height: ScreenUtil().setWidth(20),
                ),
                getProductDetailChildren(productData).length > 0
                    ? Container(
                        width: double.infinity,
                        child: Column(
                            children: getProductDetailChildren(productData)),
                      )
                    : SizedBox.shrink(),
                Container(
                  color: Color(0xfff3f3f3),
                  height: getProductDetailChildren(productData).length > 0
                      ? ScreenUtil().setWidth(20)
                      : 0,
                ),
                productData.specifications != null ||
                        productData.specifications.length != 0
                    ? Container(
                        width: double.infinity,
                        child: Column(
                            children: getSpecificationChildren(
                                productData.specifications)),
                      )
                    : Container(),
                SizedBox(
                  height: productData.specifications != null ||
                          productData.specifications.length != 0
                      ? ScreenUtil().setWidth(20)
                      : 0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(51),
          )
        ],
      )),
      Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Color(0xffffffff),
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, ScreenUtil().setWidth(45),
                ScreenUtil().setWidth(20), 20),
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
                        width: ScreenUtil().radius(35),
                        height: ScreenUtil().radius(35),
                        decoration: new BoxDecoration(
                          color: Color(0xfff3f3f3),
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
                            event: EVENT_PRODUCT_DETAILS_ADD_TO_WISHLIST,
                            data: data);
                      },
                      child: Container(
                          margin: EdgeInsets.fromLTRB(
                              0, 0, ScreenUtil().setWidth(8), 0),
                          width: ScreenUtil().radius(35),
                          height: ScreenUtil().radius(35),
                          decoration: new BoxDecoration(
                            color: Color(0xfff3f3f3),
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
                          child: CheckWishListClass(
                              productData.id, productData.id)),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(15),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0, 0, ScreenUtil().setWidth(8), 0),
                      width: ScreenUtil().radius(35),
                      height: ScreenUtil().radius(35),
                      decoration: new BoxDecoration(
                        color: Color(0xfff3f3f3),
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
                      child:
                          // Transform.translate(
                          //   offset: Offset(-10, 0),
                          //   child:
                          CartLogo(),
                    )
                  ],
                )
                    ),
              ],
            ),
          )),
      cartStatusButton == "Not Available"
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
                          width: ScreenUtil().setWidth(170),
                          height: ScreenUtil().setHeight(45),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              side: BorderSide(
                                  width: 2, color: AppColors.primaryElement),
                            ),
                            onPressed: () async {
                              if (Provider.of<ProfileModel>(context,
                                          listen: false)
                                      .user !=
                                  null) {
                                await Provider.of<WishlistViewModel>(context,
                                        listen: false)
                                    .toggleItem(productData.id);
                                setState(() {});
                              } else {
                                locator<NavigationService>()
                                    .pushNamed(routes.LoginRoute);
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
                                    width: ScreenUtil().setWidth(16),
                                  ),
                                  Text(
                                    "WISHLIST",
                                    style: TextStyle(
                                        color: Color(0xff646464),
                                        fontSize: ScreenUtil().setSp(
                                          16,
                                        ),
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Container(
                          decoration: BoxDecoration(
                              color: AppColors.primaryElement,
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(5))),
                          width: ScreenUtil().setWidth(170),
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
                              if (cartStatusButton == "Not Available") {
                              } else {
                                if (cartStatusButton == "Add to cart") {
                                  setState(() {
                                    cartStatusButton = "Go to cart";
                                  });
                                  Provider.of<CartViewModel>(context,
                                          listen: false)
                                      .cartAddItem(productData.id,
                                          productData.id, 1, false);
                                } else {
                                  _navigationService
                                      .pushNamed(routes.CartRoute);
                                }
                              }
                            },
                            child: Container(
                             
                              //padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                              color: cartStatusButton == "Not Available"
                                  ? AppColors.primaryElement
                                  : AppColors.primaryElement,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  cartStatusButton == "Not Available"
                                      ? SizedBox.shrink()
                                      : Icon(
                                          Icons.shopping_cart,
                                          color: Color(0xffffffff),
                                          size: ScreenUtil().setWidth(22),
                                        ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(16),
                                  ),
                                  Text(
                                    cartStatusButton,
                                    style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontSize: ScreenUtil().setSp(
                                          16,
                                        ),
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ))
                    ],
                  ))),
    ]);
  }

  getSpecificationChildren(List<Specifications> specifications) {
    List<Widget> children = [];
    if (specifications.length != 0) {
      children.add(
        Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                top: ScreenUtil().setWidth(15)),
            height: ScreenUtil().setWidth(50),
            color: Color(0xffffffff),
            width: double.infinity,
            child: Text(
              "Product Specification",
              style: TextStyle(
                  color: Color(0xff4a4a4a),
                  fontSize: ScreenUtil().setSp(20),
                  fontWeight: FontWeight.w600),
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
              left: ScreenUtil().setWidth(30),
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
                                  specifications[i].name,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Color(0xff000000)),
                                ))
                          ],
                        )),
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: Text(
                        specifications[i].value,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xffa4a4a4)),
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
              left: ScreenUtil().setWidth(30),
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
                                  style: TextStyle(color: Color(0xff000000)),
                                ))
                          ],
                        )),
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: Text(
                        "${productData?.countryOfOrigin}",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xffa4a4a4)),
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
              left: ScreenUtil().setWidth(30),
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
                                  "Warranty: ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Color(0xff000000)),
                                ))
                          ],
                        )),
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: Text(
                        productData?.warranty ?? '',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xffa4a4a4)),
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
                left: ScreenUtil().setWidth(30),
                top: ScreenUtil().setWidth(15)),
            height: ScreenUtil().setWidth(50),
            color: Color(0xffffffff),
            width: double.infinity,
            child: Text(
              "Product Details",
              style: TextStyle(
                  color: Color(0xff4a4a4a),
                  fontSize: ScreenUtil().setSp(20),
                  fontWeight: FontWeight.w600),
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
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
          color: Color(0xffffffff),
          width: double.infinity,
          child: Text(
            "Key Features",
            style: TextStyle(
                color: Color(0xff4a4a4a),
                fontSize: ScreenUtil().setSp(20),
                fontWeight: FontWeight.w600),
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
            bottom: ScreenUtil().setWidth(10),
            left: ScreenUtil().setWidth(10),
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
                  width: ScreenUtil().setWidth(50),
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
      // children.add(Container(
      //     color: Color(0xffffffff),
      //     height: ScreenUtil().setWidth(32),
      //     width: double.infinity,
      //     padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
      //     child:Center(
      //         child:Container(
      //           width: double.infinity,
      //         child:Text(features[i].value,textAlign: TextAlign.left,)))));
    }
    return children;
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
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            print(result.exception.toString());
            return Container();
          }
          if (result.isLoading) {
            return Container();
          }
          print(jsonEncode(result.data["reviewSummary"]));
          if (result.data == null) {
            return Row(children: [
            Container(
            padding: EdgeInsets.only(top: ScreenUtil().setWidth(3)),
          child: Text("0",style: TextStyle(color: Color(0xff6d6d6d),fontSize: ScreenUtil().setWidth(18)),)),
              SizedBox(width: ScreenUtil().setWidth(3),),
              Icon(FontAwesomeIcons.solidStar,size: ScreenUtil().setWidth(14),color: Colors.amber,)
            ],);
          }
          if(result.data["reviewSummary"] == null){
            return Row(children: [
              Container(
                padding: EdgeInsets.only(top: ScreenUtil().setWidth(3)),
                child:Text("0",style: TextStyle(color: Color(0xff6d6d6d),fontSize: ScreenUtil().setWidth(18)),),

              ),
              SizedBox(width: ScreenUtil().setWidth(3),),
              Icon(FontAwesomeIcons.solidStar,size: ScreenUtil().setWidth(14),color: Colors.amber,)
            ],);
          }
          return Row(children: [
          Container(
          padding: EdgeInsets.only(top: ScreenUtil().setWidth(3)),
          child:
            Text(result.data["reviewSummary"]["avg"].toString()??"0",style: TextStyle(color: Color(0xff6d6d6d),fontSize: ScreenUtil().setWidth(18)),)),
            SizedBox(width: ScreenUtil().setWidth(3),),
            Icon(FontAwesomeIcons.solidStar,size: ScreenUtil().setWidth(14),color: Colors.amber,)
          ],);
          //   return RatingBar.builder(
          //     itemSize: ScreenUtil().setWidth(18),
          //     initialRating: 0,
          //     minRating: 0,
          //     direction: Axis.horizontal,
          //     allowHalfRating: true,
          //     itemCount: 5,
          //     itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
          //     itemBuilder: (context, _) => Icon(
          //       Icons.star,
          //       color: Color(0xfff2b200),
          //     ),
          //     ignoreGestures: true,
          //     onRatingUpdate: (double value) {},
          //   );
          // }
          // if (result.data["reviewSummary"] == null) {
          //   return RatingBar.builder(
          //     itemSize: ScreenUtil().setWidth(18),
          //     initialRating: 0,
          //     minRating: 0,
          //     direction: Axis.horizontal,
          //     allowHalfRating: true,
          //     itemCount: 5,
          //     itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
          //     itemBuilder: (context, _) => Icon(
          //       Icons.star,
          //       color: Color(0xfff2b200),
          //     ),
          //     ignoreGestures: true,
          //     onRatingUpdate: (double value) {},
          //   );
          // }
          // return RatingBar.builder(
          //   itemSize: ScreenUtil().setWidth(18),
          //   initialRating:
          //       double.parse(result.data["reviewSummary"]["avg"]) ?? 0,
          //   // minRating: 0,
          //   direction: Axis.horizontal,
          //   allowHalfRating: true,
          //   itemCount: 5,
          //   itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
          //   itemBuilder: (context, _) => Icon(
          //     Icons.star,
          //     color: Color(0xfff2b200),
          //   ),
          //   ignoreGestures: true,
          //   onRatingUpdate: (double value) {},
          // );
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
  bool status;

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
                {VoidCallback refetch, FetchMore fetchMore}) {
              if (result.hasException) {
                print(result.exception.toString());
                return Container();
              }
              if (result.isLoading) {
                return Icon(Icons.workspaces_outline,
                    color: Color(0xffd3d3d3), size: 20);
              }
              if (result.isConcrete) {
                status = result.data["checkWishlist"];
                return Center(
                  // margin: EdgeInsets.only(left: ScreenUtil().setWidth(0.4)),
                  child: InkWell(
                    child: status == false
                        ? Icon(
                            FontAwesomeIcons.heart,
                            color: Colors.red,
                            size: 20,
                          )
                        : Icon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.red,
                            size: 20,
                          ),
                    onTap: () async {
                      if (Provider.of<ProfileModel>(context, listen: false)
                              .user !=
                          null) {
                        await Provider.of<WishlistViewModel>(context,
                                listen: false)
                            .toggleItem(widget.productID);
                        setState(() {
                          status = !status;
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
