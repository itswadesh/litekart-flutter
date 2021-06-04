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
      _endpoint = "https://tapi.litekart.in/api/";
      _graphQlUrl = "https://tapi.litekart.in/graphql";
    } else {
      _endpoint = "https://tapi.litekart.in/api/";
      _graphQlUrl = "https://tapi.litekart.in/graphql";
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
