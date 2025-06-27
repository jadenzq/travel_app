import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Forum/Forum.dart';
import 'package:travel_app/Login/Login.dart';
import 'package:travel_app/Memo/Memo.dart';
import 'package:travel_app/Models/post.dart';
import 'package:travel_app/Profile/profile.dart';
import 'package:travel_app/home_page.dart';
import 'package:travel_app/Book/flightDetails.dart'; // 导入你的详情页
import 'package:travel_app/Book/hotelDetails.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  int currentPageIndex = 0;
  bool isLoggedIn = false;

  List<Post> _allPosts = [];
  String _loggedInUserName = "Gloria";
  String _loggedInUserProfileImage = "assets/images/photo111.jpg";

  @override
  void initState() {
    super.initState();
    _allPosts = Post.getAllPosts();
  }

  void handleLogIn() {
    setState(() {
      isLoggedIn = true;
      currentPageIndex = 0;
    });
  }
  
  void _addPost(Post newPost) {
    setState(() {
      newPost.id = _allPosts.length + 1;
      _allPosts.insert(0, newPost);
    });
  }

  void _deletePost(Post postToDelete) {
    setState(() {
      _allPosts.removeWhere((post) => post.id == postToDelete.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(
        posts: _allPosts,
        currentUserName: _loggedInUserName,
        onDeletePost: _deletePost,
      ),
      Forum(
        posts: _allPosts,
        addPostCallback: _addPost,
        currentUserName: _loggedInUserName,
        currentUserProfileImagePath: _loggedInUserProfileImage,
        onDeletePost: _deletePost,
      ),
      Memo(),
      isLoggedIn ? ProfilePage() : LoginPage(onLogIn: handleLogIn),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/flightDetails': (context) => const Flightdetails(), // 注册路由
        '/hotelDetails': (context) => const HotelDetails(), // 假设你有一个酒店详情页
      },
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        body: pages[currentPageIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: NavigationBar(
            labelTextStyle: WidgetStateProperty<TextStyle>.fromMap(
              <WidgetStatesConstraint, TextStyle>{
                WidgetState.any: GoogleFonts.ubuntu(),
              },
            ),
            onDestinationSelected:
                (index) => setState(() {
                  currentPageIndex = index;
                }),
            selectedIndex: currentPageIndex,
            indicatorColor: Color(0xFFA8F1FF),
            backgroundColor: Colors.white,
            destinations: <Widget>[
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: "Home",
              ),
              const NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline),
                label: "Experiences",
              ),
              const NavigationDestination(
                icon: Icon(Icons.post_add_outlined),
                label: "Memo",
              ),
              NavigationDestination(
                icon:
                    isLoggedIn
                        ? const Icon(Icons.account_circle_outlined)
                        : const Icon(Icons.login_outlined),
                label: isLoggedIn ? "Profile" : "LogIn",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
