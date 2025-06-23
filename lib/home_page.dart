import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Book/bookingFlight.dart';
import 'package:travel_app/Book/bookingHotel.dart';
import 'package:travel_app/Forum/post_detail.dart';
import 'package:travel_app/Models/post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];

  List carouselImages = ["carousel1.png", "carousel2.png", "carousel3.png"];

  void selectFlight(context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => BookingFlight()));
  }

  void selectHotel(context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => BookingHotel()));
  }

  void getInPost(BuildContext context, int index) {
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

  void _toggleLike(int index) {
    setState(() {
      posts[index].isLike = !posts[index].isLike;
    });
  }

  @override
  Widget build(BuildContext context) {
    posts = Post.getAllPosts();

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                snap: true,
                title: Text(
                  "TripleFun",
                  style: GoogleFonts.ubuntu(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Color(0xff41729f),
              ),
            ],
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
          children: [
            _carousel(),
            SizedBox(height: 30),
            _searchBar(),
            SizedBox(height: 30),
            _flightAndHotel(context),
            SizedBox(height: 30),
            _topExperiences(),
          ],
        ),
      ),
    );
  }

  CarouselSlider _carousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        viewportFraction: 1,
      ),
      items:
          carouselImages.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset("assets/images/$i", fit: BoxFit.cover),
                  ),
                );
              },
            );
          }).toList(),
    );
  }

  Column _topExperiences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 0,
      children: [
        Text(
          "Top Experiences",
          style: GoogleFonts.ubuntu(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        MasonryGridView.count(
          padding: EdgeInsets.zero,
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

            if (data.media.isNotEmpty) {
              imageUrl = data.media[0];
            }

            return GestureDetector(
              onTap: () {
                getInPost(context, index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / 1.2,
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
                                      style: GoogleFonts.ubuntu(
                                        color: Colors.white,
                                        fontSize: 16,
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(1.0, 1.0),
                                            blurRadius: 3.0,
                                            color: Colors.black,
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
                                    onTap: () => _toggleLike(index),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 0.0,
                                            left: 0.0,
                                            child: Icon(
                                              Icons.favorite,
                                              size: 21,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Icon(
                                            Icons.favorite,
                                            size: 20, // Original size
                                            color:
                                                data.isLike
                                                    ? Colors.red
                                                    : Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    data.views,
                                    style: GoogleFonts.ubuntu(
                                      color: Colors.white,
                                      fontSize: 16,
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(1.0, 1.0),
                                          blurRadius: 3.0,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  // --- Shadow effect for Views Icon ---
                                  Stack(
                                    children: [
                                      Positioned(
                                        top: 1.0,
                                        left: 1.0,
                                        child: Icon(
                                          Icons.remove_red_eye_outlined,
                                          size:
                                              21, // Slightly larger for shadow
                                          color: Colors.black.withOpacity(
                                            0.6,
                                          ), // Shadow color
                                        ),
                                      ),
                                      const Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 20, // Original size
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                        child: Text(
                          data.title,
                          style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(data.authorImage),
                              radius: 12,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                data.authorName,
                                style: GoogleFonts.ubuntu(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
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
      ],
    );
  }

  Column _flightAndHotel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Starts Here",
          style: GoogleFonts.ubuntu(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        GridView.count(
          padding: EdgeInsets.zero,
          shrinkWrap: true, // To avoid the grid grows infinitely error
          crossAxisCount: 2,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
          childAspectRatio: 1 / 0.5,
          children: <Widget>[
            InkWell(
              onTap: () {
                selectFlight(context);
              },
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(54, 0, 0, 0),
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flight, size: 40, color: Color(0xff41729f)),
                    SizedBox(height: 5),
                    Text(
                      "Flight",
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        color: Color(0xff41729f),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                selectHotel(context);
              },
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(54, 0, 0, 0),
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hotel, size: 40, color: Color(0xff41729f)),
                    SizedBox(height: 5),
                    Text(
                      "Hotel",
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        color: Color(0xff41729f),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  SearchAnchor _searchBar() {
    return SearchAnchor(
      viewBackgroundColor: Colors.white,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          backgroundColor: WidgetStateProperty<Color>.fromMap(
            <WidgetStatesConstraint, Color>{WidgetState.any: Colors.white},
          ),
          hintText: "Search for flights and hotels.",
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search_outlined),
          trailing: <Widget>[
            Tooltip(
              message: "Filter search",
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.filter_alt_outlined),
              ),
            ),
          ],
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';

          return ListTile(
            title: Text(item, style: GoogleFonts.ubuntu()),
            onTap: () {},
          );
        });
      },
      isFullScreen: false,
    );
  }
}
