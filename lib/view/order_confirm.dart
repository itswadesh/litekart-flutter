import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../../response_handler/checkOutResponse.dart';
import '../../service/event/tracking.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/graphQl.dart';
import '../../utility/locator.dart';
import '../../values/colors.dart';
import '../../values/event_constant.dart';
import '../../view_model/address_view_model.dart';
import 'package:intl/intl.dart';
import '../../values/route_path.dart' as routes;

class OrderConfirm extends StatefulWidget {
  final CheckOutResponse details;

  OrderConfirm(this.details);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderConfirm();
  }
}

class _OrderConfirm extends State<OrderConfirm> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  CheckOutResponse checkOutData = CheckOutResponse();

  @override
  void initState() {
    checkOutData = widget.details;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            // await Provider.of<CartViewModel>(context,
            //     listen: false)
            //     .changeStatus("loading");
            // await Provider.of<OrderViewModel>(context,
            //     listen: false).refreshOrderPage();
            locator<NavigationService>()
                .pushNamedAndRemoveUntil(routes.HomeRoute);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
        title: Center(
            // width: MediaQuery.of(context).size.width * 0.39,
            child: Text(
          "Order Confirm",
          style: TextStyle(
              color: Color(0xff616161), fontSize: ScreenUtil().setSp(21)),
          textAlign: TextAlign.center,
        )),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10.0),
            // width: MediaQuery.of(context).size.width * 0.35,
          )
        ],
      ),
      body: GraphQLProvider(
          client: graphQLConfiguration.initailizeClient(),
          child: CacheProvider(
              child: Container(
            color: Color(0xfff3f3f3),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: ScreenUtil().setWidth(93),
                  ),
                  Stack(
                    children: [
                      getProductCard(),
                      Transform.translate(
                        offset: Offset(0, -ScreenUtil().setWidth(53)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setWidth(12)),
                              width: ScreenUtil().setWidth(106),
                              height: ScreenUtil().setWidth(106),
                              decoration: BoxDecoration(
                                  color: Color(0xffb8ffc9),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(50))),
                              child: Container(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setWidth(12)),
                                width: ScreenUtil().setWidth(82),
                                height: ScreenUtil().setWidth(82),
                                decoration: BoxDecoration(
                                    color: Color(0xff85ffa1),
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(45))),
                                child: Container(
                                  width: ScreenUtil().setWidth(55),
                                  height: ScreenUtil().setWidth(55),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryElement2,
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(40))),
                                  child: Icon(
                                    Icons.check,
                                    size: ScreenUtil().setWidth(40),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  getPaymentInfoCard(),
                  getDeliveryCard(),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    color: AppColors.primaryElement,
                    child: Text(
                      "© 2020 Anne Private Limited",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ))),
    );
  }

  getProductCard() {
    return GestureDetector(
      onTap: () {},
      child: Material(
          color: Color(0xfff3f3f3),
          // borderRadius: BorderRadius.circular(2),
          child: Card(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20)),
            elevation: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0,
                  ScreenUtil().setWidth(20), ScreenUtil().setWidth(17)),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: InkWell(
                onTap: () {
                  Map<String, dynamic> data = {
                    "id": EVENT_ORDER_PLACEMENT_SUCCESS,
                    "paymentType": " seleted payment type",
                    "cartValue": checkOutData.amount,
                    "paymentData": {},
                    "event": "payment-success"
                  };
                  Tracking(event: EVENT_ORDER_PLACEMENT_SUCCESS, data: data);
                },
                child: Column(children: [
                  SizedBox(
                    height: ScreenUtil().setWidth(80),
                  ),
                  Text(
                    "Thanks for your Order !!",
                    style: TextStyle(
                        color: Color(0xff404040),
                        fontSize: ScreenUtil().setSp(
                          21,
                        )),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(24),
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Order number : ",
                        style: TextStyle(
                            color: Color(0xff8b8b8b),
                            fontSize: ScreenUtil().setSp(
                              17,
                            )),
                        children: [
                          TextSpan(
                              text: "#${checkOutData.orderNo}",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: ScreenUtil().setSp(
                                    17,
                                  ),
                                  decoration: TextDecoration.underline))
                        ]),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(24),
                  ),
                  Container(
                      width: double.maxFinite,
                      child: Text(
                        "Your order was placed on ${DateFormat('dd-MM-yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(checkOutData.createdAt) * 1000))}. A Confirmation e-mail will be sent to the email Address(es) that you specified in the order details.",
                        style: TextStyle(
                            color: Color(0xff8b8b8b),
                            fontSize: ScreenUtil().setSp(
                              14,
                            )),
                      )),
                  SizedBox(
                    height: ScreenUtil().setWidth(30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: ScreenUtil().setWidth(44),
                        width: ScreenUtil().setWidth(161),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide(
                                width: 1, color: AppColors.primaryElement),
                          ),
                          onPressed: () async {
                            locator<NavigationService>()
                                .pushReplacementNamed(routes.ManageOrder);
                          },
                          child: Text(
                            "View Order",
                            style: TextStyle(
                                color: AppColors.primaryElement,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                      ),
                      Container(
                        height: ScreenUtil().setWidth(44),
                        width: ScreenUtil().setWidth(150),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide(
                                width: 1, color: AppColors.primaryElement),
                          ),
                          onPressed: () async {
                            locator<NavigationService>()
                                .pushReplacementNamed(routes.HomeRoute);
                          },
                          child: Text(
                            "Shop More",
                            style: TextStyle(
                                color: AppColors.primaryElement,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(31),
                  ),
                  Divider(
                    thickness: ScreenUtil().setWidth(0.4),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(24),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: Text(
                      "Item details",
                      style: TextStyle(
                          color: Color(0xff404040),
                          fontSize: ScreenUtil().setSp(
                            16,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(20),
                  ),
                  getDetails(checkOutData.items),
                  // SizedBox(
                  //   height: ScreenUtil().setWidth(35),
                  // ),
                  // Divider(
                  //   thickness: ScreenUtil().setWidth(0.4),
                  // ),
                  // SizedBox(
                  //   height: ScreenUtil().setWidth(21),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       "Invoice",
                  //       style: TextStyle(
                  //         fontSize: ScreenUtil().setSp(
                  //           12,
                  //         ),
                  //         color: Colors.blue,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: ScreenUtil().setWidth(3),
                  //     ),
                  //     Icon(
                  //       Icons.assignment,
                  //       color: Colors.blue,
                  //       size: ScreenUtil().setWidth(14),
                  //     ),
                  //     SizedBox(
                  //       width: ScreenUtil().setWidth(29),
                  //     ),
                  //     Text(
                  //       "Print",
                  //       style: TextStyle(
                  //         fontSize: ScreenUtil().setSp(
                  //           12,
                  //         ),
                  //         color: Colors.blue,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: ScreenUtil().setWidth(3),
                  //     ),
                  //     Icon(
                  //       Icons.print,
                  //       color: Colors.blue,
                  //       size: ScreenUtil().setWidth(14),
                  //     )
                  //   ],
                  // ),
                ]),
              ),
            ),
          )),
    );
  }

  getPaymentInfoCard() {
    return Consumer<AddressViewModel>(
        builder: (BuildContext context, value, Widget child) {
      return GestureDetector(
        onTap: () {},
        child: Material(
            color: Color(0xfff3f3f3),
            // borderRadius: BorderRadius.circular(2),
            child: Card(
              margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
              elevation: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(32),
                    ScreenUtil().setWidth(39),
                    ScreenUtil().setWidth(49),
                    ScreenUtil().setWidth(35)),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Billing Information",
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            17,
                          ),
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // SizedBox(
                  //   height: ScreenUtil().setWidth(28),
                  // ),
                  // Container(
                  //     width: double.infinity,
                  //     child: Text("Payment Method",
                  //         style: TextStyle(
                  //             fontSize: ScreenUtil()
                  //                 .setSp(15, ),
                  //             color: Color(0xffee7625),
                  //             decoration: TextDecoration.underline),
                  //         textAlign: TextAlign.left)),
                  // ListTile(
                  //   leading: Image.asset(
                  //     "assets/images/visa.png",
                  //     height: 60,
                  //   ),
                  //   title: Text(
                  //     "XXXX XXXX XXXX XX36",
                  //     style: ThemeApp().textThemeSemiGrey(),
                  //   ),
                  //   subtitle: Text(
                  //     "Exp: 12/2035",
                  //     style: ThemeApp().textThemeSemiGrey(),
                  //   ),
                  // ),
                  SizedBox(height: ScreenUtil().setWidth(30)),
                  Container(
                    width: double.infinity,
                    child: Text("Billing Address",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              15,
                            ),
                            color: AppColors.primaryElement,
                            decoration: TextDecoration.underline),
                        textAlign: TextAlign.left),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(19),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "${value.selectedAddress.firstName + " " + value.selectedAddress.lastName ?? "User"}",
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            15,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(6),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Address : " + value.selectedAddress.address.toString(),
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            15,
                          )),
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(6),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Pin : " + value.selectedAddress.zip.toString(),
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            15,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(6),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      value.selectedAddress.phone.toString(),
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            15,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(6),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      value.selectedAddress.email.toString(),
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            15,
                          )),
                    ),
                  ),
                ]),
              ),
            )),
      );
    });
  }

  getDeliveryCard() {
    return Consumer<AddressViewModel>(
        builder: (BuildContext context, value, Widget child) {
      return GestureDetector(
        onTap: () {},
        child: Material(
            color: Color(0xfff3f3f3),
            // borderRadius: BorderRadius.circular(2),
            child: Card(
              margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
              elevation: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(32),
                    ScreenUtil().setWidth(39),
                    ScreenUtil().setWidth(49),
                    ScreenUtil().setWidth(35)),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Shipping Information",
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            17,
                          ),
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(28),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text("Type: Basic Delivery",
                        style: TextStyle(
                            color: AppColors.primaryElement,
                            fontSize: ScreenUtil().setSp(
                              15,
                            )),
                        textAlign: TextAlign.left),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(21),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "${value.selectedAddress.firstName + " " + value.selectedAddress.lastName ?? "User"}",
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            15,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(6),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Address : " + value.selectedAddress.address.toString(),
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            15,
                          )),
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(6),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Pin : " + value.selectedAddress.zip.toString(),
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            15,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(6),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      value.selectedAddress.phone.toString(),
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            15,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(6),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      value.selectedAddress.email.toString(),
                      style: TextStyle(
                          color: Color(0xff5f5f5f),
                          fontSize: ScreenUtil().setSp(
                            15,
                          )),
                    ),
                  ),
                ]),
              ),
            )),
      );
    });
  }

  getDetails(List<CheckOutData> detail) {
    return Container(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: detail.length,
          itemBuilder: (BuildContext context, index) {
            return Column(children: [
              Row(
                children: <Widget>[
                  new ClipRRect(
                      child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: detail[index].img,
                    fit: BoxFit.contain,
                    width: ScreenUtil().setWidth(92),
                    height: ScreenUtil().setWidth(102),
                  )),
                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  ),
                  Container(
                    child: Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  width: ScreenUtil().setWidth(210),
                                  child: Text(
                                    "${detail[index].name}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff616161),
                                      fontSize: ScreenUtil().setSp(
                                        17,
                                      ),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(2),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                detail[index].brand,
                                style: TextStyle(
                                  color: AppColors.primaryElement,
                                  fontSize: ScreenUtil().setWidth(13),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(11),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Qty : ${detail[index].qty}",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(
                                  14,
                                )),
                              ),
                              Text(
                                "₹ ${detail[index].price}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryElement2,
                                    fontSize: ScreenUtil().setSp(
                                      14,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                child: Divider(
                  height: ScreenUtil().setWidth(15),
                  thickness: ScreenUtil().setWidth(0.4),
                  color: Color(0xfff5f5f5),
                ),
              )
            ]);
          }),
    );
  }
}
