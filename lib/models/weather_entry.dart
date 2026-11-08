/// Запис погодного щоденника: погода в місті на певну дату.
class WeatherEntry {
  final int id;
  final String city;
  final double temperature; // °C
  final String description;
  final String date; // формат РРРР-ММ-ДД

  WeatherEntry({
    required this.id,
    required this.city,
    required this.temperature,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'city': city,
        'temperature': temperature,
        'description': description,
        'date': date,
      };

  factory WeatherEntry.fromJson(Map<String, dynamic> json) => WeatherEntry(
        id: json['id'] as int,
        city: json['city'] as String? ?? 'Невідоме місто',
        temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
        description: json['description'] as String? ?? 'без опису',
        date: json['date'] as String? ?? '',
      );

  @override
  String toString() =>
      '#$id $city, $date: ${temperature.toStringAsFixed(1)} °C, $description';
}
