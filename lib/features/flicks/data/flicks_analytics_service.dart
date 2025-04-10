import 'package:flutter/material.dart';
import 'package:toys_catalogue/utils/api/api_client.dart';

class FlicksAnalyticsService {
  final ApiClient _apiClient = ApiClient();
  
  Future<Map<String, dynamic>> startVideoView(String productId, {BuildContext? context}) async {
    try {
      final response = await _apiClient.post(
        '/api/analytics/start-view/',
        body: {
          'product_id': productId,
        },
        context: context,
      );

      if (response != null) {
        print('Video view started for product $productId');
        return response;
      }
      return {};
    } catch (e) {
      print('Exception in startVideoView: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> endVideoView({
    required String sessionId,
    required int duration,
    required int percentWatched,
    BuildContext? context,
  }) async {
    try {
      print('Ending session $sessionId - watched: $duration seconds ($percentWatched%)');
      
      final response = await _apiClient.post(
        '/api/analytics/end-view/',
        body: {
          'session_id': sessionId,
          'duration': duration,
          'percent_watched': percentWatched,
        },
        context: context,
      );

      if (response != null) {
        print('Video view ended successfully');
        return response;
      }
      return {};
    } catch (e) {
      print('Exception in endVideoView: $e');
      return {};
    }
  }
}