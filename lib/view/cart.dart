import 'package:dotted_border/dotted_border.dart';
import 'package:anne/components/widgets/buttonValue.dart';
import 'package:anne/values/route_path.dart' as routes;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/view/product_detail.dart';
import 'package:anne/components/widgets/errorMessage.dart';
import 'package:anne/components/widgets/loading.dart';
import 'package:anne/view_model/auth_view_model.dart';
import 'package:anne/view_model/cart_view_model.dart';
import 'package:anne/utility/graphQl.dart';
import 'package:anne/view/checkout.dart';
import 'package:anne/components/widgets/cartEmptyMessage.dart';

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
    final NavigationService _navigationService = locator<NavigationService>();
    return Consumer<CartViewModel>(
        builder: (BuildContext context, value, Widget child) {
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
                        ScreenUtil().setWidth(27),
                        ScreenUtil().setWidth(21),
                        20,
                        ScreenUtil().setWidth(18)),
                    child: Text(
                      "${value.cartResponse.items.length} Items",
                      style: TextStyle(
                          color: Color(0xff616161),
                          fontSize: ScreenUtil().setSp(
                            16,
                          )),
                    ),
                  ),
                  Container(child: CartCard()),
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
              height: ScreenUtil().setHeight(60),
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(26),
                  ScreenUtil().setWidth(10),
                  ScreenUtil().setWidth(25),
                  ScreenUtil().setWidth(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      "Order Total: ₹ ${value.cartResponse.subtotal - value.cartResponse.discount.amount + value.cartResponse.tax + value.cartResponse.shipping}",
                      style: TextStyle(
                          color: Color(0xff383838),
                          fontSize: ScreenUtil().setSp(
                            18,
                          ))),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child:
                        Consumer<ProfileModel>(builder: (context, user, child) {
                      return Container(
                        width: ScreenUtil().setWidth(150),
                        height: ScreenUtil().setWidth(42),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xffbb8738)),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                  TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(
                                        14,
                                      ))),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)))),
                          onPressed: () {
                            if (user.user != null) {
                              _navigationService.pushNamed(routes.CheckOut);
                            } else {
                              _navigationService.pushNamed(routes.LoginRoute);
                            }
                          },
                          child: Center(
                            child: Text(
                              "CHECK OUT",
                              style: TextStyle(
                                fontFamily: 'Sofia',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(
                                  14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          )
        ],
      );
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
        builder: (BuildContext context, value, Widget child) {
      print(value.cartResponse.items.length);
      if (value.cartResponse == null || value.cartResponse.items.length == 0) {
        return Container();
      }
      return Material(
          color: Color(0xfff3f3f3),
          // borderRadius: BorderRadius.circular(2),
          child: Card(
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(11),
                ScreenUtil().setWidth(5),
                ScreenUtil().setWidth(15),
                ScreenUtil().setWidth(65)),
            elevation: 0,
            child: Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(25),
                    ScreenUtil().setWidth(21),
                    ScreenUtil().setWidth(20),
                    ScreenUtil().setWidth(26)),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: ScreenUtil().setWidth(35),
                              width: ScreenUtil().setWidth(231),
                              child: TextFormField(
                                onTap: () async {
                                  await Provider.of<CartViewModel>(context,
                                          listen: false)
                                      .changePromoStatus("loading");
                                  showCoupon();
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                    fillColor: Color(0xfff3f3f3),
                                    filled: true,
                                    contentPadding: EdgeInsets.all(
                                        ScreenUtil().setWidth(10)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffb4b4b4),
                                          width: ScreenUtil().setWidth(0.4)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffb4b4b4),
                                          width: ScreenUtil().setWidth(0.4)),
                                    ),
                                    hintText: value.promocodeStatus
                                        ? value.promocode
                                        : "Promocode",
                                    hintStyle: TextStyle(
                                        color: Color(0xffb9b9b9),
                                        fontSize: ScreenUtil().setSp(
                                          15,
                                        ))),
                              )),
                          Container(
                            width: ScreenUtil().setWidth(91),
                            height: ScreenUtil().setWidth(35),
                            child: RaisedButton(
                              color: Color(0xff00d832),
                              onPressed: () {},
                              child: Text(
                                value.promocodeStatus ? "Applied" : "Apply",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(
                                      15,
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(28),
                      ),
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
                          Text("₹ " + value.cartResponse.subtotal.toString(),
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
                          Text(value.cartResponse.qty.toString(),
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
                          Text("Your savings",
                              style: TextStyle(
                                  color: Color(0xff616161),
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  ))),
                          Text(
                              "₹ " +
                                  value.cartResponse.discount.amount.toString(),
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
                          Text("SAT/VAT tax",
                              style: TextStyle(
                                  color: Color(0xff616161),
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  ))),
                          Text("₹ " + (value.cartResponse.tax).toString(),
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
                          Text("Promocode",
                              style: TextStyle(
                                  color: Color(0xff616161),
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  ))),
                          Text(
                              value.promocodeStatus ? "Applied" : "Not Applied",
                              style: TextStyle(
                                  color: value.promocodeStatus
                                      ? Color(0xff00d832)
                                      : Colors.red,
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  ),
                                  decoration: TextDecoration.underline)),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(16),
                      ),
                      Text(
                          "Free shipping on orders of 999 or more . For first two purchase, see Offer",
                          style: TextStyle(
                              color: Color(0xffbdbdbd),
                              fontSize: ScreenUtil().setSp(
                                14,
                              ))),
                      SizedBox(
                        height: ScreenUtil().setWidth(18.5),
                      ),
                      Divider(
                        thickness: ScreenUtil().setWidth(0.4),
                        color: Color(0xffb9b9b9),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(21.5),
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
                          Text(
                              "₹ " +
                                  (value.cartResponse.subtotal -
                                          value.cartResponse.discount.amount +
                                          value.cartResponse.tax)
                                      .toString(),
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
              content: Consumer<CartViewModel>(
                  builder: (BuildContext context, value, Widget child) {
                if (value.statusPromo == "loading") {
                  Provider.of<CartViewModel>(context, listen: false)
                      .listCoupons();
                  return Container(
                      height: ScreenUtil().setWidth(340),
                      width: ScreenUtil().setWidth(386),
                      child: Loading());
                } else if (value.statusPromo == "empty") {
                  return Container(
                      height: ScreenUtil().setWidth(350),
                      width: ScreenUtil().setWidth(386),
                      child:
                          cartEmptyMessage("search", "No Promocode available"));
                } else if (value.statusPromo == "error") {
                  return Container(
                      height: ScreenUtil().setWidth(350),
                      width: ScreenUtil().setWidth(386),
                      child: errorMessage());
                }
                print(value.couponResponse.data[0].code);
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
                            itemCount: value.couponResponse.data.length,
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
                                                    .couponResponse
                                                    .data[index]
                                                    .code);
                                          },
                                          child: ((value.promocode ==
                                                  value.couponResponse
                                                      .data[index].code))
                                              ? Icon(
                                                  Icons.check_box,
                                                  color: Color(0xffee7625),
                                                  size:
                                                      ScreenUtil().setWidth(18),
                                                )
                                              : Icon(
                                                  Icons.check_box_outline_blank,
                                                  color: Color(0xffee7625),
                                                  size:
                                                      ScreenUtil().setWidth(18),
                                                ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(20),
                                        ),
                                        DottedBorder(
                                            color: Color(0xffbb8738),
                                            dashPattern: [
                                              ScreenUtil().setWidth(4),
                                              ScreenUtil().setWidth(2)
                                            ],
                                            child: Container(
                                              height: ScreenUtil().setWidth(28),
                                              width: ScreenUtil().setWidth(96),
                                              child: Center(
                                                  child: Text(
                                                value.couponResponse.data[index]
                                                    .code,
                                                style: TextStyle(
                                                    color: Color(0xffbb8738),
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
                                        "Saves upto ₹ ${value.couponResponse.data[index].maxAmount}",
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
                                        "${value.couponResponse.data[index].text}",
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
                      // Text("Maximum saving : ₹ 125",style: TextStyle(color:Color(0xff7a7a7a),fontSize: ScreenUtil().setSp(13)),),
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
                          color: Color(0xff00c32d),
                          child: buttonValueWhite(
                            "Apply Coupon",
                            buttonStatus,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }));
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
      builder: (BuildContext context, value, Widget child) {
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: value.cartResponse.items.length,
            itemBuilder: (BuildContext context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProductDetail(value.cartResponse.items[index].pid)));
                },
                child: Material(
                    color: Color(0xfff3f3f3),
                    // borderRadius: BorderRadius.circular(2),
                    child: Card(
                      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(11), 0,
                          ScreenUtil().setWidth(15), ScreenUtil().setWidth(10)),
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
                        child: Row(
                          children: <Widget>[
                            new ClipRRect(
                                child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/loading.gif',
                              image: value.cartResponse.items[index].img,
                              fit: BoxFit.contain,
                              width: ScreenUtil().setWidth(92),
                              height: ScreenUtil().setWidth(102),
                            )),
                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setWidth(20)),
                            ),
                            Container(
                              child: Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: ScreenUtil().setWidth(188),
                                          child: Text(
                                            value
                                                .cartResponse.items[index].name,
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
                                        Container(
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            width: ScreenUtil().setWidth(27),
                                            height: ScreenUtil().setWidth(27),
                                            decoration: new BoxDecoration(
                                                color: Color(0xffFFE8E8),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil()
                                                            .radius(4))),
                                            child: CheckWishListClass(
                                                value.cartResponse.items[index]
                                                    .pid,
                                                value.cartResponse.items[index]
                                                    .pid))
                                      ],
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(2),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        value.cartResponse.items[index].brand ??
                                            "",
                                        style: TextStyle(
                                          color: Color(0xffba8638),
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
                                        "₹ " +
                                            value
                                                .cartResponse.items[index].price
                                                .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff00ba0e),
                                            fontSize: ScreenUtil().setSp(
                                              14,
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(10),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Text(
                                            "Qty",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff616161),
                                                fontSize:
                                                    ScreenUtil().setSp(16)),
                                          ),
                                          value.cartResponse.items[index].qty !=
                                                  0
                                              ? new InkWell(
                                                  onTap: () async {
                                                    Provider.of<CartViewModel>(
                                                            context,
                                                            listen: false)
                                                        .cartAddItem(
                                                            value
                                                                .cartResponse
                                                                .items[index]
                                                                .pid,
                                                            value
                                                                .cartResponse
                                                                .items[index]
                                                                .pid,
                                                            -1,
                                                            false);
                                                  },
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              ScreenUtil()
                                                                  .setWidth(6),
                                                              0,
                                                              ScreenUtil()
                                                                  .setWidth(6),
                                                              0),
                                                      width: ScreenUtil()
                                                          .radius(25),
                                                      height: ScreenUtil()
                                                          .radius(25),
                                                      decoration:
                                                          new BoxDecoration(
                                                        color:
                                                            Color(0xffefefef),
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Color(
                                                                    0xff707070),
                                                                width: ScreenUtil()
                                                                    .setWidth(
                                                                        0.5)),
                                                            top: BorderSide(
                                                                color: Color(
                                                                    0xff707070),
                                                                width: ScreenUtil()
                                                                    .setWidth(
                                                                        0.5)),
                                                            left: BorderSide(
                                                                color: Color(
                                                                    0xff707070),
                                                                width: ScreenUtil()
                                                                    .setWidth(
                                                                        0.5)),
                                                            right: BorderSide(
                                                                color:
                                                                    Color(0xff707070),
                                                                width: ScreenUtil().setWidth(0.5))),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                        "-",
                                                        style: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(16)),
                                                      ))))
                                              : new Container(),
                                          new Text(
                                            value.cartResponse.items[index].qty
                                                .toString(),
                                            style: TextStyle(
                                                color: Color(0xff616161),
                                                fontSize:
                                                    ScreenUtil().setSp(17)),
                                          ),
                                          new InkWell(
                                              onTap: () async {
                                                Provider.of<CartViewModel>(
                                                        context,
                                                        listen: false)
                                                    .cartAddItem(
                                                        value.cartResponse
                                                            .items[index].pid,
                                                        value.cartResponse
                                                            .items[index].pid,
                                                        1,
                                                        false);
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      ScreenUtil().setWidth(6),
                                                      0,
                                                      ScreenUtil().setWidth(6),
                                                      0),
                                                  width:
                                                      ScreenUtil().radius(25),
                                                  height:
                                                      ScreenUtil().radius(25),
                                                  decoration: new BoxDecoration(
                                                    color: Color(0xffefefef),
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xff707070),
                                                            width: ScreenUtil()
                                                                .setWidth(0.5)),
                                                        top: BorderSide(
                                                            color: Color(
                                                                0xff707070),
                                                            width: ScreenUtil()
                                                                .setWidth(0.5)),
                                                        left: BorderSide(
                                                            color: Color(
                                                                0xff707070),
                                                            width: ScreenUtil()
                                                                .setWidth(0.5)),
                                                        right: BorderSide(
                                                            color: Color(
                                                                0xff707070),
                                                            width: ScreenUtil()
                                                                .setWidth(
                                                                    0.5))),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text("+",
                                                        style: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                                        16))),
                                                  )))
                                        ]),
                                        InkWell(
                                            onTap: () {
                                              // Provider.of<CartViewModel>(
                                              //         context,
                                              //         listen: false)
                                              //     .cartDeleteItem(value
                                              //         .cartResponse
                                              //         .items[index]
                                              //         .pid);
                                            },
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                width:
                                                    ScreenUtil().setWidth(27),
                                                height:
                                                    ScreenUtil().setWidth(27),
                                                decoration: new BoxDecoration(
                                                    color: Color(0xfff5f5f5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            ScreenUtil()
                                                                .radius(4))),
                                                child: InkWell(
                                                    onTap: () async {
                                                      Provider.of<CartViewModel>(
                                                              context,
                                                              listen: false)
                                                          .cartAddItem(
                                                              value
                                                                  .cartResponse
                                                                  .items[index]
                                                                  .pid,
                                                              value
                                                                  .cartResponse
                                                                  .items[index]
                                                                  .pid,
                                                              -value
                                                                  .cartResponse
                                                                  .items[index]
                                                                  .qty,
                                                              false);
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Color(0xff656565),
                                                      size: ScreenUtil()
                                                          .setWidth(18),
                                                    ))))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              );
            });
      },
    );
  }
}
