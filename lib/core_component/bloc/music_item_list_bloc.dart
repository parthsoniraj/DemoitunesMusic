import 'dart:async';

import 'package:demo_itunes_music/core_component/api_repositories/app_repository.dart';
import 'package:demo_itunes_music/core_component/api_repositories/errors/network_error.dart';
import 'package:demo_itunes_music/core_component/bloc/bloc.dart';
import 'package:demo_itunes_music/modules/itunesListPage/model/music_item_list_model.dart';

class MusicItemListBloc extends Bloc {
  AppRepository _appRepository = AppRepository();
  final _musicItemToDisplayController =
      StreamController<List<Results>>.broadcast();

  Stream<List<Results>> get musicItemDisplayControllerStream =>
      _musicItemToDisplayController.stream;

  Future<void> loadMusicItemList({String term}) async {
    try {
      MusicItemListModel apiResponse =
          await _appRepository.getSearchResult(term: term);

      if (apiResponse.results != null && apiResponse.results.isNotEmpty) {
        _musicItemToDisplayController.sink.add(apiResponse.results);
      } else
        _musicItemToDisplayController.sink.addError("");
    } on NetworkError catch (error) {
      _musicItemToDisplayController.sink.addError(error.message);
    }
  }

  @override
  void dispose() {
    _musicItemToDisplayController.close();
  }
}
