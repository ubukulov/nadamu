import 'package:flutter/material.dart';
import 'package:nadamu/ui/screens/ashana/AshanaQRService.dart';
import 'package:nadamu/data/services/Kitchen.dart';

class AshanaScreen extends StatefulWidget {

  const AshanaScreen({super.key});

  @override
  State<AshanaScreen> createState() => NavigationBottomBarState();
}

class NavigationBottomBarState extends State<AshanaScreen> {
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
              icon: Icon(Icons.message),
              label: 'Сообщения',
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
                          AshanaQRService(),
                          Kitchen(),
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
            child: const Text('Сообщение'),
          ),
        ][currentPageIndex],
      ),
    );
  }

}