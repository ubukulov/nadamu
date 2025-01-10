import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nadamu/business/models/ashana.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:nadamu/data/endpoints.dart';

class KitchenRightSidebarScreen extends StatefulWidget {
  @override
  _KitchenRightSidebarState createState() => _KitchenRightSidebarState();
}

class _KitchenRightSidebarState extends State<KitchenRightSidebarScreen> {
  TextEditingController dateStartController = TextEditingController();
  TextEditingController dateEndController   = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<Ashana> items = [];

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateStartController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateEndController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> fetchItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    final Map<String, dynamic> data = {
      'date_start': dateStartController.text,
      'date_end' : dateEndController.text
    };

    final Uri apiUrl = Uri.https(Endpoints.baseUrl, Endpoints.getKitchenItemsByFilter); // Replace with your API endpoint URL
    final response = await http.post(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: json.encode(data)
    );
    print(response.body.toString());
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        items = data.map((item) {
          return Ashana(
            //id: int.parse(item['id']),
            company: item['company'],
            type: item['type'],
            date: DateTime.parse(item['date']),
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Center(
                    child: Text(
                        'Поиск по фильтру',
                      style: TextStyle(
                        fontSize: 18.0
                      ),
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: dateStartController,
                        decoration: InputDecoration(
                          labelText: 'Начало',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () => _selectStartDate(context),
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: dateEndController,
                        decoration: InputDecoration(
                          labelText: 'Конец',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () => _selectEndDate(context),
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: ElevatedButton(
                    onPressed: () => fetchItems(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(126, 184, 39, 1.0),
                    ),
                    child: Text('Показать'),
                  )
                )
              ]
          ),
        )
    );
  }
}