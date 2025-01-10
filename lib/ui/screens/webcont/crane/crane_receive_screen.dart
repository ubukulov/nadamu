import 'package:flutter/material.dart';
import 'package:nadamu/ui/screens/webcont/crane/components/direct_select_rows.dart';
import 'package:nadamu/ui/screens/webcont/crane/crane_layout.dart';

class CraneReceiveScreen extends StatefulWidget{
  @override
  _CraneReceiveState createState() => _CraneReceiveState();
}

class _CraneReceiveState extends State<CraneReceiveScreen>{
  String selectedValue = 'Option 1';
  @override
  Widget build(BuildContext context) {
    return CraneLayout(
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              DirectSelectRowComponent(),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Далее'),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

}