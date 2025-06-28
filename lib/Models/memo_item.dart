import 'package:travel_app/Models/autocomplete_prediction.dart';

class MemoItem {
  final String title;
  final String content;
  final DateTime date;
  final List<String> imagePaths;
  final List<AutocompletePrediction> savedLocations;

  MemoItem({
    required this.title,
    required this.content,
    required this.date,
    this.imagePaths = const [],
    this.savedLocations = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'imagePaths': imagePaths,
      'savedLocations': savedLocations.map((sl) => sl.toJson()).toList(),
    };
  }

  factory MemoItem.fromJson(Map<String, dynamic> json) {
    return MemoItem(
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      imagePaths: List<String>.from(json['imagePaths'] ?? []),
      savedLocations:
          (json['savedLocations'] != null)
              ? json['savedLocations']
                  .map<AutocompletePrediction>(
                    (sl) => AutocompletePrediction.fromJson(sl),
                  )
                  .toList()
              : null,
    );
  }

  MemoItem copyWith({
    String? title,
    String? content,
    DateTime? date,
    List<String>? imagePaths,
    List<AutocompletePrediction>? savedLocations,
  }) {
    return MemoItem(
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      imagePaths: imagePaths ?? this.imagePaths,
      savedLocations: savedLocations ?? this.savedLocations,
    );
  }
}
