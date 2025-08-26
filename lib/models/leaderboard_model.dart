import 'package:flutter/foundation.dart';
import 'package:moveo/models/user_model.dart';

@immutable
class LeaderboardModel {
  final String uid;
  final String name;
  final int steps;
  final String profilePic;

  const LeaderboardModel({
    required this.uid,
    required this.name,
    required this.steps,
    required this.profilePic,
  });

  LeaderboardModel copyWith({
    String? uid,
    String? name,
    int? steps,
    String? profilePic,
  }) {
    return LeaderboardModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      steps: steps ?? this.steps,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'steps': steps,
      'profilePic': profilePic,
    };
  }

  factory LeaderboardModel.fromMap(Map<String, dynamic> map) {
    return LeaderboardModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      steps: map['steps'] ?? 0,
      profilePic: map['profilePic'] ?? '',
    );
  }

  factory LeaderboardModel.fromUser(UserModel user, {required int steps}) {
    return LeaderboardModel(
      uid: user.uid,
      name: user.name,
      steps: steps,
      profilePic: user.profilePic,
    );
  }

  @override
  String toString() {
    return 'LeaderboardModel(uid: $uid, name: $name, steps: $steps, profilePic: $profilePic)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LeaderboardModel &&
        other.uid == uid &&
        other.name == name &&
        other.steps == steps &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        steps.hashCode ^
        profilePic.hashCode;
  }
}
