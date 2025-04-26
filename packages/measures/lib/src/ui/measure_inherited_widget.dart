import 'package:flutter/material.dart';

import '../abstractions/measure_config.dart';
import '../abstractions/measure_service.dart';

/// InheritedWidget для передачи сервиса замеров и конфигурации через дерево виджетов.
///
/// Этот виджет позволяет получить доступ к сервису замеров и конфигурации
/// из любого места в дереве виджетов.
class MeasureInheritedWidget extends InheritedWidget {
  /// Сервис замеров.
  final MeasureService measureService;

  /// Конфигурация замеров по умолчанию.
  final MeasureConfig config;

  /// Создает новый экземпляр [MeasureInheritedWidget].
  ///
  /// [key] - ключ виджета.
  /// [measureService] - сервис замеров.
  /// [config] - конфигурация замеров по умолчанию.
  /// [child] - дочерний виджет.
  const MeasureInheritedWidget({
    super.key,
    required this.measureService,
    required this.config,
    required super.child,
  });

  /// Получает ближайший [MeasureInheritedWidget] в дереве виджетов.
  ///
  /// [context] - контекст сборки.
  ///
  /// Возвращает экземпляр [MeasureInheritedWidget].
  /// Выбрасывает исключение, если [MeasureInheritedWidget] не найден.
  static MeasureInheritedWidget of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<MeasureInheritedWidget>();
    assert(result != null, 'No MeasureInheritedWidget found in context');
    return result!;
  }

  /// Получает сервис замеров из ближайшего [MeasureInheritedWidget] в дереве виджетов.
  ///
  /// [context] - контекст сборки.
  ///
  /// Возвращает экземпляр [MeasureService].
  /// Выбрасывает исключение, если [MeasureInheritedWidget] не найден.
  static MeasureService getService(BuildContext context) {
    return of(context).measureService;
  }

  /// Получает конфигурацию замеров по умолчанию из ближайшего [MeasureInheritedWidget] в дереве виджетов.
  ///
  /// [context] - контекст сборки.
  ///
  /// Возвращает экземпляр [MeasureConfig].
  /// Выбрасывает исключение, если [MeasureInheritedWidget] не найден.
  static MeasureConfig getConfig(BuildContext context) {
    return of(context).config;
  }

  @override
  bool updateShouldNotify(MeasureInheritedWidget oldWidget) {
    return measureService != oldWidget.measureService ||
        config != oldWidget.config;
  }
}
