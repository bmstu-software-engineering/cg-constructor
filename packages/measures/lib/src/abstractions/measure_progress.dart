import 'package:flutter/foundation.dart';

/// Класс для отслеживания прогресса выполнения замеров.
///
/// Этот класс содержит информацию о текущем состоянии процесса замеров,
/// включая текущую итерацию, общее количество итераций и ключ текущего замера.
@immutable
class MeasureProgress {
  /// Флаг, указывающий, выполняются ли в данный момент замеры.
  final bool isRunning;

  /// Текущая итерация замера.
  final int currentIteration;

  /// Общее количество итераций, которые будут выполнены.
  final int totalIterations;

  /// Ключ текущего замера.
  ///
  /// Может быть null, если замеры не выполняются.
  final String? currentKey;

  /// Создает новый экземпляр [MeasureProgress].
  ///
  /// [isRunning] - флаг, указывающий, выполняются ли в данный момент замеры.
  /// [currentIteration] - текущая итерация замера.
  /// [totalIterations] - общее количество итераций, которые будут выполнены.
  /// [currentKey] - ключ текущего замера, может быть null.
  const MeasureProgress({
    required this.isRunning,
    required this.currentIteration,
    required this.totalIterations,
    this.currentKey,
  });

  /// Возвращает прогресс выполнения замеров в виде числа от 0 до 1.
  double get progress =>
      totalIterations > 0 ? currentIteration / totalIterations : 0.0;

  /// Создает начальный экземпляр [MeasureProgress] с пустыми значениями.
  factory MeasureProgress.initial() => const MeasureProgress(
    isRunning: false,
    currentIteration: 0,
    totalIterations: 0,
    currentKey: null,
  );

  /// Создает копию текущего экземпляра с возможностью изменения некоторых полей.
  MeasureProgress copyWith({
    bool? isRunning,
    int? currentIteration,
    int? totalIterations,
    String? Function()? currentKeyBuilder,
  }) {
    return MeasureProgress(
      isRunning: isRunning ?? this.isRunning,
      currentIteration: currentIteration ?? this.currentIteration,
      totalIterations: totalIterations ?? this.totalIterations,
      currentKey: currentKeyBuilder != null ? currentKeyBuilder() : currentKey,
    );
  }

  /// Создает новый экземпляр [MeasureProgress] с увеличенной текущей итерацией.
  MeasureProgress incrementIteration() {
    return copyWith(currentIteration: currentIteration + 1);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MeasureProgress &&
        other.isRunning == isRunning &&
        other.currentIteration == currentIteration &&
        other.totalIterations == totalIterations &&
        other.currentKey == currentKey;
  }

  @override
  int get hashCode {
    return isRunning.hashCode ^
        currentIteration.hashCode ^
        totalIterations.hashCode ^
        currentKey.hashCode;
  }

  @override
  String toString() {
    return 'MeasureProgress(isRunning: $isRunning, '
        'currentIteration: $currentIteration, '
        'totalIterations: $totalIterations, '
        'currentKey: $currentKey)';
  }
}
