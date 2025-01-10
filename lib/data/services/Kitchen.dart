import 'package:flutter/material.dart';
import 'package:nadamu/business/routers/Router.dart';

class Kitchen extends StatelessWidget {
  const Kitchen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.transparent)
          ),
          onPressed: () {
            Routes.router.navigateTo(context, 'my-kitchen');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.restaurant,
                size: 50.0,
                color: Color.fromRGBO(126, 184, 39, 1.0),
              ),
              Text(
                'Асхана',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 12),
              )
            ],
          ),
        )
    );
  }

}