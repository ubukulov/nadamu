import 'package:flutter/material.dart';
import 'package:nadamu/config/variables.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: mainColor,
      ),
    );
  }
}