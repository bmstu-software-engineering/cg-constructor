import 'package:flutter/widgets.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

abstract interface class Algorithm<
  DataModelType extends DataModel,
  ResultModelType extends ResultModel
> {
  DataModelType getDataModel();
  ResultModelType calculate();
}

abstract interface class AlgorithmWithCustomElement implements Algorithm {
  Widget buildTopMenuWidget();
  Widget buildBottomMenuWidget();
}

mixin BaseAlgorithmWithCustomElement implements AlgorithmWithCustomElement {
  @override
  Widget buildTopMenuWidget() => SizedBox.shrink();
  @override
  Widget buildBottomMenuWidget() => SizedBox.shrink();
}

/// Интерфейс для алгоритмов, поддерживающих различные варианты расчета
abstract interface class VariatedAlgorithm implements Algorithm {
  /// Выполняет расчет с указанным вариантом
  ResultModel calculateWithVariant(String? variant);

  /// Возвращает список доступных вариантов расчета
  List<AlgorithmVariant> getAvailableVariants();
}

/// Класс, представляющий вариант расчета алгоритма
class AlgorithmVariant {
  /// Идентификатор варианта
  final String id;

  /// Название варианта (отображается на кнопке)
  final String name;

  /// Иконка для кнопки (опционально)
  final IconData? icon;

  /// Цвет кнопки (опционально)
  final Color? color;

  const AlgorithmVariant({
    required this.id,
    required this.name,
    this.icon,
    this.color,
  });
}

abstract interface class DataModel {}

abstract interface class AlgorithmData {}

abstract interface class FormsDataModel implements DataModel {
  DynamicFormModel get config;

  AlgorithmData get data;
}

abstract interface class ResultModel {}

class ViewerResultModel implements ResultModel {
  final List<Point> points;
  final List<Line> lines;
  final String? markdownInfo;

  const ViewerResultModel({
    this.markdownInfo,
    this.points = const [],
    this.lines = const [],
  });
}

class ViewerResultModelV2 implements ResultModel {
  final FigureCollection figureCollection;
  final String? markdownInfo;

  const ViewerResultModelV2({
    required this.figureCollection,
    this.markdownInfo,
  });
}
