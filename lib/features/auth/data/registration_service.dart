import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toys_catalogue/constants/constants.dart';

class RegistrationService {
  final String baseUrl = apiURL;

  Future<Map<String, dynamic>> registerShopWithOwner({
    required String shopName,
    required String shopAddress,
    required String shopPhone,
    required String shopEmail,
    String? shopDescription,
    required String ownerUsername,
    required String ownerEmail,
    required String ownerPassword,
    required String ownerFirstName,
    required String ownerLastName,
    File? bannerImage,
  }) async {
    try {
      // Create multipart request for containing file
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/auth/register/shop/'),
      );

      // Add text fields
      request.fields['shop_name'] = shopName;
      request.fields['shop_address'] = shopAddress;
      request.fields['shop_phone'] = shopPhone;
      request.fields['shop_email'] = shopEmail;
      if (shopDescription != null && shopDescription.isNotEmpty) {
        request.fields['shop_description'] = shopDescription;
      }
      request.fields['owner_username'] = ownerUsername;
      request.fields['owner_email'] = ownerEmail;
      request.fields['owner_password'] = ownerPassword;
      request.fields['owner_first_name'] = ownerFirstName;
      request.fields['owner_last_name'] = ownerLastName;

      // If banner image is provided, add it to the request
      if (bannerImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'banner',
          bannerImage.path,
        ));
      }

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // Save tokens
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['tokens']['access']);
        await prefs.setString('refresh_token', data['tokens']['refresh']);
        await prefs.setString('role', 'owner');
        await prefs.setString('username', data['owner']['username']);
        
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to register shop');
      }
    } catch (e) {
      throw Exception('Failed to register shop: $e');
    }
  }
}