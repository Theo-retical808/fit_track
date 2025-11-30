import 'package:on_audio_query/on_audio_query.dart';
import '../models/track.dart';

class AudioService {
  static final OnAudioQuery _audioQuery = OnAudioQuery();

  static Future<bool> checkPermission() async {
    return await _audioQuery.permissionsStatus();
  }

  static Future<bool> requestPermission() async {
    return await _audioQuery.permissionsRequest();
  }

  static Future<List<Track>> getDeviceTracks() async {
    final hasPermission = await checkPermission() || await requestPermission();
    if (!hasPermission) return [];

    final songs = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );

    return songs.map((song) => Track(
      id: song.id.toString(),
      title: song.title,
      artist: song.artist ?? 'Unknown Artist',
      albumArt: song.uri,
      uri: song.uri ?? '',
      duration: song.duration ?? 0,
    )).toList();
  }
}
