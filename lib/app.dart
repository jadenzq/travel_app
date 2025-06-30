import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Forum/Forum.dart';
import 'package:travel_app/Login/Login.dart';
import 'package:travel_app/Map/location_search_page.dart';
import 'package:travel_app/Memo/Memo.dart';
import 'package:travel_app/Models/post.dart';
import 'package:travel_app/Profile/profile.dart';
import 'package:travel_app/home_page.dart';

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
  String _loggedInUserName = "Guest";
  String _loggedInUserProfileImage = "assets/images/default-avatar.jpg";
    String _loggedInUserEmail = "";
  String _loggedInUserPhone = "";

  @override
  void initState() {
    super.initState();
    _allPosts = Post.getAllPosts();
    _initializeUser();
  }

  void _initializeUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isLoggedIn = true;
        _loggedInUserName = user.displayName ?? user.email ?? "User";
        _loggedInUserProfileImage = user.photoURL ?? "assets/images/default-avatar.jpg";
        _loggedInUserEmail = user.email ?? "";
        _loggedInUserPhone = user.phoneNumber ?? "";

      });

      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            _loggedInUserName = userDoc.get('username') ?? _loggedInUserName;
            _loggedInUserEmail = userDoc.get('email') ?? _loggedInUserEmail;
            _loggedInUserPhone = userDoc.get('phone') ?? _loggedInUserPhone;

          });
        }
      } catch (e) {
        developer.log("Error fetching user data from Firestore: $e");
      }
    } else {
      setState(() {
        isLoggedIn = false;
        _loggedInUserName = "Guest";
        _loggedInUserProfileImage = "assets/images/default-avatar.jpg";
        _loggedInUserEmail = "";
        _loggedInUserPhone = "";
      });
    }

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!mounted) return;
      setState(() {
        isLoggedIn = user != null;
      });
      if (user != null) {
        setState(() {
          _loggedInUserName = user.displayName ?? user.email ?? "User";
          _loggedInUserProfileImage = user.photoURL ?? "assets/images/default-avatar.jpg";
          _loggedInUserEmail = user.email ?? "";
          _loggedInUserPhone = user.phoneNumber ?? "";
        });
        try {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (userDoc.exists) {
            setState(() {
              _loggedInUserName = userDoc.get('username') ?? _loggedInUserName;
              _loggedInUserEmail = userDoc.get('email') ?? _loggedInUserEmail;
              _loggedInUserPhone = userDoc.get('phone') ?? _loggedInUserPhone;
            });
          }
        } catch (e) {
          developer.log("Error fetching user data from Firestore on auth state change: $e");
        }
      } else {
        setState(() {
          _loggedInUserName = "Guest";
          _loggedInUserProfileImage = "assets/images/default-avatar.jpg";
          _loggedInUserEmail = "";
          _loggedInUserPhone = "";
        });
      }
    });
  }

  void handleLogIn() {
    setState(() {
      isLoggedIn = true;
      currentPageIndex = 0;
    });
    _initializeUser();
  }
  
  void _addPost(Post newPost) {
    setState(() {
      newPost.id = _allPosts.length;
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
    final user = FirebaseAuth.instance.currentUser;

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
      isLoggedIn ? ProfilePage(
        getUserName: _loggedInUserName,
        getEmail: _loggedInUserEmail,
        getPhone: _loggedInUserPhone,
        getProfileImagePath: _loggedInUserProfileImage,
      ) : LoginPage(onLogIn: handleLogIn),
    ];

    // 用户已登录，进入 Profile 页面
    if (user == null) {
      return LoginPage(
        onLogIn: () {
          if (!mounted) return;
          handleLogIn();
        },
      );
    }

    return Scaffold(
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
    );
  }
}
