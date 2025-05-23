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
  final List<String> commentIds;
  final String id;
  final int likesCount;  // Add this field
  final int commentsCount;  // Add this field

  const Post({
    required this.rearCameraPhotoUrl,
    required this.frontCameraPhotoUrl,
    this.text,
    this.hashtags = const [],
    this.link,
    required this.uid,
    required this.createdAt,
    required this.commentIds,
    required this.id,
    this.likesCount = 0,  // Default to 0
    this.commentsCount = 0,  // Default to 0
  });

  Post copyWith({
    String? rearCameraPhotoUrl,
    String? frontCameraPhotoUrl,
    String? text,
    List<String>? hashtags,
    String? link,
    String? uid,
    DateTime? createdAt,
    List<String>? commentIds,
    String? id,
    int? likesCount,
    int? commentsCount,
  }) {
    return Post(
      rearCameraPhotoUrl: rearCameraPhotoUrl ?? this.rearCameraPhotoUrl,
      frontCameraPhotoUrl: frontCameraPhotoUrl ?? this.frontCameraPhotoUrl,
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
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
    result.addAll({'commentIds': commentIds});
    result.addAll({'likesCount': likesCount});
    result.addAll({'commentsCount': commentsCount});

    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      rearCameraPhotoUrl: map['rearCameraPhotoUrl'] as String,
      frontCameraPhotoUrl: map['frontCameraPhotoUrl'] as String,
      text: map['text'] as String?,
      hashtags: List<String>.from(map['hashtags'] ?? []),
      link: map['link'] as String?,
      uid: map['uid'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      commentIds: List<String>.from(map['commentIds'] ?? []),
      id: map['\$id'] as String,
      likesCount: map['likesCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Post(rearCameraPhotoUrl: $rearCameraPhotoUrl, frontCameraPhotoUrl: $frontCameraPhotoUrl, text: $text, hashtags: $hashtags, link: $link, uid: $uid, createdAt: $createdAt, commentIds: $commentIds, id: $id, likesCount: $likesCount, commentsCount: $commentsCount)';
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
      listEquals(other.commentIds, commentIds) &&
      other.id == id &&
      other.likesCount == likesCount &&
      other.commentsCount == commentsCount;
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
      commentIds.hashCode ^
      id.hashCode ^
      likesCount.hashCode ^
      commentsCount.hashCode;
  }
}
