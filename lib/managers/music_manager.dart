import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';
import '../services/audio_service.dart';

class MusicManager extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Track> _playlist = [];
  int _currentIndex = -1;

  List<Track> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  Track? get currentTrack => _currentIndex >= 0 && _currentIndex < _playlist.length
      ? _playlist[_currentIndex]
      : null;

  bool get isPlaying => _audioPlayer.playing;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  Future<void> loadPlaylist() async {
    _playlist = await AudioService.getDeviceTracks();
    notifyListeners();
  }

  Future<void> play(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    final track = _playlist[index];

    try {
      await _audioPlayer.setFilePath(track.uri);
      await _audioPlayer.play();
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing track: $e');
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    notifyListeners();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
    notifyListeners();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    notifyListeners();
  }

  Future<void> next() async {
    if (_currentIndex < _playlist.length - 1) {
      await play(_currentIndex + 1);
    }
  }

  Future<void> previous() async {
    if (_currentIndex > 0) {
      await play(_currentIndex - 1);
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
