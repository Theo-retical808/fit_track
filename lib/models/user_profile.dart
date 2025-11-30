class UserProfile {
  final String name;
  final int age;
  final double weight; // kg
  final double height; // cm
  final String gender;

  UserProfile({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'weight': weight,
        'height': height,
        'gender': gender,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] ?? '',
        age: json['age'] ?? 0,
        weight: json['weight']?.toDouble() ?? 0.0,
        height: json['height']?.toDouble() ?? 0.0,
        gender: json['gender'] ?? '',
      );

  UserProfile copyWith({
    String? name,
    int? age,
    double? weight,
    double? height,
    String? gender,
  }) =>
      UserProfile(
        name: name ?? this.name,
        age: age ?? this.age,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        gender: gender ?? this.gender,
      );
}
