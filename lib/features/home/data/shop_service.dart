import 'package:flutter/material.dart';
import 'package:toys_catalogue/utils/api/api_client.dart';

class ShopService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getShopBanner({BuildContext? context}) async {
    try {
      final response = await _apiClient.get(
        '/api/store/banner/',
        context: context,
      );

      if (response != null) {
        return response;
      } else {
        print('Null response received for shop banner');
        // Return default values if no response
        return {
          'banner_url': null,
          'shop_name': null
        };
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

  // Add more shop-related API methods here
  Future<List<dynamic>> getShopCategories({BuildContext? context}) async {
    try {
      final response = await _apiClient.get(
        '/api/store/categories/',
        context: context,
      );

      if (response != null) {
        return response['categories'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error fetching shop categories: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getShopDetails({BuildContext? context}) async {
    try {
      final response = await _apiClient.get(
        '/api/store/details/',
        context: context,
      );

      if (response != null) {
        return response;
      }
      return {};
    } catch (e) {
      print('Error fetching shop details: $e');
      return {};
    }
  }
}