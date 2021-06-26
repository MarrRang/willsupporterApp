import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:will_support/page/home/home_page.dart';
import 'package:will_support/page/login/login_page.dart';

import 'package:flutter/foundation.dart' as foundation;
import 'common/auth/global_secure_storage.dart';
import 'common/constant/ws_constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterSecureStorage _storage = GlobalSecureStorage().getStorage();

  await _storage.deleteAll();
  if (await _storage.read(key: AUTH_REMEMBER_ID_YN_KEY) == "false") {
  await _storage.deleteAll();
  }

  String? loginToken = await _storage.read(key: 'AomrLoginToken');

  runApp(MyApp(loginToken??=""));
}

class MyApp extends StatelessWidget {
  final String loginToken;

  MyApp(this.loginToken);

  @override
  Widget build(BuildContext context) {
    switch (foundation.defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return CupertinoApp(
            home: StringUtils.isNullOrEmpty(loginToken) ? LoginPage() : HomePage(loginToken)
        );
        break;
      case TargetPlatform.android:
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.white,
          ),
          home: StringUtils.isNullOrEmpty(loginToken) ? LoginPage() : HomePage(loginToken),
        );
      default :
        break;
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: StringUtils.isNullOrEmpty(loginToken) ? LoginPage() : HomePage(loginToken),
    );
  }
}
