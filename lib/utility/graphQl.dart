import 'dart:convert';

import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import '../../utility/api_endpoint.dart';

String token;
String tempToken;

class GraphQLConfiguration {
  HttpLink httpLink = HttpLink((ApiEndpoint()).graphQlUrl,
      defaultHeaders: {"cookie": token, "content-type": "application/json"},
      httpResponseDecoder: (response) async {
    /*log("Response Header : " + response.headers.toString());
    log("Response Body : " + response.body);*/
    if (response.headers.containsKey("set-cookie")) {
      tempToken = response.headers["set-cookie"];
    }
    return json.decode(
      utf8.decode(
        response.bodyBytes,
      ),
    ) as Map<String, dynamic>;
  });

  ValueNotifier<GraphQLClient> initailizeClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(store: HiveStore()),
        link: httpLink,
      ),
    );
    return client;
  }

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: httpLink,
    );
  }
}
