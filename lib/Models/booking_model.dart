class BookingModel {
  final String id;
  final String type; // 'hotel' 或 'flight'
  final String title;
  final String subtitle;
  final String price;
  final DateTime bookingDate;
  final DateTime startDate;
  final DateTime? endDate;
  final String status; // 'confirmed', 'pending', 'cancelled'
  final Map<String, dynamic> details;

  BookingModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.bookingDate,
    required this.startDate,
    this.endDate,
    this.status = 'confirmed',
    required this.details,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      subtitle: json['subtitle'],
      price: json['price'],
      bookingDate: DateTime.parse(json['bookingDate']),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      status: json['status'] ?? 'confirmed',
      details: json['details'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'price': price,
      'bookingDate': bookingDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'details': details,
    };
  }
}
