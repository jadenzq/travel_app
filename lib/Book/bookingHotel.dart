import 'dart:async';

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

  double _notificationOpacity = 0.0;
  String _notificationMessage = '';
  Timer? _notificationTimer;

  // 计算停留天数
  int? get stayDuration {
    if (checkInDate != null && checkOutDate != null) {
      int days = checkOutDate!.difference(checkInDate!).inDays;
      return days > 0 ? days : null; // 确保天数大于0
    }
    return null;
  }

  // Format date display
  String _formatDate(DateTime date) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    String month = months[date.month - 1];
    String day = '${date.day}';
    String weekday = weekdays[date.weekday - 1];

    return '$month $day $weekday';
  }

  @override 
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }

  void _showCustomNotification(String message) {
    setState(() {
      _notificationMessage = message;
      _notificationOpacity = 1.0;
    });


    _notificationTimer?.cancel();
    _notificationTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _notificationOpacity = 0.0;
        });
      }
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Hotel',
          style: GoogleFonts.ubuntu(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: SizedBox.expand(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //  photo at the top, no padding
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: Image.asset(
                        'assets/images/Hotel.png',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // main content with padding
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10),
            
                          // content title
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Find the Most Comfortable Hotel for Your Trip!',
                              style: GoogleFonts.ubuntu(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 24),
            
                          // Location input
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: locationController,
                              decoration: InputDecoration(
                                labelText: 'Location',
                                labelStyle: GoogleFonts.ubuntu(color: Colors.blueAccent),
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Colors.blueAccent,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.blueAccent,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.blue[50],
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
            
                          // 日期选择区域 - 放在同一行
                          Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue[50]!, Colors.blue[100]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Check-in 部分
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
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
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              checkInDate != null
                                                  ? Colors.blueAccent
                                                  : Colors.grey[300]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                color: Colors.blueAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                'Check-in',
                                                style: GoogleFonts.ubuntu(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            checkInDate == null
                                                ? 'Select Date'
                                                : _formatDate(checkInDate!),
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  checkInDate == null
                                                      ? Colors.grey[500]
                                                      : Colors.blueAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
            
                                SizedBox(width: 12),
            
                                // 分隔符
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.grey[300],
                                ),
            
                                SizedBox(width: 12),
            
                                // Check-out 部分
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            checkInDate?.add(Duration(days: 1)) ??
                                            DateTime.now().add(Duration(days: 1)),
                                        firstDate:
                                            checkInDate?.add(Duration(days: 1)) ??
                                            DateTime.now(),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          checkOutDate = picked;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              checkOutDate != null
                                                  ? Colors.blueAccent
                                                  : Colors.grey[300]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.event,
                                                color: Colors.blueAccent,
                                                size: 16,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                'Check-out',
                                                style: GoogleFonts.ubuntu(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            checkOutDate == null
                                                ? 'Select Date'
                                                : _formatDate(checkOutDate!),
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  checkOutDate == null
                                                      ? Colors.grey[500]
                                                      : Colors.blueAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
            
                          // 停留天数显示
                          if (stayDuration != null) ...[
                            Container(
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey[200]!),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.green[200]!),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.hotel, color: Colors.green, size: 20),
                                    SizedBox(width: 8),
                                    Column(
                                      children: [
                                        Text(
                                          '${stayDuration!} night${stayDuration! > 1 ? 's' : ''}',
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                        Text(
                                          'Stay Duration',
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 12,
                                            color: Colors.green[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
            
                          // 客人数量选择
                          Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey[200]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        color: Colors.blueAccent,
                                        size: 24,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Guests',
                                        style: GoogleFonts.ubuntu(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap:
                                            guests > 1
                                                ? () => setState(() => guests--)
                                                : null,
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color:
                                                guests > 1
                                                    ? Colors.blueAccent
                                                    : Colors.grey[300],
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 16),
                                        width: 40,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$guests',
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => setState(() => guests++),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
            
                          // Search Button
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blueAccent, Colors.blue[700]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
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
                                    _showCustomNotification('Please fill all fields');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search, color: Colors.white, size: 24),
                                  SizedBox(width: 12),
                                  Text(
                                    'Search Hotels',
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              bottom: _notificationOpacity > 0 ? 20 : -100,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: _notificationOpacity,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        _notificationMessage,
                        style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
