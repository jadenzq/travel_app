// For testing purpose only
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingHotel extends StatefulWidget {
  const BookingHotel({super.key});

  @override
  State<BookingHotel> createState() => _BookingHotelState();
}

class _BookingHotelState extends State<BookingHotel> {
  final TextEditingController locationController = TextEditingController();
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int guests = 1;

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Hotel', style: GoogleFonts.ubuntu(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 顶部图片（无Padding，紧贴边缘）
            ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Image.asset(
                'assets/images/Hotel.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // 其余内容加Padding
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),

                  // 标题
                  Text(
                    'Find the Most Comfortable Hotel for Your Trip!',
                    style: GoogleFonts.ubuntu(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  // 输入框
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Check-in
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          checkInDate == null
                              ? 'Select Check-in Date'
                              : 'Check-in: ${checkInDate!.toLocal().toString().split(' ')[0]}',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              checkInDate = picked;
                              if (checkOutDate != null &&
                                  checkOutDate!.isBefore(checkInDate!)) {
                                checkOutDate = null;
                              }
                            });
                          }
                        },
                        child: Text('Choose'),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Check-out
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          checkOutDate == null
                              ? 'Select Check-out Date'
                              : 'Check-out: ${checkOutDate!.toLocal().toString().split(' ')[0]}',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: checkInDate ?? DateTime.now(),
                            firstDate: checkInDate ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              checkOutDate = picked;
                            });
                          }
                        },
                        child: Text('Choose'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Guests
                  Row(
                    children: [
                      Text('Guests:', style: GoogleFonts.ubuntu(fontSize: 16)),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed:
                            guests > 1 ? () => setState(() => guests--) : null,
                      ),
                      Text('$guests', style: GoogleFonts.ubuntu(fontSize: 16)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => setState(() => guests++),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (locationController.text.isNotEmpty &&
                          checkInDate != null &&
                          checkOutDate != null) {
                        Navigator.pushNamed(
                          context,
                          '/hotelDetails',
                          arguments: {
                            'location': locationController.text,
                            'checkIn': checkInDate?.toIso8601String(),
                            'checkOut': checkOutDate?.toIso8601String(),
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields')),
                        );
                      }
                    },
                    child: Text(
                      'Search',
                      style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
