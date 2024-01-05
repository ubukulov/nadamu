import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nadamu/routers/Router.dart';
import 'package:nadamu/screens/AuthScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../endpoints.dart';

class CabinetScreen extends StatefulWidget {

  const CabinetScreen({super.key});

  @override
  _CabinetState createState() => _CabinetState();
}

class _CabinetState extends State<CabinetScreen> {
  Map<String, dynamic> user = {};
  bool pushValue = false;
  bool oftenValue = false;
  bool faceValue = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(
                  child: ClipOval(
                    child: Image.network(
                      '${Endpoints.baseUrlWithHttps}/${user['image']}',
                      width: 150,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Center(
                  child: Text(
                    '${user['full_name']}',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Почта: ${user['email']}',
                  style: TextStyle(
                      fontSize: 16.0
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Телефон: ${user['phone']}',
                  style: TextStyle(
                      fontSize: 16.0
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Компания: ',
                  style: TextStyle(
                      fontSize: 16.0
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Должность: ${user['position']}',
                  style: TextStyle(
                      fontSize: 16.0
                  ),
                )
              ),
              Divider(
                color: Colors.green,
                thickness: 1,
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Push-уведомления'),
                    SizedBox(height: 20.0),
                    Switch(
                      value: pushValue,
                      activeColor: Color.fromRGBO(126, 184, 39,1.0),
                      onChanged: (value) {
                        setState(() {
                          pushValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Быстрый вход'),
                    SizedBox(height: 20.0),
                    Switch(
                      value: oftenValue,
                      activeColor: Color.fromRGBO(126, 184, 39,1.0),
                      onChanged: (value) {
                        setState(() {
                          oftenValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Вход через Touch ID/Face ID'),
                    SizedBox(height: 20.0),
                    Switch(
                      value: faceValue,
                      activeColor: Color.fromRGBO(126, 184, 39,1.0),
                      onChanged: (value) {
                        setState(() {
                          faceValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  child: ElevatedButton(
                    child: Text('Выйти'),
                    onPressed: () => _logoutUser(context),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(126, 184, 39,1.0))
                    ),
                  ),
                  width: double.infinity,
                )
              )
            ],
          ),
        ),
      )
    );
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    setState(() {
      user = json.decode(userJson!);
    });
  }

  Future<void> _logoutUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user_token');
    prefs.remove('user');
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }
}