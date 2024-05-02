import 'package:flutter/material.dart';
import 'package:groupchatfirebase/components/groupchat_tile.dart';
import 'package:groupchatfirebase/components/user_tile.dart'; // Import UserTile
import 'package:groupchatfirebase/page/chat_page.dart';
import 'package:groupchatfirebase/page/group_chat/addmemberchat_page.dart';
import 'package:groupchatfirebase/page/group_chat/groupchat_page.dart';
import 'package:groupchatfirebase/services/auth/auth_service.dart';
import 'package:groupchatfirebase/components/my_drawer.dart';
import 'package:groupchatfirebase/services/chat/chat_service.dart';
import 'package:groupchatfirebase/services/chat/groupchat_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService(); // Khởi tạo service cho chat
  final AuthService _authService =
      AuthService(); // Khởi tạo service cho authentication
  final GroupChatService _groupChatService = GroupChatService();
  late List<Map<String, dynamic>> _groupChats = []; // Danh sách các nhóm chat

  @override
  void initState() {
    super.initState();
    _updateGroupChats(); // Gọi hàm để cập nhật danh sách nhóm chat
  }

  void _updateGroupChats() {
    _groupChatService.getGroupChatsStream().listen((groups) {
      setState(() {
        _groupChats = groups; // Cập nhật danh sách nhóm chat khi có thay đổi
      });
    });
  }

  void logout(BuildContext context) {
    final _auth = AuthService();
    _auth.signOut(); // Đăng xuất người dùng
    Navigator.pop(context);
  }

  void _createGroupChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateGroupChatPage(), // Mở trang tạo nhóm chat
      ),
    );
  }

  // chat with user
  void navigateToChatPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverEmail: 'Email của người nhận',
          receiverID: 'ID của người nhận',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () => _createGroupChat(context), // Nút tạo nhóm chat
            icon: Icon(Icons.group_add),
          ),
          IconButton(
            onPressed: () => logout(context), // Nút đăng xuất
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: const MyDrawer(), // Menu bên trái
      body: _buildUserList(), // Hiển thị danh sách người dùng và nhóm chat
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUsersStream(), // Lấy stream người dùng từ service
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        List<Widget> tiles = [];

        List<Map<String, dynamic>> users =
            snapshot.data!; // Danh sách người dùng
        tiles.addAll(users.map<Widget>((userData) => _buildUserListItem(
            userData, context))); // Tạo giao diện cho từng người dùng

        // Thêm danh sách GroupChatTile
        tiles.add(const Text('Group Chats',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
        tiles.addAll(_groupChats.map<Widget>(
            (groupChat) => _buildGroupChatTile(groupChat, context)));

        return ListView(
          children: tiles,
        );
      },
    );
  }

  Widget _buildGroupChatTile(
      Map<String, dynamic> groupChat, BuildContext context) {
    // Extract group chat information from the groupChat object
    String groupName =
        groupChat['name']; // Replace with actual group name property
    List<String> members = groupChat['members']?.cast<String>() ??
        []; // Safe access and null check
    // Replace with actual members list property

    return GroupChatTile(
      groupName: groupName,
      members: members,
      onTap: () {
        // Navigate to the GroupChatPage for the specific group
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupChatPage(
              groupId: groupChat['groupId'] ?? '',
              groupName: groupName,

              // Sử dụng tên thuộc tính thực tế
              senderId: _authService.getCurrentUser()?.uid ?? '',
              senderName: _authService.getCurrentUser()?.displayName ?? '',
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
