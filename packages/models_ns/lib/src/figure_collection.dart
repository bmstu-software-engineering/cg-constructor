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

  String toJsonString() => jsonEncode(toJson());
}
