import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckService {
  /// Checks if the user is logged in by verifying if access token exists
  Future<bool> isUserLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      
      // User is logged in if access token exists
      return accessToken != null && accessToken.isNotEmpty;
    } catch (e) {
      print("Error checking auth status: $e");
      return false;
    }
  }
  
  /// Gets the user role, if available
  Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('role');
    } catch (e) {
      print("Error getting user role: $e");
      return null;
    }
  }
}