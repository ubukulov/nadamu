import 'package:flutter/material.dart';
import 'package:nadamu/ui/screens/webcont/crane/crane_layout.dart';
import 'components/crane_next_button.dart';
import 'components/direct_select_crane.dart';
import 'components/direct_select_slinger.dart';
import 'components/direct_select_zone.dart';
import 'package:nadamu/data/variables/colors.dart';


class CraneScreen extends StatefulWidget{
  static const routeName = 'crane';
  @override
  _CraneState createState() => _CraneState();
}

class _CraneState extends State<CraneScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Future<void> dataFuture() async {
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return CraneLayout(
      content: FutureBuilder(
        future: dataFuture(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: mainLoaderColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Ошибка: ${snapshot.error}');
          } else {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DirectSelectZoneComponent(),
                DirectSelectCraneComponent(),
                // DirectSelectSlingerComponent(),
                CraneNextButton()
              ],
            );
          }
        },
      ),
    );
  }
}