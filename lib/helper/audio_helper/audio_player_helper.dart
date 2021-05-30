import 'package:audioplayers/audioplayers.dart';
import 'package:demo_itunes_music/helper/audio_helper/audiodownloader.dart';

class AudioPlayerHelper {
  final _audioPlayer = AudioPlayer();
  final _audioDownloader = AudioDownloader();
  static final AudioPlayerHelper _singleton = new AudioPlayerHelper._internal();

  factory AudioPlayerHelper() {
    return _singleton;
  }

  AudioPlayerHelper._internal() {}

  playTrack(String url) async {
    var previewFilename = await _audioDownloader.downloadUrl(url);
    await _audioPlayer.play(previewFilename, isLocal: true);
  }

  stopTrack() async {
    await _audioPlayer.stop();
  }

  void pauseMusic() {
    _audioPlayer.pause();
  }
}
