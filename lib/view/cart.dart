import 'package:anne/components/base/tz_dialog.dart';
import 'package:anne/enum/tz_dialog_type.dart';
import 'package:anne/view_model/product_detail_view_model.dart';
import 'package:anne/view_model/wishlist_view_model.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../components/widgets/buttonValue.dart';
import '../../response_handler/cartResponse.dart';
import '../../service/event/tracking.dart';
import '../../values/colors.dart';
import '../../values/event_constant.dart';
import '../../values/route_path.dart' as routes;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../utility/query_mutation.dart';
import '../../view/product_detail.dart';
import '../../components/widgets/errorMessage.dart';
import '../../components/widgets/loading.dart';
import '../../view_model/auth_view_model.dart';
import '../../view_model/cart_view_model.dart';
import '../../utility/graphQl.dart';
import '../../components/widgets/cartEmptyMessage.dart';
import '../main.dart';

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Cart();
  }
}

class _Cart extends State<Cart> {
  QueryMutation addMutation = QueryMutation();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  var total = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
        title: Text("Cart",
            style: TextStyle(
                color: Color(0xff616161),
                fontSize: ScreenUtil().setSp(
                  21,
                ))),
        // actions: [
        //   Container(
        //       padding: EdgeInsets.only(right: 10.0),
        //       // width: MediaQuery.of(context).size.width * 0.35,
        //       )
        // ],
      ),
      body: GraphQLProvider(
        client: graphQLConfiguration.initailizeClient(),
        child: CacheProvider(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Color(0xfff3f3f3),
            child: getCartList(),
          ),
        ),
      ),
    );
  }

  Widget getCartList() {
    final NavigationService? _navigationService = locator<NavigationService>();
    return Consumer<CartViewModel>(
        builder: (BuildContext context, value, Widget? child) {
      if (value.status == "loading") {
        Provider.of<CartViewModel>(context, listen: false).fetchCartData();
        return Loading();
      } else if (value.status == "empty") {
        return cartEmptyMessage("cart", "Cart is Empty");
      } else if (value.status == "error") {
        return InkWell(
            onTap: () async {
              await refreshCart();
            },
            child: errorMessage());
      }

      return Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              Container(
                  child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(20),
                        ScreenUtil().setWidth(21),
                        20,
                        ScreenUtil().setWidth(18)),
                    child: Text(
                      "${value.cartResponse!.items!.length} Items",
                      style: TextStyle(
                          color: Color(0xff616161),
                          fontSize: ScreenUtil().setSp(
                            16,
                          )),
                    ),
                  ),
                  Container(child: CartCard()),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(20),
                        ScreenUtil().setWidth(15),
                        20,
                        ScreenUtil().setWidth(20)),
                    child: Text(
                      "COUPONS",
                      style: TextStyle(
                          color: Color(0xff616161),
                          fontSize: ScreenUtil().setSp(
                            16,
                          )),
                    ),
                  ),
                  Container(
                      color: Color(0xffffffff),
                      child:
                  InkWell(
                      onTap: () async{
                        await Provider.of<CartViewModel>(context,
                            listen: false)
                            .changePromoStatus("loading");
                        showCoupon();
                      },
                      child:
                  Container(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right:ScreenUtil().setWidth(20),top:ScreenUtil().setWidth(20),bottom: ScreenUtil().setWidth(20) ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(value.promocodeStatus!
                            ?"Applied Promocode ("+ value.promocode!+")"
                            : "Apply Promocode"),
                        Icon(FontAwesomeIcons.angleRight,color: Color(0xffd0d0d0),size: ScreenUtil().setWidth(14),),
                      ],
                    )
                  )
                  )),
                  SizedBox(height: ScreenUtil().setWidth(15),),
                  Container(
                    child: CartBillCard(),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ))
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: ScreenUtil().setHeight(61),
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(20),
                  ScreenUtil().setWidth(10),
                  ScreenUtil().setWidth(20),
                  ScreenUtil().setWidth(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total : ${store!.currencySymbol} ${value.cartResponse!.total!.toStringAsFixed(store!.currencyDecimals!)}",
                      style: TextStyle(
                          color: Color(0xff383838),
                          fontSize: ScreenUtil().setSp(
                            18,
                          ))),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Consumer<ProfileModel>(
                      builder: (context, user, child) {
                        return Container(
                          width: ScreenUtil().setWidth(170),
                          height: ScreenUtil().setHeight(42),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: AppColors.primaryElement,
                              side: BorderSide(
                                  width: 2, color: AppColors.primaryElement),
                            ),
                            onPressed: () async {
                              if (user.user != null) {
                                _navigationService!.pushNamed(routes.CheckOut);
                              } else {
                                if (settingData!.otpLogin!) { locator<NavigationService>().pushNamed(routes.LoginRoute);}
                                else{
                                  locator<NavigationService>().pushNamed(routes.EmailLoginRoute);
                                }
                              }
                            },
                            child: Text(
                              "PLACE ORDER",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(
                                  16,
                                ),
                                fontWeight: FontWeight.w600,
                                  color: Color(0xffffffff),
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  void showCoupon() {
    bool buttonStatus = true;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Apply Coupon",
                    style: TextStyle(
                        color: Color(0xff3a3a3a),
                        fontSize: ScreenUtil().setSp(17)),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: ScreenUtil().setWidth(20),
                      color: Color(0xff3a3a3a),
                    ),
                  ),
                ],
              ),
              content: Container(
                child: Consumer<CartViewModel>(
                    builder: (BuildContext context, value, Widget? child) {
                      if (value.statusPromo == "loading") {
                        Provider.of<CartViewModel>(context, listen: false)
                            .listCoupons();
                        return Container(
                            height: ScreenUtil().setWidth(340),
                            width: ScreenUtil().setWidth(386),
                            child: Loading());
                      } else if (value.statusPromo == "empty") {
                        return  Container(
                              height: ScreenUtil().setHeight(340),
                              width: ScreenUtil().setWidth(386),
                              child: CouponEmpty()
                          );
                      } else if (value.statusPromo == "error") {
                        return Container(
                            height: ScreenUtil().setWidth(350),
                            width: ScreenUtil().setWidth(386),
                            child: CouponError());
                      }

                      return Container(
                        height: ScreenUtil().setWidth(350),
                        width: ScreenUtil().setWidth(386),
                        child: Column(
                          children: [
                            Divider(
                              height: ScreenUtil().setWidth(0.4),
                              thickness: ScreenUtil().setWidth(0.4),
                              color: Color(0xff707070),
                            ),
                            SizedBox(
                              height: ScreenUtil().setWidth(25),
                            ),
                            Container(
                              height: ScreenUtil().setWidth(250),
                              child: ListView.builder(
                                  itemCount: value.couponResponse!.data!.length,
                                  itemBuilder: (BuildContext build, index) {
                                    return Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  await Provider.of<CartViewModel>(
                                                      context,
                                                      listen: false)
                                                      .selectPromoCode(value
                                                      .couponResponse!
                                                      .data![index]
                                                      .code);
                                                },
                                                child: value.promocode ==
                                                    value.couponResponse!
                                                        .data![index].code
                                                    ? Icon(
                                                  Icons.check_box,
                                                  color: AppColors.primaryElement,
                                                  size:
                                                  ScreenUtil().setWidth(18),
                                                )
                                                    : Icon(
                                                  Icons.check_box_outline_blank,
                                                  color: AppColors.primaryElement,
                                                  size:
                                                  ScreenUtil().setWidth(18),
                                                ),
                                              ),
                                              SizedBox(
                                                width: ScreenUtil().setWidth(20),
                                              ),
                                              DottedBorder(
                                                  color: AppColors.primaryElement,
                                                  dashPattern: [
                                                    ScreenUtil().setWidth(4),
                                                    ScreenUtil().setWidth(2)
                                                  ],
                                                  child: Container(
                                                    height: ScreenUtil().setWidth(28),
                                                    width: ScreenUtil().setWidth(96),
                                                    child: Center(
                                                        child: Text(
                                                          value.couponResponse!.data![index]
                                                              .code!,
                                                          style: TextStyle(
                                                              color: AppColors.primaryElement,
                                                              fontSize:
                                                              ScreenUtil().setSp(
                                                                13,
                                                              )),
                                                        )),
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setWidth(15),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(35)),
                                            width: double.infinity,
                                            child: Text(
                                              "Saves upto ${store!.currencySymbol} ${value.couponResponse!.data![index].maxAmount!.toStringAsFixed(store!.currencyDecimals!)}",
                                              style: TextStyle(
                                                  color: Color(0xff3a3a3a),
                                                  fontSize: ScreenUtil().setSp(14)),
                                            ),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setWidth(9),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(35)),
                                            width: double.infinity,
                                            child: Text(
                                              "${value.couponResponse!.data![index].text}",
                                              style: TextStyle(
                                                  color: Color(0xff3a3a3a),
                                                  fontSize: ScreenUtil().setSp(14)),
                                            ),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setWidth(38),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: ScreenUtil().setWidth(14),
                            ),
                            // Text("Maximum saving : ${store.currencySymbol} 125",style: TextStyle(color:Color(0xff7a7a7a),fontSize: ScreenUtil().setSp(13)),),
                            // SizedBox(height: ScreenUtil().setWidth(9),),
                            Container(
                              height: ScreenUtil().setWidth(36),
                              width: ScreenUtil().setWidth(224),
                              child: RaisedButton(
                                padding: EdgeInsets.fromLTRB(
                                    0,
                                    ScreenUtil().setWidth(9),
                                    0,
                                    ScreenUtil().setWidth(9)),
                                onPressed: () async {
                                  if (value.promocode != "") {
                                    setState(() {
                                      buttonStatus = !buttonStatus;
                                    });
                                    await Provider.of<CartViewModel>(context,
                                        listen: false)
                                        .applyCoupon();
                                    Navigator.pop(context);
                                  }
                                },
                                color: AppColors.primaryElement2,
                                child: buttonValueWhite(
                                  "Apply Coupon",
                                  buttonStatus,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ));
        });
  }

  refreshCart() async {
    await Provider.of<CartViewModel>(context, listen: false).refreshCart();
  }
}

class CartBillCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartBillCard();
  }
}

class _CartBillCard extends State<CartBillCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<CartViewModel>(
        builder: (BuildContext context, value, Widget? child) {

      if (value.cartResponse == null || value.cartResponse!.items!.length == 0) {
        return Container();
      }
      return Material(
          color: Color(0xfff3f3f3),
          // borderRadius: BorderRadius.circular(2),
          child: Card(
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(0),
                ScreenUtil().setWidth(0),
                ScreenUtil().setWidth(0),
                ScreenUtil().setWidth(65)),
            elevation: 0,
            child: Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(20),
                    ScreenUtil().setWidth(20),
                    ScreenUtil().setWidth(20),
                    ScreenUtil().setWidth(20)),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Container(
                  child: Column(
                    children: <Widget>[

                      //     Container(
                      //         height: ScreenUtil().setWidth(45),
                      //         child: TextFormField(
                      //           onTap: () async {
                      //             await Provider.of<CartViewModel>(context,
                      //                     listen: false)
                      //                 .changePromoStatus("loading");
                      //             showCoupon();
                      //           },
                      //           readOnly: true,
                      //           decoration: InputDecoration(
                      //               fillColor: Color(0xfff3f3f3),
                      //               filled: true,
                      //               contentPadding: EdgeInsets.all(
                      //                   ScreenUtil().setWidth(10)),
                      //               enabledBorder: OutlineInputBorder(
                      //                 borderSide: BorderSide(
                      //                     color: Color(0xffb4b4b4),
                      //                     width: ScreenUtil().setWidth(0.4)),
                      //               ),
                      //               focusedBorder: OutlineInputBorder(
                      //                 borderSide: BorderSide(
                      //                     color: Color(0xffb4b4b4),
                      //                     width: ScreenUtil().setWidth(0.4)),
                      //               ),
                      //               hintText: value.promocodeStatus
                      //                   ? value.promocode
                      //                   : "Apply Promocode",
                      //               hintStyle: TextStyle(
                      //                   color: Color(0xffb9b9b9),
                      //                   fontSize: ScreenUtil().setSp(
                      //                     15,
                      //                   ))),
                      //         )),
                      // SizedBox(
                      //   height: ScreenUtil().setWidth(28),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Price Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff383838),
                                fontSize: ScreenUtil().setSp(
                                  20,
                                )),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Item Subtotal",
                              style: TextStyle(
                                  color: Color(0xff616161),
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  ))),
                          Text("${store!.currencySymbol} " + value.cartResponse!.subtotal!.toStringAsFixed(store!.currencyDecimals!),
                              style: TextStyle(
                                  color: Color(0xff616161),
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  )))
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Total Items",
                              style: TextStyle(
                                  color: Color(0xff616161),
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  ))),
                          Text(value.cartResponse!.qty.toString(),
                              style: TextStyle(
                                  color: Color(0xff616161),
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  )))
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(16),
                      ),
                      value.cartResponse!.discount!.amount! > 0.0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Your savings",
                                    style: TextStyle(
                                        color: Color(0xff616161),
                                        fontSize: ScreenUtil().setSp(
                                          16,
                                        ))),
                                Text(
                                    "${store!.currencySymbol} " +
                                        value.cartResponse!.discount!.amount!
                                            .toStringAsFixed(store!.currencyDecimals!),
                                    style: TextStyle(
                                        color: Color(0xff616161),
                                        fontSize: ScreenUtil().setSp(
                                          16,
                                        )))
                              ],
                            )
                          : Container(),

                      value.cartResponse!.discount!.amount! > 0.0
                          ? SizedBox(
                              height: ScreenUtil().setWidth(16),
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Shipping Charges",
                              style: TextStyle(
                                  color: Color(0xff616161),
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  ))),
                          Text("${store!.currencySymbol} " + double.parse(value.cartResponse!.shipping!).toStringAsFixed(store!.currencyDecimals!),
                              style: TextStyle(
                                  color: Color(0xff616161),
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  )))
                        ],
                      ),

                      value.promocodeStatus!
                          ? SizedBox(
                        height: ScreenUtil().setWidth(16),
                      ):Container(),
                      // value.cartResponse.tax > 0
                      //     ? Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: <Widget>[
                      //           Text("SAT/VAT tax",
                      //               style: TextStyle(
                      //                   color: Color(0xff616161),
                      //                   fontSize: ScreenUtil().setSp(
                      //                     16,
                      //                   ))),
                      //           Text("${store.currencySymbol} " + (value.cartResponse.tax).toString(),
                      //               style: TextStyle(
                      //                   color: Color(0xff616161),
                      //                   fontSize: ScreenUtil().setSp(
                      //                     16,
                      //                   )))
                      //         ],
                      //       )
                      //     : SizedBox.shrink(),
                      // value.cartResponse.tax > 0
                      //     ? SizedBox(
                      //         height: ScreenUtil().setWidth(16),
                      //       )
                      //     : SizedBox.shrink(),
                      value.promocodeStatus!
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Promocode",
                                    style: TextStyle(
                                        color: Color(0xff616161),
                                        fontSize: ScreenUtil().setSp(
                                          16,
                                        ))),
                                Text(
                                    value.promocodeStatus!
                                        ? "Applied"
                                        : "Not Applied",
                                    style: TextStyle(
                                        color: value.promocodeStatus!
                                            ? AppColors.primaryElement2
                                            : Colors.red,
                                        fontSize: ScreenUtil().setSp(
                                          16,
                                        ),
                                        decoration: TextDecoration.underline)),
                              ],
                            )
                          : Container(),
                      /*SizedBox(
                        height: ScreenUtil().setWidth(16),
                      ),
                      Text(
                          "Free shipping on orders of 999 or more . For first two purchase, see Offer",
                          style: TextStyle(
                              color: Color(0xffbdbdbd),
                              fontSize: ScreenUtil().setSp(
                                14,
                              ))),*/
                      SizedBox(
                        height: ScreenUtil().setWidth(18),
                      ),
                      Divider(
                        thickness: ScreenUtil().setWidth(0.4),
                        color: Color(0xffb9b9b9),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Total Price",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff000000),
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  ))),
                          Text("${store!.currencySymbol} " + (value.cartResponse!.total!).toStringAsFixed(store!.currencyDecimals!),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff000000),
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  ))),
                        ],
                      ),
                    ],
                  ),
                )),
          ));
    });
  }

  void showCoupon() {
    bool buttonStatus = true;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Apply Coupon",
                    style: TextStyle(
                        color: Color(0xff3a3a3a),
                        fontSize: ScreenUtil().setSp(17)),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: ScreenUtil().setWidth(20),
                      color: Color(0xff3a3a3a),
                    ),
                  ),
                ],
              ),
              content: Container(
                child: Consumer<CartViewModel>(
                    builder: (BuildContext context, value, Widget? child) {
                  if (value.statusPromo == "loading") {
                    Provider.of<CartViewModel>(context, listen: false)
                        .listCoupons();
                    return Container(
                        height: ScreenUtil().setWidth(340),
                        width: ScreenUtil().setWidth(386),
                        child: Loading());
                  } else if (value.statusPromo == "empty") {
                    return  Container(

                          height: ScreenUtil().setHeight(340),
                          width: ScreenUtil().setWidth(386),
                          child: CouponEmpty()
                      );
                  } else if (value.statusPromo == "error") {
                    return Container(
                      color: Colors.red,
                        height: ScreenUtil().setWidth(350),
                        width: ScreenUtil().setWidth(386),
                        child: CouponError());
                  }

                  return Container(
                    height: ScreenUtil().setWidth(350),
                    width: ScreenUtil().setWidth(386),
                    child: Column(
                      children: [
                        Divider(
                          height: ScreenUtil().setWidth(0.4),
                          thickness: ScreenUtil().setWidth(0.4),
                          color: Color(0xff707070),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(25),
                        ),
                        Container(
                          height: ScreenUtil().setWidth(250),
                          child: ListView.builder(
                              itemCount: value.couponResponse!.data!.length,
                              itemBuilder: (BuildContext build, index) {
                                return Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await Provider.of<CartViewModel>(
                                                      context,
                                                      listen: false)
                                                  .selectPromoCode(value
                                                      .couponResponse!
                                                      .data![index]
                                                      .code);
                                            },
                                            child: value.promocode ==
                                                    value.couponResponse!
                                                        .data![index].code
                                                ? Icon(
                                                    Icons.check_box,
                                                    color: AppColors.primaryElement,
                                                    size:
                                                        ScreenUtil().setWidth(18),
                                                  )
                                                : Icon(
                                                    Icons.check_box_outline_blank,
                                                    color: AppColors.primaryElement,
                                                    size:
                                                        ScreenUtil().setWidth(18),
                                                  ),
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(20),
                                          ),
                                          DottedBorder(
                                              color: AppColors.primaryElement,
                                              dashPattern: [
                                                ScreenUtil().setWidth(4),
                                                ScreenUtil().setWidth(2)
                                              ],
                                              child: Container(
                                                height: ScreenUtil().setWidth(28),
                                                width: ScreenUtil().setWidth(96),
                                                child: Center(
                                                    child: Text(
                                                  value.couponResponse!.data![index]
                                                      .code!,
                                                  style: TextStyle(
                                                      color: AppColors.primaryElement,
                                                      fontSize:
                                                          ScreenUtil().setSp(
                                                        13,
                                                      )),
                                                )),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setWidth(15),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(35)),
                                        width: double.infinity,
                                        child: Text(
                                          "Saves upto ${store!.currencySymbol} ${value.couponResponse!.data![index].maxAmount!.toStringAsFixed(store!.currencyDecimals!)}",
                                          style: TextStyle(
                                              color: Color(0xff3a3a3a),
                                              fontSize: ScreenUtil().setSp(14)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setWidth(9),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(35)),
                                        width: double.infinity,
                                        child: Text(
                                          "${value.couponResponse!.data![index].text}",
                                          style: TextStyle(
                                              color: Color(0xff3a3a3a),
                                              fontSize: ScreenUtil().setSp(14)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setWidth(38),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(14),
                        ),
                        // Text("Maximum saving : ${store.currencySymbol} 125",style: TextStyle(color:Color(0xff7a7a7a),fontSize: ScreenUtil().setSp(13)),),
                        // SizedBox(height: ScreenUtil().setWidth(9),),
                        Container(
                          height: ScreenUtil().setWidth(36),
                          width: ScreenUtil().setWidth(224),
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(
                                0,
                                ScreenUtil().setWidth(9),
                                0,
                                ScreenUtil().setWidth(9)),
                            onPressed: () async {
                              if (value.promocode != "") {
                                setState(() {
                                  buttonStatus = !buttonStatus;
                                });
                                await Provider.of<CartViewModel>(context,
                                        listen: false)
                                    .applyCoupon();
                                Navigator.pop(context);
                              }
                            },
                            color: AppColors.primaryElement2,
                            child: buttonValueWhite(
                              "Apply Coupon",
                              buttonStatus,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ));
        });
  }
}

class CartCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartCard();
  }
}

class _CartCard extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // ignore: missing_required_param
    return Consumer<CartViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: value.cartResponse!.items!.length,
            itemBuilder: (BuildContext context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProductDetail(value.cartResponse!.items![index].pid)));
                },
                child: Material(
                  color: Color(0xfff3f3f3),
                  // borderRadius: BorderRadius.circular(2),
                  child: getCard(
                      value.cartResponse!.items![index], value.cartResponse),
                ),
              );
            });
      },
    );
  }

  Widget getCard(CartData cartData, CartResponse? response) {
   return Consumer<CartViewModel>(
        builder: (BuildContext context, cartValue, Widget? child) {   return Card(
      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), 0,
          ScreenUtil().setWidth(0), ScreenUtil().setWidth(10)),
      elevation: 0,
      child: Container(
        // height: ScreenUtil().setWidth(126),
        width: ScreenUtil().setWidth(388),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(15),
            ScreenUtil().setWidth(12),
            ScreenUtil().setWidth(15),
            ScreenUtil().setWidth(8)),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(children:[ Row(
          children: <Widget>[
            new ClipRRect(
            // child:  CachedNetworkImage(
            //   fit: BoxFit.contain,
            //   width: ScreenUtil().setWidth(92),
            //             height: ScreenUtil().setWidth(102),
            //     imageUrl: cartData.img!+"?tr=h-102,w-92,fo-auto",
            //     imageBuilder: (context, imageProvider) => Container(
            //       decoration: BoxDecoration(
            //         image: DecorationImage(
            //           onError: (object,stackTrace)=>Image.asset("assets/images/logo.png",width: ScreenUtil().setWidth(92),
            //             height: ScreenUtil().setWidth(102),
            //             fit: BoxFit.contain,),
            //
            //           image: imageProvider,
            //           fit: BoxFit.contain,
            //
            //         ),
            //       ),
            //     ),
            //     placeholder: (context, url) => Image.asset("assets/images/loading.gif",width: ScreenUtil().setWidth(92),
            //       height: ScreenUtil().setWidth(102),
            //       fit: BoxFit.contain,),
            //     errorWidget: (context, url, error) =>  Image.asset("assets/images/logo.png",width: ScreenUtil().setWidth(92),
            //       height: ScreenUtil().setWidth(102),
            //       fit: BoxFit.contain,),
            //   ),
                child: FadeInImage.assetNetwork(
                  imageErrorBuilder: ((context,object,stackTrace){
                    return Image.asset("assets/images/logo.png",fit: BoxFit.contain,
                      width: ScreenUtil().setWidth(92),
                      height: ScreenUtil().setWidth(102),);
                  }),
              placeholder: 'assets/images/loading.gif',
              image: cartData.img!,
              fit: BoxFit.contain,
              width: ScreenUtil().setWidth(92),
              height: ScreenUtil().setWidth(102),
            )
            ),
            SizedBox(width: ScreenUtil().setWidth(10),),
            Container(
              child: Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(250),
                          child: Text(
                            cartData.name!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff616161),
                              fontSize: ScreenUtil().setSp(
                                17,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(2),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        cartData.brand ?? "",
                        style: TextStyle(
                          color: AppColors.primaryElement,
                          fontSize: ScreenUtil().setWidth(13),
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(11),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "${store!.currencySymbol} " + cartData.price!.toStringAsFixed(store!.currencyDecimals!),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryElement2,
                            fontSize: ScreenUtil().setSp(
                              14,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(10),
                    ),
    Consumer<ProductDetailViewModel>(
    builder: (BuildContext context, productDetailValue, Widget? child) {   return    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Text(
                            "Qty",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff616161),
                                fontSize: ScreenUtil().setSp(16)),
                          ),
                          SizedBox(width: 5,),
                          cartData.qty != 0
                              ? new InkWell(
                                  onTap: () async {
                                    if(cartData.qty==1){
                                    await  productDetailValue.changeButtonStatus("ADD TO BAG");
                                    }
                                   cartValue
                                        .cartAddItem(cartData.pid, cartData.pid,
                                            -1, false);
                                    Map<String, dynamic> data = {
                                      "id": EVENT_CART_DECREASE_ITEM_COUNT,
                                      "itemId": cartData.pid,
                                      "cartItems": cartData,
                                      "cartValue": response!.subtotal,
                                      "event": "tap",
                                    };
                                    Tracking(
                                        event: EVENT_CART_DECREASE_ITEM_COUNT,
                                        data: data);
                                  },
                                   child:
                                  // Icon(FontAwesomeIcons.minusCircle, color: Color(0xff818181),size: 22,)
                            Container(
                                    // margin: EdgeInsets.fromLTRB(
                                    //     ScreenUtil().setWidth(6),
                                    //     0,
                                    //     ScreenUtil().setWidth(6),
                                    //     0),
                                    width: ScreenUtil().radius(24),
                                    height: ScreenUtil().radius(24),
                                    decoration: new BoxDecoration(
                                      color: Color(0xffefefef),
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color(0xff707070),
                                              width:
                                                  ScreenUtil().setWidth(0.5)),
                                          top: BorderSide(
                                              color: Color(0xff707070),
                                              width:
                                                  ScreenUtil().setWidth(0.5)),
                                          left: BorderSide(
                                              color: Color(0xff707070),
                                              width:
                                                  ScreenUtil().setWidth(0.5)),
                                          right: BorderSide(
                                              color: Color(0xff707070),
                                              width:
                                                  ScreenUtil().setWidth(0.5))),
                                      borderRadius: BorderRadius.circular(5)
                                      //  shape: BoxShape.circle,
                                    ),
                                    child:Icon(Icons.remove,size: 13,),
                                    // child: Center(
                                    //     child: Text(
                                    //   "-",
                                    //   style: TextStyle(
                                    //       fontSize: ScreenUtil().setSp(15))
                                    //         ,textAlign: TextAlign.center
                                    // )),
                                  )
                          )
                              : new Container(),
                          SizedBox(width: 4,),
                          new Text(
                            cartData.qty.toString(),
                            style: TextStyle(
                                color: Color(0xff616161),
                                fontSize: ScreenUtil().setSp(17)),
                          ),
                          SizedBox(width: 4,),
                          new InkWell(
                              onTap: () async {

                                cartValue
                                    .cartAddItem(
                                        cartData.pid, cartData.pid, 1, false);
                                Map<String, dynamic> data = {
                                  "id": EVENT_CART_INCREASE_ITEM_COUNT,
                                  "itemId": cartData.pid,
                                  "cartItems": cartData,
                                  "cartValue": response!.subtotal,
                                  "event": "tap",
                                };
                                Tracking(
                                    event: EVENT_CART_INCREASE_ITEM_COUNT,
                                    data: data);
                              },
                              child:
                              //Icon(FontAwesomeIcons.plusCircle,color: Color(0xff818181),size: 22,)
                              Container(
                                // margin: EdgeInsets.fromLTRB(
                                //     ScreenUtil().setWidth(6),
                                //     0,
                                //     ScreenUtil().setWidth(6),
                                //     0),
                                width: ScreenUtil().setWidth(24),
                                height: ScreenUtil().setWidth(24),
                               // padding: EdgeInsets.only(bottom: 3),
                                decoration: new BoxDecoration(
                                  color: Color(0xffefefef),
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xff707070),
                                          width: ScreenUtil().setWidth(0.5)),
                                      top: BorderSide(
                                          color: Color(0xff707070),
                                          width: ScreenUtil().setWidth(0.5)),
                                      left: BorderSide(
                                          color: Color(0xff707070),
                                          width: ScreenUtil().setWidth(0.5)),
                                      right: BorderSide(
                                          color: Color(0xff707070),
                                          width: ScreenUtil().setWidth(0.5))),
                                    borderRadius: BorderRadius.circular(5)
                                 // shape: BoxShape.circle,
                                ),
                                //child: Center(
                                  child: Icon(Icons.add,size: 14,)
                                  // Text("+",
                                  //     style: TextStyle(
                                  //         fontSize: ScreenUtil().setSp(15)),textAlign: TextAlign.center,),
                               // ),
                              )
    )
                        ]),

                      ],
                    );})
                  ],
                ),
              ),
            )
          ],
        ),
    Divider(),
        Consumer<ProductDetailViewModel>(
    builder: (BuildContext context, productDetailValue, Widget? child) {   return   Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              InkWell(
                  onTap: () async {
                    // final NavigationService _navigationService = locator<NavigationService>();
                    // TzDialog _dialog =
                    // TzDialog(_navigationService.navigationKey.currentContext, TzDialogType.progress);
                    // _dialog.show();
                   await productDetailValue.changeButtonStatus("ADD TO BAG");
                  await  cartValue
                        .cartAddItem(cartData.pid, cartData.pid,
                        -cartData.qty!, false);
                //  _dialog.close();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Color(0xffd3d3d3))
                      )
                    ),
                    width: ScreenUtil().setWidth(150),
                    height: ScreenUtil().setWidth(30),
                    child: Center(
                      child: Text("REMOVE",style: TextStyle(color: AppColors.primaryElement),),
                    ),
                  )),

              InkWell(
                  onTap: () async {
    if (Provider.of<ProfileModel>(context,
    listen: false)
        .user !=
    null) {
      final NavigationService _navigationService = locator<NavigationService>();
      TzDialog _dialog =
      TzDialog(_navigationService.navigationKey.currentContext,
          TzDialogType.progress);
      _dialog.show();
      await Provider.of<WishlistViewModel>(context, listen: false)
          .toggleItem(cartData.pid);
     await cartValue
          .cartAddItem(cartData.pid, cartData.pid,
          -cartData.qty!, false);
      _dialog.close();
    }
    else {
      if (settingData!.otpLogin!) { locator<NavigationService>().pushNamed(routes.LoginRoute);}
      else{
        locator<NavigationService>().pushNamed(routes.EmailLoginRoute);
      }
    }
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(215),
                    height: ScreenUtil().setWidth(30),
                    child: Center(
                      child: Text("MOVE TO WISHLIST",style: TextStyle(color: AppColors.primaryElement),),
                    ),
                  ))
            ],
          );})
    ]),
      ),
    );});
  }
}
