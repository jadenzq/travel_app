import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  LatLng? latitude;
  LatLng? longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'] as LatLng?, 
      longitude: json['longitude'] as LatLng?
    );
  }
}
