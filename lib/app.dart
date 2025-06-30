import 'package:flutter/material.dart';
import 'package:travel_app/Forum/forum.dart';
import 'package:travel_app/Login/Login.dart';
import 'package:travel_app/Memo/Memo.dart';
import 'package:travel_app/Profile/profile.dart';
import 'package:travel_app/home_page.dart';
import 'package:travel_app/Book/flightDetails.dart'; // 导入你的详情页
import 'package:travel_app/Book/hotelDetails.dart';
import 'package:travel_app/Book/hotelInfo.dart'; // 导入酒店信息页
import 'package:travel_app/Book/flightDetailInfo.dart'; // 导入航班详细信息页
import 'package:travel_app/Book/paymentPage.dart'; // 导入支付页面
import 'package:travel_app/Book/booking_history_page.dart'; // 导入预订历史页面

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/flightDetails': (context) => const Flightdetails(), // Flight details route
        '/hotelDetails': (context) => const HotelDetails(), // Hotel details page
        '/hotelInfo': (context) => const HotelInfo(), // Hotel info page route
        '/flightDetailInfo': (context) => const FlightDetailInfo(), // Flight detail info route
        '/payment': (context) => const PaymentPage(), // Payment page route
        '/bookingHistory': (context) => const BookingHistoryPage(), // Booking history page route
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
