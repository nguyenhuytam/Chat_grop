import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchatfirebase/components/chat_bubble.dart';
import 'package:groupchatfirebase/components/my_textfield.dart';
import 'package:groupchatfirebase/models/group_message/group_chat.dart';
import 'package:groupchatfirebase/models/group_message/group_message.dart';
import 'package:groupchatfirebase/services/auth/auth_service.dart';
import 'package:groupchatfirebase/services/chat/groupchat_service.dart';

class GroupChatPage extends StatefulWidget {
  final String groupId;
  final String senderId;
  final String senderName;
  final String groupName;

  GroupChatPage({
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.groupName,
    Key? key,
  }) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final GroupChatService _chatService = GroupChatService();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _myFocusNode.addListener(() {
      if (_myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
  }

  @override
  void dispose() {
    _myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      if (_authService.getCurrentUser() != null) {
        await _chatService.sendGroupMessage(
          widget.groupId,
          _messageController.text,
          widget.senderId,
          widget.senderName,
        );
        _messageController.clear();
      } else {
        // Handle the case where the user is not authenticated.
        // For example, you can show an error message or redirect the user to the login page.
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.groupName)),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<List<GroupMessage>>(
      stream: _chatService.getGroupMessagesStream(widget.groupId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
        List<GroupMessage> messages = snapshot.data!;
        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(messages[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(GroupMessage message) {
    return ListTile(
      title: Text(widget.groupName),
      subtitle: Text(message.senderName),
      trailing: IconButton(
        icon: Icon(Icons.edit), // Edit icon
        onPressed: () {
          // Handle edit functionality
          _editMessage(message);
        },
      ),
      onLongPress: () {
        // Long press to delete message
        _deleteMessage(message);
      },
    );
  }

  void _editMessage(GroupMessage message) {
    // Implement edit message functionality
  }

  void _deleteMessage(GroupMessage message) {
    // Implement delete message functionality
  }
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
              focusNode: _myFocusNode,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
