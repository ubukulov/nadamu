import 'dart:convert';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:nadamu/data/store/app_store.dart';
import 'package:nadamu/data/variables/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:nadamu/data/endpoints.dart';
import 'package:nadamu/business/models/technique.dart';

class DirectSelectCraneComponent extends StatefulWidget{
  @override
  _DirectSelectCraneState createState() => _DirectSelectCraneState();
}

class _DirectSelectCraneState extends State<DirectSelectCraneComponent> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int selectedIndex = 0;

  Future<List<Technique>> fetchTechniques(String token) async {
    final Uri apiUrl = Uri.https(Endpoints.baseUrl, Endpoints.getTechniques);
    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Technique> tech = List<Technique>.from(
          data.map((item) => Technique(
              id: item['id'],
              name: item['name'],
              status: item['status'],
            )
          )
      );
      return tech;
    } else {
      throw Exception('Произошло ошибка при получение список техники');
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

  _showScaffold() {
    final snackBar = SnackBar(content: Text('asda'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<AppStore>(context);
    return FutureBuilder(
      key: Key('fbTechniques'),
      future: fetchTechniques(appStore.getString('user_token')),
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
            List<Technique>? data = snapshot.data;
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
                                        "Выберите технику",
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
                                                    onItemSelectedListener: (item, index, context) {
                                                      selectedIndex = index;
                                                      appStore.changeTechnique(data[index].id);
                                                    },
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