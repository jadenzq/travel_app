import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Models/post.dart';
import 'package:video_player/video_player.dart';

class PostDetail extends StatefulWidget {
  final Post post;
  final VoidCallback onToggleLike;

  const PostDetail({super.key, required this.post, required this.onToggleLike});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  late bool _isLiked;
  late PageController _imagePageController;
  int _currentPage = 0;

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoInitialized = false;
  
  Duration _currentVideoPosition = Duration.zero;
  Duration _videoDuration = Duration.zero;

  bool _isContentExpanded = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLike;

    if (!widget.post.isVideo)
    {
      _imagePageController = PageController();

      _imagePageController.addListener(() {
        setState(() {
          if (_imagePageController.page != null) {
            _currentPage = _imagePageController.page!.round();
          }
        });
      });
    }
    
    else
    {
      _videoPlayerController = VideoPlayerController.asset(widget.post.media[1])
        ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          _videoDuration = _videoPlayerController.value.duration;
        });

        _videoPlayerController.addListener(_updateVideoProgress);

        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          autoInitialize: true,
          autoPlay: true,
          looping: true,
          showControls: false,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: GoogleFonts.ubuntu(color: Colors.white),
              ),
            );
          },
        );
      });
    }
  }

  void _updateVideoProgress() 
  {
    if (_isVideoInitialized) 
    {
      setState(() {
        _currentVideoPosition = _videoPlayerController.value.position;
      });
    }
  }

  void _togglePlayPause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } 
    else {
      _videoPlayerController.play();
    }

    setState(() {});
  }

  @override
  void dispose() {
    if (!widget.post.isVideo) 
    {
      _imagePageController.dispose();
    }

    else
    {
      _videoPlayerController.removeListener(_updateVideoProgress); 
      _videoPlayerController.dispose();
      _chewieController.dispose();
    }

    super.dispose();
  }

  void _handleLikeToggle() {
    setState(() {
      _isLiked = !_isLiked;
      widget.onToggleLike();
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    return widget.post.isVideo ? videoPostView() : imagePostView();  
  }

  Widget imagePostView()
  {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.post.authorImage),
              radius: 20,
            ),
            SizedBox(width: 10),
            Text(
              widget.post.authorName,
              style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      // Blur background image
                      Container(
                        height: 300,
                        child: ClipRect(
                          child: Stack(
                            children: [
                              Image.asset(
                                widget.post.media[_currentPage],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 15.0,
                                  sigmaY: 15.0,
                                ),
                                child: Container(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 300,
                        child: PageView.builder(
                          controller: _imagePageController,
                          itemCount: widget.post.media.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Image.asset(
                                widget.post.media[index],
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.post.media.length,
                            (idx) => buildDot(idx),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.title,
                          style: GoogleFonts.ubuntu(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 20,
                              color: Color(0xff41729f),
                            ),
                            SizedBox(width: 5),
                            Text(
                              widget.post.location,
                              style: GoogleFonts.ubuntu(
                                fontSize: 16,
                                color: Color(0xff41729f),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.post.content,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.ubuntu(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              bottom: 20.0,
              top: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: _handleLikeToggle,
                  borderRadius: BorderRadius.circular(8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: _isLiked ? Colors.red : Colors.grey,
                          ),
                          SizedBox(width: 5),
                          Text('Like', style: GoogleFonts.ubuntu()),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.share, color: Colors.grey),
                    SizedBox(width: 5),
                    Text('Share', style: GoogleFonts.ubuntu()),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.remove_red_eye_outlined, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(widget.post.views, style: GoogleFonts.ubuntu()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) 
  {
    bool isCurrent = index == _currentPage;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: isCurrent ? 6.0 : 5.0,
      width: isCurrent ? 6.0 : 5.0,
      decoration: BoxDecoration(
        color: isCurrent ? Colors.white : Colors.white.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget videoPostView() 
  {
    final double expandedBoxHeight = 150.0;
    double currentContentHeight = _isContentExpanded ? expandedBoxHeight + 50.0 : 20.0;

    final double usernameBottom = 20 + currentContentHeight + 8.0;
    final double locationBottom = usernameBottom + 18.0 + 8.0;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _togglePlayPause,
                      // onDoubleTap: _handleLikeToggle,
                      child: _isVideoInitialized
                                ? AspectRatio(
                                    aspectRatio:
                                        _videoPlayerController.value.aspectRatio,
                                    child: Chewie(controller: _chewieController),
                                  )
                                : Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      const Color(0xff41729f),
                                    ),
                                  ),
                                ),
                    ),
                  ),

                  Positioned(
                    top: 24.0,
                    left: 8.0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),

                  if (_isVideoInitialized)
                    Positioned(
                      top: 24.0,
                      right: 16.0,
                      child: IconButton(
                        icon: Icon(
                          _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 36.0,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                    ),

                  Positioned(
                    bottom: 30.0,
                    right: 8.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(widget.post.authorImage),
                          radius: 24,
                        ),
                        const SizedBox(height: 30),
                        Column(
                          children: [
                            InkWell(
                              onTap: _handleLikeToggle,
                              child: Icon(
                                Icons.favorite,
                                color: _isLiked ? Colors.red : Colors.white,
                                size: 30,
                              ),
                            ),
                            Text(
                              'Like',
                              style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Column(
                          children: [
                            const Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              'Share',
                              style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Column(
                          children: [
                            const Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              widget.post.views,
                              style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: locationBottom,
                    left: 16.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Color(0xff41729f),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.post.location,
                            style: GoogleFonts.ubuntu(
                              color: Color(0xff41729f),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: usernameBottom,
                    left: 16.0,
                    child: Text(
                      '@${widget.post.authorName}',
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 20,
                    left: 16.0,
                    right: 80.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isContentExpanded = !_isContentExpanded;
                            });
                          },

                          child: Container(
                            padding: _isContentExpanded ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
                            decoration: _isContentExpanded
                                          ? BoxDecoration(
                                              color: Colors.black.withOpacity(0.4),
                                              borderRadius: BorderRadius.circular(4.0),
                                            )
                                          : null,
                            child: _isContentExpanded
                                    ? SizedBox(
                                        height: expandedBoxHeight,
                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                          primary: false,
                                          child: Text(
                                            widget.post.content,
                                            style: GoogleFonts.ubuntu(
                                              color: Colors.white.withOpacity(0.9),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              shadows: const [
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 3.0,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        widget.post.content,
                                        style: GoogleFonts.ubuntu(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(1.0, 1.0),
                                              blurRadius: 3.0,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                          ),
                        ),

                        if (_isContentExpanded)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isContentExpanded = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'hide',
                                style: GoogleFonts.ubuntu(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(0.5, 0.5),
                                      blurRadius: 1.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  if (_isVideoInitialized)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        value: _videoDuration.inMilliseconds > 0 ? _currentVideoPosition.inMilliseconds / _videoDuration.inMilliseconds : 0,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 114, 183, 247),
                        ),
                        minHeight: 3.0,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
