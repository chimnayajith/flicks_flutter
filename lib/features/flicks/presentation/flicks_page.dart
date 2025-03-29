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
  // Remove hardcoded videoPaths and use product data instead
  
  // Default fallback URL
  final String fallbackVideoUrl = 'https://flickscatalogue.s3.amazonaws.com/products/flicks/flick1.mp4';
  
  final ProductService _productService = ProductService();
  List<Product> _filteredProducts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRelatedProducts();
  }
  
  Future<void> _fetchRelatedProducts() async {
    if (widget.args == null) return;
    
    final source = widget.args!['source'];
    if (source == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      if (source == 'trending') {
        final trending = await _productService.getTrendingProducts();
        setState(() {
          _filteredProducts = trending.where((p) => p.videoUrl != null && p.videoUrl!.isNotEmpty).toList();
          _isLoading = false;
        });
      } else if (source == 'top') {
        final top = await _productService.getTopProducts();
        setState(() {
          _filteredProducts = top.where((p) => p.videoUrl != null && p.videoUrl!.isNotEmpty).toList();
          _isLoading = false;
        });
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
    // Check if we have a specific video URL to play
    final String? videoUrl = widget.args?['videoUrl'] as String?;
    final String? title = widget.args?['title'] as String?;
    final String? imageUrl = widget.args?['imageUrl'] as String?;
    final String? description = widget.args?['description'] as String?;
    
    // If we have a specific videoUrl, show it
    if (videoUrl != null && videoUrl.isNotEmpty) {
      return _buildSingleVideoPage(videoUrl, title, imageUrl, description);
    }
    
    // Otherwise use the normal flicks page with fetched product videos
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
              // Replace existing PageView with a new one that uses _filteredProducts
              _isLoading 
              ? Center(child: CircularProgressIndicator(color: ColorsClass.secondaryTheme))
              : _filteredProducts.isEmpty 
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
                    scrollDirection: Axis.vertical,
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return _buildNetworkVideoPlayer(
                        product.videoUrl ?? fallbackVideoUrl,
                        title: product.title,
                        imageUrl: product.imageUrl,
                        description: product.description,
                      );
                    },
                  ),
              
              // Back Button
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
                    final mainPageState = context.findAncestorStateOfType<MainPageState>();
                    if (mainPageState != null) {
                      mainPageState.pageController.jumpToPage(0);
                    }
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
            // Video
            Center(
              child: _buildNetworkVideoPlayer(
                videoUrl, 
                title: title ?? 'Product', 
                imageUrl: imageUrl,
                description: description,
              ),
            ),
            
            // Back Button
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
    {String? title, String? imageUrl, String? description}
  ) {
    return NetworkVideoPage(
      videoUrl: videoUrl.isEmpty ? fallbackVideoUrl : videoUrl,
      title: title,
      imageUrl: imageUrl,
      description: description,
      productId: widget.args?['productId'] as String?,
    );
  }
}

class VideoPage extends StatefulWidget {
  final String videoPath;

  const VideoPage({Key? key, required this.videoPath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

// Keep the existing VideoPage implementation
class _VideoPageState extends State<VideoPage> {
  // Keep your existing code
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
    _controller = VideoPlayerController.asset(widget.videoPath);
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
    // Keep your existing build method
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragDistance += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragDistance.abs() > _dragThreshold) {
          if (_dragDistance < 0) { // Left swipe
            Navigator.pushNamed(context, RouteNames.productDetailsPage);
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
                    // Video Player
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

                    // Product Info (inside AspectRatio)
                    Positioned(
                      bottom: 20,
                      left: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap:(){
                            Navigator.pushNamed(context, RouteNames.productDetailsPage);
                        },
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Name and Avatar Row
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage('company_logo_url'),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Product Name',
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
                          // Description
                          Text(
                            'Product description that can be longer and more detailed...',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      )
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
            
            // Progress Bar
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

// New class for network videos
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
          if (_dragDistance < 0 && widget.productId != null) { // Left swipe
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
                    // Video Player
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

                    // Product Info (inside AspectRatio)
                    Positioned(
                      bottom: 20,
                      left: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap:(){
                          if (widget.productId != null) {
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
                            // Name and Avatar Row
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
                            // Description
                            Text(
                              widget.description ?? 'Product description that can be longer and more detailed...',
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
            
            // Progress Bar
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