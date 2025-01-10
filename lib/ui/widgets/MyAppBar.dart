import 'package:flutter/material.dart';
import 'package:nadamu/config/variables.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;

  MyAppBar({required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: mainColor,
      title: Text(title),
      /*actions: [
        IconButton(
          icon: Icon(Icons.search), // Add custom action buttons
          onPressed: () {
            // Handle search button press
          },
        ),
        IconButton(
          icon: Icon(Icons.settings), // Add another custom action button
          onPressed: () {
            // Handle settings button press
          },
        ),
      ],*/
    );
  }
}