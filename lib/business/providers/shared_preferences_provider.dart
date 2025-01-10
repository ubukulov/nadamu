import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider with ChangeNotifier {
  late SharedPreferences _prefs;

  SharedPreferencesProvider() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  // Define methods to read and write data to SharedPreferences
  String? getString(String key) {
    return _prefs.getString(key);
  }

  getToken(String key){
    return _prefs.getString(key);
  }

  bool hasToken(String key){
    return _prefs.containsKey(key);
  }

  void setString(String key, String value) {
    _prefs.setString(key, value);
    notifyListeners();
  }
}