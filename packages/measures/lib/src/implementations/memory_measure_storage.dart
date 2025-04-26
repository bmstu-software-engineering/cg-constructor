import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../abstractions/measure_result.dart';
import '../abstractions/measure_storage.dart';

/// Реализация [MeasureStorage] для хранения результатов замеров в памяти.
///
/// Этот класс хранит результаты замеров в памяти и предоставляет
/// методы для сохранения, получения и управления результатами.
class MemoryMeasureStorage implements MeasureStorage {
  /// Карта для хранения результатов замеров.
  final Map<String, MeasureResult> _results = {};

  /// Поток для отправки обновлений при изменении результатов замеров.
  final BehaviorSubject<List<MeasureResult>> _resultsSubject;

  /// Создает новый экземпляр [MemoryMeasureStorage].
  MemoryMeasureStorage()
    : _resultsSubject = BehaviorSubject<List<MeasureResult>>.seeded([]);

  @override
  Future<void> saveResult(MeasureResult result) async {
    _results[result.key] = result;
    _notifyListeners();
  }

  @override
  Future<MeasureResult?> getResult(String key) async {
    return _results[key];
  }

  @override
  Future<List<MeasureResult>> getAllResults() async {
    return _results.values.toList();
  }

  @override
  Future<bool> removeResult(String key) async {
    final removed = _results.remove(key) != null;
    if (removed) {
      _notifyListeners();
    }
    return removed;
  }

  @override
  Future<void> clearResults() async {
    _results.clear();
    _notifyListeners();
  }

  @override
  Stream<List<MeasureResult>> get resultsStream => _resultsSubject.stream;

  /// Уведомляет слушателей об изменении результатов замеров.
  void _notifyListeners() {
    _resultsSubject.add(_results.values.toList());
  }

  /// Освобождает ресурсы, занятые хранилищем.
  ///
  /// Этот метод должен быть вызван, когда хранилище больше не нужно.
  void dispose() {
    _resultsSubject.close();
  }
}
