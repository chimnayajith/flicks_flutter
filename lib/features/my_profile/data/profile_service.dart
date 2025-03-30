import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toys_catalogue/constants/constants.dart';
import 'package:toys_catalogue/features/manage_store/domain/models/shop_model.dart';

class ProfileService {
  final String _baseUrl = apiURL;
  
  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token'); // Match the key used in ShopService
    
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final headers = await _getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('$_baseUrl/api/profile/'), 
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load user profile: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      throw Exception('Error fetching user profile: $e');
    }
  }

  Future<Shop> getShopDetails() async {
    try {
      final headers = await _getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('$_baseUrl/api/store/'), 
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Shop.fromJson(data);
      } else {
        print('Failed to load shop details: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to load shop details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching shop details: $e');
    }
  }
  

  Map<String, dynamic> _getMockUserProfile() {
    return {
      'username': 'johndoe',
      'email': 'john.doe@example.com',
      'full_name': 'John Doe',
      'phone': '9876543210',
      'address': '123 Main St, Mumbai',
      'store_name': 'Kids Toys Store',
      'membership_since': '2023-05-15'
    };
  }
  

  Shop getMockShopDetails() {
    return Shop(
      id: 1,
      name: 'Kids Toys Store',
      description: 'The best toy store in town',
      address: '123 Main St, Mumbai',
      phone: '9876543210',
      email: 'info@kidstoysstore.com',
      bannerUrl: "https://flickscatalogue.s3.amazonaws.com/shops/banners/thambikada.jpg",
      owner: ShopOwner(
        id: 1,
        username: 'johndoe',
        name: 'John Doe',
      ),
      subscription: null,
      isOwner: true,
    );
  }
}