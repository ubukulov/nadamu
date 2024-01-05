import 'package:flutter/material.dart';
import 'package:nadamu/screens/HomePageScreen.dart';
import 'package:nadamu/screens/AuthScreen.dart';
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
  // prefs.remove('user_token');
  // prefs.remove('user');
  print(prefs.getString('user_token'));
  print(prefs.getString('user'));

  runApp(
    ChangeNotifierProvider(
      create: (context) => SharedPreferencesProvider(),
      child: (prefs.containsKey('user_token'))
            ? HomePageScreen()
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