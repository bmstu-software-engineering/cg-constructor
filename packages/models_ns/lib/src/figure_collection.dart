import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models_ns/models_ns.dart';

part 'figure_collection.freezed.dart';
part 'figure_collection.g.dart';

/// Коллекция геометрических фигур
@freezed
class FigureCollection with _$FigureCollection {
  const FigureCollection._();

  /// Создает коллекцию фигур
  const factory FigureCollection({
    /// Список точек
    @Default([]) List<Point> points,

    /// Список линий
    @Default([]) List<Line> lines,

    /// Список треугольников
    @Default([]) List<Triangle> triangles,

    /// Список прямоугольников
    @Default([]) List<Rectangle> rectangles,

    /// Список квадратов
    @Default([]) List<Square> squares,

    /// Список кругов
    @Default([]) List<Circle> circles,

    /// Список эллипсов
    @Default([]) List<Ellipse> ellipses,

    /// Список дуг
    @Default([]) List<Arc> arcs,
  }) = _FigureCollection;

  /// Создание коллекции из JSON
  factory FigureCollection.fromJson(Map<String, dynamic> json) =>
      _$FigureCollectionFromJson(json);

  /// Преобразует коллекцию в JSON строку
  String toJsonString() => jsonEncode(toJson());

  /// Масштабирует все фигуры в коллекции относительно указанного центра
  FigureCollection scale(Point center, Scale scale) {
    return FigureCollection(
      points: points.map((p) => p.scale(center, scale)).toList(),
      lines: lines.map((l) => l.scale(center, scale)).toList(),
      triangles: triangles.map((t) => t.scale(center, scale)).toList(),
      rectangles: rectangles.map((r) => r.scale(center, scale)).toList(),
      squares: squares.map((s) => s.scale(center, scale)).toList(),
      circles: circles.map((c) => c.scale(center, scale)).toList(),
      ellipses: ellipses.map((e) => e.scale(center, scale)).toList(),
      arcs: arcs.map((a) => a.scale(center, scale)).toList(),
    );
  }

  /// Перемещает все фигуры в коллекции на указанный вектор
  FigureCollection move(Vector vector) {
    return FigureCollection(
      points: points.map((p) => p.move(vector)).toList(),
      lines: lines.map((l) => l.move(vector)).toList(),
      triangles: triangles.map((t) => t.move(vector)).toList(),
      rectangles: rectangles.map((r) => r.move(vector)).toList(),
      squares: squares.map((s) => s.move(vector)).toList(),
      circles: circles.map((c) => c.move(vector)).toList(),
      ellipses: ellipses.map((e) => e.move(vector)).toList(),
      arcs: arcs.map((a) => a.move(vector)).toList(),
    );
  }

  /// Поворачивает все фигуры в коллекции относительно указанного центра на указанный угол в градусах
  FigureCollection rotate(Point center, double degree) {
    return FigureCollection(
      points: points.map((p) => p.rotate(center, degree)).toList(),
      lines: lines.map((l) => l.rotate(center, degree)).toList(),
      triangles: triangles.map((t) => t.rotate(center, degree)).toList(),
      rectangles: rectangles.map((r) => r.rotate(center, degree)).toList(),
      squares: squares.map((s) => s.rotate(center, degree)).toList(),
      circles: circles.map((c) => c.rotate(center, degree)).toList(),
      ellipses: ellipses.map((e) => e.rotate(center, degree)).toList(),
      arcs: arcs.map((a) => a.rotate(center, degree)).toList(),
    );
  }
}
