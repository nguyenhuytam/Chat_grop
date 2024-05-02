import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChat {
  final String groupId; // ID của nhóm chat
  final String groupName; // Tên nhóm chat
  final List<String> members; // Danh sách các thành viên trong nhóm
  final Timestamp createdAt; // Thời gian tạo nhóm

  GroupChat({
    required this.groupId,
    required this.groupName,
    required this.members,
    required this.createdAt,
    required name,
    required String id,
  });

  // Chuyển đổi sang một Map
  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'members': members,
      'createdAt': createdAt,
    };
  }

  // Tạo một đối tượng GroupChat từ một Map
  static GroupChat fromMap(Map<String, dynamic> map) {
    return GroupChat(
      groupId: map['groupId'],
      groupName: map['groupName'],
      members: List<String>.from(map['members']),
      createdAt: map['createdAt'],
      id: '',
      name: null,
    );
  }
}
