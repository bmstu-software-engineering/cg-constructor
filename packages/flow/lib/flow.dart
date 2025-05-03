import 'package:alogrithms/algorithms/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';
import 'package:rxdart/rxdart.dart';
import 'package:viewer/viewer.dart';

export 'adapters/adapters.dart';

final class FlowBuilder<DD extends FlowDrawData> {
  final String name;
  final FlowDataStrategy _dataStrategy;
  final FlowCalculateStrategy<DD> _calculateStrategy;
  final FlowDrawStrategy<DD> _drawStrategy;

  /// Поток для информационных сообщений
  final BehaviorSubject<List<String>> infoStream =
      BehaviorSubject<List<String>>.seeded([]);

  DD? _drawData;

  FlowBuilder({
    this.name = '<no name>',
    required FlowDataStrategy dataStrategy,
    required FlowCalculateStrategy<DD> calculateStrategy,
    required FlowDrawStrategy<DD> drawStrategy,
  }) : _dataStrategy = dataStrategy,
       _calculateStrategy = calculateStrategy,
       _drawStrategy = drawStrategy;

  /// Добавляет информационное сообщение в поток
  void _addInfoMessage(String message) {
    final currentMessages = infoStream.value;
    infoStream.add([...currentMessages, message]);
  }

  /// Производит расчёты,
  /// Расчитывает набор точек для рисования
  Future<void> calculate() async {
    try {
      _drawData = await _calculateStrategy.calculate();

      final markdownInfo = _drawData?.markdownInfo;
      if (markdownInfo != null) {
        _addInfoMessage(markdownInfo);
      } else {
        _addInfoMessage('Расчеты выполнены успешно');
      }
    } on AlgorithmException catch (e) {
      _addInfoMessage('# Ошибка при расчетах\n${e.toString()}');
      rethrow;
    }
  }

  /// Производит расчёты,
  /// Рисует на точки на Viewer-е
  Future<void> draw() async {
    try {
      await _drawStrategy.draw(
        _drawData ?? (throw Exception('Данные для рисования отсутствуют')),
      );
      _addInfoMessage('Отрисовка выполнена успешно');
    } catch (e) {
      _addInfoMessage('Ошибка при отрисовке: ${e.toString()}');
      rethrow;
    }
  }

  Widget buildDataWidget() {
    final dataWidget = _dataStrategy.buildWidget();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        dataWidget,
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            try {
              if (_dataStrategy.isValid) {
                await calculate();
                await draw();
              } else {
                _addInfoMessage('# Валидация не пройдена');
              }
            } on AlgorithmException catch (_) {
              // Ошибки уже обрабатываются в методах calculate и draw
            }
          },
          child: Text('Расчитать'),
        ),
      ],
    );
  }

  /// Закрывает поток при уничтожении объекта
  void dispose() {
    infoStream.close();
  }

  Widget buildViewerWidget() => _drawStrategy.buildWidget();
}

abstract interface class FlowBuilderFactory {
  FlowBuilder create();
}

abstract interface class FlowDataStrategy {
  Widget buildWidget();

  bool get isValid;
}

final class FlowDrawData {
  final List<Point> points;
  final List<Line> lines;
  final String? markdownInfo;

  const FlowDrawData({
    this.points = const [],
    this.lines = const [],
    this.markdownInfo,
  });
}

abstract interface class FlowCalculateStrategy<DD extends FlowDrawData> {
  Future<DD> calculate();
}

abstract interface class FlowDrawStrategy<DD extends FlowDrawData> {
  Future<void> draw(DD drawData);

  Widget buildWidget();
}

class ViewerFlowDrawStrategy implements FlowDrawStrategy {
  final Viewer _viewer;

  ViewerFlowDrawStrategy(this._viewer);

  @override
  Future<void> draw(FlowDrawData drawData) async =>
      _viewer.draw(drawData.lines, drawData.points);

  @override
  Widget buildWidget() => _viewer.buildWidget();
}
