// For testing purpose only
import 'package:flutter/material.dart';

class BookingFlight extends StatelessWidget
{
  const BookingFlight({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Flight',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      body: Center(
        child: Text(
          'Booking Flight Page',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black
          ),
        ),
      ),








    );
  }
}

// llll