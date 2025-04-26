# Figure IO - Примеры

Примеры использования пакета Figure IO для работы с геометрическими фигурами в формате JSON.

## Примеры

В этом проекте представлены несколько примеров использования пакета Figure IO:

### 1. Основной пример (main.dart)

Полнофункциональный пример, демонстрирующий использование виджета `FigureReaderWidget` для чтения файлов JSON с фигурами и отображения информации о них.

```bash
flutter run -t lib/main.dart
```

### 2. Простой пример (simple_example.dart)

Упрощенный пример использования виджета `FigureReaderWidget` с минимальным набором функций.

```bash
flutter run -t lib/simple_example.dart
```

### 3. Пример с ассетами (asset_example.dart)

Пример загрузки фигур из ассетов приложения с использованием сервиса `FigureReader`.

```bash
flutter run -t lib/asset_example.dart
```

## Структура проекта

- `lib/main.dart` - Основной пример
- `lib/simple_example.dart` - Простой пример
- `lib/asset_example.dart` - Пример с ассетами
- `assets/example_figures.json` - Пример JSON-файла с фигурами

## Формат JSON

Пакет поддерживает следующий формат JSON:

```json
{
  "points": [
    {
      "x": 10,
      "y": 20
    }
  ],
  "lines": [
    {
      "a": {
        "x": 0,
        "y": 0
      },
      "b": {
        "x": 100,
        "y": 100
      }
    }
  ],
  "triangles": [
    {
      "a": {
        "x": 0,
        "y": 0
      },
      "b": {
        "x": 100,
        "y": 0
      },
      "c": {
        "x": 50,
        "y": 86.6
      }
    }
  ]
}
