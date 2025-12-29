import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class TrailerPlayerDialog extends StatefulWidget {
  final String trailerUrl;
  final String movieTitle;

  const TrailerPlayerDialog({
    super.key,
    required this.trailerUrl,
    required this.movieTitle,
  });

  static Future<void> show(
    BuildContext context, {
    required String trailerUrl,
    required String movieTitle,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black,
      builder: (context) => TrailerPlayerDialog(
        trailerUrl: trailerUrl,
        movieTitle: movieTitle,
      ),
    );
  }

  @override
  State<TrailerPlayerDialog> createState() => _TrailerPlayerDialogState();
}

class _TrailerPlayerDialogState extends State<TrailerPlayerDialog> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isPlaying = false;
  bool _showControls = true;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Force landscape orientation for video playback
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.trailerUrl),
      );

      await _controller.initialize();

      _controller.addListener(_onVideoUpdate);

      setState(() {
        _isInitialized = true;
        _duration = _controller.value.duration;
      });

      // Auto-play when initialized
      _controller.play();
      setState(() {
        _isPlaying = true;
      });

      // Hide controls after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Không thể tải video: ${e.toString()}';
      });
    }
  }

  void _onVideoUpdate() {
    if (!mounted) return;

    final position = _controller.value.position;
    final isPlaying = _controller.value.isPlaying;

    if (position != _position || isPlaying != _isPlaying) {
      setState(() {
        _position = position;
        _isPlaying = isPlaying;
      });
    }

    // Check for errors
    if (_controller.value.hasError) {
      setState(() {
        _hasError = true;
        _errorMessage =
            _controller.value.errorDescription ?? 'Lỗi không xác định';
      });
    }
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
      // Hide controls after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _controller.value.isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    // Auto-hide controls after 3 seconds if playing
    if (_showControls && _isPlaying) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _seekTo(Duration position) {
    _controller.seekTo(position);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      final hours = duration.inHours.toString();
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoUpdate);
    _controller.dispose();
    // Reset orientation to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Video player
          GestureDetector(
            onTap: _toggleControls,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: _buildVideoContent(),
            ),
          ),

          // Controls overlay
          if (_showControls) ...[
            // Top bar with title and close button
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.movieTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center play/pause button
            if (_isInitialized && !_hasError)
              Positioned.fill(
                child: Center(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),

            // Bottom progress bar
            if (_isInitialized && !_hasError)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress slider
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: context.color.territoryColor,
                          inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                          thumbColor: context.color.territoryColor,
                          overlayColor:
                              context.color.territoryColor.withValues(alpha: 0.3),
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                        ),
                        child: Slider(
                          value: _duration.inMilliseconds > 0
                              ? _position.inMilliseconds /
                                  _duration.inMilliseconds
                              : 0,
                          onChanged: (value) {
                            final position = Duration(
                              milliseconds:
                                  (value * _duration.inMilliseconds).toInt(),
                            );
                            _seekTo(position);
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Time indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Không thể phát trailer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.color.territoryColor,
                ),
                child: const Text('Đóng'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: context.color.territoryColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Đang tải trailer...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
