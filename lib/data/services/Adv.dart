import 'package:flutter/material.dart';

class Adv extends StatelessWidget {
  const Adv({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.transparent)
          ),
          onPressed: () {
            //Routes.router.navigateTo(context, 'my-kitchen');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.article,
                size: 50.0,
                color: Colors.grey
              ),
              Text(
                'Объявления',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 11),
              )
            ],
          ),
        )
    );
  }

}