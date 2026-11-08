import 'dart:convert';
import 'dart:io';

import '../models/weather_entry.dart';

/// Читання та збереження списку записів у файл JSON.
class EntryRepository {
  final String path;

  EntryRepository([this.path = 'data.json']);

  Future<List<WeatherEntry>> load() async {
    final file = File(path);
    if (!await file.exists()) return [];
    try {
      final raw = await file.readAsString();
      if (raw.trim().isEmpty) return [];
      return (jsonDecode(raw) as List)
          .map((e) => WeatherEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      stdout.writeln('Не вдалося прочитати $path ($e). Список буде порожнім.');
      return [];
    }
  }

  Future<void> save(List<WeatherEntry> entries) async {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      await File(path).writeAsString(encoder.convert(entries));
    } catch (e) {
      stdout.writeln('Не вдалося зберегти дані: $e');
    }
  }
}
