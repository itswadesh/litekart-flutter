import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/base/data_loading_indicator.dart';
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
import 'package:sms_autofill/sms_autofill.dart';

bool skipStatus = true;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with CodeAutoFill {
  bool _phoneFieldValidate = false;
  TextEditingController _mobileController;
  FocusNode _focusNode;
  String appSignature;
  String otpCode;
  int otpResendLimit = 5;

  TextEditingController _otpController = TextEditingController()..text = "";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  bool tryAutoLogin = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isCheckBox = true;

  @override
  void initState() {
    _mobileController = TextEditingController();

    errorController = StreamController<ErrorAnimationType>();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    super.initState();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
  }

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code;
      _otpController.text = otpCode;
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, model, child) =>  Scaffold(
              key: scaffoldKey,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark.copyWith(
                    statusBarColor: Colors.transparent
                ),
                child: SafeArea(
                  child: loadUi(model),
            ),
      ),
    )));
  }

  Widget loadUi(LoginViewModel model) {
    return SingleChildScrollView(child: Container(
      decoration: BoxDecoration(color: Color(0xFFFfffff)),
     child: Container(
        padding: EdgeInsets.only(left:ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
        //  color: Colors.white70,
        child: Column(children:[
          SizedBox(height: ScreenUtil().setWidth(30),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        skipStatus?
                        Container(): InkWell(
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
                      skipStatus?  GestureDetector(
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
          SizedBox(height: ScreenUtil().setWidth(40),),
          Card(
          elevation: 0,
          color: Color(0xffffffff),
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
              "Sign in With Mobile Number",
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
                        height: ScreenUtil().setWidth(80),
                          margin: EdgeInsets.only(top: 0,left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            focusNode: _focusNode,
                            controller: _mobileController,
                            // inputFormatters: <TextInputFormatter>[
                            //   FilteringTextInputFormatter.digitsOnly
                            // ],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(20),
                            ),
                            maxLength: 15,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              errorText: _phoneFieldValidate
                                  ? "Please enter valid mobile number"
                                  : null,
                              // prefix: Opacity(
                              //   opacity: 0.4986,
                              //   child: Text(
                              //     "+91 ",
                              //     textAlign: TextAlign.left,
                              //     style: TextStyle(
                              //       color: Colors.black,
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: ScreenUtil().setSp(20),
                              //     ),
                              //   ),
                              // ),
                            ),
                            onChanged: (value) async {
                              if (value.length == 10) {
                                _phoneFieldValidate = false;
                              }
                            },
                          )),

            SizedBox(
              height: ScreenUtil().setWidth(25),
            ),
                      InkWell(
                        onTap: () async {
                          if (model.resendEnable &&
                              model.resendTrial < otpResendLimit) {
                            if (_mobileController.text.isEmpty) {
                              setState(() {
                                _phoneFieldValidate = true;
                              });
                            } else {
                              if (_mobileController.text.length < otpResendLimit) {
                                setState(() {
                                  _phoneFieldValidate = true;
                                });
                              } else {
                                _focusNode.unfocus();
                                model.sendOtp(_mobileController.text);
                              }
                            }
                            listenForCode();
                          }
                        },
                        child: Container(

                          width: ScreenUtil().setWidth(324),
                          height: ScreenUtil().setHeight(45),
                          decoration: BoxDecoration(
                            color: model.resendEnable ? AppColors.primaryElement:Color(0xffffffff),
                            border: Border.all(
                                color: model.resendEnable
                                    ? AppColors.primaryElement
                                    : Colors.grey,
                                width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Get OTP",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: model.resendEnable
                                      ? Color(0xffffffff)
                                      : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: model.showOtpUi,
                        child: Container(
                          child: otpUi(model),
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
                            .pushReplacementNamed(routes.EmailLoginRoute);
                      },
                      child: Container(
                        // padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: Color(0xff414141),
                              size: ScreenUtil().setWidth(20),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(12),
                            ),
                        Transform.translate(offset: Offset(0,ScreenUtil().setWidth(1.5)),child:  Text(
                              "EMAIL LOGIN",
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
                     // color: AppColors.primaryElement,
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
                            .pushReplacementNamed(routes.RegisterRoute);
                      },
                      child:  Container(
                        //padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                        //color:  AppColors.primaryElement,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.app_registration,
                              color: AppColors.primaryElement,
                              size: ScreenUtil().setWidth(20),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(12),
                            ),
                           Transform.translate(offset: Offset(0,ScreenUtil().setWidth(1.5)),child: Text(
                              "REGISTER",
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

  Widget otpUi(LoginViewModel model) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: ScreenUtil().setWidth(30),),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Text(
              "Enter OTP",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 12,
                height: 1.70833,
              ),
            ),
          ),
           Container(
             
              child: PinCodeTextField(
                length: 4,
                textInputType: TextInputType.number,
                obsecureText: false,
                animationType: AnimationType.fade,
                shape: PinCodeFieldShape.box,
                animationDuration: Duration(milliseconds: 300),
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                backgroundColor: Color(0xFFFFFFF),
                fieldWidth: 40,
                activeFillColor: Colors.black,
                enableActiveFill: false,
                autoFocus: true,
                errorAnimationController: errorController,
                controller: _otpController,
                onCompleted: (v) {

                  _autoLogin(model);
                },
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
              ),
            ),
          SizedBox(height: ScreenUtil().setWidth(25),),
          GestureDetector(
            onTap: () {
              if (model.resendEnable && model.resendTrial < otpResendLimit) {
                if (_mobileController.text.isEmpty) {
                  _phoneFieldValidate = true;
                } else if (_mobileController.text.length < otpResendLimit) {
                  _phoneFieldValidate = true;
                } else if (_mobileController.text.length == otpResendLimit) {
                  model.sendOtp(_mobileController.text);
                }
              }
            },
            child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      model.resendTrial < otpResendLimit
                          ? "Resend OTP"
                          : "Please try take break, use skip",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: model.resendEnable ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 3.41667,
                      ),
                    ),
                    !model.resendEnable &&
                        (model?.resendTrial ?? 0) < otpResendLimit
                        ? CountdownTimer(
                      widgetBuilder: ((BuildContext context,
                          CurrentRemainingTime time) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "wait ${time.sec.toString()} second",
                            style: TextStyle(
                              color: AppColors.primaryElement,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              height: 3.41667,
                            ),
                          ),
                        );
                      }),
                      endTime: DateTime.now().millisecondsSinceEpoch +
                          1000 * 30,
                      onEnd: () {
                        model.changeResendEnable();
                      },
                    )
                        : SizedBox.shrink()
                  ],
                ),
              ),
            ),
           SizedBox(height: ScreenUtil().setWidth(30),),
           GestureDetector(
              onTap: () async {
                onLoading(context);
                if (currentText.length != 4) {
                  Navigator.pop(context);
                  errorController.add(ErrorAnimationType
                      .shake); // Triggering error shake animation
                  setState(() {
                    hasError = true;
                  });
                } else {
                  await model.validateOtp(
                      _mobileController.text, _otpController.text);
                  if (model.otpStatus) {
                    token = tempToken;
                    await Provider.of<ProfileModel>(context, listen: false)
                        .getProfile();
                    await Provider.of<CartViewModel>(context, listen: false)
                        .changeStatus("loading");
                    locator<NavigationService>()
                        .pushNamedAndRemoveUntil(routes.HomeRoute);
                  } else {
                    final snackBar = SnackBar(
                      content: Text('You have entered wrong OTP'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              child: Container(
                width: ScreenUtil().setWidth(324),
                height: ScreenUtil().setHeight(45),
                margin: EdgeInsets.only(bottom: 0),
                decoration: BoxDecoration(
                  color: AppColors.primaryElement,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }



  void _autoLogin(LoginViewModel model) async {
    if (tryAutoLogin && _otpController.text.length == 4 && model != null) {
      tryAutoLogin = false;
      onLoading(context);
      await model.validateOtp(_mobileController.text, _otpController.text);
      if (model.otpStatus) {
        await Provider.of<ProfileModel>(context, listen: false).getProfile();

        await Provider.of<CartViewModel>(context, listen: false)
            .changeStatus("loading");
        locator<NavigationService>().pushNamedAndRemoveUntil(routes.HomeRoute);
      } else {
        final snackBar = SnackBar(
          content: Text('You have entered wrong OTP'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
