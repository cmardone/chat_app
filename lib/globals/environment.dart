import 'dart:io';

class Environment {
  static String apiUrl =
      'http://${(Platform.isAndroid ? '10.0.2.2' : 'localhost')}:3000/api';
  static String socketUrl =
      'http://${(Platform.isAndroid ? '10.0.2.2' : 'localhost')}:3000';
}
