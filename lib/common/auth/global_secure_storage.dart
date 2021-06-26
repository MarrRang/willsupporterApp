import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GlobalSecureStorage {
  static final GlobalSecureStorage _globalSecureStorage = new GlobalSecureStorage._internal();

  final FlutterSecureStorage _flutterSecureStorage = new FlutterSecureStorage();

  late String _loginToken;

  factory GlobalSecureStorage() {
    return _globalSecureStorage;
  }

  GlobalSecureStorage._internal();

  FlutterSecureStorage getStorage() {
    return _flutterSecureStorage;
  }
}