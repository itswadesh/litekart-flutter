import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/graphQl.dart';
import '../../utility/locator.dart';
import '../../values/colors.dart';
import '../../components/login/pin_code_fields.dart';
import '../../view_model/auth_view_model.dart';
import '../../values/route_path.dart' as routes;
import '../../view_model/cart_view_model.dart';
import '../../view_model/login_view_model.dart';
import 'package:provider/provider.dart';
import './login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cPasswordController = TextEditingController();
  FocusNode _focusNode;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isCheckBox = true;

  @override
  void initState() {
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    super.initState();

  }





  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RegisterViewModel(),
      child: Consumer<RegisterViewModel>(
        builder: (context, model, child) =>  Scaffold(
              key: scaffoldKey,
              body: loadUi(model),
            ),
      ),
    );
  }

  Widget loadUi(RegisterViewModel model) {
    return SingleChildScrollView(child: Container(
      decoration: BoxDecoration(color: Color(0xFFF6F6f6)),
      child: Container(
        padding: EdgeInsets.only(left:ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
        //  color: Colors.white70,
        child: Column(children:[
          SizedBox(height: ScreenUtil().setWidth(60),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              skipStatus ? Container(): InkWell(
                  onTap: () {
                    locator<NavigationService>().pop();
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(
                          0, 0, ScreenUtil().setWidth(8), 0),
                      width: ScreenUtil().radius(45),
                      height: ScreenUtil().radius(45),
                      decoration: new BoxDecoration(
                        color: Color(0xffd3d3d3),
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
              skipStatus ?  GestureDetector(
                onTap: () {
                  locator<NavigationService>()
                      .pushNamedAndRemoveUntil(routes.HomeRoute);
                },
                child: Container(
                  width: ScreenUtil().setWidth(85),
                  height: ScreenUtil().setWidth(35),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Skip",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ):Container()
            ],
          ),
          SizedBox(height: ScreenUtil().setWidth(20),),
          Card(
            elevation: 0,
            color: Color(0xe0ffffff),
            child: Column(children: [
              SizedBox(height: ScreenUtil().setWidth(25)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: ScreenUtil().setWidth(60),
                    width: ScreenUtil().setWidth(60),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setWidth(20),
              ),
              Text(
                "Register New User Here",
                style:
                TextStyle(color: AppColors.primaryElement, fontSize: 18),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Image.asset("assets/images/facebook.png"),
              //     SizedBox(
              //       width: 15,
              //     ),
              //     Image.asset("assets/images/linkedin.png"),
              //     SizedBox(
              //       width: 15,
              //     ),
              //     Image.asset("assets/images/google.png"),
              //   ],
              // ),
              SizedBox(
                height: ScreenUtil().setWidth(35),
              ),
              Container(
                  height: ScreenUtil().setWidth(60),
                  margin: EdgeInsets.only(top: 0,left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _emailController,

                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(20),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: "Email",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                    ),
                  )),

              SizedBox(
                height: ScreenUtil().setWidth(20),
              ),
              Container(
                  height: ScreenUtil().setWidth(60),
                  margin: EdgeInsets.only(top: 0,left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                  child: TextField(
                    controller: _firstNameController,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(20),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: "First Name",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                    ),
                  )),

              SizedBox(
                height: ScreenUtil().setWidth(20),
              ),
              Container(
                  height: ScreenUtil().setWidth(60),
                  margin: EdgeInsets.only(top: 0,left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                  child: TextField(
                    controller: _lastNameController,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(20),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: "Last Name",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                    ),
                  )),

              SizedBox(
                height: ScreenUtil().setWidth(20),
              ),
              Container(
                  height: ScreenUtil().setWidth(60),
                  margin: EdgeInsets.only(top: 0,left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(20),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: "Password",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                    ),
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(20),
              ),
              Container(
                  height: ScreenUtil().setWidth(60),
                  margin: EdgeInsets.only(top: 0,left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                  child: TextField(
                    obscureText: true,
                    controller: _cPasswordController,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(20),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: "Confirm Password",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                    ),
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(25),
              ),
              InkWell(
                onTap: () async {
                  _focusNode.unfocus();
                  await model.register(_emailController.text,_passwordController.text,_cPasswordController.text,_firstNameController.text,_lastNameController.text);
                  if (model.registerStatus) {
                    token = tempToken;
                    await Provider.of<ProfileModel>(context, listen: false)
                        .getProfile();
                    await Provider.of<CartViewModel>(context, listen: false)
                        .changeStatus("loading");
                    locator<NavigationService>()
                        .pushNamedAndRemoveUntil(routes.HomeRoute);
                  } else {
                    final snackBar = SnackBar(
                      content: Text('Something went Wrong !!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Container(

                  width: ScreenUtil().setWidth(324),
                  height: ScreenUtil().setHeight(45),
                  decoration: BoxDecoration(
                    color: AppColors.primaryElement,
                    border: Border.all(
                        color:  AppColors.primaryElement,
                        width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "REGISTER",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:Color(0xffffffff),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(30),
              ),
              Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: ScreenUtil().setWidth(100),
                      child: Divider(),
                    ),
                    Text("   OR   ",style: TextStyle(fontSize: ScreenUtil().setSp(17)),),
                    Container(width: ScreenUtil().setWidth(100),
                      child: Divider(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(30),
              ),
              Container(
                  width: ScreenUtil().setWidth(324),
                  height: ScreenUtil().setHeight(45),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      side: BorderSide(
                          width: 2, color: Color(0xffe3e3e3)),
                    ),
                    onPressed: () async {
                      locator<NavigationService>()
                          .pushReplacementNamed(routes.LoginRoute);
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone_android,
                            color: Color(0xff414141),
                            size: ScreenUtil().setWidth(18),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(12),
                          ),
                      Transform.translate(offset: Offset(0,ScreenUtil().setWidth(1.5)),child:  Text(
                            "MOBILE LOGIN",
                            style: TextStyle(
                                color: Color(0xff414141),
                                fontSize: ScreenUtil().setSp(
                                  16,
                                ),
                                fontWeight: FontWeight.w600),
                          ))
                        ],
                      ),
                    ),
                  )),
              SizedBox(height: ScreenUtil().setWidth(25),),
              Container(
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(
                        ScreenUtil().setWidth(5))),
                width: ScreenUtil().setWidth(324),
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
                      locator<NavigationService>()
                          .pushReplacementNamed(routes.EmailLoginRoute);
                    },
                    child:  Container(
                      //padding: EdgeInsets.fromLTRB(0, 7, 0, 7),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: AppColors.primaryElement,
                            size: ScreenUtil().setWidth(20),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(12),
                          ),
                      Transform.translate(offset: Offset(0,ScreenUtil().setWidth(1.5)),child: Text(
                            "EMAIL LOGIN",
                            style: TextStyle(
                                color: AppColors.primaryElement,
                                fontSize: ScreenUtil().setSp(
                                  16,
                                ),
                                fontWeight: FontWeight.w600),
                          ))
                        ],
                      ),
                    )),
              ),
              SizedBox(height: ScreenUtil().setWidth(25),)
            ]),
          )
        ] ),
      ),
    ));
  }
}
