import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nadamu/data/store/app_store.dart';
import 'package:nadamu/ui/screens/webcont/crane/crane_layout.dart';
import 'package:http/http.dart' as http;
import 'package:nadamu/ui/screens/webcont/crane/crane_receive_screen.dart';
import 'package:provider/provider.dart';
import 'package:nadamu/data/endpoints.dart';
import 'package:nadamu/ui/widgets/loading_widget.dart';

class CraneOperationScreen extends StatefulWidget{
  @override
  _CraneOperationState createState() => _CraneOperationState();
}

class _CraneOperationState extends State<CraneOperationScreen>{
  final TextEditingController _containerController = TextEditingController();

  bool receiveBtn = false;
  bool shipBtn    = false;
  bool moveBtn    = false;
  bool isLoading  = false;
  bool isSuccess  = false;
  List<dynamic> info = [];
  late FocusNode _focusNode;

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

  Future<void> _getContainerInfo(String token, Map<String, dynamic> data) async {
    startLoading();
    final Uri apiUrl = Uri.https(Endpoints.baseUrl, Endpoints.getContainerInfo);

    final response = await http.post(
      apiUrl,
      body: jsonEncode(data),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      stopLoading();
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        info = [];
        info.add(data);
        _containerController.text = data['container_number'];
        if(data['event'] == 4) {
          receiveBtn  = false;
          shipBtn     = false;
          moveBtn     = false;
        } else {
          receiveBtn  = (data['event']    == 1) ? true : false;
          shipBtn     = (data['event']    == 2) ? true : false;
          moveBtn     = (data['event']    == 3) ? true : false;
        }

        isSuccess = true;
      });
    } else {
      setState(() {
        isSuccess = false;
      });
      stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<AppStore>(context);
    return CraneLayout(
      content: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        //focusNode: _focusNode,
                        onChanged: (value) {
                          _containerController.value = _containerController.value.copyWith(
                            text: value.toUpperCase(),
                            selection: TextSelection.collapsed(offset: value.length),
                          );
                        },
                        controller: _containerController,
                        decoration: InputDecoration(
                          hintText: 'Введите номер контейнера',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          height: 59.0,
                          width: 10.0,
                          child: ElevatedButton(
                            onPressed: () {
                              Map<String, dynamic> data = {
                                'container_number': _containerController.text,
                                'zone': appStore.selectedZone,
                                'technique_id': appStore.selectedTechnique
                              };
                              _getContainerInfo(appStore.getString('user_token'), data);
                              FocusScope.of(context).unfocus();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  )
                              ),
                              backgroundColor: Colors.black,
                            ),
                            child: Text('Найти'),
                          ),
                        )
                    ),
                  ],
                ),
              ),
              (isLoading) ? LoadingWidget() :
              (isSuccess) ? Info(info: info[0],) :
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 20, top: 20),
                child: ElevatedButton(
                  onPressed: (receiveBtn) ? (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CraneReceiveScreen())
                    );
                  } : null,
                  child: Text(
                    'Размещение',
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: (receiveBtn) ? MaterialStateProperty.all(Colors.green) : MaterialStateProperty.all(Colors.grey)
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: (shipBtn) ? (){} : null,
                  child: Text(
                    'Выдача',
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: (shipBtn) ? MaterialStateProperty.all(Colors.green) : MaterialStateProperty.all(Colors.grey)
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (moveBtn) ? (){} : null,
                  child: Text(
                    'Перемещение',
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: (moveBtn) ? MaterialStateProperty.all(Colors.green) : MaterialStateProperty.all(Colors.grey)
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class Info extends StatelessWidget{
  final info;
  const Info({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green)
      ),
      child: Text.rich(
        softWrap: true,
        textAlign: TextAlign.center,
        TextSpan(
          text: '${info['text1']}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          children: <TextSpan>[
            TextSpan(
              text: ' ${info['text2']}',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: ' ${info['text3']} ',
            ),
            TextSpan(
              text: '${info['text4']}',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

}