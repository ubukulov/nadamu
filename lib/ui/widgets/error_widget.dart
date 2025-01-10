import 'package:flutter/material.dart';

class ErrorsWidget extends StatelessWidget {
  final String errorText;

  ErrorsWidget({required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Text(
          errorText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0
          ),
        ),
      ),
    );
  }
}