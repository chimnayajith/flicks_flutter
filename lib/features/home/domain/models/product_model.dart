class Product {
  final int id;
  final String title;
  final String brand;
  final String productCategory;
  final String ageGroup;
  final String gender;
  final String? description;
  final String? manufacturerName;
  final String? imageUrl;
  final String? videoUrl;
  final List<ProductImage>? images; // Keep for backwards compatibility
  final List<GalleryItem>? gallery; // Added for product details response

  Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.productCategory,
    required this.ageGroup,
    required this.gender,
    this.description,
    this.manufacturerName,
    this.imageUrl,
    this.videoUrl,
    this.images,
    this.gallery,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse gallery items first from either 'gallery' or 'gallery_items'
    List<GalleryItem>? gallery;
    
    if (json['gallery'] != null) {
      gallery = (json['gallery'] as List)
          .map((item) => GalleryItem.fromJson(item, fieldPrefix: ''))
          .toList();
    } else if (json['gallery_items'] != null) {
      gallery = (json['gallery_items'] as List)
          .map((item) => GalleryItem.fromJson(item, fieldPrefix: 'media_'))
          .toList();
    }
    
    // Legacy parsing for 'images' field
    List<ProductImage>? images;
    if (json['images'] != null) {
      images = (json['images'] as List)
          .map((img) => ProductImage.fromJson(img))
          .toList();
    }

    return Product(
      id: json['id'],
      title: json['title'] ?? 'Unknown',
      brand: json['brand'] ?? '',
      productCategory: json['product_category'] ?? '',
      ageGroup: json['age_group'] ?? '',
      gender: json['gender'] ?? '',
      description: json['description'],
      manufacturerName: json['manufacturer_name'],
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      images: images,
      gallery: gallery,
    );
  }
}

// Add new GalleryItem class
class GalleryItem {
  final int id;
  final String type; // 'image' or 'video'
  final bool isPrimary;
  final String? altText;
  final int displayOrder;
  final String url;
  final int? duration; // For videos only

  GalleryItem({
    required this.id,
    required this.type,
    required this.isPrimary,
    this.altText,
    required this.displayOrder,
    required this.url,
    this.duration,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json, {String fieldPrefix = ''}) {
    // Handle different field names between detail and list responses
    final typeField = fieldPrefix + 'type'; // 'type' or 'media_type'
    
    return GalleryItem(
      id: json['id'],
      type: json[typeField] ?? 'image',
      isPrimary: json['is_primary'] ?? false,
      altText: json['alt_text'],
      displayOrder: json['display_order'] ?? 0,
      url: json['url'],
      duration: json['duration'],
    );
  }
}

// Keep existing ProductImage class for backward compatibility
class ProductImage {
  final int id;
  final String image;
  final bool isPrimary;
  final String? altText;

  ProductImage({
    required this.id,
    required this.image,
    required this.isPrimary,
    this.altText,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      image: json['image'],
      isPrimary: json['is_primary'] ?? false,
      altText: json['alt_text'],
    );
  }
}

class ProductsResponse {
  final List<Product> products;
  final int? count;
  final String? next;
  final String? previous;

  ProductsResponse({
    required this.products,
    this.count,
    this.next,
    this.previous,
  });

  factory ProductsResponse.fromJson(dynamic jsonData) {    
    List<dynamic> resultsData;
    Map<String, dynamic>? jsonMap;
    
    // Handle different API response formats
    if (jsonData is Map<String, dynamic>) {
      jsonMap = jsonData;
      if (jsonData.containsKey('results')) {
        resultsData = jsonData['results'] as List<dynamic>;
      } else {
        // If the response is directly a single product
        resultsData = [jsonData];
      }
    } else if (jsonData is List) {
      // If the API directly returns an array of products
      resultsData = jsonData;
      jsonMap = null;
    } else {
      // Fallback
      resultsData = [];
      jsonMap = null;
    }

    try {
      final products = resultsData
          .map((productData) => Product.fromJson(productData))
          .toList();
      
      return ProductsResponse(
        products: products,
        count: jsonMap?['count'],
        next: jsonMap?['next'],
        previous: jsonMap?['previous'],
      );
    } catch (e) {
      print("Error parsing products: $e");
      return ProductsResponse(products: []);
    }
  }
}