import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toys_catalogue/constants/constants.dart';

class FlicksAnalyticsService {
  final String baseUrl = apiURL;
  
  // Get headers for authenticated requests
  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }
  
  Future<Map<String, dynamic>> startVideoView(String productId) async {
    try {
      final headers = await _getAuthHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/analytics/start-view/'),
        headers: headers,
        body: jsonEncode({
          'product_id': productId,
        }),
      );

      if (response.statusCode == 201) {
        print('Video view started for product $productId');
        return jsonDecode(response.body);
      } else {
        print('Failed to start video view: ${response.statusCode}, ${response.body}');
        return {};
      }
    } catch (e) {
      print('Exception in startVideoView: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> endVideoView({
    required String sessionId,
    required int duration,
    required int percentWatched,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      
      print('Ending session $sessionId - watched: $duration seconds ($percentWatched%)');
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/analytics/end-view/'),
        headers: headers,
        body: jsonEncode({
          'session_id': sessionId,
          'duration': duration,
          'percent_watched': percentWatched,
        }),
      );

      if (response.statusCode == 200) {
        print('Video view ended successfully: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('Failed to end video view: ${response.statusCode}, ${response.body}');
        return {};
      }
    } catch (e) {
      print('Exception in endVideoView: $e');
      return {};
    }
  }
}