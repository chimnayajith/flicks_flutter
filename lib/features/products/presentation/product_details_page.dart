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
        
        // Clear previous images array
        _images = [];
        
        // Try to use gallery items first (new API format)
        if (_product?.gallery != null && _product!.gallery!.isNotEmpty) {
          _images = _product!.gallery!.map((item) => {
            'type': item.type,
            'url': item.url,
            'is_primary': item.isPrimary,
            'alt_text': item.altText ?? '',
            'display_order': item.displayOrder,
            'duration': item.duration
          }).toList();
        }
        // Fall back to legacy images field if gallery is empty
        else if (_product?.images != null && _product!.images!.isNotEmpty) {
          _images = _product!.images!.map((img) => {
            'type': 'image',
            'url': img.image,
            'is_primary': img.isPrimary,
            'alt_text': img.altText ?? '',
            'display_order': 0
          }).toList();
        }
        // Use imageUrl as last resort
        else if (_product?.imageUrl != null && _product!.imageUrl!.isNotEmpty) {
          _images = [{
            'type': 'image',
            'url': _product!.imageUrl!,
            'is_primary': true,
            'alt_text': _product!.title,
            'display_order': 0
          }];
        }
      });

      // Initialize video player if there's a video
      if (_product?.videoUrl != null && _product!.videoUrl!.isNotEmpty) {
        _initializeVideoPlayer(_product!.videoUrl!);
      } else {
        // Check if there's a video in the gallery
        final videoItem = _images.firstWhere(
          (item) => item['type'] == 'video', 
          orElse: () => <String, dynamic>{}
        );
        
        if (videoItem.isNotEmpty && videoItem['url'] != null) {
          _initializeVideoPlayer(videoItem['url']);
        }
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
    _videoController?.dispose(); 
    _videoController = VideoPlayerController.network(videoUrl);
    _videoController!.initialize().then((_) {
      _videoController!.seekTo(Duration.zero);
      
      if (mounted) {
        setState(() {
        });
        
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted) {
            _videoController!.play();
          }
        });
      }
    });
  }

  void _toggleVideoPlayback() {
    if (_videoController == null) return;
    
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
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
                // Find the index of the first video in the gallery
                int videoIndex = _images.indexWhere((item) => item['type'] == 'video');
                if (videoIndex >= 0) {
                  // Set the carousel to that index
                  setState(() {
                    _currentImageIndex = videoIndex;
                  });
                } else {
                  // If no gallery video, initialize the main video
                  _initializeVideoPlayer(_product!.videoUrl!);
                }
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
      ],
    );
  }

 Widget _buildImageCarousel() {
  if (_images.isEmpty) {
    return Container(
      height: 300,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
      ),
    );
  }

  return Column(
    children: [
      CarouselSlider(
        options: CarouselOptions(
          height: 300,
          viewportFraction: 1.0,
          enableInfiniteScroll: _images.length > 1,
          onPageChanged: (index, reason) {
            setState(() {
              _currentImageIndex = index;
              
              // Pause any playing video when carousel changes
              if (_videoController != null && _videoController!.value.isInitialized) {
                _videoController!.pause();
              }
              
              // If the new slide is a video, initialize the player
              if (_images[index]['type'] == 'video') {
                _initializeVideoPlayer(_images[index]['url']);
              }
            });
          },
        ),
        items: _images.map((item) {
          return Builder(
            builder: (BuildContext context) {
              // For video type items
              if (item['type'] == 'video') {
                // Check if this is the current video and controller is initialized
                bool isCurrentVideo = _currentImageIndex == _images.indexOf(item);
                
                if (isCurrentVideo && _videoController != null && _videoController!.value.isInitialized) {
                  // Show actual video player for current slide with the first frame as thumbnail
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Video player that shows the first frame as thumbnail
                      AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                      
                      // Play/pause overlay
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_videoController!.value.isPlaying) {
                              _videoController!.pause();
                            } else {
                              _videoController!.play();
                            }
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Center(
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
                        ),
                      ),
                      
                      // Video progress at bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: VideoProgressIndicator(
                          _videoController!,
                          allowScrubbing: true,
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          colors: VideoProgressColors(
                            playedColor: ColorsClass.secondaryTheme,
                            bufferedColor: Colors.white.withOpacity(0.5),
                            backgroundColor: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Show loading indicator while video initializes
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.black),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: ColorsClass.secondaryTheme,
                      ),
                    ),
                  );
                }
              }
              
              // For image type items (unchanged)
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Image.network(
                  item['url'] ?? '',
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
      if (_images.length > 1) ...[
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
    ],
  );
}

  Widget _buildVideoPlayerOverlay() {
    return Positioned.fill(
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
            
            // Play/Pause button
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_videoController!.value.isPlaying) {
                    _videoController!.pause();
                  } else {
                    _videoController!.play();
                  }
                });
              },
              child: Center(
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
            ),
            
            // Video progress indicator at bottom
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: VideoProgressIndicator(
                _videoController!,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                colors: VideoProgressColors(
                  playedColor: ColorsClass.secondaryTheme,
                  bufferedColor: Colors.white.withOpacity(0.5),
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
          ],
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