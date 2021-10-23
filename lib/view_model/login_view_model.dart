import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:anne/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../components/base/tz_dialog.dart';
import '../../enum/tz_dialog_type.dart';
import '../../utility/graphQl.dart';

import '../../utility/locator.dart';
import '../../service/navigation/navigation_service.dart';
import '../../utility/query_mutation.dart';
import '../../utility/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  TzDialog _dialog;
  bool otpStatus;
  bool showOtpUi = false;
  bool resendEnable = true;
  int resendTrial = 0;

  LoginViewModel() {
    _dialog = TzDialog(
        _navigationService.navigationKey.currentContext, TzDialogType.progress);
  }

  void sendOtp(String mobile) async {
    _dialog.show();
    changeResendEnable();
    //resendTrialIncrement();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(addMutation.getOtp()),
          variables: {'phone': "+91" + mobile}),
    );

    showOtpUi = true;
    _dialog.close();
    notifyListeners();
  }

  Future<void> validateOtp(String mobile, String otp) async {
    _dialog.show();
    try {
      GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
      GraphQLClient _client = graphQLConfiguration.clientToQuery();

      QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(addMutation.verifyOtp()),
          variables: {'phone': "+91" + mobile, 'otp': otp},
        ),
      );
      if (!result.hasException) {
        token = tempToken;
        await addCookieToSF(token);
        _dialog.close();
        otpStatus = true;
      } else {
        _dialog.close();
        otpStatus = false;
      }
    } catch (e) {
      _dialog.close();
      otpStatus = false;
    }
    _dialog.close();
    notifyListeners();
  }

  changeResendEnable() {
    resendEnable = !resendEnable;
    resendTrial = resendTrial + 1;
    notifyListeners();
  }

  resendTrialIncrement() {
    notifyListeners();
  }
}


class EmailLoginViewModel extends ChangeNotifier{
  final NavigationService _navigationService = locator<NavigationService>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  TzDialog _dialog;
  bool loginStatus = false;
  // bool resendEnable = true;
  // int resendTrial = 0;

  EmailLoginViewModel() {
    _dialog = TzDialog(
        _navigationService.navigationKey.currentContext, TzDialogType.progress);
  }

   login(String email, String password) async {
    _dialog.show();
    loginStatus=false;
   // try {
      GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
      GraphQLClient _client = graphQLConfiguration.clientToQuery();

      QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(addMutation.login()),
          variables: {'email': email, 'password': password, 'store':store.id},
        ),
      );
      if (!result.hasException) {

        loginStatus=true;
        token = tempToken;
        await addCookieToSF(token);
        _dialog.close();
      } else {

        _dialog.close();
      }
    // } catch (e) {
    //   _dialog.close();
    // }
    notifyListeners();
  }
}


class RegisterViewModel extends ChangeNotifier{
  final NavigationService _navigationService = locator<NavigationService>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  TzDialog _dialog;
  // bool resendEnable = true;
  // int resendTrial = 0;
  bool registerStatus = false;
  String errorMessage = "Something went wrong !!";
  RegisterViewModel() {
    _dialog = TzDialog(
        _navigationService.navigationKey.currentContext, TzDialogType.progress);
  }

   register(String email, String password, String cPassword, String firstName, String lastName) async {
    _dialog.show();
   // try {
      GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
      GraphQLClient _client = graphQLConfiguration.clientToQuery();

      QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(addMutation.register()),
          variables: {'email': email, 'password': password,'passwordConfirmation':cPassword,'firstName':firstName,'lastName':lastName},
        ),
      );

      if (!result.hasException) {

        registerStatus = true;
        token = tempToken;
        await addCookieToSF(token);
        _dialog.close();
      } else {

        _dialog.close();
      }
    // } catch (e) {
    //   _dialog.close();
    // }
    notifyListeners();
  }
}

class GoogleLoginViewModel extends ChangeNotifier{
  final NavigationService _navigationService = locator<NavigationService>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  TzDialog _dialog;
  // bool resendEnable = true;
  // int resendTrial = 0;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  bool googleStatus = false;
  String errorMessage = "Something went wrong !!";
  GoogleLoginViewModel() {
    _dialog = TzDialog(
        _navigationService.navigationKey.currentContext, TzDialogType.progress);
  }

  handleGoogleLogin() async {
    _dialog.show();
    var result;
    try {
     result = await _googleSignIn.signIn();
     log(result);
    } catch (error) {
      googleStatus = false;
      print(error);
      _dialog.close();
    }
   notifyListeners();
  }
}

class FacebookLoginViewModel extends ChangeNotifier{
  final NavigationService _navigationService = locator<NavigationService>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  TzDialog _dialog;
  bool fbStatus = false;
  String errorMessage = "Something went wrong !!";
  FacebookLoginViewModel() {
    _dialog = TzDialog(
        _navigationService.navigationKey.currentContext, TzDialogType.progress);
  }

  handleFacebookLogin() async {
    _dialog.show();
    final fb = FacebookLogin();
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (res.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken accessToken = res.accessToken;
        log('Access token: ${accessToken.token}');
        break;
      case FacebookLoginStatus.cancel:
        fbStatus = false;
        _dialog.close();
        break;
      case FacebookLoginStatus.error:
        fbStatus  = false;
        _dialog.close();
        print('Error while log in: ${res.error}');
        break;
    }
    notifyListeners();
  }
}

