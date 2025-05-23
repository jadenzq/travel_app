// For testing purpose only
import 'package:flutter/material.dart';

class BookingHotel extends StatelessWidget
{
  const BookingHotel({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Hotel',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.blueAccent
      )
    );
  }
}

// llll