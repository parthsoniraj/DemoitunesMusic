import 'dart:io';

import 'package:demo_itunes_music/core_component/api_repositories/api_service.dart';
import 'package:demo_itunes_music/core_component/api_repositories/errors/network_errorvice.dart';
import 'package:demo_itunes_music/modules/itunesListPage/model/music_item_list_model.dart';

class AppRepository {
  // GraphqlService _graphqlService = GraphqlService();
  ApiService _apiService = ApiService();

  // Singleton static  instance
  static final AppRepository _instance = AppRepository._privateConstructor();
  // Factory constructor
  factory AppRepository() {
    return _instance;
  }

  // Singleton initializer.
  // All initialization code write inside this function
  AppRepository._privateConstructor();

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  ///fetch Music Search Data from rest API
  Future<MusicItemListModel> getSearchResult({
    String term = "",
  }) async {
    try {
      final isConnectedToInternet = await checkInternetConnection();
      if (!isConnectedToInternet) {
        throw NetworkError('No Internet');
      }

      return await _apiService.getSearchTunes(term);
    } on NetworkError catch (error) {
      throw NetworkError('${error.message}');
    }
  }
}
