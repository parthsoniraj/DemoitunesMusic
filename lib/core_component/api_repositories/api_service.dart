import 'dart:convert';
import 'dart:io';

import 'package:demo_itunes_music/core_component/api_repositories/errors/network_error.dart';
import 'package:demo_itunes_music/modules/itunesListPage/model/music_item_list_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final Map<String, Object> cache;
  final _baseUrl = 'https://itunes.apple.com/search?term=';
  final http.Client client;

  ApiService({
    HttpClient client,
    Map<String, Object> cache,
  })  : client = client ?? http.Client(),
        cache = cache ?? <String, Object>{};

  Future<MusicItemListModel> getSearchTunes(String searchBy) async {
    String url = '$_baseUrl' + searchBy;
    final response = await client.get(
      url,
      headers: {
        HttpHeaders.acceptHeader: '*/*',
        HttpHeaders.cacheControlHeader: 'no-cache',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer account.accessToken'
      },
    );
    print('fetch SearchMusic: ${response.statusCode}');
    print('Response: fetch SearchMusic: ${response.body}');
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return MusicItemListModel.fromJson(json);
    } else {
      throw NetworkError(response.statusCode.toString());
    }
  }
}
