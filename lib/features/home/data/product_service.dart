import 'package:flutter/material.dart';
import 'package:toys_catalogue/utils/api/api_client.dart';
import 'package:toys_catalogue/features/home/domain/models/product_model.dart';

class ProductService {
  final ApiClient _apiClient = ApiClient();

  // Get trending products
  Future<List<Product>> getTrendingProducts({BuildContext? context}) async {
    try {
      final response = await _apiClient.get(
        '/api/products/trending/',
        context: context,
      );

      if (response != null) {
        print("Raw trending response received");
        final productsResponse = ProductsResponse.fromJson(response);
        print(
          "Parsed trending products count: ${productsResponse.products.length}",
        );
        return productsResponse.products;
      } else {
        print("Null response received for trending products");
        return [];
      }
    } catch (e) {
      print('Error fetching trending products: $e');
      return []; // Return empty list on error for graceful degradation
    }
  }

  // Get top products
  Future<List<Product>> getTopProducts({BuildContext? context}) async {
    try {
      final response = await _apiClient.get(
        '/api/products/top/',
        context: context,
      );

      if (response != null) {
        final productsResponse = ProductsResponse.fromJson(response);
        return productsResponse.products;
      }
      return [];
    } catch (e) {
      print('Error fetching top products: $e');
      return []; // Return empty list on error
    }
  }

  // Get product details
  Future<Product?> getProductDetails(
    int productId, {
    BuildContext? context,
  }) async {
    try {
      final response = await _apiClient.get(
        '/api/products/$productId/',
        context: context,
      );

      if (response != null) {
        return Product.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error fetching product details: $e');
      return null;
    }
  }

  Future<List<String>> getProductCategories({BuildContext? context}) async {
    try {
      final response = await _apiClient.get(
        '/api/products/categories/',
        context: context,
      );

      if (response != null) {
        // Parse the response
        final List<dynamic> data = response;

        // Convert the dynamic list to a list of strings
        return data.map((category) => category.toString()).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<List<String>> getAgeGroups({BuildContext? context}) async {
    try {
      final response = await _apiClient.get(
        '/api/products/age_groups/',
        context: context,
      );

      if (response != null) {
        // Parse the response
        final List<dynamic> data = response;

        // Convert the dynamic list to a list of strings
        return data.map((ageGroup) => ageGroup.toString()).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching age groups: $e');
      return [];
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _apiClient.get('/api/products/search/?q=$query');

      if (response == null) {
        return [];
      }

      final productsResponse = ProductsResponse.fromJson(response);
      return productsResponse.products;
    } catch (e) {
      throw Exception('Failed to search products');
    }
  }

  Future<List<Product>> getFilteredProducts({
    String? gender,
    String? ageGroup,
    String? category,
    BuildContext? context,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (gender != null && gender != 'All') {
        if (gender == 'Boys') {
          queryParams['gender'] = 'M';
        } else if (gender == 'Girls') {
          queryParams['gender'] = 'F';
        } else if (gender == 'Unisex') {
          queryParams['gender'] = 'U';
        }
      }

      if (ageGroup != null) queryParams['age_group'] = ageGroup;
      if (category != null) queryParams['category'] = category;

      print('Querying with params: $queryParams');

      // Construct endpoint with query parameters
      String endpoint = '/api/products/filter/';
      if (queryParams.isNotEmpty) {
        endpoint += '?';
        queryParams.forEach((key, value) {
          endpoint += '$key=$value&';
        });
        endpoint = endpoint.substring(
          0,
          endpoint.length - 1,
        ); // Remove trailing &
      }

      final response = await _apiClient.get(endpoint, context: context);

      if (response != null) {
        final productsResponse = ProductsResponse.fromJson(response);
        return productsResponse.products;
      }
      return [];
    } catch (e) {
      print('Error fetching filtered products: $e');
      return []; // Return empty list on error
    }
  }

  Future<List<Product>> getAllProducts({
    int page = 1,
    int pageSize = 10,
    BuildContext? context,
  }) async {
    try {
      final response = await _apiClient.get(
        '/api/products/?page=$page&page_size=$pageSize',
        context: context,
      );

      if (response != null) {
        final productsResponse = ProductsResponse.fromJson(response);
        return productsResponse.products;
      }
      return [];
    } catch (e) {
      print('Error fetching all products: $e');
      return [];
    }
  }
}
