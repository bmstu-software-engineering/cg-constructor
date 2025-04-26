import 'package:flutter/material.dart';

import '../../abstractions/measure_result.dart';

/// Виджет для отображения результатов замеров в виде таблицы.
///
/// Этот виджет отображает результаты замеров в виде таблицы с колонками для ключа,
/// среднего времени выполнения, минимального и максимального времени,
/// а также использования памяти и тиков, если они доступны.
class MeasureTableView extends StatelessWidget {
  /// Список результатов замеров для отображения.
  final List<MeasureResult> results;

  /// Создает новый экземпляр [MeasureTableView].
  ///
  /// [key] - ключ виджета.
  /// [results] - список результатов замеров для отображения.
  const MeasureTableView({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final hasMemoryData = results.any(
      (result) => result.memoryUsage.isNotEmpty,
    );
    final hasTicksData = results.any((result) => result.ticks.isNotEmpty);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        key: const Key('measure_table_view_data_table'),
        columns: [
          const DataColumn(
            label: Text('Ключ'),
            tooltip: 'Уникальный идентификатор замера',
          ),
          const DataColumn(
            label: Text('Среднее (мс)'),
            tooltip: 'Среднее время выполнения в миллисекундах',
            numeric: true,
          ),
          const DataColumn(
            label: Text('Медиана (мс)'),
            tooltip: 'Медианное время выполнения в миллисекундах',
            numeric: true,
          ),
          const DataColumn(
            label: Text('Мин (мс)'),
            tooltip: 'Минимальное время выполнения в миллисекундах',
            numeric: true,
          ),
          const DataColumn(
            label: Text('Макс (мс)'),
            tooltip: 'Максимальное время выполнения в миллисекундах',
            numeric: true,
          ),
          const DataColumn(
            label: Text('Ст. откл. (мс)'),
            tooltip:
                'Стандартное отклонение времени выполнения в миллисекундах',
            numeric: true,
          ),
          if (hasMemoryData)
            const DataColumn(
              label: Text('Память (байт)'),
              tooltip: 'Среднее использование памяти в байтах',
              numeric: true,
            ),
          if (hasTicksData)
            const DataColumn(
              label: Text('Тики'),
              tooltip: 'Среднее количество тиков процессора',
              numeric: true,
            ),
        ],
        rows:
            results.map((result) {
              return DataRow(
                key: ValueKey('measure_table_view_row_${result.key}'),
                cells: [
                  DataCell(Text(result.key)),
                  DataCell(Text(_formatDouble(result.averageExecutionTimeMs))),
                  DataCell(Text(_formatDouble(result.medianExecutionTimeMs))),
                  DataCell(Text(result.minExecutionTimeMs.toString())),
                  DataCell(Text(result.maxExecutionTimeMs.toString())),
                  DataCell(Text(_formatDouble(result.stdDevExecutionTimeMs))),
                  if (hasMemoryData)
                    DataCell(Text(_formatDouble(result.averageMemoryUsage))),
                  if (hasTicksData)
                    DataCell(Text(_formatDouble(result.averageTicks))),
                ],
              );
            }).toList(),
      ),
    );
  }

  /// Форматирует число с плавающей точкой для отображения.
  ///
  /// [value] - число для форматирования.
  ///
  /// Возвращает строковое представление числа с двумя знаками после запятой.
  String _formatDouble(double value) {
    return value.toStringAsFixed(2);
  }
}
