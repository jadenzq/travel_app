import 'dart:convert';

import 'package:travel_app/Models/autocomplete_prediction.dart';

class PlaceAutocompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? placePredictions;

  PlaceAutocompleteResponse({
    required this.status,
    required this.placePredictions,
  });

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
      status: json['status'] as String?,
      placePredictions:
          (json['suggestions'] != null)
              ? json['suggestions']
                  .map<AutocompletePrediction>(
                    (json) => AutocompletePrediction.fromJson(json["placePrediction"]),
                  )
                  .toList()
              : null,
    );
  }

  static PlaceAutocompleteResponse parseAutocompleteResult(
    String responseBody,
  ) {
    final parsedJson = json.decode(responseBody).cast<String, dynamic>();

    return PlaceAutocompleteResponse.fromJson(parsedJson);
  }
}
