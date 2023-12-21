import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ProfileVideoCarousel extends StatefulWidget {
  final List<String> videoUrls;

  const ProfileVideoCarousel({Key? key, required this.videoUrls})
      : super(key: key);

  @override
  _ProfileVideoCarouselState createState() => _ProfileVideoCarouselState();
}

class _ProfileVideoCarouselState extends State<ProfileVideoCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.videoUrls.length,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemBuilder: (context, index) {
        return VideoPlayerWidget(videoUrl: widget.videoUrls[index]);
      },
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    _isPlaying = true;
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPlaying ? _controller.pause() : _controller.play();
          _isPlaying = !_isPlaying;
        });
      },
      child: AnimatedOpacity(
        opacity: _isPlaying ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      ),
    );
  }
}
