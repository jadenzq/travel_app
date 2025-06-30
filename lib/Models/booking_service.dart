import '../Models/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'bookings';
  
  // 本地缓存列表（可选，用于快速访问）
  final List<BookingModel> _bookings = [];

  // 获取所有预订（从Firestore）
  Future<List<BookingModel>> getAllBookings() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      final bookings = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // 使用Firestore的文档ID
        return BookingModel.fromJson(data);
      }).toList();
      
      // 更新本地缓存
      _bookings.clear();
      _bookings.addAll(bookings);
      
      return bookings;
    } catch (e) {
      print('Error getting bookings: $e');
      return _bookings; // 返回本地缓存作为备选
    }
  }

  // 按时间排序获取预订
  Future<List<BookingModel>> getBookingsSortedByDate() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('startDate')
          .get();
      
      final bookings = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return BookingModel.fromJson(data);
      }).toList();
      
      return bookings;
    } catch (e) {
      print('Error getting sorted bookings: $e');
      // 如果Firestore查询失败，从本地缓存获取并排序
      final bookings = List<BookingModel>.from(_bookings);
      bookings.sort((a, b) => a.startDate.compareTo(b.startDate));
      return bookings;
    }
  }

  // 添加预订（保存到Firestore）
  Future<void> addBooking(BookingModel booking) async {
    try {
      final docData = booking.toJson();
      docData.remove('id'); // 移除ID，让Firestore自动生成
      
      final docRef = await _firestore.collection(_collection).add(docData);
      
      // 更新本地缓存
      final updatedBooking = BookingModel(
        id: docRef.id,
        type: booking.type,
        title: booking.title,
        subtitle: booking.subtitle,
        price: booking.price,
        bookingDate: booking.bookingDate,
        startDate: booking.startDate,
        endDate: booking.endDate,
        status: booking.status,
        details: booking.details,
      );
      
      _bookings.add(updatedBooking);
      
      print('Booking added successfully with ID: ${docRef.id}');
    } catch (e) {
      print('Error adding booking: $e');
      // 作为备选，添加到本地缓存
      _bookings.add(booking);
    }
  }

  // 删除预订（从Firestore）
  Future<void> removeBooking(String bookingId) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).delete();
      
      // 更新本地缓存
      _bookings.removeWhere((booking) => booking.id == bookingId);
      
      print('Booking deleted successfully');
    } catch (e) {
      print('Error deleting booking: $e');
    }
  }

  // 获取酒店预订
  Future<List<BookingModel>> getHotelBookings() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('type', isEqualTo: 'hotel')
          .get();
      
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return BookingModel.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting hotel bookings: $e');
      return _bookings.where((booking) => booking.type == 'hotel').toList();
    }
  }

  // 获取航班预订
  Future<List<BookingModel>> getFlightBookings() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('type', isEqualTo: 'flight')
          .get();
      
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return BookingModel.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting flight bookings: $e');
      return _bookings.where((booking) => booking.type == 'flight').toList();
    }
  }

  // 清空所有预订（慎用！）
  Future<void> clearAllBookings() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      final batch = _firestore.batch();
      
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      
      // 清空本地缓存
      _bookings.clear();
      
      print('All bookings cleared successfully');
    } catch (e) {
      print('Error clearing bookings: $e');
    }
  }

  // 本地缓存方法（用于离线情况）
  List<BookingModel> getCachedBookings() {
    return List.from(_bookings);
  }

  // 监听预订变化（实时更新）
  Stream<List<BookingModel>> watchBookings() {
    return _firestore
        .collection(_collection)
        .orderBy('startDate')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return BookingModel.fromJson(data);
      }).toList();
    });
  }

  // 创建酒店预订
  static BookingModel createHotelBooking({
    required String hotelName,
    required String location,
    required String roomType,
    required String price,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int stayDuration,
    String? rating,
  }) {
    return BookingModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'hotel',
      title: hotelName,
      subtitle: '$location • $roomType Room',
      price: price,
      bookingDate: DateTime.now(),
      startDate: checkInDate,
      endDate: checkOutDate,
      details: {
        'location': location,
        'roomType': roomType,
        'stayDuration': stayDuration,
        'rating': rating,
      },
    );
  }

  // 创建航班预订
  static BookingModel createFlightBooking({
    required String flightNumber,
    required String airline,
    required String price,
    required DateTime departureDate,
    String? departureTime,
    String? arrivalTime,
    String? from,
    String? to,
  }) {
    return BookingModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'flight',
      title: 'Flight $flightNumber',
      subtitle: '$airline • ${from ?? 'Unknown'} to ${to ?? 'Unknown'}',
      price: price,
      bookingDate: DateTime.now(),
      startDate: departureDate,
      details: {
        'flightNumber': flightNumber,
        'airline': airline,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'from': from,
        'to': to,
      },
    );
  }
}
