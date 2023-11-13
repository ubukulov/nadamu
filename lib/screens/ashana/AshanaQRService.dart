import 'package:flutter/material.dart';
import 'package:nadamu/routers/Router.dart';
import 'package:nadamu/screens/ashana/AshanaQRScreen.dart';

class AshanaQRService extends StatelessWidget {
  const AshanaQRService({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.transparent)
          ),
          onPressed: () {
            //Routes.router.navigateTo(context, 'ashana-qr');
            Navigator.push(context, MaterialPageRoute(builder: (context) => AshanaQRScreen()));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.qr_code_scanner,
                size: 50.0,
                color: Color.fromRGBO(126, 184, 39, 1.0),
              ),
              Text(
                'Ashana QR',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 12),
              )
            ],
          ),
        )
    );
  }
}