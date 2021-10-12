import 'dart:convert';
import 'dart:developer';
//import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:anne/repository/brainTreeRepository.dart';
import 'package:anne/repository/paypal_repository.dart';
import 'package:anne/repository/stripe_repository.dart';
import 'package:anne/values/functions.dart';
import 'package:anne/view_model/settings_view_model.dart';
import 'package:anne/view_model/store_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../repository/address_repository.dart';
//import '../../repository/cashfree_repository.dart';
import '../../repository/checkout_repository.dart';
//import '../../response_handler/cashFreeResponse.dart';
import '../../service/event/tracking.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/locator.dart';
import '../../values/colors.dart';
import '../../values/event_constant.dart';
import '../../values/route_path.dart' as routes;
//import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../service/stripePayment.dart';
import 'package:provider/provider.dart';
import '../../components/base/tz_dialog.dart';
import '../../enum/tz_dialog_type.dart';
import '../../response_handler/checkOutResponse.dart';
import '../../utility/query_mutation.dart';
import '../../components/widgets/errorMessage.dart';
import '../../components/widgets/loading.dart';
import '../../view_model/address_view_model.dart';
import '../../utility/graphQl.dart';
import '../../components/widgets/buttonValue.dart';
import '../../view_model/auth_view_model.dart';
import '../../view_model/cart_view_model.dart';
import '../../view_model/manage_order_view_model.dart';

import '../main.dart';
import 'menu/manage_order.dart';

class Checkout extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Checkout();
  }
}

class _Checkout extends State<Checkout> {
  QueryMutation addMutation = QueryMutation();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  CheckoutRepository checkoutRepository = CheckoutRepository();

  //CashfreeRepository cashfreeRepository = CashfreeRepository();
  PaypalRepository paypalRepository = PaypalRepository();
  var _formKey = GlobalKey<FormState>();
  var newAddress = true;
  String paymentMethod = "credit";
  var addressPage = true;
  var defaultAddress = true;
  var primaryAddressBox = -1;
  var buttonStatusAddress = true;
  var buttonStatusOrder = true;
  String addressId = "new";
  TextEditingController cvv = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _pin = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _town = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _country = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController cardHolder = TextEditingController();
  TextEditingController paymentCode = TextEditingController();
  List<ListItem> _dropdownMonth = [
    ListItem(1, "01"),
    ListItem(2, "02"),
    ListItem(3, "03"),
    ListItem(4, "04"),
    ListItem(5, "05"),
    ListItem(6, "06"),
    ListItem(7, "07"),
    ListItem(8, "08"),
    ListItem(9, "09"),
    ListItem(10, "10"),
    ListItem(11, "11"),
    ListItem(12, "12"),
  ];

  List<DropdownMenuItem<ListItem>> _dropdownMonthItems;
  ListItem _selectedMonth;

  List<ListItem> _dropdownYear = [
    ListItem(1, "21"),
    ListItem(2, "22"),
    ListItem(3, "23"),
    ListItem(4, "24"),
    ListItem(5, "25"),
    ListItem(6, "26"),
    ListItem(7, "27"),
    ListItem(8, "28"),
    ListItem(9, "29"),
    ListItem(10, "30"),
  ];

