import 'package:flutter/material.dart';
import 'package:nadamu/data/endpoints.dart';
import 'package:nadamu/ui/layouts/CommonLayout.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:nadamu/data/store/app_store.dart';

class MyPassQR extends StatelessWidget{
  static const routeName = 'my-qr-pass';

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<AppStore>(context, listen: false);
    var user = appStore.getUser();
    return CommonLayout(
      title: 'Мой пропуск',
      content: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          key: key,
          children: [
            Text(
              'ПРОПУСК',
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            Image.network(
              '${Endpoints.baseUrlWithHttps}/${user['image']}',
              width: 200,
              height: 150,
            ),
            Text(
              '${user['full_name']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${user['position']['title']}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
            ),
            Text(
              '${user['company']['short_ru_name']}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal
              ),
            ),
            QrImageView(
              data: user['uuid'],
              version: QrVersions.auto,
              size: 120.0,
            ),
          ],
        ),
      ),
    );
  }
}