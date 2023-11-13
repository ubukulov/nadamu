import 'package:flutter/material.dart';
import '../patterns/MyAppBar.dart';

class CommonLayout extends StatelessWidget{
  final Widget content;
  const CommonLayout({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      home: Scaffold(
        appBar: MyAppBar(),
        body: content,
      ),
    );
  }

}