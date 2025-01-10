import 'package:flutter/material.dart';
import 'package:nadamu/data/variables/colors.dart';
import '../crane_operation_screen.dart';

class CraneNextButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CraneOperationScreen())
            );
          },
          child: Text('Далее'),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(mainBtnColor),
          ),
        ),
      )
    );
  }
}