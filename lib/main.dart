import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:travel_app/Book/flightDetails.dart';
import 'package:travel_app/Book/hotelDetails.dart';
import 'package:travel_app/Map/map_page.dart';
import 'package:travel_app/app.dart';

// editing here
void main() {
  // debugPaintSizeEnabled = true;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/flightDetails': (context) => const Flightdetails(), // 注册路由
        '/hotelDetails': (context) => const HotelDetails(), // 假设你有一个酒店详情页
      },
      home: App(),
    ),
  );
}
