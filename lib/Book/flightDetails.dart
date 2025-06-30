import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Flightdetails extends StatelessWidget {
  const Flightdetails({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取传递的参数
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    final from = args?['from'] ?? 'Unknown Departure';
    final to = args?['to'] ?? 'Unknown Destination';
    final date = args?['date'] ?? '';

    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // 修改为center实现居中
          children: [
            Text('$from → $to', style: GoogleFonts.ubuntu(color: Colors.black)),
            if (date.isNotEmpty)
              Text(
                'Departure $date',
                style: GoogleFonts.ubuntu(color: Colors.white70, fontSize: 14),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // 动态生成航班信息
          Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: Image.asset(
                'assets/images/airline/airasia-logo-tail.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text('Flight: CA1234'),
              subtitle: Text('$from → $to\nDeparture: 08:00\nArrival: 10:30'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$320', // 每个航班可自定义价格
                    style: GoogleFonts.ubuntu(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/flightDetailInfo',
                  arguments: {
                    'flightNumber': 'CA1234',
                    'from': from,
                    'to': to,
                    'departureTime': '08:00',
                    'arrivalTime': '10:30',
                    'price': '\$320',
                    'airline': 'AirAsia',
                    'date': date,
                  },
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: Image.asset(
                'assets/images/airline/cathay-pacific-logo-tail.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text('Flight: MU5678'),
              subtitle: Text('$from → $to\nDeparture: 12:00\nArrival: 14:45'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$320', // 每个航班可自定义价格
                    style: GoogleFonts.ubuntu(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/flightDetailInfo',
                  arguments: {
                    'flightNumber': 'MU5678',
                    'from': from,
                    'to': to,
                    'departureTime': '12:00',
                    'arrivalTime': '14:45',
                    'price': '\$350',
                    'airline': 'Cathay Pacific',
                    'date': date,
                  },
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: Image.asset(
                'assets/images/airline/jetstar-logo-tail.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text('Flight: CZ9101'),
              subtitle: Text('$from → $to\nDeparture: 16:00\nArrival: 16:50'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$320', // 每个航班可自定义价格
                    style: GoogleFonts.ubuntu(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/flightDetailInfo',
                  arguments: {
                    'flightNumber': 'CZ9101',
                    'from': from,
                    'to': to,
                    'departureTime': '16:00',
                    'arrivalTime': '16:50',
                    'price': '\$280',
                    'airline': 'Jetstar',
                    'date': date,
                  },
                );
              },
            ),
          ),
          // 更多航班信息可以继续添加
          Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: Image.asset(
                'assets/images/airline/japan-airlines-logo-tail.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text('Flight: HU2345'),
              subtitle: Text('$from → $to\nDeparture: 20:00\nArrival: 22:30'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$320', // 每个航班可自定义价格
                    style: GoogleFonts.ubuntu(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/flightDetailInfo',
                  arguments: {
                    'flightNumber': 'HU2345',
                    'from': from,
                    'to': to,
                    'departureTime': '20:00',
                    'arrivalTime': '22:30',
                    'price': '\$290',
                    'airline': 'Japan Airlines',
                    'date': date,
                  },
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: Image.asset(
                'assets/images/airline/singapore-airlines-logo-tail.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text('Flight: FM6789'),
              subtitle: Text('$from → $to\nDeparture: 23:00\nArrival: 01:30'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$320', // 每个航班可自定义价格
                    style: GoogleFonts.ubuntu(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/flightDetailInfo',
                  arguments: {
                    'flightNumber': 'FM6789',
                    'from': from,
                    'to': to,
                    'departureTime': '23:00',
                    'arrivalTime': '01:30',
                    'price': '\$380',
                    'airline': 'Singapore Airlines',
                    'date': date,
                  },
                );
              },
            ),
          ),
          // 其他航班信息
          Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: Image.asset(
                'assets/images/airline/airasia-logo-tail.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text('Flight: CA1234'),
              subtitle: Text('$from → $to\nDeparture: 08:00\nArrival: 10:30'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$320', // 每个航班可自定义价格
                    style: GoogleFonts.ubuntu(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/flightDetailInfo',
                  arguments: {
                    'flightNumber': 'CA1234',
                    'from': from,
                    'to': to,
                    'departureTime': '08:00',
                    'arrivalTime': '10:30',
                    'price': '\$320',
                    'airline': 'AirAsia',
                    'date': date,
                  },
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: Image.asset(
                'assets/images/airline/cathay-pacific-logo-tail.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text('Flight: MU5678'),
              subtitle: Text('$from → $to\nDeparture: 12:00\nArrival: 14:45'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$350', // 每个航班可自定义价格
                    style: GoogleFonts.ubuntu(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/flightDetailInfo',
                  arguments: {
                    'flightNumber': 'MU5678',
                    'from': from,
                    'to': to,
                    'departureTime': '12:00',
                    'arrivalTime': '14:45',
                    'price': '\$350',
                    'airline': 'Cathay Pacific',
                    'date': date,
                  },
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: Image.asset(
                'assets/images/airline/air-india-logo-tail.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text('Flight: CZ9101'),
              subtitle: Text('$from → $to\nDeparture: 16:00\nArrival: 16:50'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$280', // 每个航班可自定义价格
                    style: GoogleFonts.ubuntu(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/flightDetailInfo',
                  arguments: {
                    'flightNumber': 'CZ9101',
                    'from': from,
                    'to': to,
                    'departureTime': '16:00',
                    'arrivalTime': '16:50',
                    'price': '\$280',
                    'airline': 'Air India',
                    'date': date,
                  },
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: Image.asset(
                'assets/images/airline/japan-airlines-logo-tail.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text('Flight: HU2345'),
              subtitle: Text('$from → $to\nDeparture: 20:00\nArrival: 22:30'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$290', // 每个航班可自定义价格
                    style: GoogleFonts.ubuntu(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/flightDetailInfo',
                  arguments: {
                    'flightNumber': 'HU2345',
                    'from': from,
                    'to': to,
                    'departureTime': '20:00',
                    'arrivalTime': '22:30',
                    'price': '\$290',
                    'airline': 'Japan Airlines',
                    'date': date,
                  },
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: Image.asset(
                'assets/images/airline/japan-airlines-logo-tail.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text('Flight: FM6789'),
              subtitle: Text('$from → $to\nDeparture: 23:00\nArrival: 01:30'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$380', // 每个航班可自定义价格
                    style: GoogleFonts.ubuntu(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/flightDetailInfo',
                  arguments: {
                    'flightNumber': 'FM6789',
                    'from': from,
                    'to': to,
                    'departureTime': '23:00',
                    'arrivalTime': '01:30',
                    'price': '\$380',
                    'airline': 'Japan Airlines',
                    'date': date,
                  },
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: Image.asset(
                'assets/images/airline/cathay-pacific-logo-tail.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text('Flight: CA1234'),
              subtitle: Text('$from → $to\nDeparture: 08:00\nArrival: 10:30'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$320', // 每个航班可自定义价格
                    style: GoogleFonts.ubuntu(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/flightDetailInfo',
                  arguments: {
                    'flightNumber': 'CA1234',
                    'from': from,
                    'to': to,
                    'departureTime': '08:00',
                    'arrivalTime': '10:30',
                    'price': '\$320',
                    'airline': 'Cathay Pacific',
                    'date': date,
                  },
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: Image.asset(
                'assets/images/airline/cathay-pacific-logo-tail.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text('Flight: MU5678'),
              subtitle: Text('$from → $to\nDeparture: 12:00\nArrival: 14:45'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$320', // 每个航班可自定义价格
                    style: GoogleFonts.ubuntu(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/flightDetailInfo',
                  arguments: {
                    'flightNumber': 'MU5678',
                    'from': from,
                    'to': to,
                    'departureTime': '12:00',
                    'arrivalTime': '14:45',
                    'price': '\$350',
                    'airline': 'Cathay Pacific',
                    'date': date,
                  },
                );
              },
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

// llll
