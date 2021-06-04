import 'dart:convert';
import 'dart:developer';

import 'package:anne/utils/zego_config.dart';
import 'package:anne/view/play_stream/play_stream_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:anne/components/widgets/cartEmptyMessage.dart';
import 'package:anne/model/product.dart';
import 'package:anne/response_handler/productGroupResponse.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';

import 'package:anne/utility/query_mutation.dart';
import 'package:anne/components/widgets/errorMessage.dart';
import 'package:anne/view/cart_logo.dart';
import 'package:anne/view_model/cart_view_model.dart';
import 'package:anne/utility/graphQl.dart';

import 'package:anne/components/widgets/loading.dart';
import 'package:anne/values/route_path.dart' as routes;
import 'package:anne/view_model/wishlist_view_model.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

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
  ProductDetailData productData;
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  String productId;

  @override
  void initState() {
    // TODO: implement initState
    productId = widget.productId;

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
  Future<void>  _loginRoom(roomId) async {
    String roomID = roomId;
    ZegoUser user = ZegoUser(ZegoConfig.instance.userID, ZegoConfig.instance.userName);
    await ZegoExpressEngine.instance.loginRoom(roomID, user);
    ZegoConfig.instance.roomID = roomID;
    ZegoConfig.instance.saveConfig();
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {

      int screenWidthPx = MediaQuery.of(context).size.width.toInt() * MediaQuery.of(context).devicePixelRatio.toInt();
      int screenHeightPx = (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 56.0).toInt() * MediaQuery.of(context).devicePixelRatio.toInt();

      return PlayStreamPage(roomID,screenWidthPx, screenHeightPx);

    }));

  }

  @override
  Widget build(BuildContext context) {
  if(Provider
      .of<CartViewModel>(context)
      .cartResponse
      !=null) {
    for (int i = 0; i < Provider
        .of<CartViewModel>(context)
        .cartResponse
        .items
        .length; i++) {
      if (Provider
          .of<CartViewModel>(context)
          .cartResponse
          .items[i].pid == productId) {
        setState(() {
          cartStatusButton = "Go to cart";
        });
      }
    }
  }
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
          "Product Details",
          style: TextStyle(
              color: Color(0xff616161),
              fontSize: ScreenUtil().setSp(
                21,
              )),
          textAlign: TextAlign.center,
        )),
        actions: [
          Container(
              padding: EdgeInsets.only(right: 10.0),
              // width: MediaQuery.of(context).size.width * 0.35,
              child: CartLogo())
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xfff3f3f3),
        child: Query(
          options: QueryOptions(
              document: gql(addMutation.product()),
              variables: {"id": productId}),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.hasException) {
              print(result.exception.toString());
              return errorMessage();
            }
            if (result.isLoading) {
              return Loading();
            }
            if (result.data["product"] == null) {
              return cartEmptyMessage(
                  "noNetwork", "Nothing here . Something went wrong !!");
            } else {
              log(result.data["product"].toString());
              productData = ProductDetailData.fromJson(result.data["product"]);
              if (productData.stock <= 0) {
                cartStatusButton = "Not Available";
              }
              return getProductDetails();
            }
          },
        ),
      ),
    );
  }

  imagesList(count, images) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        itemBuilder: (BuildContext context, index) {
          return Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(22)),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(9),
                ScreenUtil().setWidth(9),
                ScreenUtil().setWidth(9),
                ScreenUtil().setWidth(9)),
            height: ScreenUtil().setWidth(70),
            width: ScreenUtil().setWidth(70),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(
                      color: indexImage == index
                          ? Color(0xff32afc8)
                          : Color(0xfffffcfc),
                      width: ScreenUtil().setWidth(0.3),
                      // This would be the width of the underline
                    ),
                    top: BorderSide(
                      color: indexImage == index
                          ? Color(0xff32afc8)
                          : Color(0xfffffcfc),
                      width: ScreenUtil().setWidth(0.3),
                      // This would be the width of the underline
                    ),
                    left: BorderSide(
                      color: indexImage == index
                          ? Color(0xff32afc8)
                          : Color(0xfffffcfc),
                      width: ScreenUtil().setWidth(0.3),
                      // This would be the width of the underline
                    ),
                    right: BorderSide(
                      color: indexImage == index
                          ? Color(0xff32afc8)
                          : Color(0xfffffcfc),
                      width: ScreenUtil().setWidth(0.3),
                      // This would be the width of the underline
                    ))),
            child: InkWell(
                onTap: () {
                  setState(() {
                    indexImage = index;
                  });
                },
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/loading.gif',
                  image: images[index] != null
                      ? images[index].toString().trim()
                      : 'https://next.anne.com/icon.png',
                  width: ScreenUtil().setWidth(52),
                  height: ScreenUtil().setWidth(52),
                )),
          );
        });
  }

  Widget getProductDetails() {
    icon = Icons.favorite_border;
    var count = productData.images.length;

    return Stack(children: [
      SingleChildScrollView(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, ScreenUtil().setWidth(16.58),
                ScreenUtil().setWidth(21.58), 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.share,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                    margin:
                        EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(8), 0),
                    width: ScreenUtil().radius(24),
                    height: ScreenUtil().radius(24),
                    decoration: new BoxDecoration(
                      color: Color(0xffFFE8E8),
                      border: Border(
                          bottom: BorderSide(
                              color: Color(0xffff2300),
                              width: ScreenUtil().setWidth(0.4)),
                          top: BorderSide(
                              color: Color(0xffff2300),
                              width: ScreenUtil().setWidth(0.4)),
                          left: BorderSide(
                              color: Color(0xffff2300),
                              width: ScreenUtil().setWidth(0.4)),
                          right: BorderSide(
                              color: Color(0xffff2300),
                              width: ScreenUtil().setWidth(0.4))),
                      shape: BoxShape.circle,
                    ),
                    child: CheckWishListClass(productData.id, productData.id))
              ],
            ),
          ),
          GestureDetector(
              onHorizontalDragUpdate: (details) {
                // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                int sensitivity = 12;
                if (details.delta.dx > sensitivity) {
                  if (indexImage == 0) {
                  } else {
                    setState(() {
                      indexImage = indexImage - 1;
                    });
                  }
                } else if (details.delta.dx < -sensitivity) {
                  if (indexImage == count - 1) {
                  } else {
                    setState(() {
                      indexImage = indexImage + 1;
                    });
                  }
                }
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(60),
                    ScreenUtil().setWidth(16.65),
                    ScreenUtil().setWidth(59),
                    ScreenUtil().setWidth(27)),
                height: ScreenUtil().setWidth(291),
                width: ScreenUtil().setWidth(295),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(12),
                    ScreenUtil().setWidth(11),
                    ScreenUtil().setWidth(12),
                    ScreenUtil().setWidth(9)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                          color: Color(0xff32afc8),
                          width: ScreenUtil().setWidth(0.3),
                          // This would be the width of the underline
                        ),
                        top: BorderSide(
                          color: Color(0xff32afc8),
                          width: ScreenUtil().setWidth(0.3),
                          // This would be the width of the underline
                        ),
                        left: BorderSide(
                          color: Color(0xff32afc8),
                          width: ScreenUtil().setWidth(0.3),
                          // This would be the width of the underline
                        ),
                        right: BorderSide(
                          color: Color(0xff32afc8),
                          width: ScreenUtil().setWidth(0.3),
                          // This would be the width of the underline
                        ))),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/loading.gif',
                  image: productData.images[indexImage] != null
                      ? productData.images[indexImage].trim()
                      : 'https://next.anne.com/icon.png',
                  width: ScreenUtil().setWidth(271),
                  height: ScreenUtil().setWidth(271),
                ),
              )),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(38), 0),
            height: ScreenUtil().setWidth(70),
            child: imagesList(count, productData.images),
          ),
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
                            color: Color(0xffba8638),
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
                      productData.name??"",
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
                                        color: Color(0xff00c921),
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
                      "Delivery by : " + productData.time.toString(),
                      style: TextStyle(
                          color: Color(0xff4a4a4a),
                          fontSize: ScreenUtil().setSp(
                            13,
                          )),
                    )),
                SizedBox(
                  height: ScreenUtil().setWidth(15),
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
                                        print("thid id " +
                                            productGroup.colorGroup[index].color
                                                .colorCode
                                                .toString());
                                        return InkWell(
                                            onTap: () {
                                              print(productGroup
                                                  .colorGroup[index].id);
                                              setState(() {
                                                productId = productGroup
                                                    .colorGroup[index].id;
                                              });
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
                                                          ? Color(0xffba8638)
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
                                            onTap: () {
                                              print(productData.size.name);
                                              setState(() {
                                                productId = productGroup
                                                    .sizeGroup[index].id;
                                              });
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
                                                        ? Color(0xffba8638)
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
                productData.liveStreams!=null&&productData.liveStreams.scheduleDateTime!=null?Container(child: getLiveStreamWidget(productData.liveStreams),):Container(),
               Container(
                   padding: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setWidth(34)),
                   child:getVideoCallWidget()),

                Container(
                  color: Color(0xfff3f3f3),
                  height: ScreenUtil().setWidth(20),
                ),
                productData.features!=null||productData.features.length!=0?Container(
                  width: double.infinity,
                  child: Column(
                      children: getSpecificationChildren(productData.features)
                  ),
                ):Container(),
                SizedBox(height: productData.features!=null||productData.features.length!=0?ScreenUtil().setWidth(20):0,),
                productData.description!=null? Container(
                  width: double.infinity,
                  color: Color(0xffffffff),
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(22), ScreenUtil().setWidth(29), ScreenUtil().setWidth(28), ScreenUtil().setWidth(28)),
                  child: Column(children: [
                    Text("Description",style: TextStyle(fontSize: ScreenUtil().setSp(23),color: Color(0xff4a4a4a)),textAlign: TextAlign.center,),
                    SizedBox(height: ScreenUtil().setWidth(31),),
                    Text(productData.description,textAlign: TextAlign.center,style:TextStyle(color: Color(0xff4a4a4a),fontSize: ScreenUtil().setSp(13))),
                  ],),):Container(),

              ],
            ),
          ),

          SizedBox(
            height: ScreenUtil().setWidth(51),
          )
        ],
      )),
      cartStatusButton == "Not Available"
          ? SizedBox.shrink()
          : Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setWidth(51),
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                    textColor: Colors.white,
                    color: cartStatusButton == "Not Available"
                        ? Color(0xffbb8738).withOpacity(0.8)
                        : Color(0xffbb8738),
                    onPressed: () async {
                      if (cartStatusButton == "Not Available") {
                      } else {
                        if (cartStatusButton == "Add to cart") {
                          setState(() {
                            cartStatusButton = "Go to cart";
                          });
                          Provider.of<CartViewModel>(context, listen: false)
                              .cartAddItem(
                                  productData.id, productData.id, 1, false);
                        } else {
                          _navigationService.pushNamed(routes.CartRoute);
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        cartStatusButton == "Not Available"
                            ? SizedBox.shrink()
                            : Icon(
                                Icons.shopping_cart,
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
                                17,
                              ),
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              )),
    ]);
  }

  getSpecificationChildren(List<Features> features) {
    List<Widget> children = [];
    children.add(Container(
      color:Color(0xffffffff),
      height: ScreenUtil().setWidth(59),
      width: double.infinity,
      child: Center(child: Text("Specifications",style: TextStyle(color:Color(0xff4a4a4a),fontSize: ScreenUtil().setSp(23),),textAlign: TextAlign.center,),
    )));
    for(int i=0;i<features.length;i++){
      children.add(Container(
        color: Color(0xfff8f8f8),
        height: ScreenUtil().setWidth(32),
        width: double.infinity,
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
        child: Center(child:Container(
          width: double.infinity,
          child:Text(features[i].name+":",textAlign: TextAlign.left,)),)));
      children.add(Container(
          color: Color(0xffffffff),
          height: ScreenUtil().setWidth(32),
          width: double.infinity,
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
          child:Center(
              child:Container(
                width: double.infinity,
              child:Text(features[i].value,textAlign: TextAlign.left,)))));
    }
    return children;
  }

  getLiveStreamWidget(LiveStreamProductDetail liveStream) {
    return Container(
      child: Column(
        children: [
          Container(
              color:Color(0xffffffff),
              height: ScreenUtil().setWidth(59),
              width: double.infinity,
              child: Center(child: Text("Live Stream",style: TextStyle(color:Color(0xff4a4a4a),fontSize: ScreenUtil().setSp(23),),textAlign: TextAlign.center,),
              )),
          Container(
            child: CountdownTimer(
              endTime:
              liveStream.scheduleDateTime,
              widgetBuilder: (_, CurrentRemainingTime time) {
                if (time == null) {
                  return GestureDetector(
                      onTap: ()async{
                        await _createEngine();
                        await _loginRoom(liveStream.id);
                      },
                      child: Container(
                    width: ScreenUtil().setWidth(250),
                    height: ScreenUtil().setWidth(44),
                    decoration: BoxDecoration(
                      color: Color(0xffbb8738),
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(45)),

                    ),
                    child: Center(child: Text("Start Now !!!",style: TextStyle(color: Color(0xffffffff)),)),
                  ));
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
        ],
      ),
    );
  }

  getVideoCallWidget() {
    return GestureDetector(
        onTap: ()async{
          locator<NavigationService>().pushNamed(routes.VideoTalk);
        },
        child: Container(
          width: ScreenUtil().setWidth(250),
          height: ScreenUtil().setWidth(44),
          decoration: BoxDecoration(
            color: Color(0xffbb8738),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(45)),

          ),
          child: Center(child: Text("Call Vendor",style: TextStyle(color: Color(0xffffffff)),)),
        ));
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
              "product": widget.id,
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
            return RatingBar.builder(
              itemSize: ScreenUtil().setWidth(18),
              initialRating: 0,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Color(0xfff2b200),
              ),
              onRatingUpdate: (double value) {},
            );
          }
          if (result.data["reviewSummary"] == null) {
            return RatingBar.builder(
              itemSize: ScreenUtil().setWidth(18),
              initialRating: 0,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Color(0xfff2b200),
              ),
              onRatingUpdate: (double value) {},
            );
          }
          return RatingBar.builder(
            itemSize: ScreenUtil().setWidth(18),
            initialRating: double.parse(result.data["reviewSummary"]["avg"].toString()) ?? 0,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Color(0xfff2b200),
            ),
            onRatingUpdate: (double value) {},
          );
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
                    return Container();
                  }
                  print(jsonEncode(result.data["checkWishlist"]));

                  return Center(
                      // margin: EdgeInsets.only(left: ScreenUtil().setWidth(0.4)),
                      child: InkWell(
                    child: result.data["checkWishlist"] == false
                        ? Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                            size: ScreenUtil().setWidth(15),
                          )
                        : Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: ScreenUtil().setWidth(15),
                          ),
                    onTap: () async {
                     await Provider.of<WishlistViewModel>(context, listen: false)
                          .toggleItem(widget.productID);
                      setState(() {});
                    },
                  ));
                })));
  }
}
