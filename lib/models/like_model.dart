class Like {
  final String id;
  final String postId;
  final String uid;
  final DateTime createdAt;

  const Like({
    required this.id,
    required this.postId,
    required this.uid,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      id: map['\$id'] as String,
      postId: map['postId'] as String,
      uid: map['userId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
} 