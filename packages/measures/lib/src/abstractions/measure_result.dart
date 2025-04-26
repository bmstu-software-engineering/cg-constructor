import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

/// Результат замера производительности.
///
/// Этот класс содержит результаты замеров времени выполнения, использования памяти
/// и тиков процессора для определенной функции.
@immutable
class MeasureResult {
  /// Уникальный ключ для идентификации замера.
  final String key;

  /// Список времен выполнения в миллисекундах для каждой итерации.
  final List<int> executionTimeMs;

  /// Список использования памяти в байтах для каждой итерации.
  ///
  /// Может быть пустым, если измерение памяти не было включено в конфигурации.
  final List<int> memoryUsage;

  /// Список тиков процессора для каждой итерации.
  ///
  /// Может быть пустым, если измерение тиков не было включено в конфигурации.
  final List<int> ticks;

  /// Создает новый экземпляр [MeasureResult].
  ///
  /// [key] - уникальный ключ для идентификации замера.
  /// [executionTimeMs] - список времен выполнения в миллисекундах.
  /// [memoryUsage] - список использования памяти в байтах, по умолчанию пустой список.
  /// [ticks] - список тиков процессора, по умолчанию пустой список.
  const MeasureResult({
    required this.key,
    required this.executionTimeMs,
    this.memoryUsage = const [],
    this.ticks = const [],
  });

  /// Возвращает среднее время выполнения в миллисекундах.
  double get averageExecutionTimeMs {
    if (executionTimeMs.isEmpty) return 0;
    return executionTimeMs.fold<double>(0, (a, b) => a + b) /
        executionTimeMs.length;
  }

  /// Возвращает медианное время выполнения в миллисекундах.
  double get medianExecutionTimeMs {
    if (executionTimeMs.isEmpty) return 0;
    final sorted = List<int>.from(executionTimeMs)..sort();
    final middle = sorted.length ~/ 2;
    if (sorted.length.isOdd) {
      return sorted[middle].toDouble();
    } else {
      return (sorted[middle - 1] + sorted[middle]) / 2.0;
    }
  }

  /// Возвращает минимальное время выполнения в миллисекундах.
  int get minExecutionTimeMs {
    if (executionTimeMs.isEmpty) return 0;
    return executionTimeMs.reduce((a, b) => a < b ? a : b);
  }

  /// Возвращает максимальное время выполнения в миллисекундах.
  int get maxExecutionTimeMs {
    if (executionTimeMs.isEmpty) return 0;
    return executionTimeMs.reduce((a, b) => a > b ? a : b);
  }

  /// Возвращает стандартное отклонение времени выполнения в миллисекундах.
  double get stdDevExecutionTimeMs {
    if (executionTimeMs.isEmpty) return 0;
    final mean = averageExecutionTimeMs;
    final squaredDifferences = executionTimeMs
        .map((time) => math.pow(time - mean, 2))
        .fold(0.0, (a, b) => a + b);
    return math.sqrt(squaredDifferences / executionTimeMs.length);
  }

  /// Возвращает среднее использование памяти в байтах.
  double get averageMemoryUsage {
    if (memoryUsage.isEmpty) return 0;
    return memoryUsage.fold<double>(0, (a, b) => a + b) / memoryUsage.length;
  }

  /// Возвращает среднее количество тиков процессора.
  double get averageTicks {
    if (ticks.isEmpty) return 0;
    return ticks.fold<double>(0, (a, b) => a + b) / ticks.length;
  }

  /// Создает копию текущего экземпляра с возможностью изменения некоторых полей.
  MeasureResult copyWith({
    String? key,
    List<int>? executionTimeMs,
    List<int>? memoryUsage,
    List<int>? ticks,
  }) {
    return MeasureResult(
      key: key ?? this.key,
      executionTimeMs: executionTimeMs ?? this.executionTimeMs,
      memoryUsage: memoryUsage ?? this.memoryUsage,
      ticks: ticks ?? this.ticks,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
    return other is MeasureResult &&
        other.key == key &&
        listEquals(other.executionTimeMs, executionTimeMs) &&
        listEquals(other.memoryUsage, memoryUsage) &&
        listEquals(other.ticks, ticks);
  }

  @override
  int get hashCode {
    return key.hashCode ^
        Object.hashAll(executionTimeMs) ^
        Object.hashAll(memoryUsage) ^
        Object.hashAll(ticks);
  }

  @override
  String toString() {
    return 'MeasureResult(key: $key, executionTimeMs: $executionTimeMs, '
        'memoryUsage: $memoryUsage, ticks: $ticks)';
  }
}
