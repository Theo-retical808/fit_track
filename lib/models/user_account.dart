import 'user_profile.dart';
import 'exercise_session.dart';
import 'track.dart';

class UserAccount {
  final String username;
  final String password;
  final String userDataFile;
  final DateTime createdAt;

  UserAccount({
    required this.username,
    required this.password,
    required this.userDataFile,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'userDataFile': userDataFile,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        username: json['username'] ?? '',
        password: json['password'] ?? '',
        userDataFile: json['userDataFile'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
      );
}

class UserData {
  final String username;
  UserProfile? profile;
  List<ExerciseSession> exerciseHistory;
  List<Track> musicPlaylist;

  UserData({
    required this.username,
    this.profile,
    this.exerciseHistory = const [],
    this.musicPlaylist = const [],
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'profile': profile?.toJson(),
        'exerciseHistory': exerciseHistory.map((e) => e.toJson()).toList(),
        'musicPlaylist': musicPlaylist.map((t) => t.toJson()).toList(),
      };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        username: json['username'] ?? '',
        profile: json['profile'] != null
            ? UserProfile.fromJson(json['profile'])
            : null,
        exerciseHistory: (json['exerciseHistory'] as List?)
                ?.map((e) => ExerciseSession.fromJson(e))
                .toList() ??
            [],
        musicPlaylist: (json['musicPlaylist'] as List?)
                ?.map((t) => Track.fromJson(t))
                .toList() ??
            [],
      );
}
