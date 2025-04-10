import 'package:flutter/material.dart';
import 'package:toys_catalogue/utils/api/api_client.dart';
import 'package:toys_catalogue/features/manage_store/domain/models/shop_model.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getUserProfile({BuildContext? context}) async {
    try {
      final response = await _apiClient.get(
        '/api/profile/',
        context: context,
      );
      
      if (response != null) {
        return response;
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      throw Exception('Error fetching user profile: $e');
    }
  }

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

  Future<Map<String, dynamic>> updateUserProfile({
    required Map<String, dynamic> profileData,
    BuildContext? context,
  }) async {
    try {
      final response = await _apiClient.put(
        '/api/profile/',
        body: profileData,
        context: context,
      );
      
      if (response != null) {
        return response;
      } else {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      print('Error updating user profile: $e');
      throw Exception('Error updating user profile: $e');
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    BuildContext? context,
  }) async {
    try {
      final response = await _apiClient.post(
        '/api/profile/change-password/',
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
        context: context,
      );
      
      return response != null;
    } catch (e) {
      print('Error changing password: $e');
      throw Exception('Error changing password: $e');
    }
  }
}