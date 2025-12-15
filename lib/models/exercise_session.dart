class ExerciseSession {
  final String id;
  final String exerciseType;
  final DateTime startTime;
  final DateTime? endTime;
  final double distance; // km
  final int duration; // seconds
  final double caloriesBurned;
  final double targetValue;
  final List<LocationPoint> route;
  final int repetitions; // for time-based exercises

  ExerciseSession({
    required this.id,
    required this.exerciseType,
    required this.startTime,
    this.endTime,
    this.distance = 0.0,
    this.duration = 0,
    this.caloriesBurned = 0.0,
    this.targetValue = 0.0,
    this.route = const [],
    this.repetitions = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'exerciseType': exerciseType,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'distance': distance,
        'duration': duration,
        'caloriesBurned': caloriesBurned,
        'targetValue': targetValue,
        'route': route.map((p) => p.toJson()).toList(),
        'repetitions': repetitions,
      };

  factory ExerciseSession.fromJson(Map<String, dynamic> json) => ExerciseSession(
        id: json['id'] ?? '',
        exerciseType: json['exerciseType'] ?? '',
        startTime: DateTime.parse(json['startTime']),
        endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
        distance: json['distance']?.toDouble() ?? 0.0,
        duration: json['duration'] ?? 0,
        caloriesBurned: json['caloriesBurned']?.toDouble() ?? 0.0,
        targetValue: json['targetValue']?.toDouble() ?? 0.0,
        route: (json['route'] as List?)?.map((p) => LocationPoint.fromJson(p)).toList() ?? [],
        repetitions: (json['repetitions'] as int?) ?? 0,
      );

  ExerciseSession copyWith({
    String? id,
    String? exerciseType,
    DateTime? startTime,
    DateTime? endTime,
    double? distance,
    int? duration,
    double? caloriesBurned,
    double? targetValue,
    List<LocationPoint>? route,
    int? repetitions,
  }) =>
      ExerciseSession(
        id: id ?? this.id,
        exerciseType: exerciseType ?? this.exerciseType,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        distance: distance ?? this.distance,
        duration: duration ?? this.duration,
        caloriesBurned: caloriesBurned ?? this.caloriesBurned,
        targetValue: targetValue ?? this.targetValue,
        route: route ?? this.route,
        repetitions: repetitions ?? this.repetitions,
      );
}

class LocationPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp.toIso8601String(),
      };

  factory LocationPoint.fromJson(Map<String, dynamic> json) => LocationPoint(
        latitude: json['latitude']?.toDouble() ?? 0.0,
        longitude: json['longitude']?.toDouble() ?? 0.0,
        timestamp: DateTime.parse(json['timestamp']),
      );
}
