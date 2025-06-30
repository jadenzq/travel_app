class Post {
  int? id;
  String title;
  String content;
  String views;
  List<String> media;
  String authorName;
  String authorImage;
  String location;
  bool isLike = false;
  bool isVideo = false;

  Post({
    required this.title,
    required this.content,
    required this.views,
    required this.media,
    required this.authorName,
    required this.authorImage,
    required this.location,
    this.isVideo = false
  });

  static List<Post> getAllPosts() {
    List<Post> posts = [];

    posts.add(
      Post(
        title: "Penang One's Better",
        content:
            "Penang's George Town is a UNESCO World Heritage site for a reason - every alley tells a story! I spent days wandering through historic shophouses, admiring incredible street art, and indulging in some of the best hawker food Malaysia has to offer. A paradise for foodies and culture lovers!",
        views: "20k",
        media: [
          "assets/images/post-image/Penang-Street-Art.jpg",
          "assets/images/post-image/Penang-Street.jpg",
          "assets/images/post-image/Penang-Hokkien-Mee.jpg",
          "assets/images/post-image/Penang-Cendol.jpg",
          "assets/images/post-image/Penang-Komtar.jpg"
        ],
        authorName: "Alex Lee",
        authorImage: "assets/images/user/Alex.jpg",
        location: "Penang, Malaysia",
      ),
    );

    posts.add(
      Post(
        title: "A pleasure trip in Paris",
        content:
            "From the glittering Eiffel Tower to the charming Montmartre streets, Paris captivated my heart. Every corner held a new surprise, a delightful cafe, or a masterpiece waiting to be admired. The boat cruise along the Seine was simply magical!",
        views: "2.4M",
        media: [
          "assets/images/post-image/Paris-Notre-Dame.jpg",
          "assets/images/post-image/Paris-Eiffel-Tower.jpg",
          "assets/images/post-image/Paris-Coffee.jpg",
          "assets/images/post-image/Paris-Seine.jpg",
        ],
        authorName: "Sophie",
        authorImage: "assets/images/user/Sophie.jpg",
        location: "Paris, France",
      ),
    );

    posts.add(
      Post(
        title: "Kyoto's Tranquil Beauty: Temples and Cherry Blossoms",
        content:
            "Stepping into Kyoto felt like traveling back in time. The ancient temples, serene gardens, and traditional wooden houses create an atmosphere of unparalleled peace. Witnessing the cherry blossoms in full bloom at Arashiyama Bamboo Grove was an unforgettable experience.",
        views: "80k",
        media: [
          "assets/images/post-image/Kyoto-Cherry-Blossom.jpg",
          "assets/images/post-image/Kyoto-Temple.jpg",
          "assets/images/post-image/Kyoto-Street.jpg"
        ],
        authorName: "Kenji",
        authorImage: "assets/images/user/Kenji.jpg",
        location: "Kyoto, Japan",
      ),
    );

    posts.add(
      Post(
        title: "Majestic Niagara Falls: A Natural Wonder",
        content:
            "Experiencing the sheer power and beauty of Niagara Falls was absolutely awe-inspiring. The roar of the water, the mist on my face, and the vibrant rainbows created an unforgettable spectacle. Definitely a must-visit natural wonder!",
        views: "5.1M",
        media: [
          "assets/images/video-thumbnail/Canada-NiagaraFalls.jpg",
          "assets/videos/post-video/Canada_NiagaraFalls.mp4"
        ],
        authorName: "Oman",
        authorImage: "assets/images/user/Oman.jpg",
        location: "Niagara Falls, Canada",
        isVideo: true,

      ),
    );


    posts.add(
      Post(
        title: "Dreaming Vacation in Santorini Greece",
        content:
            "Santorini is every bit as breathtaking as the postcards suggest. The iconic white-washed buildings clinging to cliffs, the deep blue Aegean Sea, and sunsets that paint the sky in fiery hues... it's a paradise for romantics and photographers alike.",
        views: "1.5M",
        media: [
          "assets/images/post-image/Santorini-Sea.jpg",
          "assets/images/post-image/Santorini-Sunset.jpg"
        ],
        authorName: "Maria",
        authorImage: "assets/images/user/Maria.jpg",
        location: "Santorini, Greece",
      ),
    );

    posts.add(
      Post(
        title: "Historical walk in Rome",
        content:
            "Rome is a living museum. Walking through the Colosseum, visiting the Vatican, and tossing a coin in the Trevi Fountain felt like stepping back in time. The food, the history, the passion of the city - it all combined for an incredible journey.",
        views: "60k",
        media: [
          "assets/images/post-image/Rome-Colosseum.jpg",
          "assets/images/post-image/Rome-Street.jpg",
          "assets/images/post-image/Rome-St-Peter-Square.jpg",
          "assets/images/post-image/Rome-Fountain.jpg",
          "assets/images/post-image/Rome-Statue.jpg",
          "assets/images/post-image/Roman-Espresso.jpg"
        ],
        authorName: "Giovanni",
        authorImage: "assets/images/user/Giovanni.jpg",
        location: "Rome, Italy",
      ),
    );

    posts.add(
      Post(
        title: "La Boqueria Market",
        content: "Barcelona's La Boqueria market is a feast for the senses! From vibrant fruits to fresh seafood, every stall is bursting with color and flavor. I spent hours sampling tapas and soaking in the lively atmosphere. A must-visit for any foodie!",
        views: "500k",
        media: [
          "assets/images/video-thumbnail/Barcelona-La-boqueria-2.jpg",
          "assets/videos/post-video/Barcelona_La_boqueria.mp4"
        ],
        authorName: "Olivia",
        authorImage: "assets/images/user/Olivia.jpg",
        location: "Barcelona, Spain",
        isVideo: true,
      )
    );

    posts.add(
      Post(
        title: "Chongqing's Vertical Cityscape & Spicy Delights",
        content:
            "Diving deep into the unique multi-layered architecture and thrilling flavors of Chongqing! The city truly comes alive after dark with its dazzling lights and bustling hotpot streets. A must-visit for urban explorers and foodies alike.",
        views: "1.0M",
        media: [
          "assets/images/post-image/Chongqing-Hong-Ya-Dong.jpg",
          "assets/images/post-image/Chongqing-HotPot.jpg",
          "assets/images/post-image/Chongqing-Train.jpg"
        ],
        authorName: "Oman",
        authorImage: "assets/images/user/Oman.jpg",
        location: "Chongqing, China",
      ),
    );

    posts.add(
      Post(
        title: "Sunrise Symphony: Hot Air Balloons in Cappadocia",
        content:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque neque aliquam sollicitudin interdum.",
        views: "3.7M",
        media: [
          "assets/images/post-image/Turkey-Hot-Air-Ballon-1.jpg",
          "assets/images/post-image/Turkey-Hot-Air-Ballon-2.jpg",
          "assets/images/post-image/Turkey-House-View.jpg"
        ],
        authorName: "Olivia",
        authorImage: "assets/images/user/Olivia.jpg",
        location: "Cappadocia, Turkey",
      ),
    );

    posts.add(
      Post(
        title: "Sydney Review: The Opera House",
        content:
            "The Sydney Opera House is a multi-venue performing arts centre in Sydney, New South Wales, Australia. Located on the foreshore of Sydney Harbour, it is widely regarded as one of the world's most famous and distinctive buildings, and a masterpiece of 20th-century architecture.",
        views: "10k",
        media: [
          "assets/images/post-image/Sydney-Opera-House.jpg"
        ],
        authorName: "Chloe",
        authorImage: "assets/images/user/Chloe.jpg",
        location: "Sydney, Australia",
      ),
    );

    for (int i = 0; i < posts.length; i++) 
    {
      posts[i].id = i;
    }

    return posts; 
  }
}
