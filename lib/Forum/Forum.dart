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
  void _navigateToPostDetail(BuildContext context, int index) async {
    final Post postToView = widget.posts[index];

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PostDetail(
          post: postToView,
          onToggleLike: () {
            setState(() {
              widget.posts[index].isLike = !widget.posts[index].isLike;
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
      child: ListView(
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => UploadPost(
                          onPostUploaded: widget.addPostCallback,
                          currentUserName: widget.currentUserName,
                          currentUserImage: widget.currentUserProfileImagePath,
                        ),
                      ),
                    );
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
    );
  }
}
