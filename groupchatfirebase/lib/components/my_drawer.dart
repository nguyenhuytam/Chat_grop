import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // logo
          DrawerHeader(
            child: Center(
              child: Center(
                child: Icon(
                  Icons.message,
                  size: 40,
                ),
              ),
            ),
          )

          // home list title
          // setting
        ],
      ),
    );
  }
}
