import 'package:flutter/foundation.dart';

@immutable
class Post {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  const Post({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.createdAt,
    required this.likes,
    required this.commentIds,
    required this.id,
  });

  Post copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    List<String>? imageLinks,
    String? uid,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
  }) {
    return Post(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'hashtags': hashtags,
      'link': link,
      'imageLinks': imageLinks,
      'uid': uid,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      text: map['text'] ?? '',
      hashtags: List<String>.from(map['hashtags']),
      link: map['link'] ?? '',
      imageLinks: List<String>.from(map['imageLinks'] ),
      uid: map['uid'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      likes: List<String>.from(map['likes']),
      commentIds: List<String>.from(map['commentIds']),
      id: map['\$id'] ?? '',
    );
  }


  @override
  String toString() {
    return 'Post(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, createdAt: $createdAt, likes: $likes, commentIds: $commentIds, id: $id)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;
  
    return 
      other.text == text &&
      other.hashtags == hashtags &&
      other.link == link &&
      listEquals(other.imageLinks, imageLinks) &&
      other.uid == uid &&
      other.createdAt == createdAt &&
      listEquals(other.likes, likes) &&
      listEquals(other.commentIds, commentIds) &&
      other.id == id;
  }

  @override
  int get hashCode {
    return text.hashCode ^
      hashtags.hashCode ^
      link.hashCode ^
      imageLinks.hashCode ^
      uid.hashCode ^
      createdAt.hashCode ^
      likes.hashCode ^
      commentIds.hashCode ^
      id.hashCode;
  }
}
