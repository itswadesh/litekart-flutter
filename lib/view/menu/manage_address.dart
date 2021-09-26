import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../components/base/tz_dialog.dart';
import '../../components/widgets/cartEmptyMessage.dart';
import '../../components/widgets/errorMessage.dart';
import '../../components/widgets/loading.dart';
import '../../enum/tz_dialog_type.dart';
import '../../repository/address_repository.dart';
import '../../values/colors.dart';
import '../../view/cart_logo.dart';
import '../../view_model/address_view_model.dart';
import '../../view_model/auth_view_model.dart';

class ManageAddress extends StatefulWidget {
  @override
  _ManageAddressState createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  var _formKey = GlobalKey<FormState>();

  bool newAddress = true;
  bool addressPage = true;
  bool defaultAddress = true;
  var primaryAddressBox = -1;
  var buttonStatusAddress = true;
  var buttonStatusOrder = true;
  String addressId = "new";
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Color(0xff616161),
            ),
          ),
          title: Center(
              // width: MediaQuery.of(context).size.width * 0.39,
              child: Text(
            "My Address",
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
                child: CartLogo(25)),
            SizedBox(width: ScreenUtil().setWidth(20),)
          ],
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Color(0xfff3f3f3),
            child: SingleChildScrollView(
            child: newAddress ? getExistingAddress() : addNewAddress())));
  }

  getExistingAddress() {
    return Column(
      children: [
        getDeliveryOptionCard(),
        SizedBox(height: ScreenUtil().setWidth(25),),
        InkWell(
          onTap: () {
            setState(() {
              _phone.text = Provider.of<ProfileModel>(context, listen: false)
                      .user
                      .phone ??
                  "";
              _firstName.text =
                  Provider.of<ProfileModel>(context, listen: false)
                          .user
                          .firstName ??
                      "";
              _lastName.text = Provider.of<ProfileModel>(context, listen: false)
                      .user
                      .lastName ??
                  "";
              _email.text = Provider.of<ProfileModel>(context, listen: false)
                      .user
                      .email ??
                  "";
              newAddress = !newAddress;
            });
          },
          child: Container(
            height: 43,
            width: MediaQuery.of(context).size.width * 0.80,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryElement, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add New Address",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryElement,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setWidth(25),)
      ],
    );
  }

  addNewAddress() {
    return ChangeNotifierProvider(
        create: (BuildContext context) => AddressViewModel(),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(27),
              ScreenUtil().setWidth(30),
              ScreenUtil().setWidth(25),
              ScreenUtil().setWidth(32)),
          margin: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setWidth(10)),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          0, ScreenUtil().setWidth(0), 0, ScreenUtil().setWidth(27)),
                      width: double.infinity,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Add New Address",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(
                                    17,
                                  ),
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff525252)),
                            ),
                            InkWell(
                              onTap: () {
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
                                  newAddress = !newAddress;
                                });
                              },
                              child: Center(
                                child: Icon(
                                  Icons.cancel,
                                  size: ScreenUtil().setWidth(22),
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ])),
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
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
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
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
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
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
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
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
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
                        TzDialog _dialog =
                            TzDialog(context, TzDialogType.progress);
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
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
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
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
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
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
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
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
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
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
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
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
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
                  InkWell(
                    onTap: () async {
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
                        //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

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
                            buttonStatusAddress = !buttonStatusAddress;
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
                              style: TextStyle(color: AppColors.primaryElement),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    child: Container(
                      height: 43,
                      width: MediaQuery.of(context).size.width * 0.80,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.primaryElement, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add New Address",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryElement,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }

  getDeliveryOptionCard() {
    return Consumer<AddressViewModel>(
        builder: (BuildContext context, value, Widget child) {
      if (value.status == "loading") {
        Provider.of<AddressViewModel>(context, listen: false)
            .fetchAddressData();
        return Loading();
      } else if (value.status == "empty") {
        return Container(child: cartEmptyMessage("search", "No Address Found"));
      } else if (value.status == "error") {
        return InkWell(
            onTap: () async {
              await Provider.of<AddressViewModel>(context, listen: false)
                  .changeStatus("loading");
            },
            child: Container(
                child: errorMessage()));
      }
      return Column(children: [
        Container(
          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0, 0, 0),
          margin: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(20), 0, ScreenUtil().setWidth(20)),
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
                  await Provider.of<AddressViewModel>(context, listen: false)
                      .selectAddress(value.addressResponse.data[index]);
                },
                child: Material(
                    //    color: Color(0xfff3f3f3),
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
                    padding:EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                    child: Column(children:[
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
                                      value.addressResponse.data[index].id))
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
                              value.addressResponse.data[index].zip.toString(),
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
                      ),])),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          InkWell(
                              onTap: () async {
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
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(color: Color(0xffd3d3d3))
                                    )
                                ),
                                width: ScreenUtil().setWidth(150),
                                height: ScreenUtil().setWidth(30),
                                child: Center(
                                  child: Text("EDIT",style: TextStyle(color: AppColors.primaryElement),),
                                ),
                              )),

                          InkWell(
                              onTap: () async {
                                await Provider.of<AddressViewModel>(context,
                                    listen: false)
                                    .deleteAddress(
                                    value.addressResponse.data[index].id);
                              },
                              child: Container(
                                width: ScreenUtil().setWidth(215),
                                height: ScreenUtil().setWidth(30),
                                child: Center(
                                  child: Text("REMOVE",style: TextStyle(color: AppColors.primaryElement),),
                                ),
                              ))
                        ],
                      ),
                      Divider(height: 1,),
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
                )),
              );
            })
      ]);
    });
  }
}
