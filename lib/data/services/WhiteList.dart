import 'package:flutter/material.dart';

class WhiteList extends StatelessWidget {
  const WhiteList({super.key});

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
                Icons.no_crash,
                size: 50.0,
                //color: Color.fromRGBO(126, 184, 39, 1.0),
                color: Colors.grey,
              ),
              Text(
                'Белый список',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 12),
              )
            ],
          ),
        )
    );
  }

}