import 'package:flutter/material.dart';
import 'package:nadamu/data/store/app_store.dart';
import 'package:nadamu/ui/screens/HomePageScreen.dart';
import 'package:nadamu/ui/screens/AuthScreen.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:nadamu/business/routers/Router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

var mainColor = const Color.fromRGBO(126, 184, 39, 1.0);
void main() async {
  Routes.setupRouter();
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  await initializeDateFormatting('ru_RU', null);
  final prefs =  await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppStore(prefs: prefs),
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