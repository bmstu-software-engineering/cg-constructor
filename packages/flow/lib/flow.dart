import 'package:alogrithms/algorithms/exceptions.dart';
import 'package:alogrithms/alogrithms.dart';
import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';
import 'package:rxdart/rxdart.dart';
import 'package:viewer/viewer.dart';

import 'actions.dart';
import 'adapters/calculate_strategies.dart';

export 'actions.dart';
export 'adapters/adapters.dart';

final class FlowBuilder<DD extends FlowDrawData> {
  final String name;
  final FlowDataStrategy _dataStrategy;
  final FlowCalculateStrategy<DD> _calculateStrategy;
  final FlowDrawStrategy<DD> _drawStrategy;

  /// Поток для информационных сообщений
  final BehaviorSubject<List<String>> infoStream =
      BehaviorSubject<List<String>>.seeded([]);

  /// Список действий, доступных для этого FlowBuilder
  final List<FlowAction> _actions = [];

  DD? _drawData;

  FlowBuilder({
    this.name = '<no name>',
    required FlowDataStrategy dataStrategy,
    required FlowCalculateStrategy<DD> calculateStrategy,
    required FlowDrawStrategy<DD> drawStrategy,
  }) : _dataStrategy = dataStrategy,
       _calculateStrategy = calculateStrategy,
       _drawStrategy = drawStrategy;

  /// Добавляет действие в список доступных действий
  void addAction(FlowAction action) {
    _actions.add(action);
  }

  /// Добавляет информационное сообщение в поток
  void _addInfoMessage(String message) {
    final currentMessages = infoStream.value;
    infoStream.add([...currentMessages, message]);
  }

  /// Производит расчёты,
  /// Расчитывает набор точек для рисования
  Future<void> calculate({String? variant}) async {
    try {
      _drawData = await _calculateStrategy.calculate(variant: variant);

      final markdownInfo = _drawData?.markdownInfo;
      if (markdownInfo != null) {
        _addInfoMessage(markdownInfo);
      } else {
        _addInfoMessage(
          variant != null
              ? 'Расчеты выполнены успешно (вариант: $variant)'
              : 'Расчеты выполнены успешно',
        );
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

  /// Возвращает список действий на основе вариантов алгоритма
  List<FlowAction> getActionsFromAlgorithm() {
    final algorithm =
        _calculateStrategy is GenericCalculateStrategy
            ? ((_calculateStrategy as GenericCalculateStrategy).algorithm)
            : null;

    if (algorithm is VariatedAlgorithm) {
      final variants = algorithm.getAvailableVariants();
      return variants
          .map(
            (variant) => FlowAction(
              label: variant.name,
              icon: variant.icon,
              color: variant.color,
              action: (fb) async {
                if (fb._dataStrategy.isValid) {
                  await fb.calculate(variant: variant.id);
                  await fb.draw();
                } else {
                  fb._addInfoMessage('# Валидация не пройдена');
                }
              },
            ),
          )
          .toList();
    }

    // Возвращаем стандартное действие, если алгоритм не поддерживает вариации
    return [
      FlowAction(
        label: 'Расчитать',
        action: (fb) async {
          if (fb._dataStrategy.isValid) {
            await fb.calculate();
            await fb.draw();
          } else {
            fb._addInfoMessage('# Валидация не пройдена');
          }
        },
      ),
    ];
  }

  Widget buildDataWidget() {
    final dataWidget = _dataStrategy.buildWidget();

    // Если список действий пуст, добавляем стандартное действие
    if (_actions.isEmpty) {
      addAction(
        FlowAction(
          label: 'Расчитать',
          action: (fb) async {
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
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        dataWidget,
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              _actions
                  .map(
                    (action) => ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await action.action(this);
                        } on AlgorithmException catch (_) {
                          // Ошибки уже обрабатываются в методах calculate и draw
                        }
                      },
                      icon:
                          action.icon != null
                              ? Icon(action.icon)
                              : const SizedBox.shrink(),
                      label: Text(action.label),
                      style:
                          action.color != null
                              ? ElevatedButton.styleFrom(
                                backgroundColor: action.color,
                              )
                              : null,
                    ),
                  )
                  .toList(),
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
  /// Выполняет расчеты с опциональным параметром вариации
  Future<DD> calculate({String? variant});
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
