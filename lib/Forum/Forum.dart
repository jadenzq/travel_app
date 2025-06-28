import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Forum/forum_grids.dart';
import 'package:travel_app/Forum/post_detail.dart';
import 'package:travel_app/Forum/upload_post.dart';
import 'package:travel_app/Models/post.dart'; 

class Forum extends StatefulWidget 
{
  final List<Post> posts;
  final void Function(Post newPost) addPostCallback;
  final String currentUserName;
  final String currentUserProfileImagePath;
  final void Function(Post postToDelete) onDeletePost;

  const Forum({
    super.key,
    required this.posts,
    required this.addPostCallback,
    required this.currentUserName,
    required this.currentUserProfileImagePath,
    required this.onDeletePost,
  });

  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum>
{
  double _notificationOpacity = 0.0;
  String _notificationMessage = '';
  Timer? _notificationTimer;

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }

  void _showForumNotification(String message) {
    setState(() {
      _notificationMessage = message;
      _notificationOpacity = 1.0;
    });

    _notificationTimer?.cancel();
    _notificationTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) { 
        setState(() {
          _notificationOpacity = 0.0;
        });
      }
    });
  }

  void _navigateToPostDetail(BuildContext context, Post postToView) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PostDetail(
          post: postToView,
          onToggleLike: () {
            setState(() {
              postToView.isLike = !postToView.isLike;
            });
          },
          currentUserName: widget.currentUserName,
        ),
      ),
    );

    if (result == true) {
      widget.onDeletePost(postToView);
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child: SizedBox.expand(
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Experiences',
                        style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => UploadPost(
                                onPostUploaded: widget.addPostCallback,
                                currentUserName: widget.currentUserName,
                                currentUserImage: widget.currentUserProfileImagePath,
                              ),
                            ),
                          );
        
                          if (result is String && result.isNotEmpty) {
                            _showForumNotification(result);
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: Text(
                          'Upload',
                          style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff41729f),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
                ExperienceGrids(
                  posts: widget.posts,
                  currentUserName: widget.currentUserName,
                  getInPost: _navigateToPostDetail,
                ),
              ],
            ),
        
            AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                bottom: _notificationOpacity > 0 ? 20 : -100,
                left: 20,
                right: 20,
                child: AnimatedOpacity(
                  opacity: _notificationOpacity,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          _notificationMessage,
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
