import 'package:flutter/material.dart';
import 'package:nadamu/endpoints.dart';
import 'package:nadamu/layouts/CommonLayout.dart';
import 'package:provider/provider.dart';
import '../models/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

import '../providers/shared_preferences_provider.dart';

class MyPassQR extends StatelessWidget{
  MyPassQR({super.key});

  static const routeName = 'my-qr-pass';

  Future<Map<String, dynamic>> fetchUser(String token) async {
    final Uri apiUrl = Uri.https(Endpoints.baseUrl, Endpoints.getUserByToken); // Replace with your API endpoint URL
    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      //return User.fromJson(userData);
      print(userData);
      return userData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesProvider = Provider.of<SharedPreferencesProvider>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(126, 184, 39, 1.0),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back navigation here
              Navigator.pop(context);
            },
          ),
          title: Text('Мой Пропуск'),
        ),
        body: FutureBuilder(
          future: fetchUser(sharedPreferencesProvider.getToken('user_token')),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error1: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final data = snapshot.data as Map<String, dynamic>;
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  key: key,
                  children: [
                    Text(
                      'ПРОПУСК',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Image.network(
                      '${Endpoints.baseUrlWithHttps}/${data['image']}',
                      width: 200,
                      height: 150,
                    ),
                    Text(
                      '${data['full_name']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${data['position']['title']}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      '${data['company']['short_ru_name']}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                    QrImageView(
                      data: data['uuid'],
                      version: QrVersions.auto,
                      size: 120.0,
                    ),
                  ],
                ),
              );
            } else {
              return Text('No data available');
            }
          },
        ),
      ),
    );
  }

}