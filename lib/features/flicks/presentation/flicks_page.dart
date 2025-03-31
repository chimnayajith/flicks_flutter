import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/home/data/product_service.dart';
import 'package:toys_catalogue/features/home/domain/models/product_model.dart';
import 'package:toys_catalogue/features/main/presentation/main_page.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';
import 'package:video_player/video_player.dart';

class FlicksPage extends StatefulWidget {
  final Map<String, dynamic>? args;
  
  const FlicksPage({Key? key, this.args}) : super(key: key);

  @override
  _FlicksPageState createState() => _FlicksPageState();
}

class _FlicksPageState extends State<FlicksPage> {
  final String fallbackVideoUrl = 'https://flickscatalogue.s3.amazonaws.com/products/flicks/flick1.mp4';
  
  final ProductService _productService = ProductService();
  List<Product> _sectionProducts = [];
  int _currentProductIndex = 0;
  bool _isLoading = false;
  bool _enableSectionScroll = false;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadSectionProducts();
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  Future<void> _loadSectionProducts() async {
    if (widget.args == null) return;
    
    final source = widget.args!['source'];
    final productId = widget.args!['productId'];
    _enableSectionScroll = widget.args!['enableSectionScroll'] ?? false;
    
    if (source == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      List<Product> products = [];
      
      if (source == 'trending') {
        products = await _productService.getTrendingProducts();
      } else if (source == 'top') {
        products = await _productService.getTopProducts();
      } else if (source == 'filtered') {
        if (widget.args != null && widget.args!.containsKey('filterParams')) {
          final filterParams = widget.args!['filterParams'] as Map<String, dynamic>?;
          if (filterParams != null) {
            products = await _productService.getFilteredProducts(
              gender: filterParams['gender'],
              ageGroup: filterParams['age_group'],
              category: filterParams['category'],
            );
          } else {
            products = await _productService.getAllProducts(page: 1, pageSize: 20);
          }
        } else {
          products = await _productService.getAllProducts(page: 1, pageSize: 20);
        }
      } else {
        products = await _productService.getAllProducts(page: 1, pageSize: 20);
      }
      
      // Only include products with videos
      products = products.where((p) => p.videoUrl != null && p.videoUrl!.isNotEmpty).toList();
      
      // Find the index of the current product
      int index = products.indexWhere((p) => p.id.toString() == productId);
      
      setState(() {
        _sectionProducts = products;
        _currentProductIndex = index >= 0 ? index : 0;
        _isLoading = false;
      });
      
      // Initialize page controller with current index
      if (_sectionProducts.isNotEmpty && _enableSectionScroll) {
        _pageController = PageController(initialPage: _currentProductIndex);
      }
    } catch (e) {
      print("Error fetching related products: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? videoUrl = widget.args?['videoUrl'] as String?;
    final String? title = widget.args?['title'] as String?;
    final String? imageUrl = widget.args?['imageUrl'] as String?;
    final String? description = widget.args?['description'] as String?;
    
    if (!_enableSectionScroll && videoUrl != null && videoUrl.isNotEmpty) {
      return _buildSingleVideoPage(videoUrl, title, imageUrl, description);
    }
    
    return WillPopScope(
      onWillPop: () async {
        final mainPageState = context.findAncestorStateOfType<MainPageState>();
        if (mainPageState != null) {
          mainPageState.pageController.jumpToPage(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              _isLoading 
              ? Center(child: CircularProgressIndicator(color: ColorsClass.secondaryTheme))
              : _sectionProducts.isEmpty 
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam_off, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No videos available",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: _sectionProducts.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentProductIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final product = _sectionProducts[index];
                      return _buildNetworkVideoPlayer(
                        product.videoUrl ?? fallbackVideoUrl,
                        title: product.title,
                        imageUrl: product.imageUrl,
                        description: product.description,
                        productId: product.id.toString(),
                      );
                    },
                  ),
              
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSingleVideoPage(
    String videoUrl, 
    String? title, 
    String? imageUrl, 
    String? description
  ) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Center(
              child: NetworkVideoPage(
                videoUrl: videoUrl.isEmpty ? fallbackVideoUrl : videoUrl,
                title: title,
                imageUrl: imageUrl,
                description: description,
              ),
            ),
            
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNetworkVideoPlayer(
    String videoUrl, 
    {String? title, String? imageUrl, String? description, String? productId}
  ) {
    return NetworkVideoPage(
      videoUrl: videoUrl.isEmpty ? fallbackVideoUrl : videoUrl,
      title: title,
      imageUrl: imageUrl,
      description: description,
      productId: productId,
    );
  }
}

class NetworkVideoPage extends StatefulWidget {
  final String videoUrl;
  final String? title;
  final String? imageUrl;
  final String? description;
  final String? productId;

  const NetworkVideoPage({
    Key? key, 
    required this.videoUrl,
    this.title,
    this.imageUrl,
    this.description,
    this.productId,
  }) : super(key: key);

  @override
  _NetworkVideoPageState createState() => _NetworkVideoPageState();
}

class _NetworkVideoPageState extends State<NetworkVideoPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _showControls = false;
  bool _isDragging = false;
  bool _isSeeking = false;
  final double _dragThreshold = 50.0;
  double _dragDistance = 0.0;

  void _startSeeking() {
    setState(() {
      _isDragging = true;
      _isSeeking = true;
    });
  }

  void _stopSeeking() {
    setState(() {
      _isDragging = false;
      _isSeeking = false;
    });
  }
  
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragDistance += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragDistance.abs() > _dragThreshold) {
          if (_dragDistance < 0 && widget.productId != null) {
            _controller.pause();
            Navigator.pushNamed(
              context, 
              RouteNames.productDetailsPage,
              arguments: {'productId': widget.productId},
            );
          }
        }
        setState(() {
          _dragDistance = 0;
        });
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 9/16,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: FutureBuilder<void>(
                        future: _initializeVideoPlayerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return VideoPlayer(_controller);
                          } else {
                            return const Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  color: ColorsClass.secondaryTheme,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    Positioned(
                      bottom: 20,
                      left: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.productId != null) {
                            _controller.pause();
                            Navigator.pushNamed(
                              context, 
                              RouteNames.productDetailsPage,
                              arguments: {'productId': widget.productId},
                            );
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                    widget.imageUrl ?? 'https://via.placeholder.com/32'
                                  ),
                                  backgroundColor: Colors.grey[300],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.title ?? 'Product Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.description ?? 'Product description...',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            GestureDetector(
              onTap: _togglePlayPause,
              child: ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, VideoPlayerValue value, child) {
                  return AnimatedOpacity(
                    opacity: !value.isPlaying ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Center(
                      child: Icon(
                        value.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragStart: (_) => _startSeeking(),
                    onHorizontalDragEnd: (_) => _stopSeeking(),
                    onHorizontalDragCancel: () => _stopSeeking(),
                    onTapDown: (_) => _startSeeking(),
                    onTapUp: (_) => _stopSeeking(),
                    onTapCancel: () => _stopSeeking(),
                    child: Container(
                      height: _isSeeking ? 60 : 20,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            height: _isSeeking ? 38 : 6,
                            child: VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor: ColorsClass.secondaryTheme,
                                bufferedColor: Colors.white.withOpacity(0.3),
                                backgroundColor: Colors.white.withOpacity(0.1),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: _controller,
                            builder: (context, VideoPlayerValue value, child) {
                              final position = value.position.inMilliseconds /
                                  value.duration.inMilliseconds;
                              return Positioned(
                                left: constraints.maxWidth * position - 10,
                                bottom: _isSeeking ? 30 : 0,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: _isSeeking ? 20 : 10,
                                  height: _isSeeking ? 20 : 10,
                                  decoration: BoxDecoration(
                                    color: ColorsClass.secondaryTheme,
                                    shape: _isSeeking ? BoxShape.rectangle : BoxShape.circle,
                                    borderRadius: _isSeeking ? BorderRadius.circular(4) : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}