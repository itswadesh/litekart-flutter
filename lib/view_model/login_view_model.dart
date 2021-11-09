import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:anne/main.dart';
import 'package:anne/repository/login_repository.dart';
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
import 'package:sign_in_with_apple/sign_in_with_apple.dart';



class LoginViewModel extends ChangeNotifier {
  final NavigationService? _navigationService = locator<NavigationService>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  late TzDialog _dialog;
  late bool otpStatus;
  bool showOtpUi = false;
  bool resendEnable = true;
  int resendTrial = 0;

  LoginViewModel() {
    _dialog = TzDialog(
        _navigationService!.navigationKey.currentContext, TzDialogType.progress);
  }

  void sendOtp(String mobile) async {
    _dialog.show();
    changeResendEnable();
    //resendTrialIncrement();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(addMutation.getOtp()),
          variables: {'phone':  mobile}),
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
          variables: {'phone':  mobile, 'otp': otp},
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
  final NavigationService? _navigationService = locator<NavigationService>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  late TzDialog _dialog;
  bool loginStatus = false;
  // bool resendEnable = true;
  // int resendTrial = 0;

  EmailLoginViewModel() {
    _dialog = TzDialog(
        _navigationService!.navigationKey.currentContext, TzDialogType.progress);
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
          variables: {'email': email, 'password': password, 'store':store!.id},
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
  final NavigationService? _navigationService = locator<NavigationService>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  late TzDialog _dialog;
  // bool resendEnable = true;
  // int resendTrial = 0;
  bool registerStatus = false;
  String errorMessage = "Something went wrong !!";
  RegisterViewModel() {
    _dialog = TzDialog(
        _navigationService!.navigationKey.currentContext, TzDialogType.progress);
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
  final NavigationService? _navigationService = locator<NavigationService>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  late TzDialog _dialog;
  // bool resendEnable = true;
  // int resendTrial = 0;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email'
    ],
    clientId:settingData!.googleClientId
  );
  bool googleStatus = false;
  String errorMessage = "Something went wrong !!";
  GoogleLoginViewModel() {
    _dialog = TzDialog(
        _navigationService!.navigationKey.currentContext, TzDialogType.progress);
  }

  handleGoogleLogin() async {
    _dialog.show();
    try {
    final GoogleSignInAccount? result = await _googleSignIn.signIn();
    if (result != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await result.authentication;
       LoginRepository loginRepository = LoginRepository();
      googleStatus = await loginRepository.googleOneTap(googleSignInAuthentication.idToken);
      if (googleStatus) {
        token = tempToken;
        await addCookieToSF(token);
      }
      _dialog.close();
    }
    else{
      googleStatus = false;
      _dialog.close();
    }

    }
    catch (error) {
      googleStatus = false;
      print(error);
      _dialog.close();
    }
   notifyListeners();
  }
}


class AppleLoginViewModel extends ChangeNotifier{
  final NavigationService? _navigationService = locator<NavigationService>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  late TzDialog _dialog;


  bool appleStatus = false;
  String errorMessage = "Something went wrong !!";
  AppleLoginViewModel() {
    _dialog = TzDialog(
        _navigationService!.navigationKey.currentContext, TzDialogType.progress);
  }

  handleAppleLogin() async {
    _dialog.show();

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // webAuthenticationOptions: WebAuthenticationOptions(
        //   clientId:
        //   'com.aboutyou.dart_packages.sign_in_with_apple.example',
        //   redirectUri: Uri.parse(
        //     'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
        //   ),
        // ),
      );
      if(credential.authorizationCode.isNotEmpty){
        LoginRepository loginRepository = LoginRepository();
        appleStatus = await loginRepository.signInWithApple(credential.authorizationCode);
        if (appleStatus) {
          token = tempToken;
          await addCookieToSF(token);
        }
        _dialog.close();
      }
      else{
       appleStatus = false;
        _dialog.close();
      }
    }
    catch (error) {
      appleStatus = false;
      print(error);
      _dialog.close();
    }
    notifyListeners();
  }
}



class FacebookLoginViewModel extends ChangeNotifier{
  final NavigationService? _navigationService = locator<NavigationService>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  late TzDialog _dialog;
  bool fbStatus = false;
  String errorMessage = "Something went wrong !!";
  FacebookLoginViewModel() {
    _dialog = TzDialog(
        _navigationService!.navigationKey.currentContext, TzDialogType.progress);
  }

  handleFacebookLogin() async {
    _dialog.show();
    final fb = FacebookLogin();
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    log("in hereeeee");
    print("in hereeeee");

    if(res.status ==  FacebookLoginStatus.success){
      log("in hereeeee");
      print("in hereeeee");

      LoginRepository loginRepository = LoginRepository();
      final FacebookAccessToken accessToken = res.accessToken!;
      fbStatus = await loginRepository.facebookMobileLogin(accessToken.token);
     if(fbStatus) {
       token = tempToken;
       await addCookieToSF(token);
     }
      _dialog.close();
    }
    else if(res.status == FacebookLoginStatus.cancel){
      fbStatus = false;
      _dialog.close();
    }
    else if(res.status == FacebookLoginStatus.error){
      fbStatus  = false;
      _dialog.close();
      print('Error while log in: ${res.error}');
    }
    //
    // switch (res.status) {
    //   case FacebookLoginStatus.success:
    //     final FacebookAccessToken accessToken = res.accessToken;
    //
    //     fbStatus = true;
    //     log('Access token: ${accessToken.token}');
    //     break;
    //   case FacebookLoginStatus.cancel:
    //     fbStatus = false;
    //     _dialog.close();
    //     break;
    //   case FacebookLoginStatus.error:
    //     fbStatus  = false;
    //     _dialog.close();
    //     print('Error while log in: ${res.error}');
    //     break;
    // }
    notifyListeners();
  }


}

