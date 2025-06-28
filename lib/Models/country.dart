class Country 
{
  final String name;
  final List<String> states;

  Country({required this.name, required this.states});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] as String,
      states: List<String>.from(json['states'] as List),
    );
  }
}