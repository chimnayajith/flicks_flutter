import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/home/data/product_service.dart';
import 'package:toys_catalogue/features/home/domain/models/product_model.dart';
import 'package:toys_catalogue/features/main/presentation/main_page.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';
import 'package:video_player/video_player.dart';

class FlicksPage extends StatefulWidget {
  final Map<String, dynamic>? args;
  
  static Map<String, dynamic>? pendingArgs;
  
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
  bool _isBottomNavigation = false;
  late PageController _pageController;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;
  Map<String, dynamic>? _effectiveArgs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    _effectiveArgs = FlicksPage.pendingArgs ?? widget.args;
    
    if (FlicksPage.pendingArgs != null) {
      FlicksPage.pendingArgs = null;
    }
    
    _isBottomNavigation = _effectiveArgs == null;
    
    if (_effectiveArgs != null) {
      _loadSectionProducts();
    } else {
      _loadAllProducts();
    }
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  Future<void> _loadAllProducts() async {
    setState(() {
      _isLoading = true;
      _enableSectionScroll = true;
    });
    
    try {
      final response = await _productService.getAllProducts(page: 1, pageSize: 10);
      
      List<Product> products = response;
      products = products.where((p) => p.videoUrl != null && p.videoUrl!.isNotEmpty).toList();
      
      setState(() {
        _sectionProducts = products;
        _isLoading = false;
        _currentPage = 1;
        _totalPages = (response.length + 9) ~/ 10;
      });
      
      _setupScrollListener();
      
    } catch (e) {
      print("Error loading products: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _setupScrollListener() {
    _pageController.addListener(() {
      if (_pageController.position.pixels >= _pageController.position.maxScrollExtent - 500 &&
          !_isLoadingMore &&
          _currentPage < _totalPages) {
        _loadMoreProducts();
      }
    });
  }
  
  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore) return;
    
    setState(() {
      _isLoadingMore = true;
    });
    
    try {
      final nextPage = _currentPage + 1;
      final response = await _productService.getAllProducts(page: nextPage, pageSize: 10);
      
      List<Product> newProducts = response;
      newProducts = newProducts.where((p) => p.videoUrl != null && p.videoUrl!.isNotEmpty).toList();
      
      setState(() {
        _sectionProducts.addAll(newProducts);
        _currentPage = nextPage;
        _isLoadingMore = false;
      });
      
    } catch (e) {
      print("Error loading more products: $e");
      setState(() {
        _isLoadingMore = false;
      });
    }
  }
  
  Future<void> _loadSectionProducts() async {
    if (_effectiveArgs == null) return;
    
    final source = _effectiveArgs!['source'];
    final productId = _effectiveArgs!['productId'];
    _enableSectionScroll = _effectiveArgs!['enableSectionScroll'] ?? false;
    
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
        if (_effectiveArgs != null && _effectiveArgs!.containsKey('filterParams')) {
          final filterParams = _effectiveArgs!['filterParams'] as Map<String, dynamic>?;
          if (filterParams != null) {
            products = await _productService.getFilteredProducts(
              gender: filterParams['gender'],
              ageGroup: filterParams['age_group'],
              category: filterParams['category'],
            );
          } else {
            products = await _productService.getAllProducts(page: 1);
          }
        } else {
          products = await _productService.getAllProducts(page: 1);
        }
      } else {
        products = await _productService.getAllProducts(page: 1);
      }
      
      products = products.where((p) => p.videoUrl != null && p.videoUrl!.isNotEmpty).toList();
      
      int index = products.indexWhere((p) => p.id.toString() == productId);
      
      setState(() {
        _sectionProducts = products;
        _currentProductIndex = index >= 0 ? index : 0;
        _isLoading = false;
      });
      
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
    final isInMainPage = context.findAncestorStateOfType<MainPageState>() != null;
    
