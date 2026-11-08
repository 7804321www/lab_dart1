import 'dart:convert';
import 'dart:io';

import 'package:lab_dart/models/weather_entry.dart';
import 'package:lab_dart/repositories/entry_repository.dart';

Future<void> main() async {
  final repo = EntryRepository();
  final entries = await repo.load();
  stdout.writeln('Завантажено записів: ${entries.length}');

  var running = true;
  while (running) {
    printMenu();
    stdout.write('Оберіть пункт: ');
    final choice = readLine()?.trim();
    if (choice == null) break; // кінець вводу (Ctrl+D / Ctrl+Z)

    switch (choice) {
      case '1':
        showAll(entries);
      case '2':
        await addEntry(entries, repo);
      case '3':
        await removeEntry(entries, repo);
      case '0':
        running = false;
      default:
        stdout.writeln('Невідомий пункт меню, спробуйте ще раз.');
    }
  }
  stdout.writeln('До побачення!');
}

void printMenu() {
  stdout.writeln('\n=== Погодний щоденник міст ===');
  stdout.writeln('1. Показати список');
  stdout.writeln('2. Додати запис');
  stdout.writeln('3. Видалити запис');
  stdout.writeln('0. Вихід');
}

void showAll(List<WeatherEntry> entries) {
  if (entries.isEmpty) {
    stdout.writeln('Список порожній.');
    return;
  }
  for (final e in entries) {
    stdout.writeln(e);
  }
}

Future<void> addEntry(List<WeatherEntry> entries, EntryRepository repo) async {
  final city = readText('Місто: ');
  if (city == null) return;
  final temperature = readTemperature('Температура, °C: ');
  if (temperature == null) return;
  final description = readText('Опис погоди (напр. сонячно): ');
  if (description == null) return;
  final date = readDate('Дата (РРРР-ММ-ДД або ДД.ММ.РРРР, Enter - сьогодні): ');

  final nextId =
      entries.isEmpty ? 1 : entries.map((e) => e.id).reduce(_max) + 1;

  entries.add(WeatherEntry(
    id: nextId,
    city: city,
    temperature: temperature,
    description: description,
    date: date,
  ));
  await repo.save(entries);
  stdout.writeln('Запис додано.');
}

Future<void> removeEntry(
    List<WeatherEntry> entries, EntryRepository repo) async {
  if (entries.isEmpty) {
    stdout.writeln('Список порожній, видаляти нічого.');
    return;
  }
  stdout.write('Введіть id запису для видалення: ');
  final id = int.tryParse(readLine()?.trim() ?? '');
  if (id == null) {
    stdout.writeln('Некоректний id. Потрібне ціле число.');
    return;
  }
  final index = entries.indexWhere((e) => e.id == id);
  if (index == -1) {
    stdout.writeln('Запису з id $id не знайдено.');
    return;
  }
  final removed = entries.removeAt(index);
  await repo.save(entries);
  stdout.writeln('Видалено: $removed');
}

/// Читає непорожній рядок; повертає null, якщо користувач нічого не ввів.
String? readText(String prompt) {
  stdout.write(prompt);
  final text = readLine()?.trim() ?? '';
  if (text.isEmpty) {
    stdout.writeln('Поле не може бути порожнім. Додавання скасовано.');
    return null;
  }
  return text;
}

/// Читає число (допускається кома як роздільник).
double? readTemperature(String prompt) {
  stdout.write(prompt);
  final raw = (readLine() ?? '').trim().replaceAll(',', '.');
  final value = double.tryParse(raw);
  if (value == null) {
    stdout.writeln('Некоректне число. Додавання скасовано.');
    return null;
  }
  return value;
}

/// Читає дату у форматі РРРР-ММ-ДД або ДД.ММ.РРРР; інакше підставляє сьогодні.
String readDate(String prompt) {
  stdout.write(prompt);
  final raw = (readLine() ?? '').trim();
  DateTime? parsed = DateTime.tryParse(raw);
  final dotted = RegExp(r'^(\d{1,2})\.(\d{1,2})\.(\d{4})$').firstMatch(raw);
  if (parsed == null && dotted != null) {
    parsed = DateTime.tryParse(
        '${dotted[3]}-${dotted[2]!.padLeft(2, '0')}-${dotted[1]!.padLeft(2, '0')}');
  }
  final date = parsed ?? DateTime.now();
  if (raw.isNotEmpty && parsed == null) {
    stdout.writeln('Некоректна дата, використано сьогоднішню.');
  }
  return date.toIso8601String().substring(0, 10);
}

/// Читає рядок із консолі в UTF-8, щоб українські літери не спотворювалися.
String? readLine() => stdin.readLineSync(encoding: utf8);

int _max(int a, int b) => a > b ? a : b;
