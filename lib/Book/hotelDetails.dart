import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HotelDetails extends StatelessWidget {
  const HotelDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final location = args?['location'] ?? 'Unknown';
    final checkIn =
        args?['checkIn'] != null
            ? DateTime.parse(args!['checkIn']).toString().split(' ')[0]
            : 'N/A';
    final checkOut =
        args?['checkOut'] != null
            ? DateTime.parse(args!['checkOut']).toString().split(' ')[0]
            : 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              location,
              style: TextStyle(color: Colors.black, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              '$checkIn ~ $checkOut',
              style: TextStyle(color: Colors.black45, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 24),
          Text(
            'Recommended Hotels',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),

          // 酒店1
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,

                '/hotelInfo',
                arguments: {
                  'hotelName': 'Santorini Blue Hotel',
                  'rating': '4.5',
                  'image': 'assets/images/hotels/hotel1.jpg',
                  'location': location,
                  'checkIn': checkIn,
                  'checkOut': checkOut,
                },
              );
            },
            child: Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/images/hotels/hotel1.jpg', // 请确保图片已添加到assets
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                    title: Text('Santorini Blue Hotel'),
                    subtitle: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star_half, color: Colors.amber, size: 18),
                        SizedBox(width: 8),
                        Text('4.5'),
                      ],
                    ),
                    trailing: Text(
                      '\$220',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 酒店2
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/hotelInfo',
                arguments: {
                  'hotelName': 'Aegean Sea Resort',
                  'rating': '5.0',
                  'image': 'assets/images/hotels/hotel2.jpg',
                  'location': location,
                  'checkIn': checkIn,
                  'checkOut': checkOut,
                },
              );
            },
            child: Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/images/hotels/hotel2.jpg',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                    title: Text('Aegean Sea Resort'),
                    subtitle: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 8),
                        Text('5.0'),
                      ],
                    ),

                    trailing: Text(
                      '\$350',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 酒店3
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/hotelInfo',
                arguments: {
                  'hotelName': 'Ocean View Paradise',
                  'rating': '4.0',
                  'image': 'assets/images/hotels/hotel3.jpg',
                  'location': location,
                  'checkIn': checkIn,
                  'checkOut': checkOut,
                },
              );
            },
            child: Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/images/hotels/hotel3.jpg',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                    title: Text('Ocean View Paradise'),
                    subtitle: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star_half, color: Colors.amber, size: 18),
                        Icon(Icons.star_border, color: Colors.amber, size: 18),
                        SizedBox(width: 8),
                        Text('4.0'),
                      ],
                    ),
                    trailing: Text(
                      '\$180',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 酒店4
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/hotelInfo',
                arguments: {
                  'hotelName': 'Luxury Beachfront Hotel',
                  'rating': '4.5',
                  'image': 'assets/images/hotels/hotel4.jpg',
                  'location': location,
                  'checkIn': checkIn,
                  'checkOut': checkOut,
                },
              );
            },
            child: Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/images/hotels/hotel4.jpg',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                    title: Text('Luxury Beachfront Hotel'),
                    subtitle: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star_half, color: Colors.amber, size: 18),
                        SizedBox(width: 8),
                        Text('4.5'),
                      ],
                    ),
                    trailing: Text(
                      '\$300',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 酒店5
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/hotelInfo',
                arguments: {
                  'hotelName': 'Island Breeze Hotel',
                  'rating': '4.0',
                  'image': 'assets/images/hotels/hotel5.jpg',
                  'location': location,
                  'checkIn': checkIn,
                  'checkOut': checkOut,
                },
              );
            },
            child: Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/images/hotels/hotel5.jpg',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                    title: Text('Island Breeze Hotel'),
                    subtitle: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star_half, color: Colors.amber, size: 18),
                        Icon(Icons.star_border, color: Colors.amber, size: 18),
                        SizedBox(width: 8),
                        Text('4.0'),
                      ],
                    ),
                    trailing: Text(
                      '\$200',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 酒店6
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/hotelInfo',
                arguments: {
                  'hotelName': 'Sunset Paradise Hotel',
                  'rating': '4.0',
                  'image': 'assets/images/hotels/hotel6.jpg',
                  'location': location,
                  'checkIn': checkIn,
                  'checkOut': checkOut,
                },
              );
            },
            child: Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/images/hotels/hotel6.jpg',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                    title: Text('Sunset Paradise Hotel'),
                    subtitle: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star_half, color: Colors.amber, size: 18),
                        Icon(Icons.star_border, color: Colors.amber, size: 18),
                        SizedBox(width: 8),
                        Text('4.0'),
                      ],
                    ),
                    trailing: Text(
                      '\$250',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ...existing code...
    );
  }
}
