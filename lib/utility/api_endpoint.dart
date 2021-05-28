import 'package:flutter/foundation.dart';

class ApiEndpoint {
  String _endpoint;
  String _productList;
  String _searchHint;
  String _graphQlUrl;
  String _validateOtpApi;
  String _addToCartApi;

  ApiEndpoint() {
    if (kReleaseMode) {
      _endpoint = "https://pre.tablez.com/api/";
      _graphQlUrl = "https://pre.tablez.com/graphql";
    } else {
      _endpoint = "https://stg.tablez.com/api/";
      _graphQlUrl = "https://stg.tablez.com/graphql";
    }
    _productList = "${_endpoint}products/es";
    _searchHint = "${_endpoint}products/autocomplete";
    _validateOtpApi = "${_endpoint}flutter/verify-otp";
    _addToCartApi = "${_endpoint}flutter/add-to-cart";
  }

  String get productList => _productList;

  String get searchHint => _searchHint;

  String get graphQlUrl => _graphQlUrl;

  String get validateOtpApi => _validateOtpApi;

  String get addToCartApi => _addToCartApi;
}

ApiEndpoint apiEndpoint = ApiEndpoint();
