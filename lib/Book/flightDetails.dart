import 'package:flutter/material.dart';

class Flightdetails extends StatelessWidget {
  const Flightdetails({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取传递的参数
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    final from = args?['from'] ?? 'Unknown Departure';
    final to = args?['to'] ?? 'Unknown Destination';
    final date = args?['date'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // 修改为center实现居中
          children: [
        Text(
          '$from → $to',
          style: TextStyle(color: Colors.white),
        ),
        if (date.isNotEmpty)
          Text(
            'Departure $date',
            style: TextStyle(color: Colors.white70, fontSize: 14,),
          ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // 动态生成航班信息
            Card(
            child: ListTile(
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
      style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward_ios, size: 16),
  ],
),
            ),
          ),



          Card(
            child: ListTile(
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
      style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward_ios, size: 16),
  ],
),
            ),
          ),
          Card(
            child: ListTile(
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
      style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward_ios, size: 16),
  ],
),
            ),
          ),
          // 更多航班信息可以继续添加
          Card(
            child: ListTile(
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
      style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward_ios, size: 16),
  ],
),            ),
          ),
          Card(
            child: ListTile(
              leading: Image.asset('assets/images/airline/singapore-airlines-logo-tail.png', 
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
      style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward_ios, size: 16),
  ],
),            ),
          ),
          // 其他航班信息
          Card(
            child: ListTile(
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
      style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward_ios, size: 16),
  ],
),            ),
          ),
          Card(
            child: ListTile(
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
      style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward_ios, size: 16),
  ],
),            ),
          ),
          Card(
            child: ListTile(
              leading: Image.asset('assets/images/airline/air-india-logo-tail.png', 
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
      style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward_ios, size: 16),
  ],
),            ),
          ),
          Card(
            child: ListTile(
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
      style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward_ios, size: 16),
  ],
),            ),
          ),
          Card(
            child: ListTile(
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
      '\$320', // 每个航班可自定义价格
      style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward_ios, size: 16),
  ],
),            ),
          ),
          Card(
            child: ListTile(
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
      style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward_ios, size: 16),
  ],
),            ),
          ),
          Card(
            child: ListTile(
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
      style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.arrow_forward_ios, size: 16),
  ],
),            ),
          ),
          SizedBox(height: 24),
         
        ],
      ),
    );
  }
}

// llll