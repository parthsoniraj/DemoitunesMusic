import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<ValueNotifier<GraphQLClient>> getGraphqlClient({String searchBy}) async {
  ValueNotifier<GraphQLClient> graphqlClient = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: _getGraphqlLink(searchBy),
    ),
  );
  return graphqlClient;
}

Link _getGraphqlLink(String searchBy) {
  String url = 'https://itunes.apple.com/search?term=' + searchBy;
  Map<String, String> header = Map();
  header["Content-type"] = "application/json";
  // header["Accept-Language"] = AppUtils.getSelectedLanguage();
  header["Accept-Charset"] = "utf-8";
  HttpLink link = HttpLink(
    uri: url,
    headers: header,
  );
  return link;
}
