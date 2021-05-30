import 'package:json_annotation/json_annotation.dart';

part 'music_item_list_model.g.dart';

@JsonSerializable()
class MusicItemListModel {
  int resultCount;
  List<Results> results;

  MusicItemListModel({this.resultCount, this.results});

  factory MusicItemListModel.fromJson(Map<String, dynamic> json) =>
      _$MusicItemListModelFromJson(json);

  Map<String, dynamic> toJson() => _$MusicItemListModelToJson(this);
}

@JsonSerializable()
class Results {
  String wrapperType;
  String kind;
  int collectionId;
  int trackId;
  String artistName;
  String collectionName;
  String trackName;
  String collectionCensoredName;
  String trackCensoredName;
  int collectionArtistId;
  String collectionArtistViewUrl;
  String collectionViewUrl;
  String trackViewUrl;
  String previewUrl;
  String artworkUrl30;
  String artworkUrl60;
  String artworkUrl100;
  double collectionPrice;
  double trackPrice;
  double trackRentalPrice;
  double collectionHdPrice;
  double trackHdPrice;
  double trackHdRentalPrice;
  String releaseDate;
  String collectionExplicitness;
  String trackExplicitness;
  int discCount;
  int discNumber;
  int trackCount;
  int trackNumber;
  int trackTimeMillis;
  String country;
  String currency;
  String primaryGenreName;
  String contentAdvisoryRating;
  String shortDescription;
  String longDescription;
  bool hasITunesExtras;
  int artistId;
  String artistViewUrl;
  bool isStreamable;
  String collectionArtistName;

  Results(
      {this.wrapperType,
      this.kind,
      this.collectionId,
      this.trackId,
      this.artistName,
      this.collectionName,
      this.trackName,
      this.collectionCensoredName,
      this.trackCensoredName,
      this.collectionArtistId,
      this.collectionArtistViewUrl,
      this.collectionViewUrl,
      this.trackViewUrl,
      this.previewUrl,
      this.artworkUrl30,
      this.artworkUrl60,
      this.artworkUrl100,
      this.collectionPrice,
      this.trackPrice,
      this.trackRentalPrice,
      this.collectionHdPrice,
      this.trackHdPrice,
      this.trackHdRentalPrice,
      this.releaseDate,
      this.collectionExplicitness,
      this.trackExplicitness,
      this.discCount,
      this.discNumber,
      this.trackCount,
      this.trackNumber,
      this.trackTimeMillis,
      this.country,
      this.currency,
      this.primaryGenreName,
      this.contentAdvisoryRating,
      this.shortDescription,
      this.longDescription,
      this.hasITunesExtras,
      this.artistId,
      this.artistViewUrl,
      this.isStreamable,
      this.collectionArtistName});

  factory Results.fromJson(Map<String, dynamic> json) =>
      _$ResultsFromJson(json);

  Map<String, dynamic> toJson() => _$ResultsToJson(this);
}
