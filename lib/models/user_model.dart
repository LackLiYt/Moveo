import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String email;
  final String name;
  final List<String> followers;
  final List<String> following;
  final String profilePic;
  final String bannerPic;
  final String uid;
  final String bio;
  final bool isCooked;
  final int points;
  final int level;
  final int experience; // Current experience points
  final int experienceToNextLevel; // Experience needed for next level

  const UserModel({
    required this.email,
    required this.name,
    required this.followers,
    required this.following,
    required this.profilePic,
    required this.bannerPic,
    required this.uid,
    required this.bio,
    required this.isCooked,
    this.points = 0,
    this.level = 1,
    this.experience = 0,
    this.experienceToNextLevel = 100,
  });

  UserModel copyWith({
    String? email,
    String? name,
    List<String>? followers,
    List<String>? following,
    String? profilePic,
    String? bannerPic,
    String? uid,
    String? bio,
    bool? isCooked,
    int? points,
    int? level,
    int? experience,
    int? experienceToNextLevel,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      isCooked: isCooked ?? this.isCooked,
      points: points ?? this.points,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      experienceToNextLevel: experienceToNextLevel ?? this.experienceToNextLevel,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'followers': followers});
    result.addAll({'following': following});
    result.addAll({'profilePic': profilePic});
    result.addAll({'bannerPic': bannerPic});
    result.addAll({'uid': uid});
    result.addAll({'bio': bio});
    result.addAll({'isCooked': isCooked});
    result.addAll({'points': points});
    result.addAll({'level': level});
    result.addAll({'experience': experience});
    result.addAll({'experienceToNextLevel': experienceToNextLevel});
    
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      profilePic: map['profilePic'] ?? '',
      bannerPic: map['bannerPic'] ?? '',
      uid: map['uid'] ?? '',
      bio: map['bio'] ?? '',
      isCooked: map['isCooked'] ?? false,
      points: map['points'] ?? 0,
      level: map['level'] ?? 1,
      experience: map['experience'] ?? 0,
      experienceToNextLevel: map['experienceToNextLevel'] ?? 100,
    );
  }

  // Calculate experience needed for next level
  static int calculateExperienceForLevel(int level) {
    // Exponential growth formula: base * (multiplier ^ (level - 1))
    const base = 100;
    const multiplier = 1.5;
    return (base * (multiplier * (level - 1))).round();
  }

  // Add experience and handle level up
  UserModel addExperience(int amount) {
    int newExperience = experience + amount;
    int newLevel = level;
    int newExperienceToNextLevel = experienceToNextLevel;

    // Check for level up
    while (newExperience >= newExperienceToNextLevel) {
      newExperience -= newExperienceToNextLevel;
      newLevel++;
      newExperienceToNextLevel = calculateExperienceForLevel(newLevel);
    }

    return copyWith(
      experience: newExperience,
      level: newLevel,
      experienceToNextLevel: newExperienceToNextLevel,
    );
  }

  // Add points
  UserModel addPoints(int amount) {
    return copyWith(points: points + amount);
  }

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, followers: $followers, following: $following, profilePic: $profilePic, bannerPic: $bannerPic, uid: $uid, bio: $bio, isCooked: $isCooked, points: $points, level: $level, experience: $experience, experienceToNextLevel: $experienceToNextLevel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.email == email &&
      other.name == name &&
      listEquals(other.followers, followers) &&
      listEquals(other.following, following) &&
      other.profilePic == profilePic &&
      other.bannerPic == bannerPic &&
      other.uid == uid &&
      other.bio == bio &&
      other.isCooked == isCooked &&
      other.points == points &&
      other.level == level &&
      other.experience == experience &&
      other.experienceToNextLevel == experienceToNextLevel;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      name.hashCode ^
      followers.hashCode ^
      following.hashCode ^
      profilePic.hashCode ^
      bannerPic.hashCode ^
      uid.hashCode ^
      bio.hashCode ^
      isCooked.hashCode ^
      points.hashCode ^
      level.hashCode ^
      experience.hashCode ^
      experienceToNextLevel.hashCode;
  }
}
