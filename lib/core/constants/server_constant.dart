import 'dart:io';

class ServerConstant {
  static String serverURL = Platform.isAndroid ? "http://10.0.2.2:9091" : "http://127.0.0.1:9091";
}
