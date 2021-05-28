import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:anne/components/base/tz_dialog.dart';
import 'package:anne/enum/tz_dialog_type.dart';
import 'package:anne/utility/api_endpoint.dart';
import 'package:anne/utility/graphQl.dart';

import 'package:anne/utility/locator.dart';
import 'package:anne/service/navigation/navigation_service.dart';
import 'package:anne/utility/query_mutation.dart';
import 'package:anne/utility/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();
  TzDialog _dialog;
  bool otpStatus;
  bool showOtpUi = false;

  LoginViewModel() {
    _dialog = TzDialog(
        _navigationService.navigationKey.currentContext, TzDialogType.progress);
  }

  void sendOtp(String mobile) async {
    _dialog.show();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(addMutation.getOtp()), variables: {'phone': mobile}),
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
          variables: {'phone': mobile, 'otp': otp},
        ),
      );
      if(!result.hasException){
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
}
