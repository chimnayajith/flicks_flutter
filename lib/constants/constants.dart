import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String apiURL =
    String.fromEnvironment("API_URL", defaultValue: "http://192.168.1.6:8000");
const storage = FlutterSecureStorage();
