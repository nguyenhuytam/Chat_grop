import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupchatfirebase/models/group_message/group_chat.dart';
import 'package:groupchatfirebase/models/group_message/group_message.dart';
import 'package:groupchatfirebase/models/group_message/group_member.dart';
import 'package:groupchatfirebase/models/group_message/group.dart'; // Import class Group

class GroupChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createGroupChat(String groupName, List<String> members) async {
    try {
      String groupId = _firestore.collection('groups').doc().id;
      // Tạo một tài liệu mới trong Firestore
      DocumentReference groupRef = await _firestore
          .collection('groups')
          .add({'name': groupName, 'members': members, 'groupId': groupId});

      // Thêm thông tin về nhóm vào tài liệu của từng thành viên
      for (String memberId in members) {
        // Tạo một tài liệu nhóm trong collection của mỗi thành viên
        await _firestore
            .collection('users')
            .doc(memberId)
            .collection('groups')
            .doc(groupId)
            .set({
          'name': groupName,
          'groupId': groupId,
        });
      }
    } catch (e) {
      print('Error creating group chat: $e');
      throw e; // Re-throw để cho phép lớp gọi xử lý ngoại lệ theo cách phù hợp
    }
  }

  Stream<List<Map<String, dynamic>>> getGroupChatsStream() {
    return _firestore.collection("groups").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final group = doc.data();
        return group;
      }).toList();
    });
  }

  // Phương thức để thêm thành viên vào nhóm chat
  Future<void> addMemberToGroup(String groupId, String memberId) async {
    try {
      // Tạo một tài liệu mới trong Firestore
      await _firestore.collection('group_members').add({
        'groupId': groupId,
        'userId': memberId,
      });
    } catch (e) {
      print('Error adding member to group: $e');
      throw e; // Re-throw để cho phép lớp gọi xử lý ngoại lệ theo cách phù hợp
    }
  }

  // Phương thức để lấy danh sách người dùng từ Firestore
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Lấy trường "email" của mỗi người dùng
        final String email = doc.data()["email"];

        // Trả về một Map chứa thông tin của mỗi người dùng
        return {
          "email": email,
          // Các trường khác nếu cần
        };
      }).toList();
    });
  }

  // Phương thức để gửi tin nhắn trong nhóm
  Future<void> sendGroupMessage(String groupId, String message, String senderId,
      String senderName) async {
    try {
      // Tạo một tài liệu mới trong Firestore
      await _firestore.collection('group_messages').add({
        'groupId': groupId,
        'message': message,
        'senderId': senderId,
        'senderName': senderName,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error sending group message: $e');
      throw e; // Re-throw để cho phép lớp gọi xử lý ngoại lệ theo cách phù hợp
    }
  }

  // Phương thức để lấy tin nhắn trong nhóm
  Stream<List<GroupMessage>> getGroupMessagesStream(String groupId) {
    return _firestore
        .collection("group_messages")
        .where('groupId', isEqualTo: groupId)
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return GroupMessage.fromMap(doc.data());
      }).toList();
    });
  }
}
