import 'package:flutter/material.dart';
import 'package:toys_catalogue/utils/api/api_client.dart';
import 'package:toys_catalogue/features/manage_store/domain/models/shop_model.dart';

class ShopService {
  final ApiClient _apiClient = ApiClient();

  Future<Shop> getShopDetails({BuildContext? context}) async {
    try {
      final response = await _apiClient.get(
        '/api/store/',
        context: context,
      );

      if (response != null) {
        return Shop.fromJson(response);
      } else {
        throw Exception('Failed to load shop details');
      }
    } catch (e) {
      print('Error fetching shop details: $e');
      throw Exception('Error fetching shop details: $e');
    }
  }

  Future<Shop> updateShopDetails({
    required Map<String, dynamic> shopData,
    BuildContext? context,
  }) async {
    try {
      final response = await _apiClient.put(
        '/api/store/',
        body: shopData,
        context: context,
      );

      if (response != null) {
        return Shop.fromJson(response);
      } else {
        throw Exception('Failed to update shop details');
      }
    } catch (e) {
      print('Error updating shop details: $e');
      throw Exception('Error updating shop details: $e');
    }
  }
  
  Future<Map<String, dynamic>> uploadShopBanner({
    required String filePath,
    BuildContext? context,
  }) async {
    // Note: For file uploads, you would need to extend ApiClient
    // to support multipart requests or handle this separately
    throw UnimplementedError('File upload not yet implemented');
  }
  
  Future<bool> deleteShopBanner({BuildContext? context}) async {
    try {
      final response = await _apiClient.delete(
        '/api/store/banner/',
        context: context,
      );
      
      return response != null;
    } catch (e) {
      print('Error deleting shop banner: $e');
      return false;
    }
  }
}