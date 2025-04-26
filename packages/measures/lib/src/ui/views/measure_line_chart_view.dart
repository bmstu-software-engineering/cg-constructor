import 'package:flutter/material.dart';

import '../../abstractions/measure_result.dart';

/// Виджет для отображения результатов замеров в виде линейного графика.
///
/// Этот виджет отображает результаты замеров в виде линейного графика, где каждая точка
/// представляет время выполнения для определенной итерации.
class MeasureLineChartView extends StatelessWidget {
  /// Список результатов замеров для отображения.
  final List<MeasureResult> results;

  /// Высота графика.
  final double height;

  /// Создает новый экземпляр [MeasureLineChartView].
  ///
  /// [key] - ключ виджета.
  /// [results] - список результатов замеров для отображения.
  /// [height] - высота графика, по умолчанию 300.
  const MeasureLineChartView({
    super.key,
    required this.results,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const SizedBox.shrink();
    }

    // Определяем максимальное количество итераций
    int maxIterations = 0;
    for (final result in results) {
      if (result.executionTimeMs.length > maxIterations) {
        maxIterations = result.executionTimeMs.length;
      }
    }

    // Определяем максимальное значение для оси Y
    double maxY = 10.0;
    for (final result in results) {
      if (result.executionTimeMs.isNotEmpty) {
        final maxTime =
            result.executionTimeMs.reduce((a, b) => a > b ? a : b).toDouble();
        if (maxTime > maxY) {
          maxY = maxTime;
        }
      }
    }
    maxY *= 1.2; // Добавляем 20% для лучшего отображения

    // Создаем список цветов для линий
    final colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Время выполнения по итерациям (мс)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Легенда
            if (results.length > 1)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                children: List.generate(results.length, (index) {
                  final result = results[index];
                  final color = colors[index % colors.length];
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 12, height: 12, color: color),
                      const SizedBox(width: 4),
                      Text(result.key, style: const TextStyle(fontSize: 12)),
                    ],
                  );
                }),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth =
                      constraints.maxWidth - 40; // Оставляем место для оси Y
                  final maxHeight =
                      constraints.maxHeight - 30; // Оставляем место для оси X
                  final xStep =
                      maxIterations <= 1
                          ? maxWidth
                          : maxWidth / (maxIterations - 1);

                  return Stack(
                    children: [
                      // Горизонтальные линии сетки
                      ...List.generate(5, (index) {
                        final y = maxHeight * (1 - index / 4);
                        final value = maxY * index / 4;
                        return Positioned(
                          left: 0,
                          top: y,
                          right: 0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                                child: Text(
                                  value.toStringAsFixed(0),
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      // Вертикальные линии сетки
                      ...List.generate(maxIterations, (index) {
                        final x = 40 + index * xStep;
                        return Positioned(
                          left: x,
                          top: 0,
                          bottom: 0,
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              Text(
                                (index + 1).toString(),
                                style: const TextStyle(fontSize: 10),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      }),

                      // Линии графика
                      ...List.generate(results.length, (resultIndex) {
                        final result = results[resultIndex];
                        final color = colors[resultIndex % colors.length];

                        // Если нет данных, не рисуем линию
                        if (result.executionTimeMs.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        // Создаем точки для линии
                        final points = <Offset>[];
                        for (
                          int i = 0;
                          i < result.executionTimeMs.length;
                          i++
                        ) {
                          final x = 40 + i * xStep;
                          final y =
                              maxHeight -
                              (result.executionTimeMs[i] / maxY) * maxHeight;
                          points.add(Offset(x, y));
                        }

                        return Positioned.fill(
                          child: CustomPaint(
                            painter: _LinePainter(
                              points: points,
                              color: color,
                              showPoints: true,
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Класс для рисования линии графика.
class _LinePainter extends CustomPainter {
  /// Список точек для рисования линии.
  final List<Offset> points;

  /// Цвет линии.
  final Color color;

  /// Флаг, указывающий, нужно ли отображать точки на линии.
  final bool showPoints;

  /// Создает новый экземпляр [_LinePainter].
  _LinePainter({
    required this.points,
    required this.color,
    this.showPoints = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    // Рисуем линию
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    // Рисуем точки
    if (showPoints) {
      final pointPaint =
          Paint()
            ..color = color
            ..style = PaintingStyle.fill;

      for (final point in points) {
        canvas.drawCircle(point, 3, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.color != color ||
        oldDelegate.showPoints != showPoints;
  }
}