    if (isInMainPage) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Flicks Feed", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: _buildFlicksFeed(),
      );
    }
    
    final String? videoUrl = _effectiveArgs?['videoUrl'] as String?;
    final String? title = _effectiveArgs?['title'] as String?;
    final String? imageUrl = _effectiveArgs?['imageUrl'] as String?;
    final String? description = _effectiveArgs?['description'] as String?;
    
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
              _buildFlicksFeed(),
              
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
  
  Widget _buildFlicksFeed() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: ColorsClass.secondaryTheme));
    }
    
    if (_sectionProducts.isEmpty) {
      return Center(
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
      );
    }
    
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _sectionProducts.length + (_isLoadingMore ? 1 : 0),
      onPageChanged: (index) {
        if (index < _sectionProducts.length) {
          setState(() {
            _currentProductIndex = index;
          });
        }
      },
      itemBuilder: (context, index) {
        if (index == _sectionProducts.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: ColorsClass.secondaryTheme),
            ),
          );
        }
        
        final product = _sectionProducts[index];
        return _buildNetworkVideoPlayer(
          product.videoUrl ?? fallbackVideoUrl,
          title: product.title,
          imageUrl: product.imageUrl,
          description: product.description,
          productId: product.id.toString(),
        );
      },
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
  bool _isDragging = false;
  final double _dragThreshold = 50.0;
  double _dragDistance = 0.0;

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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
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
            // Video player
            Center(
              child: AspectRatio(
                aspectRatio: 9/16,
                child: GestureDetector(
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
              ),
            ),
            
            // Product info overlay at bottom
            Positioned(
              bottom: 25,
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
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.title ?? "Untitled Product",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(0.7),
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (widget.description != null) ...[
                      SizedBox(height: 8),
                      Text(
                        widget.description!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.7),
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Play/pause icon overlay
            Center(
              child: AnimatedOpacity(
                opacity: _controller.value.isPlaying ? 0.0 : 0.7,
                duration: Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),
            
            // Progress bar at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, VideoPlayerValue value, child) {
                  if (!value.isInitialized) {
                    return SizedBox.shrink();
                  }
                  
                  final duration = value.duration.inMilliseconds;
                  final position = value.position.inMilliseconds;
                  final progress = duration > 0 ? position / duration : 0.0;
                  final progressWidth = MediaQuery.of(context).size.width * progress;
                  
                  return GestureDetector(
                    onHorizontalDragStart: (details) {
                      setState(() => _isDragging = true);
                      _controller.pause();
                    },
                    onHorizontalDragUpdate: (details) {
                      if (!_isDragging) return;
                      
                      final box = context.findRenderObject() as RenderBox;
                      final width = box.size.width;
                      final dx = details.localPosition.dx.clamp(0, width);
                      final percent = dx / width;
                      
                      _controller.seekTo(Duration(milliseconds: (percent * duration).round()));
                    },
                    onHorizontalDragEnd: (details) {
                      setState(() => _isDragging = false);
                      _controller.play();
                    },
                    onTapDown: (details) {
                      final RenderBox box = context.findRenderObject() as RenderBox;
                      final width = box.size.width;
                      final dx = details.localPosition.dx.clamp(0, width);
                      final percent = dx / width;
                      
                      _controller.seekTo(Duration(milliseconds: (percent * duration).round()));
                    },
                    child: Container(
                      height: _isDragging ? 40 : 26, // Taller even when not dragging
                      color: Colors.transparent,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.centerLeft,
                        children: [
                          // Background track (full width)
                          Container( // Removed animation
                            height: _isDragging ? 24 : 8, // Taller bar
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              // Removed border radius completely
                            ),
                          ),
                          
                          // Progress track (partial width based on playback)
                          Stack(
                            children: [
                              // The progress bar itself
                              Container( // Removed animation
                                height: _isDragging ? 24 : 8, // Taller bar
                                width: progressWidth,
                                color: ColorsClass.secondaryTheme, // No border radius
                              ),
                              
                              // Time texts when dragging
                              if (_isDragging)
                                Container(
                                  width: progressWidth,
                                  height: 24,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    _formatDuration(value.position),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          
                          // Total duration (right aligned)
                          if (_isDragging)
                            Positioned(
                              right: 8,
                              child: Text(
                                _formatDuration(value.duration),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          
                          // Draggable dot/handle
                          Positioned(
                            left: progressWidth - (_isDragging ? 8 : 6),
                            child: Container( // Removed animation
                              width: _isDragging ? 16 : 12,
                              height: _isDragging ? 16 : 12,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: _isDragging ? BoxShape.rectangle : BoxShape.circle,
                                borderRadius: _isDragging ? BorderRadius.circular(4) : null,
                                border: Border.all(
                                  color: ColorsClass.secondaryTheme,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: _isDragging 
                                ? Icon(
                                    Icons.drag_handle,
                                    color: ColorsClass.secondaryTheme,
                                    size: 10,
                                  )
                                : null,
                            ),
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