import 'dart:math' as math;

import 'package:alogrithms/alogrithms.dart';
import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

/// Пример алгоритма, поддерживающего различные варианты расчета
class ExampleAlgorithmWithVariants implements VariatedAlgorithm {
  // Фиксированный радиус для примера
  final double radius = 100;

  @override
  ResultModel calculate() {
    // Стандартный расчет (без вариации)
    return calculateWithVariant(null);
  }

  @override
  ResultModel calculateWithVariant(String? variant) {
    // Создаем точки и линии в зависимости от варианта
    final points = <Point>[];
    final lines = <Line>[];
    String? markdownInfo;

    switch (variant) {
      case 'circle':
        // Создаем круг
        _generateCircle(points, lines, radius);
        markdownInfo =
            '## Круг\nРадиус: $radius\nКоличество точек: ${points.length}';
        break;
      case 'square':
        // Создаем квадрат
        _generateSquare(points, lines, radius);
        markdownInfo =
            '## Квадрат\nСторона: ${radius * 2}\nКоличество точек: ${points.length}';
        break;
      case 'triangle':
        // Создаем треугольник
        _generateTriangle(points, lines, radius);
        markdownInfo =
            '## Треугольник\nРадиус описанной окружности: $radius\nКоличество точек: ${points.length}';
        break;
      default:
        // По умолчанию создаем точку
        points.add(const Point(x: 0, y: 0));
        markdownInfo = '## Точка\nКоординаты: (0, 0)';
    }

    return ViewerResultModel(
      points: points,
      lines: lines,
      markdownInfo: markdownInfo,
    );
  }

  /// Генерирует точки и линии для круга
  void _generateCircle(List<Point> points, List<Line> lines, double radius) {
    const segments = 36; // Количество сегментов для аппроксимации круга

    for (int i = 0; i < segments; i++) {
      final angle1 = 2 * math.pi * i / segments;
      final angle2 = 2 * math.pi * (i + 1) / segments;

      final p1 = Point(
        x: radius * math.cos(angle1),
        y: radius * math.sin(angle1),
      );

      final p2 = Point(
        x: radius * math.cos(angle2),
        y: radius * math.sin(angle2),
      );

      points.add(p1);
      lines.add(Line(a: p1, b: p2));
    }
  }

  /// Генерирует точки и линии для квадрата
  void _generateSquare(List<Point> points, List<Line> lines, double radius) {
    final side = radius * 2;
    final halfSide = side / 2;

    final p1 = Point(x: -halfSide, y: -halfSide);
    final p2 = Point(x: halfSide, y: -halfSide);
    final p3 = Point(x: halfSide, y: halfSide);
    final p4 = Point(x: -halfSide, y: halfSide);

    points.addAll([p1, p2, p3, p4]);

    lines.addAll([
      Line(a: p1, b: p2),
      Line(a: p2, b: p3),
      Line(a: p3, b: p4),
      Line(a: p4, b: p1),
    ]);
  }

  /// Генерирует точки и линии для треугольника
  void _generateTriangle(List<Point> points, List<Line> lines, double radius) {
    const segments = 3; // Треугольник имеет 3 вершины

    for (int i = 0; i < segments; i++) {
      final angle1 = 2 * math.pi * i / segments;
      final angle2 = 2 * math.pi * (i + 1) / segments;

      final p1 = Point(
        x: radius * math.cos(angle1),
        y: radius * math.sin(angle1),
      );

      final p2 = Point(
        x: radius * math.cos(angle2),
        y: radius * math.sin(angle2),
      );

      points.add(p1);
      lines.add(Line(a: p1, b: p2));
    }
  }

  @override
  DataModel getDataModel() {
    // Возвращаем пустую модель данных для примера
    return EmptyDataModel();
  }

  @override
  List<AlgorithmVariant> getAvailableVariants() {
    return [
      const AlgorithmVariant(
        id: 'circle',
        name: 'Круг',
        icon: Icons.circle_outlined,
        color: Colors.blue,
      ),
      const AlgorithmVariant(
        id: 'square',
        name: 'Квадрат',
        icon: Icons.square_outlined,
        color: Colors.green,
      ),
      const AlgorithmVariant(
        id: 'triangle',
        name: 'Треугольник',
        icon: Icons.change_history_outlined,
        color: Colors.orange,
      ),
    ];
  }
}

/// Пустая модель данных для примера
class EmptyDataModel implements FormsDataModel {
  // Создаем пустую конфигурацию формы
  final _config = DynamicFormModel(
    config: FormConfig(fields: [], name: 'empty_form'),
  );

  @override
  DynamicFormModel get config => _config;

  @override
  AlgorithmData get data => _EmptyData();
}

/// Пустые данные для примера
class _EmptyData implements AlgorithmData {}
