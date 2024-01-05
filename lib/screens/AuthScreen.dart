import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:nadamu/screens/HomePageScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nadamu/endpoints.dart';
import 'package:nadamu/patterns/LoadingWidget.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_token', token);
  }

  Future<void> saveUser(String user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  Future<void> _authenticateUser(BuildContext context) async {
    startLoading();
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final Uri apiUrl = Uri.https(Endpoints.baseUrl, Endpoints.authLogin); // Replace with your API endpoint URL

    final Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      apiUrl,
      body: jsonEncode(requestBody),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final bool isAuthenticated = responseData['status'];

      if (isAuthenticated) {
        setState(() {
          saveToken(responseData['token']);
          saveUser(jsonEncode(responseData['user']));
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomePageScreen()),
          );
          stopLoading();
        });
      } else {
        setState(() {
          stopLoading();
        });
      }
    } else {
      setState(() {
        stopLoading();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Логин или пароль не правильно'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  var maskFormatter = new MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => DefaultTabController(
            length: 2, // Number of tabs
            child: Scaffold(
                body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Container(
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/images/logo.svg',
                              width: 200,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 40.0),
                            ),
                            const TabBar(
                              tabs: [
                                Tab(
                                  child: Text(
                                    'По Паролю',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'По Телефону',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: isLoading
                                     ? LoadingWidget()
                                     : TabBarView(
                                        children: [
                                          // Content for Tab 1
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Center(
                                              child: Column(
                                                children: <Widget>[
                                                  TextField(
                                                    controller: _emailController,
                                                    decoration: const InputDecoration(labelText: 'Email'),
                                                  ),
                                                  const SizedBox(height: 16.0),
                                                  TextField(
                                                    controller: _passwordController,
                                                    obscureText: true,
                                                    decoration: const InputDecoration(labelText: 'Пароль'),
                                                  ),
                                                  const SizedBox(height: 32.0),
                                                  ElevatedButton(
                                                    onPressed: () => _authenticateUser(context),
                                                    child: const Text('Авторизоваться'),
                                                    style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(126, 184, 39,1.0))
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Center(
                                              child: Column(
                                                children: <Widget>[
                                                  TextField(
                                                    controller: _phoneController,
                                                    decoration: const InputDecoration(labelText: 'Телефон'),
                                                    inputFormatters: [maskFormatter]
                                                  ),
                                                  const SizedBox(height: 16.0),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      //
                                                    },
                                                    child: const Text('Отправить код'),
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(126, 184, 39,1.0))
                                                    ),
                                                  ),
                                                  const SizedBox(height: 32.0),
                                                  /*ElevatedButton(
                                            onPressed: _authenticateUser,
                                            child: const Text('Авторизоваться'),
                                          ),*/
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                )
            )
        ),
      ),
      );
  }

}