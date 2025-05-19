import 'package:flutter/foundation.dart';

@immutable
class ChatModel {
  final String id;
  final String userId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserProfilePic;
  final String lastMessage;
  final DateTime lastMessageTime;

  const ChatModel({
    required this.id,
    required this.userId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserProfilePic,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  ChatModel copyWith({
    String? id,
    String? userId,
    String? otherUserId,
    String? otherUserName,
    String? otherUserProfilePic,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) {
    return ChatModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserProfilePic: otherUserProfilePic ?? this.otherUserProfilePic,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      'otherUserProfilePic': otherUserProfilePic,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      otherUserId: map['otherUserId'] ?? '',
      otherUserName: map['otherUserName'] ?? '',
      otherUserProfilePic: map['otherUserProfilePic'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: DateTime.parse(map['lastMessageTime'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  String toString() {
    return 'ChatModel(id: $id, userId: $userId, otherUserId: $otherUserId, otherUserName: $otherUserName, otherUserProfilePic: $otherUserProfilePic, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ChatModel &&
      other.id == id &&
      other.userId == userId &&
      other.otherUserId == otherUserId &&
      other.otherUserName == otherUserName &&
      other.otherUserProfilePic == otherUserProfilePic &&
      other.lastMessage == lastMessage &&
      other.lastMessageTime == lastMessageTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      otherUserId.hashCode ^
      otherUserName.hashCode ^
      otherUserProfilePic.hashCode ^
      lastMessage.hashCode ^
      lastMessageTime.hashCode;
  }
}

class ChatMessage {
  final String messageId;
  final String message;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;
  final bool isSeenByReceiver;
  final bool isImage;
  final bool isGroupInvite;
  final List<String> userData;

  ChatMessage({
    required this.messageId,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.isSeenByReceiver,
    required this.isImage,
    required this.isGroupInvite,
    required this.userData,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      messageId: map['\$id'] ?? '',
      message: map['message'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      isSeenByReceiver: map['isSeenbyReceiver'] ?? false,
      isImage: map['isImage'] ?? false,
      isGroupInvite: map['isGroupInvite'] ?? false,
      userData: List<String>.from(map['userData'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp.toIso8601String(),
      'isSeenbyReceiver': isSeenByReceiver,
      'isImage': isImage,
      'isGroupInvite': isGroupInvite,
      'userData': userData,
    };
  }
}

class ChatData {
  final ChatMessage message;
  final List<String> users;

  ChatData({
    required this.message,
    required this.users,
  });
}

class GroupMessage {
  final String messageId;
  final String groupId;
  final String message;
  final String senderId;
  final DateTime timestamp;
  final bool isImage;
  final List<String> userData;

  GroupMessage({
    required this.messageId,
    required this.groupId,
    required this.message,
    required this.senderId,
    required this.timestamp,
    required this.isImage,
    required this.userData,
  });

  factory GroupMessage.fromMap(Map<String, dynamic> map) {
    return GroupMessage(
      messageId: map['\$id'] ?? '',
      groupId: map['groupId'] ?? '',
      message: map['message'] ?? '',
      senderId: map['senderId'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      isImage: map['isImage'] ?? false,
      userData: List<String>.from(map['userData'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'message': message,
      'senderId': senderId,
      'timestamp': timestamp.toIso8601String(),
      'isImage': isImage,
      'userData': userData,
    };
  }
} 