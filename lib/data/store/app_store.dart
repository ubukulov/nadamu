import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStore extends ChangeNotifier{
  SharedPreferences prefs;
  late String selectedZone;
  late int selectedTechnique;

  AppStore({required this.prefs});

  getString(String key) {
    return prefs.getString(key);
  }

  bool hasString(String key){
    return prefs.containsKey(key);
  }

  void setString(String key, String value) {
    prefs.setString(key, value);
    notifyListeners();
  }

  Map<String, dynamic> getUser() {
    return jsonDecode(getString('user'));
  }

  void changeZone(String zone){
    selectedZone = zone;
  }

  void changeTechnique(int technique){
    selectedTechnique = technique;
  }
}