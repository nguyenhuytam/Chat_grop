import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMessage {
  final String messageId; // ID của tin nhắn
  final String groupId; // ID của nhóm chat
  final String senderId; // ID của người gửi
  final String senderName; // Tên người gửi
  final String message; // Nội dung tin nhắn
  final Timestamp timestamp; // Thời gian gửi tin nhắn

  GroupMessage({
    required this.messageId,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });

  // Chuyển đổi sang một Map
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'groupId': groupId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp,
    };
  }

  // Tạo một đối tượng GroupMessage từ một Map
  static GroupMessage fromMap(Map<String, dynamic> map) {
    return GroupMessage(
      messageId: map['messageId'],
      groupId: map['groupId'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
