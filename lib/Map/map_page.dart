import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_app/Models/autocomplete_prediction.dart';
import 'package:travel_app/Models/place_details.dart';
import 'package:travel_app/Models/place_details_response.dart';
import 'package:travel_app/Utilities/network_utility.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.savedLocations});

  final List<AutocompletePrediction> savedLocations;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Future<List<PlaceDetails>>? _placeDetails;

  @override
  void initState() {
    super.initState();
    if (widget.savedLocations.isEmpty) {
      return;
    }
    _placeDetails = getPlaceDetails();
  }

  // Get place details
  Future<List<PlaceDetails>>? getPlaceDetails() async {
    List<PlaceDetails> tempPlaceDetails = [];

    for (var location in widget.savedLocations) {
      Uri
      uri = Uri.https("places.googleapis.com", "v1/places/${location.placeId}", {
        "fields":
            "nationalPhoneNumber,internationalPhoneNumber,formattedAddress,location,rating",
        "key": "AIzaSyCLxYn-Dgp1r1Qp2HbIubEc-egYC1_xb9E",
      });

      var response = await NetworkUtility.getRequest(uri);

      if (response != null) {
        PlaceDetailsResponse result =
            PlaceDetailsResponse.parsePlaceDetailsResult(response);

        if (result.placeDetails != null) {
          tempPlaceDetails.add(result.placeDetails!);
        }
      }
    }

    return tempPlaceDetails;
  }

  Set<Marker> getAllMarkers(List<PlaceDetails> places) {
    var markers = <Marker>{};

    for (int i = 0; i < places.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId("_place$i"),
          position: places[i].location.coordinate,
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Locations"), centerTitle: true),
      body:
          _placeDetails == null
              ? Center(child: Text("No Saved Locations Found."))
              : FutureBuilder(
                future: _placeDetails,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: snapshot.data![0].location.coordinate,
                        zoom: 13,
                      ),
                      markers: getAllMarkers(snapshot.data!),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error.toString()}");
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
    );
  }
}
