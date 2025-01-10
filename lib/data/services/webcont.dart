import 'package:flutter/material.dart';
import 'package:nadamu/business/routers/Router.dart';

class Webcont extends StatelessWidget {
  const Webcont({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.transparent)
          ),
          onPressed: () {
            Routes.router.navigateTo(context, 'crane');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.directions_railway,
                size: 50.0,
                color: Color.fromRGBO(126, 184, 39, 1.0),
              ),
              Text(
                'Webcont',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 12),
              )
            ],
          ),
        )
    );
  }

}