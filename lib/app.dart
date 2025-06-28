import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Forum/forum.dart';
import 'package:travel_app/Login/Login.dart';
import 'package:travel_app/Map/location_search_page.dart';
import 'package:travel_app/Memo/Memo.dart';
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

  void handleLogIn() {
    setState(() {
      isLoggedIn = true;
      currentPageIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(),
      Forum(),
      Memo(),
      isLoggedIn ? ProfilePage() : LoginPage(onLogIn: handleLogIn),
    ];

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
