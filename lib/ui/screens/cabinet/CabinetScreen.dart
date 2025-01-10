import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nadamu/ui/screens/AuthScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nadamu/data/endpoints.dart';

import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class CabinetScreen extends StatefulWidget {

  const CabinetScreen({super.key});

  @override
  _CabinetState createState() => _CabinetState();
}

class _CabinetState extends State<CabinetScreen> {
  bool pushValue = false;
  bool oftenValue = false;
  bool faceValue = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget();
              } else if(snapshot.hasError) {
                return ErrorsWidget(errorText: snapshot.error.toString());
              } else {
                final data = snapshot.data!;
                Map<String, dynamic> user = json.decode(data);
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (user['image'] != null) ? Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: ClipOval(
                            child: Image.network(
                              '${Endpoints.baseUrlWithHttps}/${user['image']}',
                              width: 150,
                            ),
                          ),
                        ),
                      ) : Center(
                        child: Image.asset(
                          'assets/images/icon-user-default.png',
                          width: 150.0,
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
                            'Компания: ${user['company']['full_company_name']}',
                            style: TextStyle(
                                fontSize: 16.0
                            ),
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Должность: ${user['position']['title']}',
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
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
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