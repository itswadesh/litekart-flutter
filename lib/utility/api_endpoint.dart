import 'package:flutter/foundation.dart';


class ApiEndpoint {
  String? _url;
  String? _endpoint;
  String? _productList;
  String? _searchHint;
  String? _graphQlUrl;
  String? _validateOtpApi;
  String? _addToCartApi;
  String? _searchLink;
  String? _categoryLink;
  String? _brandLink;
  String? _externalLink;
  String? _cashFreeEndpoint ;
  String? _domainName;
  ApiEndpoint() {
    if (kReleaseMode) {
      _endpoint = "https://api.anne.biz/api/";
      _url = "https://api.anne.biz";
      _graphQlUrl = "https://api.anne.biz/graphql";
      _domainName = "anne.biz";
    }
    else {
      _endpoint = "https://api.anne.biz/api/";
      _url = "https://api.anne.biz";
      _graphQlUrl = "https://api.anne.biz/graphql";
      _domainName = "anne.biz";
    }
    _productList = "${_endpoint}products/es";
    _cashFreeEndpoint = "${_endpoint}pay/capture-cashfree";
    _searchHint = "${_endpoint}products/autocomplete";
    _validateOtpApi = "${_endpoint}flutter/verify-otp";
    _addToCartApi = "${_endpoint}flutter/add-to-cart";
    _searchLink = "/search/";
    _brandLink = "/brand/";
    _categoryLink = "/c/";
    _externalLink = "http";
  }
  String? get domainName => _domainName;
  String? get cashFreeEndpoint => _cashFreeEndpoint;
  String? get searchLink => _searchLink;
  String? get brandLink => _brandLink;
  String? get categoryLink => _categoryLink;
  String? get externalLink => _externalLink;
  String? get url => _url;
  String? get productList => _productList;

  String? get searchHint => _searchHint;

  String? get graphQlUrl => _graphQlUrl;

  String? get validateOtpApi => _validateOtpApi;

  String? get addToCartApi => _addToCartApi;
}

ApiEndpoint apiEndpoint = ApiEndpoint();
