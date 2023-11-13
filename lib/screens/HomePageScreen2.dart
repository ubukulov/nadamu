import 'package:flutter/material.dart';
import '../services/Adv.dart';
import '../services/Kitchen.dart';
import '../services/MyPass.dart';
import '../services/Phone.dart';
import '../services/WhiteList.dart';
import '../services/Vacancy.dart';
import '../services/Services.dart';
import 'package:nadamu/screens/QRScreen.dart';

class HomePageScreen2 extends StatefulWidget {

  const HomePageScreen2({super.key});

  @override
  State<HomePageScreen2> createState() => NavigationBottomBarState();
}

class NavigationBottomBarState extends State<HomePageScreen2> {
  int currentPageIndex = 0;

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
            NavigationDestination(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Damu QR',
            ),
            NavigationDestination(
              icon: Icon(Icons.message),
              label: 'Сообщения',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.menu),
              icon: Icon(Icons.menu),
              label: 'Сервисы',
            ),
          ],
        ),
        body: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                  Container(
                    height: 250,
                    child: GridView.count(
                        crossAxisCount: 4, // Number of columns in the grid
                        children: <Widget>[
                          MyPass(),
                          Kitchen(),
                          Vacancy(),
                          Services(),
                          WhiteList(),
                          Adv(),
                          Phone(),
                        ]
                    ),
                  ),
                  Divider(
                    color: Colors.green,
                    thickness: 1,
                    height: 5,
                  ),
                  //Vacancy(),
                  ],
            )
          ),
          Container(
            color: Colors.green,
            alignment: Alignment.center,
            child: MyHome(),
          ),
          Container(
            color: Colors.green,
            alignment: Alignment.center,
            child: const Text('Page 3'),
          ),
          Container(
            color: Colors.blue,
            alignment: Alignment.center,
            child: const Text('Page 4'),
          ),
        ][currentPageIndex],
      ),
    );
  }

}