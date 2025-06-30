import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HotelInfo extends StatefulWidget {
  const HotelInfo({super.key});

  @override
  State<HotelInfo> createState() => _HotelInfoState();
}

class _HotelInfoState extends State<HotelInfo> {
  String selectedRoomType = 'Standard';

  // 房间类型数据
  final List<Map<String, dynamic>> roomTypes = [
    {
      'type': 'Standard',
      'price': 150,
      'description': 'Comfortable room with basic amenities',
      'features': ['Free WiFi', 'Air Conditioning', 'Private Bathroom', 'TV'],
      'image': 'assets/images/hotels/room1.jpg',
    },
    {
      'type': 'Deluxe',
      'price': 220,
      'description': 'Spacious room with premium amenities',
      'features': [
        'Free WiFi',
        'Air Conditioning',
        'Private Bathroom',
        'TV',
        'Mini Bar',
        'City View',
      ],
      'image': 'assets/images/hotels/room2.jpg',
    },
    {
      'type': 'Suite',
      'price': 350,
      'description': 'Luxury suite with separate living area',
      'features': [
        'Free WiFi',
        'Air Conditioning',
        'Private Bathroom',
        'TV',
        'Mini Bar',
        'Ocean View',
        'Balcony',
        'Room Service',
      ],
      'image': 'assets/images/hotels/room3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final hotelName = args?['hotelName'] ?? 'Hotel';
    final hotelRating = args?['rating'] ?? '4.0';
    final hotelImage = args?['image'] ?? 'assets/images/hotels/hotel1.jpg';
    final location = args?['location'] ?? 'Unknown';
    final checkInStr = args?['checkIn'] as String?;
    final checkOutStr = args?['checkOut'] as String?;

    // 解析日期并计算停留天数
    DateTime? checkInDate;
    DateTime? checkOutDate;
    int stayDuration = 1; // 默认1晚

    if (checkInStr != null && checkOutStr != null) {
      try {
        checkInDate = DateTime.parse(checkInStr);
        checkOutDate = DateTime.parse(checkOutStr);
        stayDuration = checkOutDate.difference(checkInDate).inDays;
        if (stayDuration <= 0) stayDuration = 1; // 确保至少1晚
      } catch (e) {
        // 日期解析失败，使用默认值
        stayDuration = 1;
      }
    }

    final selectedRoom = roomTypes.firstWhere(
      (room) => room['type'] == selectedRoomType,
    );
    final roomPricePerNight = selectedRoom['price'] as int;
    final totalPrice = roomPricePerNight * stayDuration;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          hotelName,
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 酒店图片
            Container(
              height: 250,
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
                child: Image.asset(hotelImage, fit: BoxFit.cover),
              ),
            ),

            // 主要内容
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
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 酒店信息
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hotelName,
                                style: GoogleFonts.ubuntu(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                location,
                                style: GoogleFonts.ubuntu(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              SizedBox(width: 4),
                              Text(
                                hotelRating,
                                style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // 房间类型选择标题
                    Text(
                      'Select Room Type',
                      style: GoogleFonts.ubuntu(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 16),

                    // 房间类型选择
                    Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: roomTypes.length,
                        itemBuilder: (context, index) {
                          final roomType = roomTypes[index]['type'];
                          final isSelected = roomType == selectedRoomType;

                          return Container(
                            margin: EdgeInsets.only(right: 12),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedRoomType = roomType;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isSelected
                                        ? Colors.blueAccent
                                        : Colors.grey[200],
                                foregroundColor:
                                    isSelected
                                        ? Colors.white
                                        : Colors.grey[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                roomType,
                                style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 24),

                    // 选中房间详情
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[50]!, Colors.blue[100]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${selectedRoom['type']} Room',
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '\$${selectedRoom['price']}/night',
                                    style: GoogleFonts.ubuntu(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              selectedRoom['description'],
                              style: GoogleFonts.ubuntu(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Room Features:',
                              style: GoogleFonts.ubuntu(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  selectedRoom['features'].map<Widget>((
                                    feature,
                                  ) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.blueAccent.withOpacity(
                                            0.3,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        feature,
                                        style: GoogleFonts.ubuntu(
                                          fontSize: 12,
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),

                            // 入住信息和价格计算
                            if (checkInDate != null &&
                                checkOutDate != null) ...[
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.green.withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Check-in:',
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          checkInDate
                                              .toLocal()
                                              .toString()
                                              .split(' ')[0],
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Check-out:',
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          checkOutDate
                                              .toLocal()
                                              .toString()
                                              .split(' ')[0],
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Stay Duration:',
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          '$stayDuration night${stayDuration > 1 ? 's' : ''}',
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Price:',
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '\$${roomPricePerNight} × $stayDuration night${stayDuration > 1 ? 's' : ''}',
                                              style: GoogleFonts.ubuntu(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              '\$$totalPrice',
                                              style: GoogleFonts.ubuntu(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    // 预订按钮
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
                          // 跳转到支付页面，传递酒店订单参数
                          Navigator.pushNamed(
                            context,
                            '/payment',
                            arguments: {
                              'orderType': 'hotel',
                              'hotelName': hotelName,
                              'location': location,
                              'roomType': selectedRoom['type'],
                              'roomDescription': selectedRoom['description'],
                              'price': '\$${totalPrice}', // 使用计算后的总价格
                              'pricePerNight': '\$${roomPricePerNight}', // 每晚价格
                              'stayDuration': stayDuration, // 停留天数
                              'checkInDate':
                                  checkInDate?.toLocal().toString().split(
                                    ' ',
                                  )[0] ??
                                  'Unknown',
                              'checkOutDate':
                                  checkOutDate?.toLocal().toString().split(
                                    ' ',
                                  )[0] ??
                                  'Unknown',
                              'rating': hotelRating,
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.hotel, color: Colors.white, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'Book ${selectedRoom['type']} Room - \$${totalPrice}',
                              style: GoogleFonts.ubuntu(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
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
    );
  }
}
