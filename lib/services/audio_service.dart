// import 'package:on_audio_query/on_audio_query.dart'; // Temporarily disabled
import '../models/track.dart';

class AudioService {
  // static final OnAudioQuery _audioQuery = OnAudioQuery(); // Temporarily disabled

  static Future<bool> checkPermission() async {
    // return await _audioQuery.permissionsStatus(); // Temporarily disabled
    return true; // Mock permission for now
  }

  static Future<bool> requestPermission() async {
    // return await _audioQuery.permissionsRequest(); // Temporarily disabled
    return true; // Mock permission for now
  }

  static Future<List<Track>> getDeviceTracks() async {
    // Temporarily return mock data instead of querying device
    return [
      Track(
        id: '1',
        title: 'Sample Song 1',
        artist: 'Sample Artist',
        albumArt: null,
        uri: 'sample_uri_1',
        duration: 180000, // 3 minutes
      ),
      Track(
        id: '2',
        title: 'Sample Song 2',
        artist: 'Another Artist',
        albumArt: null,
        uri: 'sample_uri_2',
        duration: 240000, // 4 minutes
      ),
    ];
    
    /* Original implementation - temporarily disabled
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
    */
  }
}
