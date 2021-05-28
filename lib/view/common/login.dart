import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anne/components/base/data_loading_indicator.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/graphQl.dart';
import 'package:anne/utility/locator.dart';
import 'package:anne/values/colors.dart';
import 'package:anne/components/login/pin_code_fields.dart';
import 'package:anne/view_model/auth_view_model.dart';
import 'package:anne/values/route_path.dart' as routes;
import 'package:anne/view_model/cart_view_model.dart';
import 'package:anne/view_model/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with CodeAutoFill {
  bool _phoneFieldValidate = false;
  TextEditingController _mobileController;
  FocusNode _focusNode;
  var onTapRecognizer;
  String appSignature;
  String otpCode;

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
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
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
        builder: (context, model, child) => WillPopScope(
            child: Scaffold(
              key: scaffoldKey,
              body: loadUi(model),
            ),
            onWillPop: () async {
              locator<NavigationService>()
                  .pushNamedAndRemoveUntil(routes.HomeRoute);
              return true;
            }),
      ),
    );
  }

  Widget loadUi(LoginViewModel model) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(color: Color(0xFFF6F6f6)),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 26,
            top: 70,
            right: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: 35,
                        child: Image.asset(
                          'assets/images/anne.png',
                        )),
                    GestureDetector(
                      onTap: () {
                        locator<NavigationService>()
                            .pushNamedAndRemoveUntil(routes.HomeRoute);
                      },
                      child: Container(
                        width: 78,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
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
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(top: 69),
                    child: Text(
                      'Login with mobile number',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      focusNode: _focusNode,
                      controller: _mobileController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                      maxLength: 10,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        errorText: _phoneFieldValidate
                            ? "Please enter valid mobile number"
                            : null,
                        prefix: Opacity(
                          opacity: 0.4986,
                          child: Text(
                            "+91 ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      onChanged: (value) async {
                        if (value.length == 10) {
                          _phoneFieldValidate = false;
                        }
                      },
                    )),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    if (_mobileController.text.isEmpty) {
                      setState(() {
                        _phoneFieldValidate = true;
                      });
                    } else {
                      if (_mobileController.text.length < 10) {
                        setState(() {
                          _phoneFieldValidate = true;
                        });
                      } else {
                        _focusNode.unfocus();
                        model.sendOtp(_mobileController.text);
                      }
                    }
                    listenForCode();
                  },
                  child: Container(
                    height: 43,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.primaryElement, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Get OTP",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryElement,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget otpUi(LoginViewModel model) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      width: double.infinity,
      margin: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(),
          ),
          Align(
            alignment: Alignment.topLeft,
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
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: PinCodeTextField(
                length: 4,
                textInputType: TextInputType.number,
                obsecureText: false,
                animationType: AnimationType.fade,
                shape: PinCodeFieldShape.box,
                animationDuration: Duration(milliseconds: 300),
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                backgroundColor: Color(0xFFF6F6f6),
                fieldWidth: 40,
                activeFillColor: Colors.black,
                enableActiveFill: false,
                autoFocus: true,
                errorAnimationController: errorController,
                controller: _otpController,
                onCompleted: (v) {
                  print("Completed");
                  _autoLogin(model);
                },
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_mobileController.text.isEmpty) {
                _phoneFieldValidate = true;
              } else if (_mobileController.text.length < 10) {
                _phoneFieldValidate = true;
              } else if (_mobileController.text.length == 10) {
                model.sendOtp(_mobileController.text);
              }
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 2, top: 28, bottom: 0),
                child: Text(
                  "Resend OTP",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 3.41667,
                  ),
                ),
              ),
            ),
          ),
          Flexible(flex: 1, child: Container()),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
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
                width: 176,
                height: 50,
                margin: EdgeInsets.only(bottom: 0),
                decoration: BoxDecoration(
                  color: AppColors.primaryElement,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
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
        await Provider.of<ProfileModel>(context, listen: false)
            .getProfile();

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
