import 'package:flutter/material.dart';

class FlightDetailInfo extends StatefulWidget {
  const FlightDetailInfo({super.key});

  @override
  State<FlightDetailInfo> createState() => _FlightDetailInfoState();
}

class _FlightDetailInfoState extends State<FlightDetailInfo> {
  String _selectedPriceOption = 'basic'; // 'basic', 'baggage', 'flexible'

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final flightNumber = args?['flightNumber'] ?? 'Unknown Flight';
    final from = args?['from'] ?? 'Unknown';
    final to = args?['to'] ?? 'Unknown';
    final departureTime = args?['departureTime'] ?? 'Unknown';
    final arrivalTime = args?['arrivalTime'] ?? 'Unknown';
    final price = args?['price'] ?? '\$0';
    final airline = args?['airline'] ?? 'Unknown Airline';
    final date = args?['date'] ?? '';

    // 根据航空公司名称获取对应的图标路径
    String getAirlineIcon(String airlineName) {
      switch (airlineName.toLowerCase()) {
        case 'airasia':
          return 'assets/images/airline/airasia-logo-tail.png';
        case 'cathay pacific':
          return 'assets/images/airline/cathay-pacific-logo-tail.png';
        case 'jetstar':
          return 'assets/images/airline/jetstar-logo-tail.png';
        case 'japan airlines':
          return 'assets/images/airline/japan-airlines-logo-tail.png';
        case 'singapore airlines':
          return 'assets/images/airline/singapore-airlines-logo-tail.png';
        case 'air india':
          return 'assets/images/airline/air-india-logo-tail.png';
        default:
          return 'assets/images/airline/airasia-logo-tail.png'; // 默认图标
      }
    }

    // 计算选择的价格
    String getSelectedPrice(String basePrice) {
      int basePriceValue = int.parse(basePrice.replaceAll('\$', ''));
      switch (_selectedPriceOption) {
        case 'baggage':
          return '\$${basePriceValue + 50}';
        case 'flexible':
          return '\$${basePriceValue + 100}';
        default:
          return basePrice;
      }
    }

    // 计算静态价格（用于显示各选项的固定价格）
    String getStaticPrice(String basePrice, String option) {
      int basePriceValue = int.parse(basePrice.replaceAll('\$', ''));
      switch (option) {
        case 'baggage':
          return '\$${basePriceValue + 50}';
        case 'flexible':
          return '\$${basePriceValue + 100}';
        default:
          return basePrice;
      }
    }

    // 获取选项描述
    String getPriceOptionDescription() {
      switch (_selectedPriceOption) {
        case 'basic':
          return 'Basic fare';
        case 'baggage':
          return 'Includes extra 20kg checked baggage';
        case 'flexible':
          return 'Change flight date free of charge';
        default:
          return '';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          flightNumber,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 航班基本信息卡片
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              // 航空公司图标
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.asset(
                                  getAirlineIcon(airline),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      flightNumber,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    Text(
                                      airline,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    if (date.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Text(
                        'Date: $date',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // 航班路线信息
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flight Route',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Departure',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                from,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                departureTime,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.flight_takeoff,
                          color: Colors.blueAccent,
                          size: 30,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '→',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(
                          Icons.flight_land,
                          color: Colors.blueAccent,
                          size: 30,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Arrival',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                to,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                arrivalTime,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // 航班服务信息
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flight Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.wifi, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Free WiFi'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.restaurant, color: Colors.green),
                        SizedBox(width: 8),
                        Text('In-flight Meals'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.tv, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Entertainment System'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.luggage, color: Colors.green),
                        SizedBox(width: 8),
                        Text('23kg Baggage Allowance'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // 价格选择选项
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Your Fare',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // 基础价格选项
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedPriceOption == 'basic' ? Colors.blueAccent : Colors.grey[300]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RadioListTile<String>(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Basic Fare',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Baisic fare with no extras',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              price,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        value: 'basic',
                        groupValue: _selectedPriceOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedPriceOption = value!;
                          });
                        },
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    // 行李额度选项
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedPriceOption == 'baggage' ? Colors.blueAccent : Colors.grey[300]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RadioListTile<String>(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Baggage Included',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'extra 20kg baggage',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              getStaticPrice(price, 'baggage'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        value: 'baggage',
                        groupValue: _selectedPriceOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedPriceOption = value!;
                          });
                        },
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    // 灵活改签选项
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedPriceOption == 'flexible' ? Colors.blueAccent : Colors.grey[300]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RadioListTile<String>(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Flexible Fare',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'reschedule free of charge',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              getStaticPrice(price, 'flexible'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        value: 'flexible',
                        groupValue: _selectedPriceOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedPriceOption = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // 预订按钮
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/payment',
                    arguments: {
                      'flightNumber': flightNumber,
                      'price': getSelectedPrice(price),
                      'originalPrice': price,
                      'airline': airline,
                      'from': from,
                      'to': to,
                      'date': date,
                      'fareType': _selectedPriceOption,
                      'fareDescription': getPriceOptionDescription(),
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Book Flight - ${getSelectedPrice(price)}',
                  style: TextStyle(
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
    );
  }
}
