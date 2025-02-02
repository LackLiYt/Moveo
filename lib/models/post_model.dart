import 'package:flutter/foundation.dart';

@immutable
class Post {
  final String rearCameraPhotoUrl; // Required URL of the rear camera photo
  final String frontCameraPhotoUrl; // Required URL of the front camera photo
  final String? text; // Optional text
  final List<String> hashtags;
  final String? link; // Optional link in text
  final String uid; // User ID
  final DateTime createdAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;

  const Post({
    required this.rearCameraPhotoUrl,
    required this.frontCameraPhotoUrl,
    this.text,
    this.hashtags = const [],
    this.link,
    required this.uid,
    required this.createdAt,
    required this.likes,
    required this.commentIds,
    required this.id,
  });

  Post copyWith({
    String? rearCameraPhotoUrl,
    String? frontCameraPhotoUrl,
    String? text,
    List<String>? hashtags,
    String? link,
    String? uid,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
  }) {
    return Post(
      rearCameraPhotoUrl: rearCameraPhotoUrl ?? this.rearCameraPhotoUrl,
      frontCameraPhotoUrl: frontCameraPhotoUrl ?? this.frontCameraPhotoUrl,
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'rearCameraPhotoUrl': rearCameraPhotoUrl});
    result.addAll({'frontCameraPhotoUrl': frontCameraPhotoUrl});
    if (text != null) result.addAll({'text': text});
    result.addAll({'hashtags': hashtags});
    if (link != null) result.addAll({'link': link});
    result.addAll({'uid': uid});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'likes': likes});
    result.addAll({'commentIds': commentIds});

    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      rearCameraPhotoUrl: map['rearCameraPhotoUrl'] as String, // Required
      frontCameraPhotoUrl: map['frontCameraPhotoUrl'] as String, // Required
      text: map['text'] ?? '',
      hashtags: List<String>.from(map['hashtags'] ?? []),
      link: map['link'] ?? '',
      uid: map['uid'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      likes: List<String>.from(map['likes'] ?? []),
      commentIds: List<String>.from(map['commentIds'] ?? []),
      id: map['\$id'] ?? '',
    );
  }


  @override
  String toString() {
    return 'Post(rearCameraPhotoUrl: $rearCameraPhotoUrl, frontCameraPhotoUrl: $frontCameraPhotoUrl, text: $text, hashtags: $hashtags, link: $link, uid: $uid, createdAt: $createdAt, likes: $likes, commentIds: $commentIds, id: $id)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return 
      other.rearCameraPhotoUrl == rearCameraPhotoUrl &&
      other.frontCameraPhotoUrl == frontCameraPhotoUrl &&
      other.text == text &&
      listEquals(other.hashtags, hashtags) &&
      other.link == link &&
      other.uid == uid &&
      other.createdAt == createdAt &&
      listEquals(other.likes, likes) &&
      listEquals(other.commentIds, commentIds) &&
      other.id == id;
  }

  @override
  int get hashCode {
    return rearCameraPhotoUrl.hashCode ^
      frontCameraPhotoUrl.hashCode ^
      text.hashCode ^
      hashtags.hashCode ^
      link.hashCode ^
      uid.hashCode ^
      createdAt.hashCode ^
      likes.hashCode ^
      commentIds.hashCode ^
      id.hashCode;
  }
}
