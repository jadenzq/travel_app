import 'package:flutter/material.dart';
import 'package:travel_app/Forum/post_detail.dart';
import 'package:travel_app/Models/post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExperienceGrids extends StatefulWidget 
{
  const ExperienceGrids({super.key});

  @override
  State<ExperienceGrids> createState() => _ExperienceGridsState();
}

class _ExperienceGridsState extends State<ExperienceGrids> 
{
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    posts = Post.getAllPosts();
  }

  void _toggleLike(int index) 
  {
    setState(() {
      posts[index].isLike = !posts[index].isLike;
    });
  }

  void getInPost(BuildContext context, int index) 
  {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
          (ctx) => PostDetail(
            post: posts[index],
            onToggleLike: () {
              _toggleLike(index);
            },
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: MasonryGridView.count(
        shrinkWrap: true, 
        physics: const NeverScrollableScrollPhysics(), 
        crossAxisCount: 2, 
        mainAxisSpacing: 10.0, 
        crossAxisSpacing: 10.0, 
        itemCount: posts.length, 
        itemBuilder: (BuildContext context, int index) {
          final Post data = posts[index];
          final int? postId = data.id;
          String imageUrl = '';

          if (data.images.isNotEmpty) 
          {
            imageUrl = data.images[0];
          }

          double aspectRatio = 1.0;
          if (postId != null) 
          {
            if (postId % 5 == 0) 
            {
              aspectRatio = 0.5; // Wider and shorter (2:1 ratio)
            } 
            else if (postId % 5 == 1 || postId % 5 == 3) 
            {
              aspectRatio = 0.8; // Slightly taller than square (4:5 ratio)
            } else 
            {
              aspectRatio = 1.2; // Taller than square (5:4 ratio)
            }
          }

          return GestureDetector(
            onTap: () {
              getInPost(context, index);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Stack(
                  children: [
                    Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 8,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Positioned(
                                top: 1.0,
                                left: 1.0,
                                child: Icon(
                                  Icons.location_pin,
                                  size: 21,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                              const Icon(
                                Icons.location_pin,
                                size: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              data.location,
                              style: TextStyle(
                                color:Colors.white,
                                fontSize: 16,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  Shadow(
                                    offset: const Offset(-1.0, -1.0),
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        children: [
                          InkWell(
                            onTap:
                                () => _toggleLike(index),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.favorite,
                                size: 20,
                                color:
                                    data.isLike? Colors.red: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            data.views,
                            style: TextStyle(
                              color:Colors.white,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  offset: const Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Colors.black.withOpacity(0.6,),
                                ),
                                Shadow(
                                  offset: const Offset(-1.0, -1.0),
                                  blurRadius: 3.0,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 20,
                            color: Colors.white
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
