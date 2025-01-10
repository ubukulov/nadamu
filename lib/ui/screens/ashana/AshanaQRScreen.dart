import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nadamu/data/endpoints.dart';
import 'dart:convert';


class AshanaQRScreen extends StatelessWidget {
  const AshanaQRScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ashana QR',
          style: TextStyle(
              color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              // Add the logic to close the current screen
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: QRViewExample(),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class Employee {
  late final String full_name;
  late final String company_name;
  late final int count;
  late final int user_id;
  late final String image;

  Employee({required this.full_name, required this.company_name, required this.count, required this.user_id, required this.image});

  // Convert Vacancy object to a JSON representation
  Map<String, dynamic> toJson() {
    return {
      'full_name': full_name,
      'company_name': company_name,
      'count': count,
      'user_id': user_id,
      'image': image,
    };
  }

  // Create a Vacancy object from a JSON map
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      full_name: json['full_name'],
      company_name: json['company_name'],
      count: json['count'],
      user_id: json['user_id'],
      image: json['image'],
    );
  }
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isLoading = false;
  List<Employee> employee = [];
  bool isFoundEmployee = false;
  bool isSuccessChange = false;


  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if(isFoundEmployee)
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              child: Text(
                                'Результат'
                              ),
                            ),
                            Image.network(
                              '${Endpoints.baseUrlWithHttps}/${employee.first.image}',
                              width: 200,
                              height: 150,
                            ),
                            Text(
                              'ФИО: ${employee.first.full_name}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 10.0
                              ),
                            ),
                            Text(
                              'Компания: ${employee.first.company_name}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 10.0
                              ),
                            ),
                            Text(
                              'Обедов на сегодня: ${employee.first.count}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 10.0
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: employee.first.count < 2 ? () => _fixKitchen() : null,
                                    style: ButtonStyle(
                                      backgroundColor: employee.first.count < 2 ? MaterialStateProperty.all(Color.fromRGBO(126, 184, 39,1.0)) : MaterialStateProperty.all(Color.fromRGBO(204, 204, 204,1.0))
                                    ),
                                    child: Text('Подтвердить')
                                ),
                                SizedBox(width: 20),
                                ElevatedButton(
                                    onPressed: () => cancelAshana(),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.red)
                                    ),
                                    child: Text('Отменить')
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  else if(isSuccessChange)
                    Column(
                      children: [
                        Padding(
                          child: Text(
                            '1 Обед Стандарт записан',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.green
                            ),
                          ),
                          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
                        ),
                        Padding(
                          child: Text(
                            'на ${employee.first.full_name}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.green
                            ),
                          ),
                          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
                        ),
                        Padding(
                          child: Text(
                            'Талонов за сегодня:  ${employee.first.count}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.green
                            ),
                          ),
                          padding: EdgeInsets.only(left: 20, right: 20),
                        )
                      ],
                    )
                  else
                    Text(
                      'Сканируйте QR код',
                      style: TextStyle(
                          fontSize: 14.0
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 250.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: const Color.fromRGBO(126, 184, 39, 1.0),
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if(isFoundEmployee) {
        this.controller?.pauseCamera();
      } else {
        this.controller?.resumeCamera();
        setState(() {
          result = scanData;
          _getUserByUuid(result!.code);
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void cancelAshana(){
    setState(() {
      isFoundEmployee = false;
      this.controller?.resumeCamera();
      employee = [];
    });
  }

  Future<void> _getUserByUuid(String? username) async {
    final prefs = await SharedPreferences.getInstance();
    startLoading();

    final Uri apiUrl = Uri.https(Endpoints.baseUrl, Endpoints.getUserByUuid); // Replace with your API endpoint URL

    final Map<String, dynamic> requestBody = {
      'username': username,
    };

    final response = await http.post(
      apiUrl,
      body: jsonEncode(requestBody),
      headers: {
        'Authorization': 'Bearer ${prefs.getString('user_token')}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        employee.clear();
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => HomePageScreen2()),
        // );
        employee.add(Employee(full_name: jsonData['full_name'], company_name: jsonData['company_name'], count: jsonData['count'], user_id: jsonData['user_id'], image: jsonData['image']));
        stopLoading();
        isFoundEmployee = true;
        this.controller?.resumeCamera();
      });
    } else {
      setState(() {
        stopLoading();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.body.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        isFoundEmployee = false;
      });
    }
  }

  Future<void> _fixKitchen() async {
    final prefs = await SharedPreferences.getInstance();
    startLoading();

    final Uri apiUrl = Uri.https(Endpoints.baseUrl, Endpoints.fixChanges); // Replace with your API endpoint URL

    final Map<String, dynamic> requestBody = {
      'user_id': employee.first.user_id,
    };

    final response = await http.post(
      apiUrl,
      body: jsonEncode(requestBody),
      headers: {
        'Authorization': 'Bearer ${prefs.getString('user_token')}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        stopLoading();
        isFoundEmployee = false;
        this.controller?.resumeCamera();
        isSuccessChange = true;
      });
    } else {
      setState(() {
        stopLoading();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.body.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        isFoundEmployee = false;
        isSuccessChange = false;
      });
    }
  }
}