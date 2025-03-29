import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toys_catalogue/features/manage_store/domain/models/shop_model.dart';
import 'package:toys_catalogue/constants/constants.dart';

class ShopService {
  final String baseUrl = apiURL;

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Shop> getShopDetails() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/store/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Shop.fromJson(data);
      } else {
        throw Exception('Failed to load shop details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching shop details: $e');
      throw Exception('Error fetching shop details: $e');
    }
  }

  // For development/testing
  Future<Shop> getMockShopDetails() async {
    // Mock data matching the provided JSON
    final mockData = {
      "id": 1,
      "name": "Thambi kada",
      "description": "Vallikavu's best toys. One stop shop for all things toys.",
      "address": "Vallikavu junction, Karunagappally",
      "phone": "9495483360",
      "email": "thambi@gmail.com",
      "banner_url": "https://flickscatalogue.s3.amazonaws.com/shops/banners/thambikada.jpg",
      "owner": {
        "id": 2,
        "username": "thambi",
        "name": "thambi"
      },
      "subscription": null,
      "is_owner": true
    };
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return Shop.fromJson(mockData);
  }
}