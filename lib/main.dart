import 'package:flutter/material.dart';
import 'package:travel_app/Book/flightDetails.dart';
import 'package:travel_app/Book/hotelDetails.dart';
import 'package:travel_app/app.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// editing here
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: App(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      routes: {
        '/flightDetails': (context) => const Flightdetails(),
        '/hotelDetails': (context) => const HotelDetails(),
      },
    ),
  );
}