  List<DropdownMenuItem<ListItem>> _dropdownYearItems;
  ListItem _selectedYear;
  final cardNumber = MaskedTextController(mask: '0000-0000-0000-0000');
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    _dropdownMonthItems = buildDropDownMenuItems(_dropdownMonth);
    _selectedMonth = _dropdownMonthItems[0].value;
    _dropdownYearItems = buildDropDownMenuItems(_dropdownYear);
    _selectedYear = _dropdownYearItems[0].value;
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: settingData.stripePublishableKey,
        ));

  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem.name,
            style: TextStyle(fontSize: 12),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            ),
          ),
          title: Text(
            "Billing Details",
            style: TextStyle(
                color: Color(0xff616161),
                fontSize: ScreenUtil().setSp(
                  21,
                )),
            textAlign: TextAlign.center,
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 10.0),
              // width: MediaQuery.of(context).size.width * 0.35,
            )
          ]),
      body: GraphQLProvider(
          client: graphQLConfiguration.initailizeClient(),
          child: CacheProvider(
              child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  color: Color(0xfff3f3f3),
                  child: getCartList()))),
    );
  }

  getBillCard() {
    return Consumer<CartViewModel>(
        builder: (BuildContext context, value, Widget child) {
          return Material(
              color: Color(0xfff3f3f3),
              // borderRadius: BorderRadius.circular(2),
              child: Card(
                margin: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(0),
                    ScreenUtil().setWidth(5),
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Container(
                        //         height: ScreenUtil().setWidth(35),
                        //         width: ScreenUtil().setWidth(231),
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
                        //               contentPadding:
                        //                   EdgeInsets.all(ScreenUtil().setWidth(10)),
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
                        //               labelText: value.promocodeStatus
                        //                   ? value.promocode
                        //                   : "Promocode",
                        //               labelStyle: TextStyle(
                        //                   color: Color(0xffb9b9b9),
                        //                   fontSize: ScreenUtil().setSp(
                        //                     15,
                        //                   ))),
                        //         )),
                        //     Container(
                        //       width: ScreenUtil().setWidth(91),
                        //       height: ScreenUtil().setWidth(35),
                        //       child: OutlinedButton(
                        //         style: OutlinedButton.styleFrom(
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(5),
                        //           ),
                        //           side: BorderSide(
                        //               width: 1, color: AppColors.primaryElement),
                        //         ),
                        //         onPressed: () {},
                        //         child: Text(
                        //           value.promocodeStatus ? "Applied" : "Apply",
                        //           style: TextStyle(
                        //               fontFamily: 'Montserrat',
                        //               color: AppColors.primaryElement),
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // ),
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
                            Text("${store.currencySymbol} " + value.cartResponse
                                .subtotal.toString(),
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
                        value.cartResponse.discount.amount > 0
                            ? Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Your savings",
                                    style: TextStyle(
                                        color: Color(0xff616161),
                                        fontSize: ScreenUtil().setSp(
                                          16,
                                        ))),
                                Text(
                                    "${store.currencySymbol} " +
                                        value.cartResponse.discount.amount
                                            .toString(),
                                    style: TextStyle(
                                        color: Color(0xff616161),
                                        fontSize: ScreenUtil().setSp(
                                          16,
                                        )))
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setWidth(16),
                            )
                          ],
                        )
                            : SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Shipping Charges",
                                style: TextStyle(
                                    color: Color(0xff616161),
                                    fontSize: ScreenUtil().setSp(
                                      16,
                                    ))),
                            Text("${store.currencySymbol} " + value.cartResponse
                                .shipping.toString(),
                                style: TextStyle(
                                    color: Color(0xff616161),
                                    fontSize: ScreenUtil().setSp(
                                      16,
                                    )))
                          ],
                        ),
                        value.promocodeStatus
                            ? SizedBox(
                          height: ScreenUtil().setWidth(16),
                        ) : Container(),
                        // value.cartResponse.tax > 0
                        //     ? Column(
                        //         children: [
                        //           Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: <Widget>[
                        //               Text("SAT/VAT tax",
                        //                   style: TextStyle(
                        //                       color: Color(0xff616161),
                        //                       fontSize: ScreenUtil().setSp(
                        //                         16,
                        //                       ))),
                        //               Text(
                        //                   "${store.currencySymbol} " +
                        //                       (value.cartResponse.tax).toString(),
                        //                   style: TextStyle(
                        //                       color: Color(0xff616161),
                        //                       fontSize: ScreenUtil().setSp(
                        //                         16,
                        //                       )))
                        //             ],
                        //           ),
                        //           SizedBox(
                        //             height: ScreenUtil().setWidth(16),
                        //           )
                        //         ],
                        //       )
                        //     : SizedBox.shrink(),
                        value.promocodeStatus
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
                                value.promocodeStatus
                                    ? "Applied"
                                    : "Not Applied",
                                style: TextStyle(
                                    color: value.promocodeStatus
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
                          height: ScreenUtil().setWidth(21.5),
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
                            Text("${store.currencySymbol} " + (value
                                .cartResponse.total).toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff000000),
                                    fontSize: ScreenUtil().setSp(
                                      16,
                                    ))),
                          ],
                        ),
                        addressPage ? Container() : getDeliveryCard(),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  getDeliveryCard() {
    return Consumer<AddressViewModel>(
        builder: (BuildContext context, value, Widget child) {
          return Container(
            // padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(children: [
              SizedBox(
                height: ScreenUtil().setWidth(21),
              ),
              Container(
                  height: ScreenUtil().setWidth(46),
                  width: double.infinity,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: BorderSide(width: 2,
                            color: buttonStatusOrder
                                ? AppColors.primaryElement
                                : Colors.grey),
                      ),
                      onPressed: () async {
                        paymentHandle(value.selectedAddress.id);
                      },
                      child: Text(
                        'Place Order',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: buttonStatusOrder
                                ? AppColors.primaryElement
                                : Colors.grey),
                      ))),
              SizedBox(
                height: ScreenUtil().setWidth(19),
              ),
              Divider(
                thickness: ScreenUtil().setWidth(0.4),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(21),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "Delivery:",
                  style: TextStyle(
                      color: Color(0xff5f5f5f),
                      fontSize: ScreenUtil().setWidth(20)),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(21),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "${value.selectedAddress.firstName + " " +
                      value.selectedAddress.lastName ?? "User"}",
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
          );
        });
  }

  getDeliveryOptionCard() {
    return Consumer<AddressViewModel>(
        builder: (BuildContext context, value, Widget child) {
          if (value.status == "loading") {
            Provider.of<AddressViewModel>(context, listen: false)
                .fetchAddressData();
            if (Provider
                .of<StoreViewModel>(context)
                .status == "loading" || Provider
                .of<StoreViewModel>(context)
                .status == "error") {
              Provider.of<StoreViewModel>(context,
                  listen: false)
                  .fetchStore();
            }
            return Loading();
          } else if (value.status == "empty") {
            return Container(height: ScreenUtil().setWidth(20));
          } else if (value.status == "error") {
            return Container(
              height: ScreenUtil().setWidth(20),
            );
          }
          return Column(children: [
            Container(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0, 0, 0),
              margin: EdgeInsets.fromLTRB(
                  0, ScreenUtil().setWidth(20), 0, ScreenUtil().setWidth(20)),
              width: double.infinity,
              child: Text(
                "Select Delivery Address",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(
                      17,
                    ),
                    fontWeight: FontWeight.w500,
                    color: Color(0xff525252)),
              ),
            ),
            ListView.builder(

                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: value.addressResponse.data.length,
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await Provider.of<AddressViewModel>(
                          context, listen: false)
                          .selectAddress(value.addressResponse.data[index]);
                    },
                    child: Material(
                        color: Color(0xfffffff),
                        // borderRadius: BorderRadius.circular(2),
                        child: Card(
                          margin: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(0),
                              ScreenUtil().setWidth(0),
                              ScreenUtil().setWidth(0),
                              ScreenUtil().setWidth(0)),
                          elevation: 0.1,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(0),
                                ScreenUtil().setWidth(20),
                                ScreenUtil().setWidth(0),
                                ScreenUtil().setWidth(10)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(20)),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        // InkWell(
                                        //   onTap: () async {
                                        //     await Provider.of<AddressViewModel>(context,
                                        //             listen: false)
                                        //         .selectAddress(
                                        //             value.addressResponse.data[index]);
                                        //   },
                                        //   child:
                                        (value.selectedAddress != null &&
                                            (value.selectedAddress.id ==
                                                value.addressResponse
                                                    .data[index].id))
                                            ? Icon(
                                          Icons.check_circle,
                                          color: AppColors.primaryElement,
                                          size: ScreenUtil().setWidth(18),
                                        )
                                            : Icon(
                                          Icons.check_box_outline_blank,
                                          color: AppColors.primaryElement,
                                          size: ScreenUtil().setWidth(18),
                                        ),
                                        // ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(9.33),
                                        ),
                                        Container(
                                          width: ScreenUtil().setWidth(245),
                                          child: Text(
                                            "${(value.addressResponse
                                                .data[index].firstName + " " +
                                                value.addressResponse
                                                    .data[index].lastName) ??
                                                "User"}",
                                            style: TextStyle(
                                                color: Color(0xff525252),
                                                fontSize: ScreenUtil().setSp(
                                                  17,
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(16),
                                    ),
                                    Container(
                                      padding:
                                      EdgeInsets.only(
                                          left: ScreenUtil().setWidth(26)),
                                      width: double.infinity,
                                      child: Text(
                                        "Address : " +
                                            value.addressResponse.data[index]
                                                .address
                                                .toString(),
                                        style: TextStyle(
                                            color: Color(0xff5f5f5f),
                                            fontSize: ScreenUtil().setSp(
                                              16,
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(11),
                                    ),
                                    Container(
                                      padding:
                                      EdgeInsets.only(
                                          left: ScreenUtil().setWidth(26)),
                                      width: double.infinity,
                                      child: Text(
                                        "Pin : " +
                                            value.addressResponse.data[index]
                                                .zip.toString(),
                                        style: TextStyle(
                                            color: Color(0xff5f5f5f),
                                            fontSize: ScreenUtil().setSp(
                                              16,
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(12),
                                    ),
                                    Container(
                                      padding:
                                      EdgeInsets.only(
                                          left: ScreenUtil().setWidth(26)),
                                      width: double.infinity,
                                      child: Text(
                                        value.addressResponse.data[index].phone
                                            .toString(),
                                        style: TextStyle(
                                            color: Color(0xff5f5f5f),
                                            fontSize: ScreenUtil().setSp(
                                              15,
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(13),
                                    ),
                                    Container(
                                      padding:
                                      EdgeInsets.only(
                                          left: ScreenUtil().setWidth(26)),
                                      width: double.infinity,
                                      child: Text(
                                        value.addressResponse.data[index].email
                                            .toString(),
                                        style: TextStyle(
                                            color: Color(0xff5f5f5f),
                                            fontSize: ScreenUtil().setSp(
                                              15,
                                            )),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: ScreenUtil().setWidth(26),
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     InkWell(
                                    //       onTap: () {
                                    //         setState(() {
                                    //           primaryAddressBox = index;
                                    //         });
                                    //       },
                                    //       child: primaryAddressBox == index
                                    //           ? Icon(
                                    //               Icons.check_box,
                                    //               color: AppColors.primaryElement,
                                    //               size: ScreenUtil().setWidth(18),
                                    //             )
                                    //           : Icon(
                                    //               Icons.check_box_outline_blank,
                                    //               color: AppColors.primaryElement,
                                    //               size: ScreenUtil().setWidth(18),
                                    //             ),
                                    //     ),
                                    //     SizedBox(
                                    //       width: ScreenUtil().setWidth(12.25),
                                    //     ),
                                    //     Container(
                                    //       width: ScreenUtil().setWidth(250),
                                    //       child: Text(
                                    //         "Make this a primary Address",
                                    //         style: TextStyle(
                                    //             color: Color(0xff5c5c5c),
                                    //             fontSize: ScreenUtil().setSp(
                                    //               13,
                                    //             )),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(20),
                                    ),
                                  ])),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  InkWell(
                                      onTap: () async {
                                        addressId =
                                            value.addressResponse.data[index]
                                                .id;
                                        _phone.text =
                                            value.addressResponse.data[index]
                                                .phone;
                                        _address.text =
                                            value.addressResponse.data[index]
                                                .address;
                                        _pin.text = value
                                            .addressResponse.data[index].zip
                                            .toString();
                                        _email.text =
                                            value.addressResponse.data[index]
                                                .email;
                                        _town.text =
                                            value.addressResponse.data[index]
                                                .town;
                                        _city.text =
                                            value.addressResponse.data[index]
                                                .city;
                                        _country.text =
                                            value.addressResponse.data[index]
                                                .country;
                                        _state.text =
                                            value.addressResponse.data[index]
                                                .state;
                                        _firstName.text = value
                                            .addressResponse.data[index]
                                            .firstName;
                                        _lastName.text = value
                                            .addressResponse.data[index]
                                            .lastName;
                                        setState(() {
                                          newAddress = !newAddress;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    color: Color(0xffd3d3d3))
                                            )
                                        ),
                                        width: ScreenUtil().setWidth(150),
                                        height: ScreenUtil().setWidth(30),
                                        child: Center(
                                          child: Text("EDIT", style: TextStyle(
                                              color: AppColors
                                                  .primaryElement),),
                                        ),
                                      )),

                                  InkWell(
                                      onTap: () async {
                                        await Provider.of<AddressViewModel>(
                                            context,
                                            listen: false)
                                            .deleteAddress(
                                            value.addressResponse.data[index]
                                                .id);
                                      },
                                      child: Container(
                                        width: ScreenUtil().setWidth(215),
                                        height: ScreenUtil().setWidth(30),
                                        child: Center(
                                          child: Text("REMOVE",
                                            style: TextStyle(color: AppColors
                                                .primaryElement),),
                                        ),
                                      ))
                                ],
                              ),
                              Divider(height: 1,)
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     Container(
                              //         height: ScreenUtil().setWidth(37),
                              //         width: ScreenUtil().setWidth(100),
                              //         child: OutlinedButton(
                              //           style: OutlinedButton.styleFrom(
                              //             shape: RoundedRectangleBorder(
                              //               borderRadius: BorderRadius.circular(18.0),
                              //             ),
                              //             side: BorderSide(
                              //                 width: 1,
                              //                 color: AppColors.primaryElement),
                              //           ),
                              //           onPressed: () {
                              //             addressId =
                              //                 value.addressResponse.data[index].id;
                              //             _phone.text =
                              //                 value.addressResponse.data[index].phone;
                              //             _address.text =
                              //                 value.addressResponse.data[index].address;
                              //             _pin.text = value
                              //                 .addressResponse.data[index].zip
                              //                 .toString();
                              //             _email.text =
                              //                 value.addressResponse.data[index].email;
                              //             _town.text =
                              //                 value.addressResponse.data[index].town;
                              //             _city.text =
                              //                 value.addressResponse.data[index].city;
                              //             _country.text =
                              //                 value.addressResponse.data[index].country;
                              //             _state.text =
                              //                 value.addressResponse.data[index].state;
                              //             _firstName.text = value
                              //                 .addressResponse.data[index].firstName;
                              //             _lastName.text = value
                              //                 .addressResponse.data[index].lastName;
                              //             setState(() {
                              //               newAddress = !newAddress;
                              //             });
                              //           },
                              //           child: Text(
                              //             "Edit",
                              //             style: TextStyle(
                              //                 color: AppColors.primaryElement,
                              //                 fontFamily: 'Montserrat'),
                              //           ),
                              //         )),
                              //     SizedBox(
                              //       width: ScreenUtil().setWidth(14),
                              //     ),
                              //     Container(
                              //       height: ScreenUtil().setWidth(37),
                              //       width: ScreenUtil().setWidth(100),
                              //       child: OutlinedButton(
                              //         style: OutlinedButton.styleFrom(
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.circular(18.0),
                              //           ),
                              //           side: BorderSide(
                              //               width: 1, color: AppColors.primaryElement),
                              //         ),
                              //         onPressed: () async {
                              //           await Provider.of<AddressViewModel>(context,
                              //                   listen: false)
                              //               .deleteAddress(
                              //                   value.addressResponse.data[index].id);
                              //         },
                              //         child: Text(
                              //           "Remove",
                              //           style: TextStyle(
                              //               color: AppColors.primaryElement,
                              //               fontFamily: 'Montserrat'),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // )
                            ]),
                          ),
                        )),);
                }),
            Container(height: ScreenUtil().setWidth(30),)
          ]);
        });
  }

  Widget getCartList() {
    return Stack(
      children: [
        SingleChildScrollView(
            child: Column(children: [
              Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setWidth(26),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: ScreenUtil().setWidth(20),
                                    width: ScreenUtil().setWidth(20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.primaryElement),
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().radius(20))),
                                    child: Center(
                                        child: Icon(
                                          Icons.check_circle,
                                          color: AppColors.primaryElement,
                                          size: ScreenUtil().setWidth(15),
                                        )),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setWidth(10),
                                  ),
                                  Text(
                                    "Cart",
                                    style: TextStyle(
                                        color: AppColors.primaryElement,
                                        fontSize: ScreenUtil().setSp(
                                          12,
                                        )),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(12), 0, 0, 0),
                              width: ScreenUtil().setWidth(105),
                              child: Column(
                                children: [
                                  DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: ScreenUtil().setWidth(105),
                                    lineThickness: ScreenUtil().setWidth(0.8),
                                    dashLength: ScreenUtil().setWidth(4),
                                    dashColor: AppColors.primaryElement,
                                    dashRadius: 0.0,
                                    dashGapLength: ScreenUtil().setWidth(4),
                                    dashGapColor: Colors.transparent,
                                    dashGapRadius: 0.0,
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setWidth(24),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  addressPage = true;
                                });
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    addressPage
                                        ? Container(
                                      height: ScreenUtil().setWidth(20),
                                      width: ScreenUtil().setWidth(20),
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryElement,
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().radius(20))),
                                      child: Center(
                                          child: Text(
                                            "2",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ScreenUtil().setSp(
                                                  12,
                                                )),
                                          )),
                                    )
                                        : Container(
                                      height: ScreenUtil().setWidth(20),
                                      width: ScreenUtil().setWidth(20),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.primaryElement),
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().radius(20))),
                                      child: Center(
                                          child: Icon(
                                            Icons.check_circle,
                                            color: AppColors.primaryElement,
                                            size: ScreenUtil().setWidth(15),
                                          )),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(10),
                                    ),
                                    Text(
                                      "Address",
                                      style: TextStyle(
                                          color: AppColors.primaryElement,
                                          fontSize: ScreenUtil().setSp(
                                            12,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(12), 0, 0, 0),
                              width: ScreenUtil().setWidth(105),
                              child: Column(
                                children: [
                                  DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: ScreenUtil().setWidth(105),
                                    lineThickness: ScreenUtil().setWidth(0.8),
                                    dashLength: ScreenUtil().setWidth(4),
                                    dashColor: AppColors.primaryElement,
                                    dashRadius: 0.0,
                                    dashGapLength: ScreenUtil().setWidth(4),
                                    dashGapColor: Colors.transparent,
                                    dashGapRadius: 0.0,
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setWidth(24),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (Provider
                                    .of<AddressViewModel>(context,
                                    listen: false)
                                    .selectedAddress !=
                                    null) {
                                  setState(() {
                                    addressPage = false;
                                  });
                                }
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    addressPage
                                        ? Container(
                                      height: ScreenUtil().setWidth(20),
                                      width: ScreenUtil().setWidth(20),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.primaryElement),
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().radius(20))),
                                      child: Center(
                                          child: Text(
                                            "3",
                                            style: TextStyle(
                                                color: AppColors.primaryElement,
                                                fontSize: ScreenUtil().setSp(
                                                  12,
                                                )),
                                          )),
                                    )
                                        : Container(
                                      height: ScreenUtil().setWidth(20),
                                      width: ScreenUtil().setWidth(20),
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryElement,
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().radius(20))),
                                      child: Center(
                                          child: Text(
                                            "3",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ScreenUtil().setSp(
                                                  12,
                                                )),
                                          )),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(10),
                                    ),
                                    Text(
                                      "Payment",
                                      style: TextStyle(
                                          color: AppColors.primaryElement,
                                          fontSize: ScreenUtil().setSp(
                                            12,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      addressPage
                          ? (newAddress
                          ? getExistingAddress()
                          : addNewAddress())
                          : getPaymentOption(),
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
                      Consumer<CartViewModel>(
                          builder: (BuildContext context, value, Widget child) {
                            return Container(
                                color: Color(0xffffffff),
                                child:
                                InkWell(
                                    onTap: () async {
                                      await Provider.of<CartViewModel>(context,
                                          listen: false)
                                          .changePromoStatus("loading");
                                      showCoupon();
                                    },
                                    child:
                                    Container(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(20),
                                            right: ScreenUtil().setWidth(20),
                                            top: ScreenUtil().setWidth(20),
                                            bottom: ScreenUtil().setWidth(20)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(value.promocodeStatus
                                                ? "Applied Promocode (" +
                                                value.promocode + ")"
                                                : "Apply Promocode"),
                                            Icon(FontAwesomeIcons.angleRight,
                                              color: Color(0xffd0d0d0),
                                              size: ScreenUtil().setWidth(14),),
                                          ],
                                        )
                                    )
                                ));
                          }),
                      SizedBox(height: ScreenUtil().setWidth(15),),
                      Container(
                        child: getBillCard(),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      /*addressPage
                  ? Container()
                  : Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      color: AppColors.primaryElement,
                      child: Text(
                        "© 2020 Anne Private Limited",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),*/
                      addressPage
                          ? SizedBox(
                        height: 50,
                      )
                          : Container(),
                    ],
                  ))
            ])),
        addressPage
            ? Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: ScreenUtil().setHeight(61),
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(20),
                  ScreenUtil().setWidth(10),
                  ScreenUtil().setWidth(25),
                  ScreenUtil().setWidth(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<CartViewModel>(builder:
                      (BuildContext context, value, Widget child) {
                    if (value.cartResponse == null ||
                        value.cartResponse.items.length == 0) {
                      return Container();
                    }
                    return Text(
                        "TOTAL : ${store.currencySymbol} " +
                            (value.cartResponse.total).toString()
                        //"$total"
                        ,
                        style: TextStyle(
                            color: Color(0xff383838),
                            fontSize: ScreenUtil().setSp(
                              18,
                            )));
                  }),
                  Container(
                    child: Consumer<AddressViewModel>(
                      builder: (context, value, child) {
                        return Container(
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setHeight(42),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(5),
                                ),
                                side: BorderSide(
                                    width: 2,
                                    color: value.selectedAddress == null
                                        ? Colors.grey
                                        : AppColors.primaryElement),
                              ),
                              onPressed: () async {
                                if (value.selectedAddress != null) {
                                  setState(() {
                                    addressPage = false;
                                  });
                                }
                              },
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(
                                      16,
                                    ),
                                    fontWeight: FontWeight.w500,
                                    color: value.selectedAddress == null
                                        ? Colors.grey
                                        : AppColors.primaryElement,
                                    fontFamily: 'Montserrat'),
                              ),
                            ));
                      },
                    ),
                  )
                  /*Consumer<AddressViewModel>(builder:
                            (BuildContext context, value, Widget child) {
                          return Container(
                            width: 110,
                            child: RaisedButton(
                              color: value.selectedAddress != null
                                  ? AppColors.primaryElement
                                  : Color(0x66ee7625),
                              onPressed: () {
                                if (value.selectedAddress != null) {
                                  setState(() {
                                    addressPage = false;
                                  });
                                }
                              },
                              child: Text(
                                "CONTINUE",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        })*/
                ],
              )),
        ) : Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: ScreenUtil().setHeight(61),
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(20),
                  ScreenUtil().setWidth(10),
                  ScreenUtil().setWidth(25),
                  ScreenUtil().setWidth(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<CartViewModel>(builder:
                      (BuildContext context, value, Widget child) {
                    if (value.cartResponse == null ||
                        value.cartResponse.items.length == 0) {
                      return Container();
                    }
                    return Text(
                        "TOTAL : ${store.currencySymbol} " +
                            (value.cartResponse.total).toString()
                        //"$total"
                        ,
                        style: TextStyle(
                            color: Color(0xff383838),
                            fontSize: ScreenUtil().setSp(
                              18,
                            )));
                  }),
                  Container(
                    child: Consumer<AddressViewModel>(
    builder: (BuildContext context, value, Widget child) {
    return  Container(
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setHeight(42),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(5),
                                ),
                                side: BorderSide(
                                    width: 2,
                                    color:  buttonStatusOrder
                                        ? AppColors.primaryElement
                                        : Colors.grey),
                              ),
                              onPressed: () async {
                                paymentHandle(value.selectedAddress.id);
                              },
                              child: Text(
                                "PLACE ORDER",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(
                                      16,
                                    ),
                                    fontWeight: FontWeight.w500,
                                    color: buttonStatusOrder
                                        ? AppColors.primaryElement
                                        : Colors.grey,
                                    fontFamily: 'Montserrat'),
                              ),
                            ));})
                  )
                ],
              )),
        )
            ,
      ],
    );
  }

  getExistingAddress() {
    return Column(
      children: [
        getDeliveryOptionCard(),
        Container(
          width: ScreenUtil().setWidth(370),
          height: ScreenUtil().setWidth(42),
          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0,
              ScreenUtil().setWidth(20), ScreenUtil().setWidth(15)),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: BorderSide(width: 1, color: AppColors.primaryElement),
            ),
            onPressed: () async {
              setState(() {
                _phone.text = Provider
                    .of<ProfileModel>(context, listen: false)
                    .user
                    .phone ??
                    "";
                _firstName.text =
                    Provider
                        .of<ProfileModel>(context, listen: false)
                        .user
                        .firstName ??
                        "";
                _lastName.text =
                    Provider
                        .of<ProfileModel>(context, listen: false)
                        .user
                        .lastName ??
                        "";
                _email.text = Provider
                    .of<ProfileModel>(context, listen: false)
                    .user
                    .email ??
                    "";
                newAddress = !newAddress;
              });
            },
            child: Text(
              'Add New Address',
              style: TextStyle(
                  fontFamily: 'Montserrat', color: AppColors.primaryElement),
            ),
          ),
        ),
      ],
    );
  }

  addNewAddress() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(27),
          ScreenUtil().setWidth(30),
          ScreenUtil().setWidth(25),
          ScreenUtil().setWidth(32)),
      margin: EdgeInsets.fromLTRB(
          0, ScreenUtil().setWidth(22), 0, ScreenUtil().setWidth(10)),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  "CONTACT DETAILS",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(
                        15,
                      ),
                      color: Color(0xff818181)),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty || value == "") {
                        return 'First Name is Required';
                      }
                      return null;
                    },
                    controller: _firstName,
                    decoration: InputDecoration(
                        fillColor: Color(0xfff3f3f3),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        labelText: "First Name *",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              15,
                            ))),
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty || value == "") {
                        return 'Last Name is Required';
                      }
                      return null;
                    },
                    controller: _lastName,
                    decoration: InputDecoration(
                        fillColor: Color(0xfff3f3f3),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        labelText: "Last Name *",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              15,
                            ))),
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty || value == "") {
                        return 'Email is Required';
                      }
                      return null;
                    },
                    controller: _email,
                    decoration: InputDecoration(
                        fillColor: Color(0xfff3f3f3),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              15,
                            ))),
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty || value == "") {
                        return 'Phone number is Required';
                      }
                      return null;
                    },
                    controller: _phone,
                    decoration: InputDecoration(
                        fillColor: Color(0xfff3f3f3),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        labelText: "Phone",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              15,
                            ))),
                    keyboardType: TextInputType.phone,
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(35),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "ADDRESS DETAILS",
                  style: TextStyle(
                      color: Color(0xff818181),
                      fontSize: ScreenUtil().setSp(
                        15,
                      )),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty && value.length != 6) {
                        return 'A 6 digit Pin is Required';
                      }
                      return null;
                    },
                    controller: _pin,
                    onChanged: (value) async {
                      if (value.length == 6) {
                        TzDialog _dialog = TzDialog(
                            context, TzDialogType.progress);
                        _dialog.show();
                        final AddressRepository addressRepository =
                        AddressRepository();
                        var result =
                        await addressRepository.fetchDataFromZip(value);
                        if (result != null) {
                          setState(() {
                            _country.text = result["country"];
                            _state.text = result["state"];
                            _city.text = result["city"];
                          });
                        }
                        _dialog.close();
                      }
                    },
                    decoration: InputDecoration(
                        fillColor: Color(0xfff3f3f3),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        labelText: "Zip code",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              15,
                            ))),
                    keyboardType: TextInputType.number,
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'City Name is Required';
                      }
                      return null;
                    },
                    readOnly: true,
                    controller: _city,
                    decoration: InputDecoration(
                        fillColor: Color(0xfff3f3f3),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        labelText: "City *",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              15,
                            ))),
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'State Name is Required';
                      }
                      return null;
                    },
                    readOnly: true,
                    controller: _state,
                    decoration: InputDecoration(
                        fillColor: Color(0xfff3f3f3),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        labelText: "State",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              15,
                            ))),
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Country Name is Required';
                      }
                      return null;
                    },
                    readOnly: true,
                    controller: _country,
                    decoration: InputDecoration(
                        fillColor: Color(0xfff3f3f3),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        labelText: "Country *",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              15,
                            ))),
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Address is Required';
                      }
                      return null;
                    },
                    controller: _address,
                    decoration: InputDecoration(
                        fillColor: Color(0xfff3f3f3),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        labelText: "Address",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              15,
                            ))),
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Town Name is Required';
                      }
                      return null;
                    },
                    controller: _town,
                    decoration: InputDecoration(
                        fillColor: Color(0xfff3f3f3),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.0),
                        ),
                        labelText: "Town",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              15,
                            ))),
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(28),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        defaultAddress = !defaultAddress;
                      });
                    },
                    child: defaultAddress
                        ? Icon(
                      Icons.check_box,
                      color: AppColors.primaryElement,
                      size: ScreenUtil().setWidth(18),
                    )
                        : Icon(
                      Icons.check_box_outline_blank,
                      color: AppColors.primaryElement,
                      size: ScreenUtil().setWidth(18),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(12.25),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(250),
                    child: Text(
                      "Make this a primary Address",
                      style: TextStyle(
                          color: Color(0xff5c5c5c),
                          fontSize: ScreenUtil().setSp(
                            13,
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setWidth(27),
              ),
              Container(
                // padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: ScreenUtil().setWidth(362),
                height: ScreenUtil().setWidth(42),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(width: 1, color: AppColors.primaryElement),
                  ),
                  onPressed: () async {
                    if (buttonStatusAddress) {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      primaryAddressBox = -1;
                      setState(() {
                        primaryAddressBox = -1;
                        buttonStatusAddress = !buttonStatusAddress;
                      });

                      var response = await Provider.of<AddressViewModel>(
                          context,
                          listen: false)
                          .saveAddress(
                          addressId,
                          _email.text,
                          _firstName.text,
                          _lastName.text,
                          _address.text,
                          _town.text,
                          _city.text,
                          _country.text,
                          _state.text,
                          _pin.text,
                          _phone.text);
                      if (response) {
                        setState(() {
                          addressId = "new";
                          _phone.text = "";
                          _address.text = "";
                          _pin.text = "";
                          _email.text = "";
                          _town.text = "";
                          _city.text = "";
                          _country.text = "";
                          _state.text = "";
                          _firstName.text = "";
                          _lastName.text = "";
                          buttonStatusAddress = !buttonStatusAddress;
                          newAddress = !newAddress;
                        });
                      } else {
                        setState(() {
                          buttonStatusAddress = !buttonStatusAddress;
                        });
                        final snackBar = SnackBar(
                          backgroundColor: Colors.black,
                          content: Text(
                            'Something went wrong. Please Try Again!!',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  child: Text(
                    "Add Address",
                    style: TextStyle(
                        color: AppColors.primaryElement,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  getPaymentOption() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(14),
          ScreenUtil().setWidth(33),
          ScreenUtil().setWidth(14),
          ScreenUtil().setWidth(44)),
      margin: EdgeInsets.fromLTRB(
          0, ScreenUtil().setWidth(22), 0, ScreenUtil().setWidth(15)),
      child: InkWell(
        onTap: () {
          Map<String, dynamic> data = {
            "id": EVENT_PAYMENT_SELECTED_TYPE,
            "paymentType": paymentMethod,
            "event": "tap",
          };
          Tracking(event: EVENT_PAYMENT_SELECTED_TYPE, data: data);
        },
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  paymentMethod = "credit";
                });
              },
              child:
            creditCard(),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(15),
            ),
      GestureDetector(
        onTap: (){
          setState(() {
            paymentMethod = "paypal";
          });
        },
        child:
            paypalCard()),
            SizedBox(
              height: ScreenUtil().setWidth(15),
            ),
            // podCard(),
            // SizedBox(
            //   height: ScreenUtil().setWidth(15),
            // ),
            // upiCard(),
            // SizedBox(
            //   height: ScreenUtil().setWidth(15),
            // ),
            //netBankingCard()
          ],
        ),
      ),
    );
  }

  creditCard() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(25),
            ScreenUtil().setWidth(30),
            ScreenUtil().setWidth(25),
            ScreenUtil().setWidth(22)),
        decoration: BoxDecoration(
            border: Border.all(
                color: paymentMethod == "credit"
                    ? AppColors.primaryElement
                    : Color(0xff707070),
                width: ScreenUtil().setWidth(0.9)),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(3))),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        paymentMethod = "credit";
                      });
                    },
                    child: paymentMethod == "credit"
                        ? Icon(
                      Icons.adjust_sharp,
                      color: AppColors.primaryElement,
                    )
                        : Icon(
                      Icons.panorama_fish_eye,
                      color: Color(0xff707070),
                    )),
                SizedBox(
                  width: ScreenUtil().setWidth(19),
                ),
                Column(children: [
                  Text(
                    "Credit/Debit card",
                    style: TextStyle(
                        color: Color(0xff6d6d6d),
                        fontSize: ScreenUtil().setSp(14)),
                  ),
                  // Text(
                  //   "(no cost EMI available)",
                  //   style: TextStyle(
                  //       color: Color(0xff6d6d6d),
                  //       fontSize: ScreenUtil().setSp(10)),
                  // )
                ]),
                SizedBox(
                  width: ScreenUtil().setWidth(69),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                          height: ScreenUtil().setWidth(18),
                          width: ScreenUtil().setWidth(32),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff707070))),
                          child: Image.asset(
                            "assets/images/masterCard.png",
                          )),
                      SizedBox(
                        width: ScreenUtil().setWidth(3),
                      ),
                      Container(
                          height: ScreenUtil().setWidth(18),
                          width: ScreenUtil().setWidth(32),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff707070))),
                          child: Image.asset("assets/images/rupayCard.png")),
                      SizedBox(
                        width: ScreenUtil().setWidth(3),
                      ),
                      Container(
                          height: ScreenUtil().setWidth(18),
                          width: ScreenUtil().setWidth(32),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff707070))),
                          child: Image.asset(
                            "assets/images/visaCard.png",
                          )),
                      // SizedBox(
                      //   width: ScreenUtil().setWidth(3),
                      // ),
                      // Container(
                      //     height: ScreenUtil().setWidth(18),
                      //     width: ScreenUtil().setWidth(32),
                      //     decoration: BoxDecoration(
                      //         border: Border.all(color: Color(0xff707070))),
                      //     child: Image.asset(
                      //       "assets/images/americanCard.png",
                      //     )),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setWidth(23),
            ),
            Container(
              width: double.infinity,
              child: Text(
                "Card Number",
                style: TextStyle(
                    color: AppColors.primaryElement,
                    fontSize: ScreenUtil().setWidth(14)),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(11),
            ),
            Container(
              height: ScreenUtil().setWidth(50),
              
              child: TextField(
                controller: cardNumber,
                style: TextStyle(
                    color: Color(0xff525252),
                    fontSize: ScreenUtil().setSp(14)),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xff707070), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xff707070), width: 1.0),
                    ),
                    hintText: "xxxx - xxxx - xxxx - xxxx",
                    hintStyle: TextStyle(
                        color: Color(0xff525252),
                        fontSize: ScreenUtil().setSp(14))),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Container(
              width: double.infinity,
              child: Text(
                "Card Holder Name",
                style: TextStyle(
                    color: AppColors.primaryElement,
                    fontSize: ScreenUtil().setWidth(14)),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(11),
            ),
            Container(
            
              height: ScreenUtil().setWidth(50),
              child: TextField(
                controller: cardHolder,
                style: TextStyle(
                    color: Color(0xff525252),
                    fontSize: ScreenUtil().setSp(14)),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xff707070), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xff707070), width: 1.0),
                    ),
                    hintText: "John",
                    hintStyle: TextStyle(
                        color: Color(0xff525252),
                        fontSize: ScreenUtil().setSp(14))),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              children: [
                Container(
                  width: ScreenUtil().setWidth(95),
                  child: Text(
                    "Expire Month",
                    style: TextStyle(
                        color: AppColors.primaryElement,
                        fontSize: ScreenUtil().setSp(14)),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(25),
                ),
                Container(
                  width: ScreenUtil().setWidth(95),
                  child: Text(
                    "Expire Year",
                    style: TextStyle(
                        color: AppColors.primaryElement,
                        fontSize: ScreenUtil().setSp(14)),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(25),
                ),
                Container(
                  width: ScreenUtil().setWidth(95),
                  child: Text(
                    "Security Code",
                    style: TextStyle(
                        color: AppColors.primaryElement,
                        fontSize: ScreenUtil().setSp(14)),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 11,
            ),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xff707070)),
                        borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(3))),
                    padding: EdgeInsets.only(left: 5),
                    height: ScreenUtil().setWidth(40),
                    width: ScreenUtil().setWidth(95),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<ListItem>(
                            value: _selectedMonth,
                            items: _dropdownMonthItems,
                            onChanged: (value) {
                              setState(() {
                                _selectedMonth = value;
                              });
                            }))),
                SizedBox(
                  width: ScreenUtil().setWidth(25),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xff707070)),
                        borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(3))),
                    padding: EdgeInsets.only(left: 5),
                    height: ScreenUtil().setWidth(40),
                    width: ScreenUtil().setWidth(95),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<ListItem>(
                            value: _selectedYear,
                            items: _dropdownYearItems,
                            onChanged: (value) {
                              setState(() {
                                _selectedYear = value;
                              });
                            }))),
                SizedBox(
                  width: ScreenUtil().setWidth(25),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  height: ScreenUtil().setWidth(40),
                  width: ScreenUtil().setWidth(95),

                  color: Colors.white,
                  child: TextField(
                    controller: cvv,
                    style: TextStyle(
                        color: Color(0xff525252),
                        fontSize: ScreenUtil().setSp(14)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xff707070), width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xff707070), width: 1.0),
                        ),
                        hintText: "xxx",
                        hintStyle: TextStyle(
                            color: Color(0xff525252),
                            fontSize: ScreenUtil().setSp(14))),
                    keyboardType: TextInputType.number,
                  ),
                ),

              ],
            ),
          ],
        ));
  }

  paypalCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(
              color: paymentMethod == "paypal"
                  ? AppColors.primaryElement
                  : Color(0xff707070),
              width: ScreenUtil().setWidth(0.9)),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(3))),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                setState(() {
                  paymentMethod = "paypal";
                });
              },
              child: paymentMethod == "paypal"
                  ? Icon(
                Icons.adjust_sharp,
                color: AppColors.primaryElement,
              )
                  : Icon(
                Icons.panorama_fish_eye,
                color: Color(0xff707070),
              )),
          SizedBox(
            width: ScreenUtil().setWidth(19),
          ),
          Text(
            "Paypal",
            style: TextStyle(
                color: Color(0xff6d6d6d), fontSize: ScreenUtil().setSp(14)),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(214),
          ),
          Container(
            child: Row(
              children: [
                Container(
                    height: ScreenUtil().setWidth(18),
                    width: ScreenUtil().setWidth(32),
                    child: Image.asset(
                      "assets/images/paypal.png",
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  podCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(
              color: paymentMethod == "pod"
                  ? AppColors.primaryElement
                  : Color(0xff707070),
              width: ScreenUtil().setWidth(0.9)),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(3))),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                setState(() {
                  paymentMethod = "pod";
                });
              },
              child: paymentMethod == "pod"
                  ? Icon(
                Icons.adjust_sharp,
                color: AppColors.primaryElement,
              )
                  : Icon(
                Icons.panorama_fish_eye,
                color: Color(0xff707070),
              )),
          SizedBox(
            width: ScreenUtil().setWidth(19),
          ),
          Text(
            "POD (Pay On Delivery)",
            style: TextStyle(
                color: Color(0xff6d6d6d), fontSize: ScreenUtil().setSp(14)),
          ),
        ],
      ),
    );
  }

  //
  // upiCard() {
  //   return Container(
  //     padding: EdgeInsets.fromLTRB(
  //         ScreenUtil().setWidth(26),
  //         ScreenUtil().setWidth(30),
  //         ScreenUtil().setWidth(17),
  //         ScreenUtil().setWidth(22)),
  //     decoration: BoxDecoration(
  //         border: Border.all(
  //             color: paymentMethod == "upi"
  //                 ? AppColors.primaryElement
  //                 : Color(0xff707070),
  //             width: ScreenUtil().setWidth(0.9)),
  //         borderRadius: BorderRadius.circular(ScreenUtil().setWidth(3))),
  //     child: Row(
  //       children: [
  //         InkWell(
  //             onTap: () {
  //               setState(() {
  //                 paymentMethod = "upi";
  //               });
  //             },
  //             child: paymentMethod == "upi"
  //                 ? Icon(
  //                     Icons.adjust_sharp,
  //                     color: AppColors.primaryElement,
  //                   )
  //                 : Icon(
  //                     Icons.panorama_fish_eye,
  //                     color: Color(0xff707070),
  //                   )),
  //         SizedBox(
  //           width: ScreenUtil().setWidth(19),
  //         ),
  //         Text(
  //           "UPI (Using UPI ID)",
  //           style: TextStyle(
  //               color: Color(0xff6d6d6d), fontSize: ScreenUtil().setSp(14)),
  //         ),
  //         SizedBox(
  //           width: ScreenUtil().setWidth(80),
  //         ),
  //         Container(
  //           child: Row(
  //             children: [
  //               Container(
  //                   height: ScreenUtil().setWidth(24),
  //                   width: ScreenUtil().setWidth(24),
  //                   child: Image.asset(
  //                     "assets/images/gpay.png",
  //                   )),
  //               SizedBox(
  //                 width: ScreenUtil().setWidth(4),
  //               ),
  //               Container(
  //                   height: ScreenUtil().setWidth(24),
  //                   width: ScreenUtil().setWidth(24),
  //                   child: Image.asset(
  //                     "assets/images/phonePay.png",
  //                   )),
  //               SizedBox(
  //                 width: ScreenUtil().setWidth(4),
  //               ),
  //               Container(
  //                   height: ScreenUtil().setWidth(24),
  //                   width: ScreenUtil().setWidth(40),
  //                   child: Image.asset(
  //                     "assets/images/upi.png",
  //                   )),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  netBankingCard() {
    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(
                color: paymentMethod == "nb"
                    ? AppColors.primaryElement
                    : Color(0xff707070),
                width: ScreenUtil().setWidth(0.9)),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      paymentMethod = "nb";
                    });
                  },
                  child: paymentMethod == "nb"
                      ? Icon(
                    Icons.adjust_sharp,
                    color: AppColors.primaryElement,
                  )
                      : Icon(
                    Icons.panorama_fish_eye,
                    color: Color(0xff707070),
                  )),
              SizedBox(
                width: ScreenUtil().setWidth(19),
              ),
              Text(
                "Net Banking (Online Transaction)",
                style: TextStyle(
                    color: Color(0xff6d6d6d), fontSize: ScreenUtil().setSp(14)),
              ),
              /*SizedBox(
                width: ScreenUtil().setWidth(50),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                        height: ScreenUtil().setWidth(23),
                        width: ScreenUtil().setWidth(23),
                        child: Icon(
                          Icons.account_balance,
                          color: Color(0xff707070),
                          size: ScreenUtil().setWidth(23),
                        )),
                  ],
                ),
              ),*/
            ],
          ),
          // SizedBox(
          //   height: ScreenUtil().setWidth(23),
          // ),
          // Container(
          //   width: double.infinity,
          //   child: Text(
          //     "Bank Code",
          //     style: TextStyle(
          //         color: AppColors.primaryElement,
          //         fontSize: ScreenUtil().setWidth(14)),
          //     textAlign: TextAlign.left,
          //   ),
          // ),
          // SizedBox(
          //   height: ScreenUtil().setWidth(11),
          // ),
          // Container(
          //   height: ScreenUtil().setWidth(50),
          //   child: TextField(
          //     controller: paymentCode,
          //     decoration: InputDecoration(
          //         fillColor: Colors.white,
          //         filled: true,
          //         enabledBorder: OutlineInputBorder(
          //           borderSide:
          //           BorderSide(color: Color(0xff707070), width: 1.0),
          //         ),
          //         focusedBorder: OutlineInputBorder(
          //           borderSide:
          //           BorderSide(color: Color(0xff707070), width: 1.0),
          //         ),
          //         hintText: "xxxx",
          //         hintStyle: TextStyle(
          //             color: Color(0xff525252),
          //             fontSize: ScreenUtil().setSp(13))),
          //   ),
          // ),
        ]));
  }

  void paymentHandle(selectedAddressId) async {
    double amount = Provider.of<CartViewModel>(context,listen: false).cartResponse.total;
    if (buttonStatusOrder) {
      setState(() {
        buttonStatusOrder = !buttonStatusOrder;
      });
      TzDialog _dialog = TzDialog(
          context, TzDialogType.progress);
      _dialog.show();
      if (paymentMethod == "credit") {
          StripeRepository stripeRepository = StripeRepository();
          CreditCard creditCard = CreditCard(
            number: cardNumber.text.replaceAll("-", ""),
            expMonth: _selectedMonth.value,
            expYear: int.parse(_selectedYear.name),
            cvc: cvv.text,
          );

          await StripePayment.createTokenWithCard(
            creditCard,
          ).then((token) async{
            log("${token.tokenId}");
            var stripe = await stripeRepository.stripe(selectedAddressId, token.tokenId);

            if(stripe["status"]=="completed"){
              _dialog.close();
              handlePaymentSuccess("credit", stripe["value"]["id"]);
            }
            else if(stripe["status"]=="error"){
              _dialog.close();
              handlePaymentFailure(stripe["error"]);
            }
          }).catchError((onError){
            _dialog.close();
            handlePaymentFailure(onError.toString());});
  }

      else if(paymentMethod=="paypal"){
        BrainTreeRepository brainTreeRepository = BrainTreeRepository();
        double amount = Provider.of<CartViewModel>(context,listen: false).cartResponse.total;
        var tokenizationKey = await brainTreeRepository.brainTreeToken();
        final request = BraintreePayPalRequest(amount: amount.toString());
        log(tokenizationKey["braintreeToken"]);
        try {
          final result = await Braintree.requestPaypalNonce(
            tokenizationKey["braintreeToken"],
            request,
          );
          _dialog.close();
        log(result.description);
        } catch(e){
          _dialog.close();
          handlePaymentFailure(e.toString());
        }
        // if(result["status"]=="completed"){
        //   handlePaymentSuccess("credit", result["value"]["paymentOrderId"]);
        // }
        // else if(result["status"]=="error"){
        //   handlePaymentFailure(result["error"]);
        // }
      }



    //  QueryResult resultPaypal = await paypalRepository.paypalPayNow(selectedAddressId);
    // log(resultPaypal.toString());
      // QueryResult resultCashFree =
      //     await cashfreeRepository.cashFreePayNow(selectedAddressId);

      // if (!resultCashFree.hasException && resultCashFree.data != null) {
      //   CashFreeResponse cashFreeResponse = CashFreeResponse();
      //   cashFreeResponse =
      //       CashFreeResponse.fromJson(resultCashFree.data["cashfreePayNow"]);
      //
      //   var tokenData = cashFreeResponse.token;
      //   if (paymentMethod == "nb") {
      //     Map<String, dynamic> inputParams = {
      //       "tokenData": tokenData,
      //       "orderId": cashFreeResponse.orderId,
      //       "orderAmount": cashFreeResponse.orderAmount,
      //       "customerName": cashFreeResponse.customerName,
      //       "orderNote": cashFreeResponse.orderNote,
      //       "orderCurrency": cashFreeResponse.orderCurrency,
      //       "appId": cashFreeResponse.appId,
      //       "customerPhone": cashFreeResponse.customerPhone,
      //       "customerEmail": cashFreeResponse.customerEmail,
      //       "stage": kReleaseMode ? 'PROD' : 'TEST',
      //       "notifyUrl": cashFreeResponse.notifyUrl,
      //     };
      //     CashfreePGSDK.doPayment(inputParams).then((value) async {
      //       log(value.toString());
      //       if (value["txStatus"] == "SUCCESS") {
      //         await handlePaymentSuccess(
      //             selectedAddressId, "nb", value["orderId"], value);
      //       } else {
      //         await handlePaymentFailure();
      //       }
      //     });
      //   } else {
      //     //await handlePaymentSuccess(selectedAddressId, "pod");
      //   }
      // } else {
      //   print(resultCashFree.exception);
      //   setState(() {
      //     buttonStatusOrder = !buttonStatusOrder;
      //   });
      //   final snackBar = SnackBar(
      //     backgroundColor: Colors.black,
      //     content: InkWell(
      //       onTap: () {
      //         Map<String, dynamic> data = {
      //           "id": EVENT_PAYMENT_TRY_AGAIN,
      //           "paymentType": paymentMethod,
      //           "event": "tap",
      //         };
      //         Tracking(event: EVENT_PAYMENT_TRY_AGAIN, data: data);
      //       },
      //       child: Center(
      //         child: Text(
      //           "Something went wrong",
      //           style: TextStyle(color: Colors.white),
      //         ),
      //       ),
      //     ),
      //   );
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // }
    }
  }

  handlePaymentSuccess(paymentMode, orderId) async {
    TzDialog _dialog = TzDialog(
        context, TzDialogType.progress);
    _dialog.show();
    await checkoutRepository.paySuccessPageHit(orderId);
    // FormData cashFreeData;
    // cashFreeData = FormData.fromMap({
    //   "txStatus":value["txStatus"],
    //   "txMessage":value["txMessage"],
    //   ""
    // });

   // bool response = await cashfreeRepository.captureCashFree(value);
    // log(response.toString());
    await Provider.of<CartViewModel>(context, listen: false)
        .changeStatus("loading");
    await Provider.of<OrderViewModel>(context, listen: false)
        .refreshOrderPage();
    QueryResult result = await checkoutRepository.order(orderId);
    print(result.data.toString());
    if (!result.hasException) {
      setState(() {
        buttonStatusOrder = !buttonStatusOrder;
      });
      CheckOutResponse checkoutResponse =
          CheckOutResponse.fromJson(result.data["order"]);
      _dialog.close();
      locator<NavigationService>()
          .pushReplacementNamed(routes.OrderConfirm, args: checkoutResponse);
    } else {
      _dialog.close();
      setState(() {
        buttonStatusOrder = !buttonStatusOrder;
      });
      print(result.exception);
      final snackBar = SnackBar(
        backgroundColor: Colors.black,
        content: InkWell(
          onTap: () {
            Map<String, dynamic> data = {
              "id": EVENT_ORDER_PLACEMENT_FAILURE,
              "paymentType": paymentMethod,
              //"cartValue" : value.cartResponse.subtotal.toString(),
              "paymentData": {},
              "event": "payment-failed",
            };
            Tracking(event: EVENT_ORDER_PLACEMENT_FAILURE, data: data);
          },
          child: Text(
            'Something went wrong.',
            style: TextStyle(color: Color(0xffffffff)),
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  handlePaymentFailure(error) {
    setState(() {
      buttonStatusOrder = !buttonStatusOrder;
    });
    final snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: InkWell(
        onTap: () {
          Map<String, dynamic> data = {
            "id": EVENT_ORDER_PLACEMENT_CANCEL,
            "paymentType": paymentMethod,
            //"cartValue" : value.cartResponse.subtotal.toString(),
            "paymentData": {},
            "event": "payment-failed"
          };
          Tracking(event: EVENT_ORDER_PLACEMENT_CANCEL, data: data);
        },
        child: Text(
          error,
          style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(14)),
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    height: ScreenUtil().setWidth(250),
                    width: ScreenUtil().setWidth(256),
                    child: Container(
                      child: Center(
                        child: Text('No Coupon Available'),
                      ),
                    ));
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
                                                value.couponResponse.data[index]
                                                    .code))
                                            ? Icon(
                                                Icons.check_box,
                                                color: AppColors.primaryElement,
                                                size: ScreenUtil().setWidth(18),
                                              )
                                            : Icon(
                                                Icons.check_box_outline_blank,
                                                color: AppColors.primaryElement,
                                                size: ScreenUtil().setWidth(18),
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
                                              value.couponResponse.data[index]
                                                  .code,
                                              style: TextStyle(
                                                  color: AppColors.primaryElement,
                                                  fontSize: ScreenUtil().setSp(
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
                                      "Saves upto ${store.currencySymbol} ${value.couponResponse.data[index].maxAmount}",
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
                    // Text("Maximum saving : ${store.currencySymbol} 125",style: TextStyle(color:Color(0xff7a7a7a),fontSize: ScreenUtil().setSp(13)),),
                    // SizedBox(height: ScreenUtil().setWidth(9),),
                    Container(
                        height: ScreenUtil().setWidth(36),
                        width: ScreenUtil().setWidth(224),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            side: BorderSide(
                                width: 2, color: AppColors.primaryElement),
                          ),
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
                          child: Text('Apply Coupon'),
                        ))
                  ],
                ),
              );
            }),
          );
        });
  }
}
