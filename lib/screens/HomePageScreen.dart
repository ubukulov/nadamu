import 'package:flutter/material.dart';
import 'package:nadamu/screens/cabinet/CabinetScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/Adv.dart';
import '../services/Kitchen.dart';
import '../services/MyPass.dart';
import '../services/Phone.dart';
import '../services/WhiteList.dart';
import '../services/Vacancy.dart';
import '../services/Services.dart';
import 'package:nadamu/screens/ashana/AshanaQRService.dart';
import 'dart:convert';

class HomePageScreen extends StatefulWidget {
  static const routeName = '/';
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => NavigationBottomBarState();
}

class NavigationBottomBarState extends State<HomePageScreen> {
  int currentPageIndex = 0;
  List<Widget> servicesList = [];

  @override
  void initState() {
    super.initState();
    generateWidgetsList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: const Color.fromRGBO(126, 184, 39, 1.0),
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Главная',
            ),
            /*NavigationDestination(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Damu QR',
            ),*/
            NavigationDestination(
              icon: Icon(Icons.message),
              label: 'Сообщения',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.account_box),
              icon: Icon(Icons.account_box),
              label: 'Профиль',
            ),
          ],
        ),
        body: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                  Container(
                    height: 250,
                    child: GridView.count(
                        crossAxisCount: 4, // Number of columns in the grid
                        children: servicesList
                    ),
                  ),
                  Divider(
                    color: Colors.green,
                    thickness: 1,
                    height: 5,
                  ),
                  ],
            )
          ),
          /*Container(
            color: Colors.green,
            alignment: Alignment.center,
            child: MyHome(),
          ),*/
          Container(
            color: Colors.green,
            alignment: Alignment.center,
            child: const Text('Page 2'),
          ),
          CabinetScreen(),
        ][currentPageIndex],
      ),
    );
  }

  Future<void> generateWidgetsList() async {
    final prefs =  await SharedPreferences.getInstance();
    String? userRoles = prefs.getString('user');

    Map<String, dynamic> roles = json.decode(userRoles!);

    for(int i = 0; i < roles['roles'].length; i++) {
      switch(roles['roles'][i]['slug']) {
        case "ashana":
          setState(() {
            servicesList = [];
            servicesList.add(AshanaQRService());
          });

          break;

        default:
          setState(() {
            servicesList = [];
            if(!servicesList.contains(MyPass())) {
              servicesList.add(MyPass());
            }
            if(!servicesList.contains(Kitchen())) {
              servicesList.add(Kitchen());
            }
            if(!servicesList.contains(Vacancy())) {
              servicesList.add(Vacancy());
            }
            if(!servicesList.contains(Adv())) {
              servicesList.add(Adv());
            }
            if(!servicesList.contains(Phone())) {
              servicesList.add(Phone());
            }
          });
      }
    }
  }
}