class AutocompletePrediction {
  final String? place;
  final String? placeId;
  final String? text;
  final StructuredFormat? structuredFormat;

  AutocompletePrediction({
    required this.place,
    required this.placeId,
    required this.text,
    required this.structuredFormat,
  });

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      place: json['place'] as String?,
      placeId: json['placeId'] as String?,
      text: (json['text'] as Map<String, dynamic>)['text'] as String?,
      structuredFormat:
          (json['structuredFormat'] != null)
              ? StructuredFormat.fromJson(json['structuredFormat'])
              : null,
    );
  }
}

class StructuredFormat {
  final String? mainText;
  final String? secondaryText;

  StructuredFormat({required this.mainText, required this.secondaryText});

  factory StructuredFormat.fromJson(Map<String, dynamic> json) {
    return StructuredFormat(
      mainText: (json['mainText'] as Map<String, dynamic>)['text'] as String?,
      secondaryText: (json['secondaryText'] != null)
        ? (json['secondaryText'] as Map<String, dynamic>)['text'] as String?
        : null
    );
  }
}
