import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/main/presentation/main_page.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:video_player/video_player.dart';

class FlicksPage extends StatefulWidget {
  const FlicksPage({Key? key}) : super(key: key);

  @override
  _FlicksPageState createState() => _FlicksPageState();
}

class _FlicksPageState extends State<FlicksPage> {
  final List<String> videoPaths = [
    'assets/flick1.mp4',
    'assets/flick2.mp4',
    'assets/flick3.mp4',
  ];

  @override
  Widget build(BuildContext context) {
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
              // Existing PageView
              PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: videoPaths.length,
                itemBuilder: (context, index) {
                  return VideoPage(videoPath: videoPaths[index]);
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
}

class VideoPage extends StatefulWidget {
  final String videoPath;

  const VideoPage({Key? key, required this.videoPath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _showControls = false;
  
  bool _isDragging = false;
  bool _isSeeking = false;  // New state for seeking

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
  return Container(
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
                ),
              ],
            ),
          ),
        ),
        
        GestureDetector(
          onTap: _togglePlayPause,  // Add gesture detector here
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
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: StreamBuilder(
        //     stream: Stream.periodic(const Duration(milliseconds: 200)),
        //     builder: (context, snapshot) {
        //       return Container(
        //         height: 38,
        //         child: VideoProgressIndicator(
        //           _controller,
        //           allowScrubbing: true,
        //           colors: VideoProgressColors(
        //             playedColor: ColorsClass.secondaryTheme,
        //             bufferedColor: Colors.white.withOpacity(0.3),
        //             backgroundColor: Colors.white.withOpacity(0.1),
        //           ),
        //           padding: EdgeInsets.zero,
        //         ),
        //       );
        //     },
        //   ),
        // ),
Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,  // Important!
                onHorizontalDragStart: (_) => _startSeeking(),
                onHorizontalDragEnd: (_) => _stopSeeking(),
                onHorizontalDragCancel: () => _stopSeeking(),
                onTapDown: (_) => _startSeeking(),
                onTapUp: (_) => _stopSeeking(),
                onTapCancel: () => _stopSeeking(),
                child: Container(
                  height: _isSeeking ? 60 : 20,  // Larger touch target
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
    )
    );
  }
}