import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String apiURL =
    String.fromEnvironment("API_URL", defaultValue: "https://flicks.chaayakada.fun");
const storage = FlutterSecureStorage();
