import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Models/post.dart';

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

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLike;
    _imagePageController = PageController();

    _imagePageController.addListener(() {
      setState(() {
        if (_imagePageController.page != null) {
          _currentPage = _imagePageController.page!.round();
        }
      });
    });
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  void _handleLikeToggle() {
    setState(() {
      _isLiked = !_isLiked;
      widget.onToggleLike();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              style: GoogleFonts.ubuntu(
                color: Colors.white, 
                fontSize: 18
              ),

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
                                widget.post.images[_currentPage],
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
                          itemCount: widget.post.images.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Image.asset(
                                widget.post.images[index],
                                fit:
                                    BoxFit
                                        .contain, //This is for blur background
                                // Expand images
                                // fit: BoxFit.cover,
                                // width: double.infinity,
                                // height: double.infinity,
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
                            widget.post.images.length,
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
                          style: GoogleFonts.ubuntu(
                            fontSize: 16
                          ),
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
                          Text(
                            'Like',
                            style: GoogleFonts.ubuntu(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.share, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      'Share',
                      style: GoogleFonts.ubuntu()
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.remove_red_eye_outlined, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      widget.post.views,
                      style: GoogleFonts.ubuntu()
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
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
}
