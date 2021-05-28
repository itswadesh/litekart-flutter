import 'dart:convert';
import 'package:anne/repository/address_repository.dart';
import 'package:anne/repository/cashfree_repository.dart';
import 'package:anne/repository/checkout_repository.dart';
import 'package:anne/response_handler/cashFreeResponse.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/values/route_path.dart' as routes;
import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:provider/provider.dart';
import 'package:anne/components/base/tz_dialog.dart';
import 'package:anne/enum/tz_dialog_type.dart';
import 'package:anne/response_handler/checkOutResponse.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/components/widgets/errorMessage.dart';
import 'package:anne/components/widgets/loading.dart';
import 'package:anne/view_model/address_view_model.dart';
import 'package:anne/utility/graphQl.dart';
import 'package:anne/components/widgets/buttonValue.dart';
import 'package:anne/components/widgets/cartEmptyMessage.dart';
import 'package:anne/view_model/cart_view_model.dart';

import 'menu/manage_order.dart';

class Checkout extends StatefulWidget {
  Checkout();

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
  CashfreeRepository cashfreeRepository = CashfreeRepository();
  var _formKey = GlobalKey<FormState>();
  var newAddress = true;
  String paymentMethod = "nb";
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
    ListItem(1, "2021"),
    ListItem(2, "2022"),
    ListItem(3, "2023"),
    ListItem(4, "2024"),
    ListItem(5, "2025"),
    ListItem(6, "2026"),
    ListItem(7, "2027"),
    ListItem(8, "2028"),
    ListItem(9, "2029"),
    ListItem(10, "2030"),
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
            "Billing Details",
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
            )
          ]),
      body: GraphQLProvider(
          client: graphQLConfiguration.initailizeClient(),
          child: CacheProvider(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Color(0xfff3f3f3),
                  child: getCartList()))),
    );
  }

  getBillCard() {
    return Consumer<CartViewModel>(
        builder: (BuildContext context, value, Widget child) {
      print("hi  " + value.cartResponse.items.length.toString());

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
                                  contentPadding:
                                      EdgeInsets.all(ScreenUtil().setWidth(10)),
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
                        Text(value.promocodeStatus ? "Applied" : "Not Applied",
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
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(
                  0, ScreenUtil().setWidth(17), 0, ScreenUtil().setWidth(13)),
              onPressed: () async {
                paymentHandle(value.selectedAddress.id);
              },
              color: Color(0xff00c32d),
              child: buttonValueWhite("PLACE ORDER", buttonStatusOrder),
            ),
          ),
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
      );
    });
  }

  getDeliveryOptionCard() {
    return Consumer<AddressViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.status == "loading") {
        Provider.of<AddressViewModel>(context, listen: false)
            .fetchAddressData();
        return Loading();
      } else if (value.status == "empty") {
        return Container(height: ScreenUtil().setWidth(20));
      } else if (value.status == "error") {
        return Container(
          height: ScreenUtil().setWidth(20),
        );
      }
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: value.addressResponse.data.length,
          itemBuilder: (BuildContext context, index) {
            return GestureDetector(
              onTap: () {},
              child: Material(
                  color: Color(0xfff3f3f3),
                  // borderRadius: BorderRadius.circular(2),
                  child: Card(
                    margin: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(26),
                        ScreenUtil().setWidth(20),
                        ScreenUtil().setWidth(26),
                        ScreenUtil().setWidth(26)),
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(32.33),
                          ScreenUtil().setWidth(36.33),
                          ScreenUtil().setWidth(29),
                          ScreenUtil().setWidth(33)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                await Provider.of<AddressViewModel>(context,
                                        listen: false)
                                    .selectAddress(
                                        value.addressResponse.data[index]);
                              },
                              child: (value.selectedAddress != null &&
                                      (value.selectedAddress.id ==
                                          value.addressResponse.data[index].id))
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Color(0xffee7625),
                                      size: ScreenUtil().setWidth(18),
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      color: Color(0xffee7625),
                                      size: ScreenUtil().setWidth(18),
                                    ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(9.33),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(245),
                              child: Text(
                                "${(value.addressResponse.data[index].firstName + " " + value.addressResponse.data[index].lastName) ?? "User"}",
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
                              EdgeInsets.only(left: ScreenUtil().setWidth(26)),
                          width: double.infinity,
                          child: Text(
                            "Address : " +
                                value.addressResponse.data[index].address
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
                              EdgeInsets.only(left: ScreenUtil().setWidth(26)),
                          width: double.infinity,
                          child: Text(
                            "Pin : " +
                                value.addressResponse.data[index].zip
                                    .toString(),
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
                              EdgeInsets.only(left: ScreenUtil().setWidth(26)),
                          width: double.infinity,
                          child: Text(
                            value.addressResponse.data[index].phone.toString(),
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
                              EdgeInsets.only(left: ScreenUtil().setWidth(26)),
                          width: double.infinity,
                          child: Text(
                            value.addressResponse.data[index].email.toString(),
                            style: TextStyle(
                                color: Color(0xff5f5f5f),
                                fontSize: ScreenUtil().setSp(
                                  15,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(26),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  primaryAddressBox = index;
                                });
                              },
                              child: primaryAddressBox == index
                                  ? Icon(
                                      Icons.check_box,
                                      color: Color(0xffee7625),
                                      size: ScreenUtil().setWidth(18),
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      color: Color(0xffee7625),
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
                          height: ScreenUtil().setWidth(36),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: ScreenUtil().setWidth(37),
                              width: ScreenUtil().setWidth(83),
                              child: RaisedButton(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(25),
                                    ScreenUtil().setWidth(11),
                                    ScreenUtil().setWidth(22),
                                    ScreenUtil().setWidth(11)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(5)),
                                    side: BorderSide(color: Color(0xffbb8738))),
                                color: Colors.white,
                                textColor: Color(0xffbb8738),
                                onPressed: () {
                                  addressId =
                                      value.addressResponse.data[index].id;
                                  _phone.text =
                                      value.addressResponse.data[index].phone;
                                  _address.text =
                                      value.addressResponse.data[index].address;
                                  _pin.text = value
                                      .addressResponse.data[index].zip
                                      .toString();
                                  _email.text =
                                      value.addressResponse.data[index].email;
                                  _town.text =
                                      value.addressResponse.data[index].town;
                                  _city.text =
                                      value.addressResponse.data[index].city;
                                  _country.text =
                                      value.addressResponse.data[index].country;
                                  _state.text =
                                      value.addressResponse.data[index].state;
                                  _firstName.text = value
                                      .addressResponse.data[index].firstName;
                                  _lastName.text = value
                                      .addressResponse.data[index].lastName;
                                  setState(() {
                                    newAddress = !newAddress;
                                  });
                                },
                                child: Text(
                                  "EDIT",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(
                                        15,
                                      ),
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(14),
                            ),
                            Container(
                              height: ScreenUtil().setWidth(37),
                              width: ScreenUtil().setWidth(83),
                              child: RaisedButton(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(14),
                                    ScreenUtil().setWidth(11),
                                    ScreenUtil().setWidth(8),
                                    ScreenUtil().setWidth(11)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(5)),
                                    side: BorderSide(color: Color(0xffbb8738))),
                                color: Colors.white,
                                textColor: Color(0xffbb8738),
                                onPressed: () async {
                                  await Provider.of<AddressViewModel>(context,
                                          listen: false)
                                      .deleteAddress(
                                          value.addressResponse.data[index].id);
                                },
                                child: Text(
                                  "REMOVE",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(
                                        15,
                                      ),
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                  )),
            );
          });
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
                                border: Border.all(color: Color(0xffba8638)),
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().radius(20))),
                            child: Center(
                                child: Icon(
                              Icons.check_circle,
                              color: Color(0xffba8638),
                              size: ScreenUtil().setWidth(15),
                            )),
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(13),
                          ),
                          Text(
                            "Cart",
                            style: TextStyle(
                                color: Color(0xffba8638),
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
                            dashColor: Color(0xffba8638),
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
                                        color: Color(0xffba8638),
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
                                            color: Color(0xffba8638)),
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().radius(20))),
                                    child: Center(
                                        child: Icon(
                                      Icons.check_circle,
                                      color: Color(0xffba8638),
                                      size: ScreenUtil().setWidth(15),
                                    )),
                                  ),
                            SizedBox(
                              height: ScreenUtil().setWidth(13),
                            ),
                            Text(
                              "Address",
                              style: TextStyle(
                                  color: Color(0xffba8638),
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
                            dashColor: Color(0xffba8638),
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
                        if (Provider.of<AddressViewModel>(context,
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
                                            color: Color(0xffba8638)),
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().radius(20))),
                                    child: Center(
                                        child: Text(
                                      "3",
                                      style: TextStyle(
                                          color: Color(0xffba8638),
                                          fontSize: ScreenUtil().setSp(
                                            12,
                                          )),
                                    )),
                                  )
                                : Container(
                                    height: ScreenUtil().setWidth(20),
                                    width: ScreenUtil().setWidth(20),
                                    decoration: BoxDecoration(
                                        color: Color(0xffba8638),
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
                              height: ScreenUtil().setWidth(13),
                            ),
                            Text(
                              "Payment",
                              style: TextStyle(
                                  color: Color(0xffba8638),
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
                  ? (newAddress ? getExistingAddress() : addNewAddress())
                  : getPaymentOption(),
              Container(
                child: getBillCard(),
              ),
              SizedBox(
                height: 25,
              ),
              addressPage
                  ? Container()
                  : Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      color: Color(0xffba8638),
                      child: Text(
                        "© 2020 anne India Private Limited",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
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
                              "Order Total: ₹ " +
                                  (value.cartResponse.subtotal -
                                          value.cartResponse.discount.amount +
                                          value.cartResponse.tax +
                                          value.cartResponse.shipping)
                                      .toString()
                              //"$total"
                              ,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 18));
                        }),
                        Consumer<AddressViewModel>(builder:
                            (BuildContext context, value, Widget child) {
                          return Container(
                            width: 110,
                            child: RaisedButton(
                              color: value.selectedAddress != null
                                  ? Color(0xffee7625)
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
                        })
                      ],
                    )),
              )
            : Container(),
      ],
    );
  }

  getExistingAddress() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(24), 0, 0, 0),
          margin: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(27), 0, 0),
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
        getDeliveryOptionCard(),
        Container(
          width: ScreenUtil().setWidth(362),
          height: ScreenUtil().setWidth(42),
          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(26), 0,
              ScreenUtil().setWidth(26), ScreenUtil().setWidth(26)),
          child: RaisedButton(
            padding: EdgeInsets.fromLTRB(
                0, ScreenUtil().setWidth(12), 0, ScreenUtil().setWidth(12)),
            onPressed: () {
              setState(() {
                newAddress = !newAddress;
              });
            },
            color: Colors.blue,
            child: Text(
              "+ ADD NEW ADDRESS",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(
                    18,
                  ),
                  color: Colors.white),
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
                  if (value.isEmpty) {
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
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: "First Name *",
                    hintStyle: TextStyle(
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
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: "Last Name *",
                    hintStyle: TextStyle(
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
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: "Email",
                    hintStyle: TextStyle(
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
                    return 'Phone Number is Required';
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
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: "Phone",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: ScreenUtil().setSp(
                          15,
                        ))),
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
                    TzDialog _dialog = TzDialog(context, TzDialogType.progress);
                    _dialog.show();
                    final AddressRepository addressRepository = AddressRepository();
                    var result = await addressRepository.fetchDataFromZip(value);
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
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: "Zip code",
                    hintStyle: TextStyle(
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
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: "City *",
                    hintStyle: TextStyle(
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
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: "State",
                    hintStyle: TextStyle(
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
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: "Country *",
                    hintStyle: TextStyle(
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
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: "Address",
                    hintStyle: TextStyle(
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
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: "Town",
                    hintStyle: TextStyle(
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
                            color: Color(0xffee7625),
                            size: ScreenUtil().setWidth(18),
                          )
                        : Icon(
                            Icons.check_box_outline_blank,
                            color: Color(0xffee7625),
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

                child: RaisedButton(
                  //  padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
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
                          backgroundColor: Colors.white,
                          content: Text(
                            'Something went wrong. Please Try Again!!',
                            style: TextStyle(color: Color(0xffee7625)),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  color: Color(0xff098DFF),
                  child: buttonValueWhite("ADD ADDRESS", buttonStatusAddress),
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
      child: Column(
        children: [
          // creditCard(),
          // SizedBox(
          //   height: ScreenUtil().setWidth(15),
          // ),
          // paypalCard(),
          // SizedBox(
          //   height: ScreenUtil().setWidth(15),
          // ),
          podCard(),
          SizedBox(
            height: ScreenUtil().setWidth(15),
          ),
          // upiCard(),
          // SizedBox(
          //   height: ScreenUtil().setWidth(15),
          // ),
          netBankingCard()
        ],
      ),
    );
  }

  // creditCard() {
  //   return Container(
  //       padding: EdgeInsets.fromLTRB(
  //           ScreenUtil().setWidth(26),
  //           ScreenUtil().setWidth(30),
  //           ScreenUtil().setWidth(17),
  //           ScreenUtil().setWidth(22)),
  //       decoration: BoxDecoration(
  //           border: Border.all(
  //               color: paymentMethod == "credit"
  //                   ? Color(0xff098dff)
  //                   : Color(0xff707070),
  //               width: ScreenUtil().setWidth(0.9)),
  //           borderRadius: BorderRadius.circular(ScreenUtil().setWidth(3))),
  //       child: Column(
  //         children: [
  //           Row(
  //             children: [
  //               InkWell(
  //                   onTap: () {
  //                     setState(() {
  //                       paymentMethod = "credit";
  //                     });
  //                   },
  //                   child: paymentMethod == "credit"
  //                       ? Icon(
  //                           Icons.adjust_sharp,
  //                           color: Color(0xff098dff),
  //                         )
  //                       : Icon(
  //                           Icons.panorama_fish_eye,
  //                           color: Color(0xff707070),
  //                         )),
  //               SizedBox(
  //                 width: ScreenUtil().setWidth(19),
  //               ),
  //               Column(children: [
  //                 Text(
  //                   "Credit/Debit card",
  //                   style: TextStyle(
  //                       color: Color(0xff6d6d6d),
  //                       fontSize: ScreenUtil().setSp(14)),
  //                 ),
  //                 Text(
  //                   "(no cost EMI available)",
  //                   style: TextStyle(
  //                       color: Color(0xff6d6d6d),
  //                       fontSize: ScreenUtil().setSp(10)),
  //                 )
  //               ]),
  //               SizedBox(
  //                 width: ScreenUtil().setWidth(40),
  //               ),
  //               Container(
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                         height: ScreenUtil().setWidth(18),
  //                         width: ScreenUtil().setWidth(32),
  //                         decoration: BoxDecoration(
  //                             border: Border.all(color: Color(0xff707070))),
  //                         child: Image.asset(
  //                           "assets/images/masterCard.png",
  //                         )),
  //                     SizedBox(
  //                       width: ScreenUtil().setWidth(3),
  //                     ),
  //                     Container(
  //                         height: ScreenUtil().setWidth(18),
  //                         width: ScreenUtil().setWidth(32),
  //                         decoration: BoxDecoration(
  //                             border: Border.all(color: Color(0xff707070))),
  //                         child: Image.asset("assets/images/rupayCard.png")),
  //                     SizedBox(
  //                       width: ScreenUtil().setWidth(3),
  //                     ),
  //                     Container(
  //                         height: ScreenUtil().setWidth(18),
  //                         width: ScreenUtil().setWidth(32),
  //                         decoration: BoxDecoration(
  //                             border: Border.all(color: Color(0xff707070))),
  //                         child: Image.asset(
  //                           "assets/images/visaCard.png",
  //                         )),
  //                     SizedBox(
  //                       width: ScreenUtil().setWidth(3),
  //                     ),
  //                     Container(
  //                         height: ScreenUtil().setWidth(18),
  //                         width: ScreenUtil().setWidth(32),
  //                         decoration: BoxDecoration(
  //                             border: Border.all(color: Color(0xff707070))),
  //                         child: Image.asset(
  //                           "assets/images/americanCard.png",
  //                         )),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: ScreenUtil().setWidth(23),
  //           ),
  //           Container(
  //             width: double.infinity,
  //             child: Text(
  //               "Card Number",
  //               style: TextStyle(
  //                   color: Color(0xffba8638),
  //                   fontSize: ScreenUtil().setWidth(14)),
  //               textAlign: TextAlign.left,
  //             ),
  //           ),
  //           SizedBox(
  //             height: ScreenUtil().setWidth(11),
  //           ),
  //           Container(
  //             height: ScreenUtil().setWidth(50),
  //             child: TextField(
  //               controller: cardNumber,
  //               decoration: InputDecoration(
  //                   fillColor: Colors.white,
  //                   filled: true,
  //                   enabledBorder: OutlineInputBorder(
  //                     borderSide:
  //                         BorderSide(color: Color(0xff707070), width: 1.0),
  //                   ),
  //                   focusedBorder: OutlineInputBorder(
  //                     borderSide:
  //                         BorderSide(color: Color(0xff707070), width: 1.0),
  //                   ),
  //                   hintText: "xxxx - xxxx - xxxx - xxxx",
  //                   hintStyle: TextStyle(
  //                       color: Color(0xff525252),
  //                       fontSize: ScreenUtil().setSp(13))),
  //               keyboardType: TextInputType.number,
  //             ),
  //           ),
  //           SizedBox(
  //             height: 18,
  //           ),
  //           Container(
  //             width: double.infinity,
  //             child: Text(
  //               "Card Holder Name",
  //               style: TextStyle(
  //                   color: Color(0xffba8638),
  //                   fontSize: ScreenUtil().setWidth(14)),
  //               textAlign: TextAlign.left,
  //             ),
  //           ),
  //           SizedBox(
  //             height: ScreenUtil().setWidth(11),
  //           ),
  //           Container(
  //             height: ScreenUtil().setWidth(50),
  //             child: TextField(
  //               controller: cardHolder,
  //               decoration: InputDecoration(
  //                   fillColor: Colors.white,
  //                   filled: true,
  //                   enabledBorder: OutlineInputBorder(
  //                     borderSide:
  //                         BorderSide(color: Color(0xff707070), width: 1.0),
  //                   ),
  //                   focusedBorder: OutlineInputBorder(
  //                     borderSide:
  //                         BorderSide(color: Color(0xff707070), width: 1.0),
  //                   ),
  //                   hintText: "John",
  //                   hintStyle: TextStyle(
  //                       color: Color(0xff525252),
  //                       fontSize: ScreenUtil().setSp(13))),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 18,
  //           ),
  //           Row(
  //             children: [
  //               Container(
  //                 child: Text(
  //                   "Expire Month",
  //                   style: TextStyle(
  //                       color: Color(0xffba8638),
  //                       fontSize: ScreenUtil().setSp(14)),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: ScreenUtil().setWidth(10),
  //               ),
  //               Container(
  //                 child: Text(
  //                   "Expire Year",
  //                   style: TextStyle(
  //                       color: Color(0xffba8638),
  //                       fontSize: ScreenUtil().setSp(14)),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: ScreenUtil().setWidth(25),
  //               ),
  //               Container(
  //                 child: Text(
  //                   "Security Code",
  //                   style: TextStyle(
  //                       color: Color(0xffba8638),
  //                       fontSize: ScreenUtil().setSp(14)),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 11,
  //           ),
  //           Row(
  //             children: [
  //               Container(
  //                   decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       border: Border.all(color: Color(0xff707070)),
  //                       borderRadius:
  //                           BorderRadius.circular(ScreenUtil().setWidth(3))),
  //                   padding: EdgeInsets.only(left: 5),
  //                   height: ScreenUtil().setWidth(40),
  //                   width: ScreenUtil().setWidth(72),
  //                   child: DropdownButtonHideUnderline(
  //                       child: DropdownButton<ListItem>(
  //                           value: _selectedMonth,
  //                           items: _dropdownMonthItems,
  //                           onChanged: (value) {
  //                             setState(() {
  //                               _selectedMonth = value;
  //                             });
  //                           }))),
  //               SizedBox(
  //                 width: ScreenUtil().setWidth(25),
  //               ),
  //               Container(
  //                   decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       border: Border.all(color: Color(0xff707070)),
  //                       borderRadius:
  //                           BorderRadius.circular(ScreenUtil().setWidth(3))),
  //                   padding: EdgeInsets.only(left: 5),
  //                   height: ScreenUtil().setWidth(40),
  //                   width: ScreenUtil().setWidth(85),
  //                   child: DropdownButtonHideUnderline(
  //                       child: DropdownButton<ListItem>(
  //                           value: _selectedYear,
  //                           items: _dropdownYearItems,
  //                           onChanged: (value) {
  //                             setState(() {
  //                               _selectedYear = value;
  //                             });
  //                           }))),
  //               SizedBox(
  //                 width: ScreenUtil().setWidth(11),
  //               ),
  //               Container(
  //                 padding: EdgeInsets.only(left: 5),
  //                 height: ScreenUtil().setWidth(40),
  //                 width: ScreenUtil().setWidth(120),
  //                 color: Colors.white,
  //                 child: TextField(
  //                   controller: cvv,
  //                   decoration: InputDecoration(
  //                       fillColor: Colors.white,
  //                       filled: true,
  //                       enabledBorder: OutlineInputBorder(
  //                         borderSide:
  //                             BorderSide(color: Color(0xff707070), width: 1.0),
  //                       ),
  //                       focusedBorder: OutlineInputBorder(
  //                         borderSide:
  //                             BorderSide(color: Color(0xff707070), width: 1.0),
  //                       ),
  //                       hintText: "Three-digit",
  //                       hintStyle: TextStyle(
  //                           color: Color(0xff525252),
  //                           fontSize: ScreenUtil().setSp(13))),
  //                   keyboardType: TextInputType.number,
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: ScreenUtil().setWidth(5),
  //               ),
  //               Container(
  //                 padding: EdgeInsets.only(top: ScreenUtil().setWidth(3)),
  //                 height: ScreenUtil().setWidth(20),
  //                 width: ScreenUtil().setWidth(20),
  //                 decoration: BoxDecoration(
  //                     border: Border.all(color: Color(0xff707070)),
  //                     borderRadius:
  //                         BorderRadius.circular(ScreenUtil().setWidth(20))),
  //                 child: Center(
  //                     child: Text(
  //                   "?",
  //                   style: TextStyle(
  //                       color: Color(0xff707070),
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: ScreenUtil().setSp(13)),
  //                 )),
  //               )
  //             ],
  //           ),
  //         ],
  //       ));
  // }
  //
  // paypalCard() {
  //   return Container(
  //     padding: EdgeInsets.fromLTRB(
  //         ScreenUtil().setWidth(26),
  //         ScreenUtil().setWidth(30),
  //         ScreenUtil().setWidth(17),
  //         ScreenUtil().setWidth(22)),
  //     decoration: BoxDecoration(
  //         border: Border.all(
  //             color: paymentMethod == "paypal"
  //                 ? Color(0xff098dff)
  //                 : Color(0xff707070),
  //             width: ScreenUtil().setWidth(0.9)),
  //         borderRadius: BorderRadius.circular(ScreenUtil().setWidth(3))),
  //     child: Row(
  //       children: [
  //         InkWell(
  //             onTap: () {
  //               setState(() {
  //                 paymentMethod = "paypal";
  //               });
  //             },
  //             child: paymentMethod == "paypal"
  //                 ? Icon(
  //                     Icons.adjust_sharp,
  //                     color: Color(0xff098dff),
  //                   )
  //                 : Icon(
  //                     Icons.panorama_fish_eye,
  //                     color: Color(0xff707070),
  //                   )),
  //         SizedBox(
  //           width: ScreenUtil().setWidth(19),
  //         ),
  //         Text(
  //           "Paypal",
  //           style: TextStyle(
  //               color: Color(0xff6d6d6d), fontSize: ScreenUtil().setSp(14)),
  //         ),
  //         SizedBox(
  //           width: ScreenUtil().setWidth(214),
  //         ),
  //         Container(
  //           child: Row(
  //             children: [
  //               Container(
  //                   height: ScreenUtil().setWidth(18),
  //                   width: ScreenUtil().setWidth(32),
  //                   child: Image.asset(
  //                     "assets/images/paypal.png",
  //                   )),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  podCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(26),
          ScreenUtil().setWidth(30),
          ScreenUtil().setWidth(17),
          ScreenUtil().setWidth(22)),
      decoration: BoxDecoration(
          border: Border.all(
              color: paymentMethod == "pod"
                  ? Color(0xff098dff)
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
                      color: Color(0xff098dff),
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
  //                 ? Color(0xff098dff)
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
  //                     color: Color(0xff098dff),
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
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(26),
            ScreenUtil().setWidth(30),
            ScreenUtil().setWidth(17),
            ScreenUtil().setWidth(22)),
        decoration: BoxDecoration(
            border: Border.all(
                color: paymentMethod == "nb"
                    ? Color(0xff098dff)
                    : Color(0xff707070),
                width: ScreenUtil().setWidth(0.9)),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(3))),
        child: Column(children: [
          Row(
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
                          color: Color(0xff098dff),
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
              SizedBox(
                width: ScreenUtil().setWidth(50),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                        height: ScreenUtil().setWidth(18),
                        width: ScreenUtil().setWidth(32),
                        child: Icon(
                          Icons.account_balance,
                          color: Color(0xff707070),
                          size: ScreenUtil().setWidth(22),
                        )),
                  ],
                ),
              ),
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
          //         color: Color(0xffba8638),
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
    if (buttonStatusOrder) {
      setState(() {
        buttonStatusOrder = !buttonStatusOrder;
      });

      QueryResult resultCashFree = await cashfreeRepository.cashFreePayNow(selectedAddressId);

      if (!resultCashFree.hasException && resultCashFree.data != null) {
          CashFreeResponse cashFreeResponse = CashFreeResponse();
          cashFreeResponse = CashFreeResponse.fromJson(resultCashFree.data["cashfreePayNow"]);

        var tokenData = cashFreeResponse.token;
        // if (paymentMethod == "credit") {
        //   Map<String, dynamic> inputParams = {
        //     "tokenData": tokenData,
        //     "orderId": resultCashFree.data["cashfreePayNow"]["orderId"],
        //     "orderAmount": resultCashFree.data["cashfreePayNow"]["orderAmount"],
        //     "customerName": resultCashFree.data["cashfreePayNow"]
        //         ["customerName"],
        //     "orderNote": resultCashFree.data["cashfreePayNow"]["orderNote"],
        //     "orderCurrency": resultCashFree.data["cashfreePayNow"]
        //         ["orderCurrency"],
        //     "appId": resultCashFree.data["cashfreePayNow"]["appId"],
        //     "customerPhone": resultCashFree.data["cashfreePayNow"]
        //         ["customerPhone"],
        //     "customerEmail": resultCashFree.data["cashfreePayNow"]
        //         ["customerEmail"],
        //     "stage": resultCashFree.data["cashfreePayNow"]["stage"],
        //     "notifyUrl": resultCashFree.data["cashfreePayNow"]["notifyUrl"],
        //     "paymentOption": "card",
        //     "card_number": cardNumber.text.toString().replaceAll("-", ""),
        //     "card_expiryMonth": _selectedMonth.name,
        //     "card_expiryYear": _selectedYear.name,
        //     "card_holder": cardHolder.text,
        //     "card_cvv": cvv.text
        //   };
        //   CashfreePGSDK.doPayment(inputParams).then((value) async {
        //     print(value["txStatus"]);
        //     print(value["txMsg"]);
        //     if (value["txStatus"] == "SUCCESS") {
        //       await handlePaymentSuccess(selectedAddressId, "card");
        //     } else {
        //       await handlePaymentFailure();
        //     }
        //   });
        // } else if (paymentMethod == "upi") {
        //   Map<String, dynamic> inputParams = {
        //     "tokenData": tokenData,
        //     "orderId": resultCashFree.data["cashfreePayNow"]["orderId"],
        //     "orderAmount": resultCashFree.data["cashfreePayNow"]["orderAmount"],
        //     "customerName": resultCashFree.data["cashfreePayNow"]
        //         ["customerName"],
        //     "orderNote": resultCashFree.data["cashfreePayNow"]["orderNote"],
        //     "orderCurrency": resultCashFree.data["cashfreePayNow"]
        //         ["orderCurrency"],
        //     "appId": resultCashFree.data["cashfreePayNow"]["appId"],
        //     "customerPhone": resultCashFree.data["cashfreePayNow"]
        //         ["customerPhone"],
        //     "customerEmail": resultCashFree.data["cashfreePayNow"]
        //         ["customerEmail"],
        //     "stage": resultCashFree.data["cashfreePayNow"]["stage"],
        //     "notifyUrl": resultCashFree.data["cashfreePayNow"]["notifyUrl"],
        //   };
        //   CashfreePGSDK.doUPIPayment(inputParams).then((value) async {
        //     if (value["txStatus"] == "SUCCESS") {
        //       await handlePaymentSuccess(selectedAddressId, "upi");
        //     } else {
        //       await handlePaymentFailure();
        //     }
        //   });
        // } else if (paymentMethod == "paypal") {
        //   Map<String, dynamic> inputParams = {
        //     "tokenData": tokenData,
        //     "orderId": resultCashFree.data["cashfreePayNow"]["orderId"],
        //     "orderAmount": resultCashFree.data["cashfreePayNow"]["orderAmount"],
        //     "customerName": resultCashFree.data["cashfreePayNow"]
        //         ["customerName"],
        //     "orderNote": resultCashFree.data["cashfreePayNow"]["orderNote"],
        //     "orderCurrency": resultCashFree.data["cashfreePayNow"]
        //         ["orderCurrency"],
        //     "appId": resultCashFree.data["cashfreePayNow"]["appId"],
        //     "customerPhone": resultCashFree.data["cashfreePayNow"]
        //         ["customerPhone"],
        //     "customerEmail": resultCashFree.data["cashfreePayNow"]
        //         ["customerEmail"],
        //     "stage": resultCashFree.data["cashfreePayNow"]["stage"],
        //     "notifyUrl": resultCashFree.data["cashfreePayNow"]["notifyUrl"],
        //     // "paymentOption": "paypal",
        //   };
        //   CashfreePGSDK.doPayment(inputParams).then((value) async {
        //     print(value["txMsg"]);
        //     if (value["txStatus"] == "SUCCESS") {
        //       await handlePaymentSuccess(selectedAddressId, "paypal");
        //     } else {
        //       await handlePaymentFailure();
        //     }
        //   });
        // } else
         if (paymentMethod == "nb") {
          Map<String, dynamic> inputParams = {
            "tokenData": tokenData,
            "orderId": cashFreeResponse.orderId,
            "orderAmount": cashFreeResponse.orderAmount,
            "customerName": cashFreeResponse.customerName,
            "orderNote": cashFreeResponse.orderNote,
            "orderCurrency": cashFreeResponse.orderCurrency,
            "appId": cashFreeResponse.appId,
            "customerPhone": cashFreeResponse.customerPhone,
            "customerEmail": cashFreeResponse.customerEmail,
            "stage": cashFreeResponse.stage,
            "notifyUrl": cashFreeResponse.notifyUrl,
          };
          CashfreePGSDK.doPayment(inputParams).then((value) async {
            print(value["txMsg"]);
            if (value["txStatus"] == "SUCCESS") {
              await handlePaymentSuccess(selectedAddressId, "nb");
            } else {
              await handlePaymentFailure();
            }
          });
        } else {
          await handlePaymentSuccess(selectedAddressId, "pod");
        }
      } else {
        print(resultCashFree.exception);
        setState(() {
          buttonStatusOrder = !buttonStatusOrder;
        });
        final snackBar = SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Something went wrong",
            style: TextStyle(color: Color(0xffee7625)),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  handlePaymentSuccess(addressId, paymentMode) async {
    QueryResult result = await checkoutRepository.checkout(addressId, paymentMode);
    if (!result.hasException) {
      setState(() {
        buttonStatusOrder = !buttonStatusOrder;
      });
      CheckOutResponse checkoutResponse =
          CheckOutResponse.fromJson(result.data["checkout"]);
      locator<NavigationService>().pushReplacementNamed(routes.OrderConfirm,args: checkoutResponse);
    } else {
      setState(() {
        buttonStatusOrder = !buttonStatusOrder;
      });
      print(result.exception);
      final snackBar = SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          'Something went wrong.',
          style: TextStyle(color: Color(0xffee7625)),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  handlePaymentFailure() {
    setState(() {
      buttonStatusOrder = !buttonStatusOrder;
    });
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        'Payment Failed !!',
        style: TextStyle(
            color: Color(0xffee7625), fontSize: ScreenUtil().setSp(14)),
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
