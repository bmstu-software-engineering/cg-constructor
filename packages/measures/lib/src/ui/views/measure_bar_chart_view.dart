import 'package:flutter/material.dart';

import '../../abstractions/measure_result.dart';

/// Виджет для отображения результатов замеров в виде гистограммы.
///
/// Этот виджет отображает результаты замеров в виде гистограммы, где каждый столбец
/// представляет среднее время выполнения для определенного ключа.
class MeasureBarChartView extends StatelessWidget {
  /// Список результатов замеров для отображения.
  final List<MeasureResult> results;

  /// Высота графика.
  final double height;

  /// Создает новый экземпляр [MeasureBarChartView].
  ///
  /// [key] - ключ виджета.
  /// [results] - список результатов замеров для отображения.
  /// [height] - высота графика, по умолчанию 300.
  const MeasureBarChartView({
    super.key,
    required this.results,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const SizedBox.shrink();
    }

    // Сортируем результаты по среднему времени выполнения
    final sortedResults = List<MeasureResult>.from(results)..sort(
      (a, b) => a.averageExecutionTimeMs.compareTo(b.averageExecutionTimeMs),
    );

    // Находим максимальное значение для масштабирования
    final maxValue =
        sortedResults.isEmpty
            ? 10.0
            : sortedResults.last.averageExecutionTimeMs * 1.2;

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Время выполнения (мс)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final barWidth = constraints.maxWidth / sortedResults.length;
                  final maxHeight =
                      constraints.maxHeight -
                      30; // Оставляем место для подписей

                  return Stack(
                    children: [
                      // Горизонтальные линии сетки
                      ...List.generate(5, (index) {
                        final y = maxHeight * (1 - index / 4);
                        final value = maxValue * index / 4;
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

                      // Столбцы гистограммы
                      Padding(
                        padding: const EdgeInsets.only(left: 30, bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(sortedResults.length, (
                            index,
                          ) {
                            final result = sortedResults[index];
                            final barHeight =
                                (result.averageExecutionTimeMs / maxValue) *
                                maxHeight;

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Tooltip(
                                  message:
                                      '${result.key}: ${result.averageExecutionTimeMs.toStringAsFixed(2)} мс',
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: barHeight.isNaN ? 0 : barHeight,
                                        decoration: BoxDecoration(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        result.key,
                                        style: const TextStyle(fontSize: 10),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
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
