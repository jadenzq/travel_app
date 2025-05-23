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

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.flight_takeoff, color: Colors.blueAccent),
              title: Text('Flight: CA1234'),
              subtitle: Text('Beijing → Shanghai\nDeparture: 08:00\nArrival:10:30'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.flight_takeoff, color: Colors.blueAccent),
              title: Text('Flight:MU5678'),
              subtitle: Text('Xiamen → Kuala Lumpur\nDeparture:12:00\nArrival:14:45'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.flight_takeoff, color: Colors.blueAccent),
              title: Text('Flight: CZ9101'),
              subtitle: Text('Kuala Lumpur → Kota Kinabalu\nDeparture：16:00\nArrival：16:50'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}

// llll