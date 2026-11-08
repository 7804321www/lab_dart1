# Лабораторна робота (Dart) - варіант 1: Погодний щоденник міст

Консольний застосунок: список записів про погоду в містах, додавання, видалення,
збереження у `data.json` та відновлення під час наступного запуску.

## Запуск
1. Встановити Dart SDK (`dart --version` має працювати в терміналі).
2. У теці проєкту: `dart run bin/main.dart`.

## Структура
- `bin/main.dart` - точка входу, текстове меню
- `lib/models/weather_entry.dart` - модель, `toJson()` / `fromJson()` / `toString()`
- `lib/repositories/entry_repository.dart` - читання/запис `data.json`

## API варіанта (використовується на рівні "добре")
https://api.open-meteo.com/v1/forecast?latitude=50.75&longitude=25.34&current=temperature_2m
