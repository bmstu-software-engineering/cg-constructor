import 'package:flutter/material.dart';

import '../abstractions/measure_progress.dart';
import '../abstractions/measure_result.dart';
import '../abstractions/measure_service.dart';
import 'measure_inherited_widget.dart';
import 'measure_view_type.dart';
import 'views/measure_bar_chart_view.dart';
import 'views/measure_line_chart_view.dart';
import 'views/measure_table_view.dart';

/// Виджет для отображения результатов замеров производительности.
///
/// Этот виджет отображает результаты замеров в различных представлениях,
/// таких как таблица, гистограмма или линейный график, а также показывает
/// прогресс выполнения замеров.
class MeasureWidget extends StatelessWidget {
  /// Заголовок виджета.
  final String title;

  /// Список ключей замеров для сравнения.
  final List<String> keysToCompare;

  /// Тип представления результатов.
  final MeasureViewType viewType;

  /// Флаг, указывающий, нужно ли показывать заголовок.
  final bool showTitle;

  /// Флаг, указывающий, нужно ли показывать прогресс выполнения замеров.
  final bool showProgress;

  /// Создает новый экземпляр [MeasureWidget].
  ///
  /// [key] - ключ виджета.
  /// [title] - заголовок виджета.
  /// [keysToCompare] - список ключей замеров для сравнения.
  /// [viewType] - тип представления результатов, по умолчанию [MeasureViewType.table].
  /// [showTitle] - флаг, указывающий, нужно ли показывать заголовок, по умолчанию true.
  /// [showProgress] - флаг, указывающий, нужно ли показывать прогресс выполнения замеров, по умолчанию true.
  const MeasureWidget({
    super.key,
    required this.title,
    required this.keysToCompare,
    this.viewType = MeasureViewType.table,
    this.showTitle = true,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    final measureService = MeasureInheritedWidget.getService(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showTitle) ...[
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            key: const Key('measure_widget_title'),
          ),
          const SizedBox(height: 8),
        ],
        if (showProgress) _buildProgressIndicator(measureService),
        _buildResultsView(measureService),
      ],
    );
  }

  /// Строит индикатор прогресса выполнения замеров.
  Widget _buildProgressIndicator(MeasureService measureService) {
    return StreamBuilder<MeasureProgress>(
      stream: measureService.progressStream,
      builder: (context, snapshot) {
        final progress = snapshot.data ?? MeasureProgress.initial();

        if (!progress.isRunning) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Выполнение замеров: ${progress.currentKey ?? ""}',
                key: const Key('measure_widget_progress_text'),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress.progress,
                key: const Key('measure_widget_progress_indicator'),
              ),
              const SizedBox(height: 4),
              Text(
                '${progress.currentIteration} из ${progress.totalIterations}',
                key: const Key('measure_widget_progress_count'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Строит представление результатов замеров.
  Widget _buildResultsView(MeasureService measureService) {
    return StreamBuilder<Map<String, MeasureResult>>(
      stream: measureService.resultsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data!;
        final relevantResults =
            keysToCompare
                .where((key) => results.containsKey(key))
                .map((key) => results[key]!)
                .toList();

        if (relevantResults.isEmpty) {
          return const Text(
            'Нет данных для отображения',
            key: Key('measure_widget_no_data'),
          );
        }

        switch (viewType) {
          case MeasureViewType.table:
            return MeasureTableView(
              results: relevantResults,
              key: const Key('measure_widget_table_view'),
            );
          case MeasureViewType.barChart:
            return MeasureBarChartView(
              results: relevantResults,
              key: const Key('measure_widget_bar_chart_view'),
            );
          case MeasureViewType.lineChart:
            return MeasureLineChartView(
              results: relevantResults,
              key: const Key('measure_widget_line_chart_view'),
            );
        }
      },
    );
  }
}
