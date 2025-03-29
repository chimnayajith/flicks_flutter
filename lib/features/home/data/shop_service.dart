import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toys_catalogue/constants/constants.dart';

class ShopService {
  final String baseUrl = apiURL;

  Future<Map<String, dynamic>> getShopBanner() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      
      if (accessToken == null) {
        throw Exception('No access token found');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/store/banner/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load shop banner: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching shop banner: $e');
      // Return default values if there's an error
      return {
        'banner_url': null,
        'shop_name': null
      };
    }
  }
}