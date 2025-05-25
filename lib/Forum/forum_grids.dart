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
  void initState()
  {
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
    Navigator.of(
      context
    ).push(MaterialPageRoute(builder: (ctx) => PostDetail(
      post: posts[index], 
      onToggleLike: () {
        _toggleLike(index);
      }
    )));
  }

  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.custom(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),

          gridDelegate: SliverWovenGridDelegate.count(
            pattern: const [
              WovenGridTile(1.1),
              WovenGridTile(
                5/7,
                crossAxisRatio: 0.9,
                alignment: AlignmentDirectional.topEnd
              ),
            ], 
            crossAxisCount: 2,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0
          ),
          childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index)
            {
              final Post data = posts[index];
              return GestureDetector(
                onTap: () {getInPost(context, index);},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: AssetImage(data.images[0]),
                      fit: BoxFit.cover
                    )
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
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
                                      color: Colors.black.withOpacity(0.6), // Darker color for outline
                                    ),
                                  ),
                                  Icon(
                                    Icons.location_pin,
                                    size: 20,
                                    color: Colors.white,
                                ),
                                ],
                              ),
                              
                              SizedBox(width: 5),
                              Text(
                                data.location,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  shadows: [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  Shadow(
                                    offset: Offset(-1.0, -1.0),
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleLike(index),
                              child: Icon(
                                Icons.favorite,
                                size: 20,
                                color: data.isLike ? Colors.red : Colors.white,
                              ),
                            ),
                            Spacer(),
                            Text(
                              data.views,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  Shadow(
                                    offset: Offset(-1.0, -1.0),
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ]
                              ),
                            ),
                            SizedBox(width: 5.0),
                            Icon(
                              Icons.remove_red_eye_outlined,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                )
              );
            },
            childCount: posts.length,
          )
        ),
      ),
    );
  }
}