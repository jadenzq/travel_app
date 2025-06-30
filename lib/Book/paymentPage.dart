import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../Models/booking_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // 倒计时相关
  late Timer _timer;
  int _remainingSeconds = 600; // 10分钟 = 600秒

  // 支付方式选择
  String _selectedPaymentMethod = 'card'; // 'card' 或 'ewallet'

  // 银行卡信息控制器
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  // 电子钱包选择
  String _selectedEWallet = 'tng';

  double _notificationOpacity = 0.0;
  String _notificationMessage = '';
  Timer? _notificationTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvcController.dispose();
    _cardHolderController.dispose();
    _notificationTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        _showTimeoutDialog();
      }
    });
  }

  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Timeout'),
          content: Text('Payment session has expired. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _processPayment() async {
    // 获取订单参数以确定订单类型
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final orderType = args?['orderType'] ?? 'flight';
    final hotelName = args?['hotelName'] ?? 'Unknown Hotel';
    final roomType = args?['roomType'] ?? 'Standard';

    // 验证输入
    if (_selectedPaymentMethod == 'card') {
      if (_cardNumberController.text.isEmpty ||
          _expiryDateController.text.isEmpty ||
          _cvcController.text.isEmpty ||
          _cardHolderController.text.isEmpty) {
        _showCustomNotification('Please fill all card details');
        return;
      }
    }

    // 获取预订服务实例
    final bookingService = BookingService();

    // 预定义消息
    String successMessage = 'Your booking has been confirmed successfully!';
    String successTitle = 'Payment Successful';

    try {
      if (orderType == 'hotel') {
        successMessage =
            'Your $roomType room at $hotelName has been booked successfully!';

        // 保存酒店预订记录
        final hotelBooking = BookingService.createHotelBooking(
          hotelName: hotelName,
          location: args?['location'] ?? 'Unknown Location',
          roomType: roomType,
          price: args?['price'] ?? '\$0',
          checkInDate: DateTime.parse(
            args?['checkInDate'] ?? DateTime.now().toIso8601String(),
          ),
          checkOutDate: DateTime.parse(
            args?['checkOutDate'] ??
                DateTime.now().add(Duration(days: 1)).toIso8601String(),
          ),
          stayDuration: args?['stayDuration'] ?? 1,
          rating: args?['rating'],
        );
        await bookingService.addBooking(hotelBooking);
      } else {
        successMessage = 'Your flight has been booked successfully!';

        // 保存航班预订记录
        final flightBooking = BookingService.createFlightBooking(
          flightNumber: args?['flightNumber'] ?? 'Unknown',
          airline: args?['airline'] ?? 'Unknown Airline',
          price: args?['price'] ?? '\$0',
          departureDate: DateTime.parse(
            args?['departureDate'] ?? DateTime.now().toIso8601String(),
          ),
          departureTime: args?['departureTime'],
          arrivalTime: args?['arrivalTime'],
          from: args?['from'],
          to: args?['to'],
        );
        await bookingService.addBooking(flightBooking);
      }
    } catch (e) {
      print('Error saving booking: $e');
      // 即使保存失败，也继续显示成功消息
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text(successTitle),
            ],
          ),
          content: Text(successMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
                // 返回到主页面
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // 通用参数
    final orderType = args?['orderType'] ?? 'flight'; // 'flight' 或 'hotel'
    final price = args?['price'] ?? '\$0';

    // 航班相关参数
    final flightNumber = args?['flightNumber'] ?? 'Unknown Flight';
    final airline = args?['airline'] ?? 'Unknown Airline';

    // 酒店相关参数
    final hotelName = args?['hotelName'] ?? 'Unknown Hotel';
    final pricePerNight = args?['pricePerNight'] ?? '\$0';
    final stayDuration = args?['stayDuration'] ?? 1;
    final checkInDate = args?['checkInDate'] ?? 'Unknown';
    final checkOutDate = args?['checkOutDate'] ?? 'Unknown';

    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Payment', style: GoogleFonts.ubuntu(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 倒计时卡片
                  Card(
                    elevation: 4,
                    color:
                        _remainingSeconds <= 60
                            ? Colors.red[50]
                            : Colors.orange[50],
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer,
                            color:
                                _remainingSeconds <= 60
                                    ? Colors.red
                                    : Colors.orange,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Payment expires in: ${_formatTime(_remainingSeconds)}',
                            style: GoogleFonts.ubuntu(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  _remainingSeconds <= 60
                                      ? Colors.red
                                      : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // 订单信息
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Summary',
                            style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(),

                          // 根据订单类型显示不同内容
                          if (orderType == 'flight') ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Flight: $flightNumber'),
                                Text(airline),
                              ],
                            ),
                            SizedBox(height: 8),
                          ] else if (orderType == 'hotel') ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Hotel:'),
                                Flexible(
                                  child: Text(
                                    hotelName,
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Check-in Date:'),
                                Text(
                                  checkInDate,
                                  style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Check-out Date:'),
                                Text(
                                  checkOutDate,
                                  style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Stay Duration:'),
                                Text(
                                  '$stayDuration night${stayDuration > 1 ? 's' : ''}',
                                  style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Price per Night:'),
                                Text(
                                  pricePerNight,
                                  style: GoogleFonts.ubuntu(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount:',
                                style: GoogleFonts.ubuntu(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                price,
                                style: GoogleFonts.ubuntu(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // 支付方式选择
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Method',
                            style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),

                          // 银行卡选项
                          RadioListTile<String>(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.credit_card,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(width: 8),
                                Text('Bank Card'),
                              ],
                            ),
                            value: 'card',
                            groupValue: _selectedPaymentMethod,
                            onChanged: (value) {
                              setState(() {
                                _selectedPaymentMethod = value!;
                              });
                            },
                          ),

                          // 电子钱包选项
                          RadioListTile<String>(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 8),
                                Text('E-Wallet'),
                              ],
                            ),
                            value: 'ewallet',
                            groupValue: _selectedPaymentMethod,
                            onChanged: (value) {
                              setState(() {
                                _selectedPaymentMethod = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // 支付详情
                  if (_selectedPaymentMethod == 'card') ...[
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 标题和卡组织图片并列
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Card Information',
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // 卡组织图片
                                Container(
                                  height: 50,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/Card.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            // 卡号
                            TextField(
                              controller: _cardNumberController,
                              decoration: InputDecoration(
                                labelText: 'Card Number',
                                hintText: '1234 5678 9012 3456',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.credit_card),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 16),

                            // 持卡人姓名
                            TextField(
                              controller: _cardHolderController,
                              decoration: InputDecoration(
                                labelText: 'Cardholder Name',
                                hintText: 'John Doe',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(height: 16),

                            Row(
                              children: [
                                // 过期日期
                                Expanded(
                                  child: TextField(
                                    controller: _expiryDateController,
                                    decoration: InputDecoration(
                                      labelText: 'Expiry Date',
                                      hintText: 'MM/YY',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.calendar_today),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                // CVC
                                Expanded(
                                  child: TextField(
                                    controller: _cvcController,
                                    decoration: InputDecoration(
                                      labelText: 'CVC',
                                      hintText: '123',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.lock),
                                    ),
                                    keyboardType: TextInputType.number,
                                    obscureText: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select E-Wallet',
                              style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),

                            // Touch n Go
                            RadioListTile<String>(
                              title: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Image.asset(
                                      'assets/images/TNG.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Touch n Go'),
                                ],
                              ),
                              value: 'tng',
                              groupValue: _selectedEWallet,
                              onChanged: (value) {
                                setState(() {
                                  _selectedEWallet = value!;
                                });
                              },
                            ),

                            // 支付宝
                            RadioListTile<String>(
                              title: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Image.asset(
                                      'assets/images/Alipay.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Alipay'),
                                ],
                              ),
                              value: 'alipay',
                              groupValue: _selectedEWallet,
                              onChanged: (value) {
                                setState(() {
                                  _selectedEWallet = value!;
                                });
                              },
                            ),

                            // PayPal
                            RadioListTile<String>(
                              title: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[800],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'P',
                                        style: GoogleFonts.ubuntu(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('PayPal'),
                                ],
                              ),
                              value: 'paypal',
                              groupValue: _selectedEWallet,
                              onChanged: (value) {
                                setState(() {
                                  _selectedEWallet = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 24),

                  // 支付按钮
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _remainingSeconds > 0 ? _processPayment : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _remainingSeconds > 0
                                ? Colors.blueAccent
                                : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _remainingSeconds > 0
                            ? 'Pay Now $price'
                            : 'Payment Expired',
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
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
