import 'package:flutter/material.dart';
import 'package:nadamu/screens/HomePageScreen.dart';
import 'package:nadamu/screens/HomePageScreen2.dart';
import 'package:nadamu/screens/QRScreen.dart';
import 'package:nadamu/screens/AuthScreen.dart';
import 'package:nadamu/screens/ashana/AshanaScreen.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:nadamu/routers/Router.dart';
import 'package:nadamu/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

var mainColor = const Color.fromRGBO(126, 184, 39, 1.0);
void main() async {
  Routes.setupRouter();
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  final prefs =  await SharedPreferences.getInstance();
  //prefs.remove('user_token');
  print(prefs.getString('user_token'));
  /*final prefs =  await SharedPreferences.getInstance();
  if(prefs.getString('user_token') != null) {
    runApp(MyApp());
  } else {
    runApp(AuthScreen());
  }*/

  /*runApp(MaterialApp(
    home: Directionality(
      textDirection: TextDirection.ltr,
      child: MyHome(),
    ),
  ));*/

  runApp(
    ChangeNotifierProvider(
      create: (context) => SharedPreferencesProvider(),
      child: (prefs.containsKey('user_token'))
            ? AshanaScreen()
            : AuthScreen(),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}