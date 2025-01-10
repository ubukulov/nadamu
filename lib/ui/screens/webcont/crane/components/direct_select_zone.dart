import 'dart:convert';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:nadamu/data/store/app_store.dart';
import 'package:nadamu/data/variables/colors.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:nadamu/data/endpoints.dart';
import 'package:nadamu/business/models/zone.dart';

class DirectSelectZoneComponent extends StatefulWidget{
  @override
  _DirectSelectZoneState createState() => _DirectSelectZoneState();
}

class _DirectSelectZoneState extends State<DirectSelectZoneComponent> {

  int selectedIndex = 0;

  Future<List<Zone>> fetchZones(String token) async {
    final Uri apiUrl = Uri.https(Endpoints.baseUrl, Endpoints.getContainersZones);
    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Zone> zones = List<Zone>.from(
          data.map((item) => Zone(
              value: item['zone'].toString(),
              title: item['title'],
            )
          )
      );
      return zones;
    } else {
      throw Exception('Произошло ошибка при получении список зон');
    }
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
    final appStore = Provider.of<AppStore>(context);
    return FutureBuilder(
      key: Key('fbZones'),
      future: fetchZones(appStore.getString('user_token')),
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
            List<Zone>? data = snapshot.data;
            return Flexible(
              child: Container(
                //padding: EdgeInsets.all(10),
                // decoration: BoxDecoration(
                //     border: Border.all(width: 1, color: Colors.yellow)
                // ),
                child: DirectSelectContainer(
                    key: Key('dscZone'),
                    child: SingleChildScrollView(
                      key: Key('scsZone'),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          //mainAxisSize: MainAxisSize.max,
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
                                        "Выберите зону",
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
                                                    values: data!.map((e) => e.title).toList(),
                                                    defaultItemIndex: selectedIndex,
                                                    itemBuilder: (String value) => getDropDownMenuItem(value),
                                                    focusedItemDecoration: _getDslDecoration(),
                                                    //onItemSelectedListener: onItemSelected
                                                    onItemSelectedListener: (item, index, context) {
                                                        selectedIndex = index;
                                                        appStore.changeZone(data[index].value);
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