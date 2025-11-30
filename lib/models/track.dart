class Track {
  final String id;
  final String title;
  final String artist;
  final String? albumArt;
  final String uri;
  final int duration; // milliseconds

  Track({
    required this.id,
    required this.title,
    required this.artist,
    this.albumArt,
    required this.uri,
    required this.duration,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'artist': artist,
        'albumArt': albumArt,
        'uri': uri,
        'duration': duration,
      };

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        artist: json['artist'] ?? '',
        albumArt: json['albumArt'],
        uri: json['uri'] ?? '',
        duration: json['duration'] ?? 0,
      );
}
