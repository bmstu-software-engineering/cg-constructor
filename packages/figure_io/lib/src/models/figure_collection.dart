import 'dart:convert';

import 'package:models_ns/models_ns.dart';
import 'figure.dart';

/// Коллекция геометрических фигур
class FigureCollection {
  /// Список точек
  final List<PointFigure> points;

  /// Список линий
  final List<LineFigure> lines;

  /// Список треугольников
  final List<TriangleFigure> triangles;

  /// Создает коллекцию фигур
  FigureCollection({
    this.points = const [],
    this.lines = const [],
    this.triangles = const [],
  });

  /// Получение всех фигур в виде плоского списка
  List<Figure> get allFigures => [
        ...points,
        ...lines,
        ...triangles,
      ];

  /// Создание коллекции из JSON
  factory FigureCollection.fromJson(Map<String, dynamic> json) {
    return FigureCollection(
      points: (json['points'] as List?)
              ?.map((e) => PointFigure(Point.fromJson(e as Map<String, dynamic>)))
              .toList() ??
          [],
      lines: (json['lines'] as List?)
              ?.map((e) => LineFigure(Line.fromJson(e as Map<String, dynamic>)))
              .toList() ??
          [],
      triangles: (json['triangles'] as List?)
              ?.map((e) => TriangleFigure(
                  Triangle.fromJson(e as Map<String, dynamic>)))
              .toList() ??
          [],
    );
  }

  /// Создание коллекции из строки JSON
  factory FigureCollection.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return FigureCollection.fromJson(json);
  }

  /// Преобразование коллекции в JSON
  Map<String, dynamic> toJson() => {
        'points': points.map((p) => p.point.toJson()).toList(),
        'lines': lines.map((l) => l.line.toJson()).toList(),
        'triangles': triangles.map((t) => t.triangle.toJson()).toList(),
      };

  /// Преобразование коллекции в строку JSON
  String toJsonString() => jsonEncode(toJson());

  /// Добавление точки в коллекцию
  FigureCollection addPoint(Point point) {
    return FigureCollection(
      points: [...points, PointFigure(point)],
      lines: lines,
      triangles: triangles,
    );
  }

  /// Добавление линии в коллекцию
  FigureCollection addLine(Line line) {
    return FigureCollection(
      points: points,
      lines: [...lines, LineFigure(line)],
      triangles: triangles,
    );
  }

  /// Добавление треугольника в коллекцию
  FigureCollection addTriangle(Triangle triangle) {
    return FigureCollection(
      points: points,
      lines: lines,
      triangles: [...triangles, TriangleFigure(triangle)],
    );
  }
}
