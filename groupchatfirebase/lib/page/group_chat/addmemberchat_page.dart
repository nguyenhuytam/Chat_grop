import 'package:flutter/material.dart';
import 'package:groupchatfirebase/page/group_chat/groupchat_page.dart';
import 'package:groupchatfirebase/services/auth/auth_service.dart';
import 'package:groupchatfirebase/services/chat/chat_service.dart';
import 'package:groupchatfirebase/services/chat/groupchat_service.dart';

class CreateGroupChatPage extends StatefulWidget {
  @override
  _CreateGroupChatPageState createState() => _CreateGroupChatPageState();
}

class _CreateGroupChatPageState extends State<CreateGroupChatPage> {
  final TextEditingController _groupNameController = TextEditingController();
  List<String> _selectedUsers = [];
  final GroupChatService _groupChatService = GroupChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Group Chat"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _groupChatService.getUsersStream(),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return Text("Error");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading..");
                }
                List<Map<String, dynamic>> users = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    String email = users[index]["email"] ?? "";
                    return CheckboxListTile(
                      title: Text(email),
                      value: _selectedUsers.contains(email),
                      onChanged: (isChecked) {
                        setState(() {
                          if (isChecked!) {
                            _selectedUsers.add(email);
                          } else {
                            _selectedUsers.remove(email);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _createGroup,
            child: Text("Create Group"),
          ),
        ],
      ),
    );
  }

  void _createGroup() {
    String groupName = _groupNameController.text;
    String currentUserEmail = _authService.getCurrentUser()!.email!;
    List<String> members = List.from(_selectedUsers);
    members
        .add(currentUserEmail); // Thêm người tạo nhóm vào danh sách thành viên

    // Tạo nhóm chat mới bằng GroupChatService
    _groupChatService.createGroupChat(groupName, members);

    // Đóng trang tạo nhóm chat và quay lại trang chính
    Navigator.pop(context);
  }
}
