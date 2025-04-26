import 'package:flutter/foundation.dart';

/// Конфигурация для выполнения замеров производительности.
///
/// Этот класс содержит настройки для выполнения замеров, такие как
/// количество итераций, использование изолятов, измерение памяти и тиков.
@immutable
class MeasureConfig {
  /// Количество итераций для выполнения замера.
  ///
  /// Чем больше итераций, тем точнее будет результат, но тем дольше
  /// будет выполняться замер.
  final int iterations;

  /// Флаг, указывающий, нужно ли использовать изолят для выполнения замеров.
  ///
  /// Если true, замеры будут выполняться в отдельном изоляте, что может
  /// дать более точные результаты, но требует дополнительных ресурсов.
  final bool useIsolate;

  /// Флаг, указывающий, нужно ли измерять использование памяти.
  ///
  /// Если true, будет измеряться использование памяти во время выполнения функции.
  final bool measureMemory;

  /// Флаг, указывающий, нужно ли измерять тики процессора.
  ///
  /// Если true, будет измеряться количество тиков процессора во время выполнения функции.
  final bool measureTicks;

  /// Создает новый экземпляр [MeasureConfig].
  ///
  /// [iterations] - количество итераций для выполнения замера, по умолчанию 1.
  /// [useIsolate] - флаг, указывающий, нужно ли использовать изолят, по умолчанию false.
  /// [measureMemory] - флаг, указывающий, нужно ли измерять память, по умолчанию true.
  /// [measureTicks] - флаг, указывающий, нужно ли измерять тики, по умолчанию false.
  const MeasureConfig({
    this.iterations = 1,
    this.useIsolate = false,
    this.measureMemory = true,
    this.measureTicks = false,
  });

  /// Создает копию текущего экземпляра с возможностью изменения некоторых полей.
  MeasureConfig copyWith({
    int? iterations,
    bool? useIsolate,
    bool? measureMemory,
    bool? measureTicks,
  }) {
    return MeasureConfig(
      iterations: iterations ?? this.iterations,
      useIsolate: useIsolate ?? this.useIsolate,
      measureMemory: measureMemory ?? this.measureMemory,
      measureTicks: measureTicks ?? this.measureTicks,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MeasureConfig &&
        other.iterations == iterations &&
        other.useIsolate == useIsolate &&
        other.measureMemory == measureMemory &&
        other.measureTicks == measureTicks;
  }

  @override
  int get hashCode {
    return iterations.hashCode ^
        useIsolate.hashCode ^
        measureMemory.hashCode ^
        measureTicks.hashCode;
  }

  @override
  String toString() {
    return 'MeasureConfig(iterations: $iterations, useIsolate: $useIsolate, '
        'measureMemory: $measureMemory, measureTicks: $measureTicks)';
  }
}
