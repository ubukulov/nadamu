import 'package:flutter/material.dart';
import 'package:nadamu/endpoints.dart';
import 'package:nadamu/screens/kitchen/KitchenRightSidebarScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../providers/shared_preferences_provider.dart';

class KitchenScreen extends StatefulWidget{
  static const routeName = 'my-kitchen';
  @override
  _MyKitchenState createState() => _MyKitchenState();
}

class Ashana {
 // late final int id;
  late final String company;
  late final String type;
  late final DateTime date;

  Ashana({required this.company, required this.type, required this.date});
}

class _MyKitchenState extends State<KitchenScreen> {
  List<Ashana> items = [];
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Future<void> fetchItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    final Uri apiUrl = Uri.https(Endpoints.baseUrl, Endpoints.getKitchenItems); // Replace with your API endpoint URL
    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
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
  void initState() {
    super.initState();
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _key,
        endDrawer: KitchenRightSidebarScreen(),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(126, 184, 39, 1.0),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back navigation here
              Navigator.pop(context);
            },
          ),
          title: Text('Асхана: История'),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_alt), // Add another custom action button
              onPressed: () {
                _key.currentState!.openEndDrawer();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    DataTable(
                      columns: [
                        //DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Компания')),
                        DataColumn(label: Text('Тип обеда')),
                        DataColumn(label: Text('Дата')),
                      ],
                      rows: items
                          .map((item) => DataRow(cells: [
                        //DataCell(Text(item.id.toString())),
                        DataCell(Text(item.company)),
                        DataCell(Text(item.type)),
                        DataCell(Text(item.date.toString()))
                      ])).toList(),
                    ),
                  ],
                )
            )
          ],
        )
      ),
    );
  }
}