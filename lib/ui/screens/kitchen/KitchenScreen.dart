import 'package:flutter/material.dart';
import 'package:nadamu/data/endpoints.dart';
import 'package:nadamu/ui/layouts/CommonLayout.dart';
import 'package:nadamu/ui/widgets/loading_widget.dart';
import 'package:nadamu/ui/widgets/error_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:nadamu/business/models/ashana.dart';
import 'package:nadamu/data/store/app_store.dart';

class KitchenScreen extends StatefulWidget{
  static const routeName = 'my-kitchen';
  @override
  _MyKitchenState createState() => _MyKitchenState();
}

class _MyKitchenState extends State<KitchenScreen> {

  Future<List<Ashana>> fetchItems(String token) async {
    final Uri apiUrl = Uri.https(Endpoints.baseUrl, Endpoints.getKitchenItems);
    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Ashana> items = [];
      items = data.map((item) {
        return Ashana(
          company: item['company'],
          type: item['type'],
          date: DateTime.parse(item['date']),
        );
      }).toList();
      return items;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  String formatDateToRussian(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('d MMM y H:m:s', 'ru_RU');
    String formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<AppStore>(context, listen: false);
    return CommonLayout(
      title: 'Асхана: История',
      content: SafeArea(
        child: FutureBuilder(
          future: fetchItems(appStore.getString('user_token')),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWidget();
            } else if(snapshot.hasError) {
              return ErrorsWidget(errorText: snapshot.error.toString());
            } else {
              final data = snapshot.data!;
              return ListView(
                scrollDirection: Axis.vertical,
                children: [
                  DataTable(
                      columns: [
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('Тип обеда')),
                        DataColumn(label: Text('Дата')),
                      ],
                      rows: List<DataRow>.generate(
                        data.length,
                            (index) => DataRow(
                          cells: [
                            DataCell(Text((index+1).toString())),
                            DataCell(Text(data[index].type.toString())),
                            DataCell(Text(formatDateToRussian(data[index].date))),
                          ],
                        ),
                      )
                  ),
                ],
              );
            }
          },
        )
      ),
    );
  }
}