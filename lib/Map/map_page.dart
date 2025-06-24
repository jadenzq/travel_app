import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const List<LatLng> _locations = [
    LatLng(2.830586, 101.703848),
    LatLng(2.824285, 101.713282),
    LatLng(2.830434, 101.706736),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _locations[0], zoom: 13),
        markers: getAllMarkers(),
      ),
    );
  }

  Set<Marker> getAllMarkers() {
    var markers = <Marker>{};

    for (int i = 0; i < _locations.length; i++) {
      markers.add(
        Marker(markerId: MarkerId("_location$i"), position: _locations[i]),
      );
    }

    return markers;
  }
}
