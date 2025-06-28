import 'dart:convert';

import 'package:travel_app/Models/place_details.dart';

class PlaceDetailsResponse {
  PlaceDetails? placeDetails;

  PlaceDetailsResponse({required this.placeDetails});

  factory PlaceDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailsResponse(placeDetails: PlaceDetails.fromJson(json));
  }

  static PlaceDetailsResponse parsePlaceDetailsResult(String responseBody) {
    final parsedJson = json.decode(responseBody).cast<String, dynamic>();

    return PlaceDetailsResponse.fromJson(parsedJson);
  }
}
