import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String apiURL =
    String.fromEnvironment("API_URL", defaultValue: "http://10.0.2.2:8000");
const storage = FlutterSecureStorage();
