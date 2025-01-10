import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:nadamu/ui/screens/screens.dart';

class Routes {
  static final router = FluroRouter();

  static final Handler _homeHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return HomePageScreen();
  });

  static final Handler _authHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return AuthScreen();
  });

  static final Handler _myPassQRHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return MyPassQR();
  });

  static final Handler _kitchenHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return KitchenScreen();
  });

  static final Handler _vacancyHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return VacancyScreen();
  });

  static final Handler _webcontHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return CraneScreen();
  });

  static void setupRouter() {
    router.define(HomePageScreen.routeName, handler: _homeHandler);
    //router.define('${AuthScreen.routeName}/:id', handler: _authHandler);
    router.define(AuthScreen.routeName, handler: _authHandler);
    router.define(MyPassQR.routeName, handler: _myPassQRHandler);
    router.define(KitchenScreen.routeName, handler: _kitchenHandler);
    router.define(VacancyScreen.routeName, handler: _vacancyHandler);
    router.define(CraneScreen.routeName, handler: _webcontHandler);
  }
}