import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Set the AppBar height

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(126, 184, 39, 1.0), // Set the background color
      title: const Text(
        'nadamu.kz'
      ),
      actions: [
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
      ],
      leading: IconButton(
        icon: Icon(Icons.menu), // Set the leading icon (e.g., menu icon)
        onPressed: () {
          // Handle leading button press
        },
      ),
    );
  }
}