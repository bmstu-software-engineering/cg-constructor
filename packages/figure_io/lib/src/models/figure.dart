import 'package:models_ns/models_ns.dart';

/// Абстрактный класс, представляющий геометрическую фигуру
abstract class Figure {
  /// Тип фигуры
  String get type;

  /// Преобразование фигуры в JSON
  Map<String, dynamic> toJson();

  /// Фабричный метод для создания фигуры из JSON
  static Figure fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'point':
        return PointFigure.fromJson(json);
      case 'line':
        return LineFigure.fromJson(json);
      case 'triangle':
        return TriangleFigure.fromJson(json);
      // Здесь можно добавлять новые типы фигур
      default:
        throw Exception('Unknown figure type: $type');
    }
  }
}

/// Фигура-точка
class PointFigure implements Figure {
  /// Точка
  final Point point;

  /// Создает фигуру-точку
  PointFigure(this.point);

  @override
  String get type => 'point';

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'point': point.toJson(),
      };

  /// Создает фигуру-точку из JSON
  factory PointFigure.fromJson(Map<String, dynamic> json) {
    return PointFigure(
      Point.fromJson(json['point'] as Map<String, dynamic>),
    );
  }
}

/// Фигура-линия
class LineFigure implements Figure {
  /// Линия
  final Line line;

  /// Создает фигуру-линию
  LineFigure(this.line);

  @override
  String get type => 'line';

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'line': line.toJson(),
      };

  /// Создает фигуру-линию из JSON
  factory LineFigure.fromJson(Map<String, dynamic> json) {
    return LineFigure(
      Line.fromJson(json['line'] as Map<String, dynamic>),
    );
  }
}

/// Фигура-треугольник
class TriangleFigure implements Figure {
  /// Треугольник
  final Triangle triangle;

  /// Создает фигуру-треугольник
  TriangleFigure(this.triangle);

  @override
  String get type => 'triangle';

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'triangle': triangle.toJson(),
      };

  /// Создает фигуру-треугольник из JSON
  factory TriangleFigure.fromJson(Map<String, dynamic> json) {
    return TriangleFigure(
      Triangle.fromJson(json['triangle'] as Map<String, dynamic>),
    );
  }
}
