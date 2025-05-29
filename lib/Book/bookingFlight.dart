import 'package:flutter/material.dart';

class BookingFlight extends StatefulWidget {
  const BookingFlight({super.key});

  @override
  State<BookingFlight> createState() => _BookingFlightState();
}

class _BookingFlightState extends State<BookingFlight> {
  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  DateTime? selectedDate;
  DateTime? returnDate;
  String tripType = 'One-way'; // 新增变量
  String seatClass = 'Economy'; // 新增变量

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Flight',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 顶部图片
            ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Image.asset(
                'assets/images/santorini-church.jpg', // 确保将图片放在此路径下
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 标题
                  Text(
                    'Book Flight For Your Next Trip!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),



                  // 下拉框
                  DropdownButton<String>(
                    value: tripType,
                    items: [
                      DropdownMenuItem(value: 'One-way', child: Text('One-way')),
                      DropdownMenuItem(value: 'Round trip', child: Text('Round trip')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        tripType = value!;
                        selectedDate = null;
                        returnDate = null;
                      });
                    },
                  ),
                  
                  SizedBox(height: 16),
                  Row(
                    children: [
                      // Departure 普通输入框
                      Expanded(
                        child: TextField(
                          controller: departureController,
                          decoration: InputDecoration(
                            labelText: 'From',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      // 交换按钮
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.autorenew,
                            color: Colors.white,
                          ),
                          tooltip: '交换出发地和目的地',
                          onPressed: () {
                            String temp = departureController.text;
                            departureController.text = destinationController.text;
                            destinationController.text = temp;
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      // Destination 普通输入框
                      Expanded(
                        child: TextField(
                          controller: destinationController,
                          decoration: InputDecoration(
                            labelText: 'To',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey[300]), // 分界线
                  SizedBox(height: 16),
                  // 出发日期
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? 'Select Departure Date'
                              : 'Departure: ${selectedDate!.toLocal().toString().split(' ')[0]}',
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
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Text('Choose Departure'),
                      ),
                    ],
                  ),
                  if (tripType == 'Round trip') ...[
                    Divider(color: Colors.grey[300]), // 分界线
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            returnDate == null
                                ? 'Select Return Date'
                                : 'Return: ${returnDate!.toLocal().toString().split(' ')[0]}',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: selectedDate ?? DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                returnDate = picked;
                              });
                            }
                          },
                          child: Text('Choose Return'),
                        ),
                      ],
                    ),
                  ],
                  Divider(color: Colors.grey[300]), // 分界线
                  SizedBox(height: 16),

                  // 舱位选择按钮
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: IntrinsicWidth(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Economy
                            SizedBox(
                              width: 90,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    seatClass = 'Economy';
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: seatClass == 'Economy' ? Colors.blueAccent : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Economy',
                                      style: TextStyle(
                                        color: seatClass == 'Economy' ? Colors.white : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Business
                            SizedBox(
                              width: 90,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    seatClass = 'Business';
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: seatClass == 'Business' ? Colors.blueAccent : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Business',
                                      style: TextStyle(
                                        color: seatClass == 'Business' ? Colors.white : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      bool isValid = departureController.text.isNotEmpty && destinationController.text.isNotEmpty && selectedDate != null && (tripType == 'One-way' || (tripType == 'Round trip' && returnDate != null));
                      if (isValid) {
                        Navigator.pushNamed(
                          context,
                          '/flightDetails',
                          arguments: {
                            'from': departureController.text,
                            'to': destinationController.text,
                            'date': selectedDate != null
                                ? selectedDate!.toLocal().toString().split(' ')[0]
                                : '',
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: Text('Search', style: TextStyle(fontSize: 18, color: Colors.white)),
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