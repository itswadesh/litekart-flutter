import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
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
    print(jsonEncode(result.data));
    showOtpUi = true;
    _dialog.close();
    notifyListeners();
  }

  Future<void> validateOtp(String mobile, String otp) async {
    _dialog.show();
    try {
      GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      print(graphQLConfiguration.httpLink);
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
    try {
      GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      print(graphQLConfiguration.httpLink);
      QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(addMutation.login()),
          variables: {'email': email, 'password': password},
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
    } catch (e) {
      _dialog.close();
    }
    _dialog.close();
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
  RegisterViewModel() {
    _dialog = TzDialog(
        _navigationService.navigationKey.currentContext, TzDialogType.progress);
  }

   register(String email, String password, String cPassword, String firstName, String lastName) async {
    _dialog.show();
    try {
      GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      print(graphQLConfiguration.httpLink);
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
    } catch (e) {
      _dialog.close();
    }
    _dialog.close();
    notifyListeners();
  }
}

