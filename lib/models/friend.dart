class Friend {
  final String id;
  final String uid;
  final String friendId;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime createdAt;
  final DateTime? updatedAt;

  Friend({
    required this.id,
    required this.uid,
    required this.friendId,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['\$id'] ?? '',
      uid: map['uid'] ?? '',
      friendId: map['friendId'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'friendId': friendId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Friend copyWith({
    String? id,
    String? uid,
    String? friendId,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Friend(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      friendId: friendId ?? this.friendId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 