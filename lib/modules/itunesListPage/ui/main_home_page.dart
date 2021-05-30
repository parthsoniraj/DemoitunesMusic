import 'package:audio_wave/audio_wave.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_itunes_music/core_component/bloc/music_item_list_bloc.dart';
import 'package:demo_itunes_music/helper/audio_helper/audio_player_helper.dart';
import 'package:demo_itunes_music/modules/itunesListPage/model/music_item_list_model.dart';
import 'package:flutter/material.dart';

class MainHomePage extends StatefulWidget {
  MainHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  MusicItemListBloc _musicItemListBloc = MusicItemListBloc();

  void loadMusic(String searchByQuery) {
    _musicItemListBloc.loadMusicItemList(term: searchByQuery);
  }

  int _selectedID = 0;
  String _selectedPreviewUrl = "";
  String _searchText = "";
  String _requestSearchText = "";
  bool isPlaying = false;
  bool showPlayer = false;

  final TextEditingController _searchQueryController =
      new TextEditingController();

  _MainHomePageState() {
    _searchQueryController.addListener(() {
      setState(() {
        _searchText = _searchQueryController.text.isEmpty
            ? ""
            : _searchQueryController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    AudioPlayerHelper().stopTrack();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: appBarTitle, actions: <Widget>[
          new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    showPlayer = false;
                    isPlaying = false;
                    AudioPlayerHelper().stopTrack();
                    this.actionIcon = new Icon(
                      Icons.close,
                      color: Colors.white,
                    );
                    this.appBarTitle = Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _searchQueryController,
                                style: new TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: "Search...",
                                  hintStyle:
                                      new TextStyle(color: Colors.white60),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue[800],
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10))),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPlayer = false;
                                    });
                                    _requestSearchText = _searchText;
                                    AudioPlayerHelper().stopTrack();
                                    loadMusic(_requestSearchText);
                                  }),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    this.actionIcon = new Icon(
                      Icons.search,
                      color: Colors.white,
                    );
                    this.appBarTitle = new Text(
                      widget.title,
                      style: new TextStyle(color: Colors.white),
                    );
                    _searchQueryController.clear();
                  }
                });
              }),
        ]),
        body: Center(
          child: StreamBuilder<List<Results>>(
              stream: _musicItemListBloc.musicItemDisplayControllerStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CircularProgressIndicator(),
                        Padding(padding: EdgeInsets.all(5)),
                        Text("Search Artist")
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: getMusicList(snapshot),
                        ),
                      ),
                      showPlayer ? bottomPlayerSection() : Offstage(),
                    ],
                  );
                }
              }),
        ));
  }

  Widget appBarTitle = new Text(
    'iTunes Music',
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  Future<void> _pullRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    loadMusic(_requestSearchText);
    _selectedID = 0;
    showPlayer = false;
    AudioPlayerHelper().stopTrack();
  }

  Widget getMusicList(AsyncSnapshot<List<Results>> snapshot) {
    List<Results> snapData = snapshot.data;

    return (snapData != null && snapData.isNotEmpty)
        ? RefreshIndicator(
            onRefresh: _pullRefresh,
            child: Container(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  //ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapData.length,
                  itemBuilder: (BuildContext context, int index) {
                    Results results = snapData[index];
                    return Container(
                      child: Card(
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _getLeadingImage(results.artworkUrl100),
                              _getDetailSection(results),
                              Center(
                                child: (_selectedID != results.trackId)
                                    ? IconButton(
                                        icon:
                                            new Icon(Icons.play_circle_outline),
                                        highlightColor: Colors.pink,
                                        onPressed: () {
                                          setState(() {
                                            _selectedID = results.trackId;
                                            isPlaying = true;
                                            showPlayer = true;
                                            _selectedPreviewUrl =
                                                results.previewUrl;
                                          });
                                          AudioPlayerHelper()
                                              .playTrack(results.previewUrl);
                                        },
                                      )
                                    : _waveSection(results),
                              )
                            ]),
                      ),
                    );
                  }),
            ))
        : Center(
            child: Text(""),
          );
  }

  Widget _getLeadingImage(String imageUrl) {
    return Container(
        width: 100,
        child: Column(children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          )
        ]));
  }

  Widget _getDetailSection(Results results) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(results.trackName ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.all(3.0)),
            Text(
              results.artistName ?? "",
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 0.8,
            ),
            Padding(padding: EdgeInsets.all(3.0)),
            Text(results.collectionName ?? "", overflow: TextOverflow.ellipsis),
            Padding(padding: EdgeInsets.all(3.0)),
            Text(
              results.primaryGenreName ?? "",
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 0.7,
            ),
            // _TrackButtonRow(_trackItem)
          ],
        ),
      ),
    );
  }

  Widget _waveSection(Results results) {
    return AudioWave(
      height: 32,
      width: 32,
      spacing: 2.5,
      animationLoop: 3,
      bars: [
        AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
        AudioWaveBar(height: 30, color: Colors.blue),
        AudioWaveBar(height: 70, color: Colors.black),
        AudioWaveBar(height: 40),
      ],
    );
  }

  Widget bottomPlayerSection() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 120,
          color: Colors.black12,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                iconSize: 70,
                icon: Icon(
                  Icons.fast_rewind,
                ),
                onPressed: null,
              ),
              (!isPlaying)
                  ? IconButton(
                      iconSize: 70,
                      icon: Icon(
                        Icons.play_circle_filled,
                      ),
                      onPressed: () {
                        setState(() {
                          isPlaying = true;
                        });
                        AudioPlayerHelper().playTrack(_selectedPreviewUrl);
                      },
                    )
                  : IconButton(
                      iconSize: 70,
                      icon: Icon(
                        Icons.pause_circle_filled,
                      ),
                      onPressed: () {
                        setState(() {
                          isPlaying = false;
                        });
                        AudioPlayerHelper().pauseMusic();
                      },
                    ),
              IconButton(
                iconSize: 60,
                icon: Icon(
                  Icons.stop,
                ),
                onPressed: () {
                  AudioPlayerHelper().stopTrack();
                  setState(() {
                    isPlaying = false;
                  });
                },
              ),
              IconButton(
                iconSize: 70,
                icon: Icon(
                  Icons.fast_forward,
                ),
                onPressed: null,
              ),
            ],
          ),
        ));
  }
}
