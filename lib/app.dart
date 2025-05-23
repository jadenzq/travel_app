import 'package:flutter/material.dart';
import 'package:travel_app/Forum/Forum.dart';
import 'package:travel_app/Login/Login.dart';
import 'package:travel_app/Memo/Memo.dart';
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

  List<Widget> pages = [HomePage(), Forum(), Memo(), LoginPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: pages[currentPageIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: NavigationBar(
          onDestinationSelected:
              (index) => setState(() {
                currentPageIndex = index;
              }),
          selectedIndex: currentPageIndex,
          indicatorColor: Color(0xFFA8F1FF),
          backgroundColor: Colors.white,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              label: "Experiences",
            ),
            NavigationDestination(
              icon: Icon(Icons.post_add_outlined),
              label: "Memo",
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle_outlined),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
