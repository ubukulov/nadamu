import 'package:flutter/material.dart';
import 'package:nadamu/services/MyPass.dart';
import 'package:nadamu/services/Kitchen.dart';
import 'package:nadamu/services/Phone.dart';
import 'package:nadamu/services/WhiteList.dart';
import 'package:nadamu/services/Adv.dart';
import 'package:nadamu/layouts/CommonLayout.dart';
import 'package:nadamu/layouts/DefaultLayout.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});
  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      content: GridView.count(
        crossAxisCount: 4, // Number of columns in the grid
        children: <Widget>[
          MyPass(),
          Kitchen(),
          Phone(),
          WhiteList(),
          Adv(),
          Kitchen(),
          Phone(),
          WhiteList(),
        ]
      ),
    );
  }
}