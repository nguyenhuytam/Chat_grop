import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String groupId; // ID của nhóm
  final String groupName; // Tên nhóm

  Group({
    required this.groupId,
    required this.groupName,
  });

  // Chuyển đổi sang một Map
  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
    };
  }

  // Tạo một đối tượng Group từ một Map
  static Group fromMap(Map<String, dynamic> map) {
    return Group(
      groupId: map['groupId'],
      groupName: map['groupName'],
    );
  }
}
