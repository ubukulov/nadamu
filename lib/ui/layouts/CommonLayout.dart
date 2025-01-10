import 'package:flutter/material.dart';
import 'package:nadamu/config/variables.dart';

class CommonLayout extends StatelessWidget{
  final String title;
  final Widget content;
  const CommonLayout({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: mainColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: content,
      ),
    );
  }

}