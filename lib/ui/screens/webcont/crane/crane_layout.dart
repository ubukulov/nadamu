import 'package:flutter/material.dart';
import 'package:nadamu/data/variables/colors.dart';

class CraneLayout extends StatelessWidget{
  final Widget content;
  const CraneLayout({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: mainBGColor,
          title: Text('Webcont: Крановщики'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back navigation here
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: content,
        ),
      ),
    );
  }

}