import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:toys_catalogue/features/home/data/product_service.dart';
import 'package:toys_catalogue/features/home/domain/models/product_model.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:video_player/video_player.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? args;

  const ProductDetailsPage({Key? key, this.args}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ProductService _productService = ProductService();
  bool _isLoading = true;
  String? _errorMessage;
  Product? _product;
  List<Map<String, dynamic>> _images = [];
  int _currentImageIndex = 0;
  VideoPlayerController? _videoController;
  bool _isPlayingVideo = false;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _fetchProductDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final productId = widget.args != null ? int.parse(widget.args!['productId'] as String) : null;
      
      if (productId == null) {
        setState(() {
          _errorMessage = 'No product ID provided';
          _isLoading = false;
        });
        return;
      }

      final product = await _productService.getProductDetails(productId);
      setState(() {
        _product = product;
        _isLoading = false;
        // Initialize images from the product
        if (product.images != null && product.images!.isNotEmpty) {
          _images = product.images!.map((img) => {
            'image': img.image,
            'is_primary': img.isPrimary,
            'alt_text': img.altText
          }).toList();
        }
      });

      // Initialize video player if there's a video
      if (product.videoUrl != null && product.videoUrl!.isNotEmpty) {
        _initializeVideoPlayer(product.videoUrl!);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load product details. Please try again.';
        _isLoading = false;
      });
      print('Error in _fetchProductDetails: $e');
    }
  }

  void _initializeVideoPlayer(String videoUrl) {
    _videoController = VideoPlayerController.network(videoUrl);
    _videoController!.initialize().then((_) {
      setState(() {}); // Refresh UI when video is ready
    });
  }

  void _toggleVideoPlayback() {
    setState(() {
      _isPlayingVideo = !_isPlayingVideo;
      if (_isPlayingVideo) {
        _videoController?.play();
      } else {
        _videoController?.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _product?.title ?? 'Product Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_product?.videoUrl != null && _product!.videoUrl!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.play_circle_outline, color: ColorsClass.secondaryTheme),
              onPressed: () {
                setState(() {
                  _isPlayingVideo = true;
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorsClass.secondaryTheme,
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchProductDetails,
                        child: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsClass.secondaryTheme,
                        ),
                      ),
                    ],
                  ),
                )
              : _buildProductDetails(),
    );
  }

  Widget _buildProductDetails() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Carousel
              _buildImageCarousel(),
              
              // Product Info
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Brand
                    Text(
                      _product?.title ?? 'Product Name',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Brand: ${_product?.brand ?? 'Unknown'}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Category and Age Group
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildInfoChip('Category: ${_product?.productCategory ?? 'N/A'}'),
                        _buildInfoChip('Age: ${_product?.ageGroup ?? 'N/A'}'),
                        _buildInfoChip('Gender: ${_getGenderText(_product?.gender)}'),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _product?.description ?? 'No description available',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Manufacturer
                    const Text(
                      'Manufacturer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.factory, color: ColorsClass.secondaryTheme),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _product?.manufacturerName ?? 'Unknown Manufacturer',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Video Player Overlay
        if (_isPlayingVideo && _videoController != null && _videoController!.value.isInitialized)
          _buildVideoPlayerOverlay(),
      ],
    );
  }

  Widget _buildImageCarousel() {
    // If no images and no primary image, show placeholder
    if (_images.isEmpty && (_product?.imageUrl == null || _product!.imageUrl!.isEmpty)) {
      return Container(
        height: 300,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        ),
      );
    }

    // If we have the image array, use it
    if (_images.isNotEmpty) {
      return Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 300,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
            ),
            items: _images.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: Image.network(
                      item['image'],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _images.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == entry.key
                      ? ColorsClass.secondaryTheme
                      : Colors.grey[350],
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    // Fallback to single image from imageUrl
    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.grey[200],
      child: Image.network(
        _product!.imageUrl!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
          );
        },
      ),
    );
  }

  Widget _buildVideoPlayerOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _toggleVideoPlayback,
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              // Video
              Center(
                child: AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              ),
              
              // Close button
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    setState(() {
                      _isPlayingVideo = false;
                      _videoController?.pause();
                    });
                  },
                ),
              ),
              
              // Play/Pause indicator
              Center(
                child: AnimatedOpacity(
                  opacity: _videoController!.value.isPlaying ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  String _getGenderText(String? genderCode) {
    if (genderCode == null) return 'Unisex';
    
    switch (genderCode.toUpperCase()) {
      case 'M':
        return 'Boys';
      case 'F':
        return 'Girls';
      case 'U':
      default:
        return 'All';
    }
  }
}