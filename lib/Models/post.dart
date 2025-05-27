class Post {
  int? id;
  String title;
  String content;
  String views;
  List<String> images;
  String authorName;
  String authorImage;
  String location;
  bool isLike = false;

  Post({
    required this.title,
    required this.content,
    required this.views,
    required this.images,
    required this.authorName,
    required this.authorImage,
    required this.location
  });

  static List<Post> getAllPosts() {
    List<Post> posts = [];

    posts.add(
      Post(
        title: "A memorable summer adventure in Malaysia lalalalala",
        content:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum.",
        views: "60k",
        images: ["assets/images/xmum.jpg", "assets/images/melina.jpg"],
        authorName: "Melina",
        authorImage: "assets/images/melina.jpg",
        location: "Malaysia",
      ),
    );

    posts.add(
      Post(
        title: "A memorable summer adventure in Malaysia",
        content:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum.",
        views: "60k",
        images: ["assets/images/xmum.jpg"],
        authorName: "Melina",
        authorImage: "assets/images/melina.jpg",
        location: "Malaysia",
      ),
    );

    posts.add(
      Post(
        title: "A memorable summer adventure in Malaysia",
        content:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum.",
        views: "60k",
        images: ["assets/images/xmum.jpg"],
        authorName: "Melina",
        authorImage: "assets/images/melina.jpg",
        location: "Malaysia",
      ),
    );

    posts.add(
      Post(
        title: "A memorable summer adventure in Malaysia",
        content:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum.",
        views: "60k",
        images: ["assets/images/xmum.jpg"],
        authorName: "Melina",
        authorImage: "assets/images/melina.jpg",
        location: "Malaysia",
      ),
    );

    posts.add(
      Post(
        title: "A memorable summer adventure in Malaysia",
        content:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum.",
        views: "60k",
        images: ["assets/images/xmum.jpg"],
        authorName: "Melina",
        authorImage: "assets/images/melina.jpg",
        location: "Malaysia",
      ),
    );

    posts.add(
      Post(
        title: "A memorable summer adventure in Malaysia",
        content:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum.",
        views: "60k",
        images: ["assets/images/xmum.jpg"],
        authorName: "Melina",
        authorImage: "assets/images/melina.jpg",
        location: "Malaysia",
      ),
    );

    posts.add(
      Post(
        title: "A memorable summer adventure in Malaysia",
        content:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum.",
        views: "60k",
        images: ["assets/images/xmum.jpg"],
        authorName: "Melina",
        authorImage: "assets/images/melina.jpg",
        location: "Malaysia",
      ),
    );

    posts.add(
      Post(
        title: "A memorable summer adventure in Malaysia",
        content:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum.",
        views: "60k",
        images: ["assets/images/xmum.jpg"],
        authorName: "Melina",
        authorImage: "assets/images/melina.jpg",
        location: "Malaysia",
      ),
    );

    for (int i = 0; i < posts.length; i++) 
    {
      posts[i].id = i;
    }

    return posts; 
  }
}
