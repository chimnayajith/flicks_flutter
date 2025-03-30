import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toys_catalogue/constants/constants.dart';
import 'package:toys_catalogue/features/home/domain/models/product_model.dart';

class ProductService {
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

  // Get trending products
  Future<List<Product>> getTrendingProducts() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/products/trending/'),
        headers: headers,
      );

      // Inside getTrendingProducts() method:
      if (response.statusCode == 200) {
        print("Raw trending response: ${response.body}");
        final data = jsonDecode(response.body);
        final productsResponse = ProductsResponse.fromJson(data);
        print("Parsed trending products count: ${productsResponse.products.length}");
        return productsResponse.products;
      }  else {
        throw Exception('Failed to load trending products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching trending products: $e');
      return []; // Return empty list on error for graceful degradation
    }
  }

  // Get top products
  Future<List<Product>> getTopProducts() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/products/top/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final productsResponse = ProductsResponse.fromJson(data);
        return productsResponse.products;
      } else {
        throw Exception('Failed to load top products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching top products: $e');
      return []; // Return empty list on error
    }
  }

  // Get filtered products
  Future<List<Product>> getFilteredProducts({
    String? gender,
    String? ageGroup,
    String? category,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (gender != null) queryParams['gender'] = gender;
      if (ageGroup != null) queryParams['age_group'] = ageGroup;
      if (category != null) queryParams['category'] = category;

      final uri = Uri.parse('$baseUrl/api/products/filter/')
          .replace(queryParameters: queryParams);

      final headers = await _getAuthHeaders();
      final response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final productsResponse = ProductsResponse.fromJson(data);
        return productsResponse.products;
      } else {
        throw Exception('Failed to load filtered products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching filtered products: $e');
      return []; // Return empty list on error
    }
  }

  // Get product details
  Future<Product> getProductDetails(int productId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/products/$productId/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to load product details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching product details: $e');
      rethrow; // Rethrow to handle in UI
    }
  }

  Future<List<String>> getProductCategories() async {
  try {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/products/categories/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Parse the response
      final List<dynamic> data = jsonDecode(response.body);
      
      // Convert the dynamic list to a list of strings
      return data.map((category) => category.toString()).toList();
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching categories: $e');
    throw Exception('Error fetching categories: $e');
  }
}
}