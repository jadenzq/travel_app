import 'package:flutter/material.dart';
import 'package:travel_app/Models/post.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Post> posts = [];

  @override
  Widget build(BuildContext context) {
    posts = Post.getAllPosts();

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
        children: [
          _searchBar(),
          SizedBox(height: 30),
          _flightAndHotel(),
          SizedBox(height: 30),
          _topExperiences(),
        ],
      ),
    );
  }

  Column _topExperiences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Top Experiences",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        GridView(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1 / 1.5,
          ),
          children: [
            for (final post in posts)
              Material(
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 255, 255),
                          Color.fromARGB(255, 255, 255, 255),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(54, 0, 0, 0),
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1 / 1.1,
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              image: DecorationImage(
                                image: Image.asset(post.images[0]).image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ), // Display the first image as thumbnail
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 5,
                                children: [
                                  CircleAvatar(
                                    maxRadius: 12,
                                    backgroundImage:
                                        Image.asset(post.authorImage).image,
                                  ),
                                  Text(post.authorName),
                                ],
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  Text(post.views),
                                  Icon(Icons.remove_red_eye_outlined),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            post.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Column _flightAndHotel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Starts Here",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true, // To avoid the grid grows infinitely error
          crossAxisCount: 2,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
          childAspectRatio: 1 / 0.5,
          children: <Widget>[
            Material(
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 255, 255, 255),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                      Icon(Icons.flight, size: 40, color: Colors.black),
                      SizedBox(height: 5),
                      Text(
                        "Flight",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 255, 255, 255),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                      Icon(Icons.hotel, size: 40, color: Colors.black),
                      SizedBox(height: 5),
                      Text(
                        "Hotel",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
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
          return ListTile(title: Text(item), onTap: () {});
        });
      },
      isFullScreen: false,
    );
  }
}
