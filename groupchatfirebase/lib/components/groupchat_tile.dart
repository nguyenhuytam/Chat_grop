import 'package:flutter/material.dart';

class GroupChatTile extends StatelessWidget {
  final String groupName;
  final List<String> members;
  final VoidCallback onTap;

  GroupChatTile({
    required this.groupName,
    required this.members,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            // icon
            const Icon(Icons.group),

            const SizedBox(width: 20),

            // group name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Members: ${members.join(', ')}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
