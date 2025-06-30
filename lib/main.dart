import 'package:flutter/material.dart';
import 'package:travel_app/Book/booking_history_page.dart';
import 'package:travel_app/Book/flightDetailInfo.dart';
import 'package:travel_app/Book/hotelInfo.dart';
import 'package:travel_app/Book/paymentPage.dart';
import 'package:travel_app/app.dart';
import 'package:travel_app/Book/flightDetails.dart';
import 'package:travel_app/Book/hotelDetails.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Sign out the user before running the app
  await FirebaseAuth.instance.signOut();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      debugShowCheckedModeBanner: false,
      routes: {
        '/flightDetails':
            (context) => const Flightdetails(), // Flight details route
        '/hotelDetails':
            (context) => const HotelDetails(), // Hotel details page
        '/hotelInfo': (context) => const HotelInfo(), // Hotel info page route
        '/flightDetailInfo':
            (context) => const FlightDetailInfo(), // Flight detail info route
        '/payment': (context) => const PaymentPage(), // Payment page route
        '/bookingHistory':
            (context) =>
                const BookingHistoryPage(), // Booking history page route
      },
      theme: ThemeData(primarySwatch: Colors.blue),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      home: const App(),
    );
  }
}
