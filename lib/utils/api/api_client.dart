import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toys_catalogue/constants/constants.dart';
import 'package:toys_catalogue/routes/route_names.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  
  factory ApiClient() => _instance;
  
  ApiClient._internal();
  
  final String baseUrl = apiURL;
  
  // For global context access
  BuildContext? _globalContext;
  
  void setGlobalContext(BuildContext context) {
    _globalContext = context;
  }
  
  Future<Map<String, String>> getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }
  
  Future<dynamic> get(
    String endpoint, {
    BuildContext? context,
    Map<String, String>? additionalHeaders,
  }) async {
    final ctx = context ?? _globalContext;
    try {
      final headers = await getAuthHeaders();
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      
      return _handleResponse(response, ctx);
    } catch (e) {
      print('API GET error: $e');
      return null;
    }
  }

  Future<dynamic> post(
    String endpoint, {
    required dynamic body,
    BuildContext? context,
    Map<String, String>? additionalHeaders,
  }) async {
    final ctx = context ?? _globalContext;
    try {
      final headers = await getAuthHeaders();
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      
      return _handleResponse(response, ctx);
    } catch (e) {
      print('API POST error: $e');
      return null;
    }
  }

  Future<dynamic> put(
    String endpoint, {
    required dynamic body,
    BuildContext? context,
    Map<String, String>? additionalHeaders,
  }) async {
    final ctx = context ?? _globalContext;
    try {
      final headers = await getAuthHeaders();
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }
      
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      
      return _handleResponse(response, ctx);
    } catch (e) {
      print('API PUT error: $e');
      return null;
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    BuildContext? context,
    Map<String, String>? additionalHeaders,
  }) async {
    final ctx = context ?? _globalContext;
    try {
      final headers = await getAuthHeaders();
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }
      
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      
      return _handleResponse(response, ctx);
    } catch (e) {
      print('API DELETE error: $e');
      return null;
    }
  }
  
  Future<dynamic> _handleResponse(http.Response response, BuildContext? context) async {
    if (response.statusCode == 401) {
      await _handleUnauthorized(context);
      return null;
    }
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('JSON parse error: ${response.body}');
        return null;
      }
    } else {
      print('API error: ${response.statusCode}, ${response.body}');
      return null;
    }
  }
  
  Future<void> _handleUnauthorized(BuildContext? context) async {
    print('Unauthorized access detected. Redirecting to login...');
    
    // Clear authentication data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('role');
    await prefs.remove('user_data');
    
    // Redirect to login page if context is available
    if (context != null && context.mounted) {
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        RouteNames.login,
        (route) => false,
      );
    } else if (_globalContext != null) {
      Navigator.of(_globalContext!, rootNavigator: true).pushNamedAndRemoveUntil(
        RouteNames.login,
        (route) => false,
      );
    } else {
      print('Warning: Cannot redirect to login. No valid context available.');
    }
  }
}