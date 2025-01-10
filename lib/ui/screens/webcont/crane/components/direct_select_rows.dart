import 'dart:convert';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:nadamu/data/variables/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:nadamu/data/endpoints.dart';

class DirectSelectRowComponent extends StatefulWidget{
  @override
  _DirectSelectRowState createState() => _DirectSelectRowState();
}

class Rows {
  late final String id;
  late final String name;

  Rows({required this.id, required this.name});
}

class _DirectSelectRowState extends State<DirectSelectRowComponent> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int selectedIndex = 0;

  Future<List<Rows>> fetchRows() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    final Uri apiUrl = Uri.https(Endpoints.baseUrl, Endpoints.getFreeRows);

    final Map<String, dynamic> requestBody = {
      //'zone': containerNumber,
      //'container_id': containerNumber,
    };

    final response = await http.post(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Rows> tech = List<Rows>.from(
          data.map((item) => Rows(
            id: item['id'].toString(),
            name: item['name'],
          )
          )
      );
      print(tech);
      return tech;
    } else {
      print('error');
      throw Exception('Failed to load user data');
    }
  }

  @override
  void initState(){
    super.initState();
  }

  _getDslDecoration() {
    return BoxDecoration(
      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }

  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(value);
        });
  }

  void onItemSelected(String item, int index, BuildContext context) {
    selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: Key('fbRows'),
      future: fetchRows(),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text('FutureBuilder возвращает null'),
            );
            break;
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator(color: mainLoaderColor,));
            break;
          case ConnectionState.done:
            List<Rows>? data = snapshot.data;
            print(data);
            return Flexible(
              child: Container(
                //padding: EdgeInsets.all(10),
                child: DirectSelectContainer(
                    key: Key('dscCrane'),
                    child: SingleChildScrollView(
                      key: Key('scsCrane'),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          verticalDirection: VerticalDirection.down,
                          children: <Widget>[
                            //SizedBox(height: 100.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: AlignmentDirectional.centerStart,
                                    margin: EdgeInsets.only(left: 4),
                                    child: Text(
                                      "Ряд",
                                      style: TextStyle(
                                          fontSize: 20
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                      child: Card(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Expanded(
                                              child: Padding(
                                                child: DirectSelectList<String>(
                                                    key: Key('directSelectCrane'),
                                                    values: data!.map((e) => e.name).toList(),
                                                    defaultItemIndex: selectedIndex,
                                                    itemBuilder: (String value) => getDropDownMenuItem(value),
                                                    focusedItemDecoration: _getDslDecoration(),
                                                    onItemSelectedListener: onItemSelected
                                                ), //
                                                padding: EdgeInsets.only(left: 12),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(right: 8),
                                                child: Container(
                                                  child: IconButton(
                                                    onPressed: () {
                                                      /* print('点击了选择按钮--');
                                                    _showScaffold();*/
                                                    },
                                                    icon: Icon(Icons.unfold_more),
                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                      )
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ),
              ),
            );
            break;
          default:
            return Center(
              child: Text('Текст по умолчанию'),
            );
        }
      },
    );
  }
}