import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HotelDetails extends StatelessWidget {
  const HotelDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final location = args?['location'] ?? 'Unknown';
    final checkIn = args?['checkIn'] != null
        ? DateTime.parse(args!['checkIn']).toString().split(' ')[0]
        : 'N/A';
    final checkOut = args?['checkOut'] != null
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
              style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              '$checkIn ~ $checkOut',
              style: GoogleFonts.ubuntu(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),      
      

        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
        
            SizedBox(height: 24),
            Text(
              'Recommended Hotels',
              style: GoogleFonts.ubuntu(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
        
            // 酒店1
            Card(
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
                      style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
        
            // 酒店2
            Card(
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
                      style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),

                     // 酒店3
            Card(
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
                      style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 20),
                    ),
                  ),
                  
          

                ],
            ),
            ),
            
            // 酒店4
            Card(
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
                      style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 20),
                    ),
                  ),
                ],
            ),
            ),
        
            // 你可以继续添加更多酒店Card
            Card(
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
                      style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),

            // 酒店6
            Card(
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
                      style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
   
          ],

          
        ),
        

        
        // ...existing code...
    );
    
  }
}