import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/booking_model.dart';
import '../Models/booking_service.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  final BookingService _bookingService = BookingService();
  String _selectedFilter = 'all'; // 'all', 'hotel', 'flight'
  bool _isLoading = true;
  List<BookingModel> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<BookingModel> bookings;
      
      switch (_selectedFilter) {
        case 'hotel':
          bookings = await _bookingService.getHotelBookings();
          break;
        case 'flight':
          bookings = await _bookingService.getFlightBookings();
          break;
        default:
          bookings = await _bookingService.getBookingsSortedByDate();
      }
      
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading bookings: $e');
      setState(() {
        _bookings = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bookings',
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
      body: Column(
        children: [
          // 筛选按钮
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildFilterButton('all', 'All', Icons.list),
                SizedBox(width: 8),
                _buildFilterButton('hotel', 'Hotels', Icons.hotel),
                SizedBox(width: 8),
                _buildFilterButton('flight', 'Flights', Icons.flight),
              ],
            ),
          ),
          
          // 预订列表
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading bookings...',
                          style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : _bookings.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _bookings.length,
                        itemBuilder: (context, index) {
                          return _buildBookingCard(_bookings[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _selectedFilter = value;
          });
          _loadBookings(); // 重新加载数据
        },
        icon: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.blueAccent,
          size: 18,
        ),
        label: Text(
          label,
          style: GoogleFonts.ubuntu(
            color: isSelected ? Colors.white : Colors.blueAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blueAccent : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: Colors.blueAccent,
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;
    
    switch (_selectedFilter) {
      case 'hotel':
        message = 'No hotel bookings yet';
        icon = Icons.hotel_outlined;
        break;
      case 'flight':
        message = 'No flight bookings yet';
        icon = Icons.flight_outlined;
        break;
      default:
        message = 'No bookings yet';
        icon = Icons.inbox_outlined;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 24),
          Text(
            message,
            style: GoogleFonts.ubuntu(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start planning your next trip!',
            style: GoogleFonts.ubuntu(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            icon: Icon(Icons.add, color: Colors.white),
            label: Text(
              'Book Now',
              style: GoogleFonts.ubuntu(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    final isHotel = booking.type == 'hotel';
    final backgroundColor = isHotel ? Colors.blue[50] : Colors.green[50];
    final iconColor = isHotel ? Colors.blueAccent : Colors.green;
    final icon = isHotel ? Icons.hotel : Icons.flight;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 头部信息
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.title,
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        booking.subtitle,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getTimeUntilBooking(booking),
                    style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 详细信息
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                if (isHotel) ..._buildHotelDetails(booking) else ..._buildFlightDetails(booking),
                
                SizedBox(height: 12),
                
                // 状态和预订时间
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(booking.status),
                        style: GoogleFonts.ubuntu(
                          color: _getStatusColor(booking.status),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      'Booked on ${_formatDate(booking.bookingDate)}',
                      style: GoogleFonts.ubuntu(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHotelDetails(BookingModel booking) {
    final details = booking.details;
    final stayDuration = details['stayDuration'] ?? 1;
    
    return [
      Row(
        children: [
          Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(
            'Check-in: ${_formatDate(booking.startDate)}',
            style: GoogleFonts.ubuntu(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
      SizedBox(height: 8),
      Row(
        children: [
          Icon(Icons.event, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(
            'Check-out: ${_formatDate(booking.endDate!)}',
            style: GoogleFonts.ubuntu(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
      SizedBox(height: 8),
      Row(
        children: [
          Icon(Icons.nights_stay, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(
            '$stayDuration night${stayDuration > 1 ? 's' : ''}',
            style: GoogleFonts.ubuntu(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildFlightDetails(BookingModel booking) {
    final details = booking.details;
    
    return [
      Row(
        children: [
          Icon(Icons.flight_takeoff, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(
            'Departure: ${_formatDate(booking.startDate)}',
            style: GoogleFonts.ubuntu(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
      if (details['departureTime'] != null) ...[
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
            SizedBox(width: 8),
            Text(
              'Time: ${details['departureTime']}',
              style: GoogleFonts.ubuntu(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    ];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmed';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // Calculate days until booking
  String _getTimeUntilBooking(BookingModel booking) {
    final now = DateTime.now();
    final startDate = booking.startDate;
    final difference = startDate.difference(now).inDays;
    
    if (difference > 0) {
      return 'In $difference day${difference > 1 ? 's' : ''}';
    } else if (difference == 0) {
      return 'Today';
    } else {
      final daysPast = difference.abs();
      return '$daysPast day${daysPast > 1 ? 's' : ''} ago';
    }
  }
}
