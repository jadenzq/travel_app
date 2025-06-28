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
    try {
      return AutocompletePrediction(
        place: json['place'] as String?,
        placeId: json['placeId'] as String?,
        text: (json['text'] as Map<String, dynamic>)['text'] as String?,
        structuredFormat:
            (json['structuredFormat'] != null)
                ? StructuredFormat.fromJson(json['structuredFormat'])
                : null,
      );
    } on TypeError catch (e) {
      return AutocompletePrediction(
        place: json['place'] as String?,
        placeId: json['placeId'] as String?,
        text: json['text'] as String?,
        structuredFormat:
            (json['structuredFormat'] != null)
                ? StructuredFormat.fromJson(json['structuredFormat'])
                : null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "place": place,
      "placeId": placeId,
      "text": text,
      "structuredFormat": structuredFormat?.toJson(),
    };
  }
}

class StructuredFormat {
  final String? mainText;
  final String? secondaryText;

  StructuredFormat({required this.mainText, required this.secondaryText});

  factory StructuredFormat.fromJson(Map<String, dynamic> json) {
    try {
      return StructuredFormat(
        mainText: (json['mainText'] as Map<String, dynamic>)['text'] as String?,
        secondaryText:
            (json['secondaryText'] != null)
                ? (json['secondaryText'] as Map<String, dynamic>)['text']
                    as String?
                : null,
      );
    } on TypeError catch (e) {
      return StructuredFormat(
        mainText: json['mainText'] as String?,
        secondaryText:
            (json['secondaryText'] != null)
                ? json['secondaryText'] as String?
                : null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {"mainText": mainText, "secondaryText": secondaryText};
  }
}
