import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetails {
  String? nationalPhoneNumber;
  String? internationalPhoneNumber;
  String? formattedAddress;
  Location location;
  String? rating;

  PlaceDetails({
    required this.nationalPhoneNumber,
    required this.internationalPhoneNumber,
    required this.formattedAddress,
    required this.location,
    required this.rating,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      nationalPhoneNumber: json['nationalPhoneNumber'] ?? "",
      internationalPhoneNumber: json['internationalPhoneNumber'] ?? "",
      formattedAddress: json['formattedAddress'] ?? "",
      location: Location.fromJson(json['location']),
      rating: json['rating'].toString(),
    );
  }
}

class Location {
  double latitude;
  double longitude;
  LatLng coordinate;

  Location({required this.latitude, required this.longitude})
    : coordinate = LatLng(latitude, longitude);

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
}
