import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../models/figure_collection.dart';

/// Сервис для чтения фигур из JSON
class FigureReader {
  /// Stream-контроллер для передачи прочитанных фигур
  final _figuresController = StreamController<FigureCollection>.broadcast();

  /// Публичный Stream для подписки
  Stream<FigureCollection> get figuresStream => _figuresController.stream;

  /// Чтение из строки JSON
  Future<FigureCollection> readFromString(String jsonString) async {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final collection = FigureCollection.fromJson(json);
      _figuresController.add(collection);
      return collection;
    } catch (e) {
      _figuresController.addError(e);
      rethrow;
    }
  }

  /// Чтение из файла
  Future<FigureCollection> readFromFile(File file) async {
    try {
      final jsonString = await file.readAsString();
      return readFromString(jsonString);
    } catch (e) {
      _figuresController.addError(e);
      rethrow;
    }
  }

  /// Чтение из байтов
  Future<FigureCollection> readFromBytes(Uint8List bytes) async {
    try {
      final jsonString = utf8.decode(bytes);
      return readFromString(jsonString);
    } catch (e) {
      _figuresController.addError(e);
      rethrow;
    }
  }

  /// Закрытие контроллера при уничтожении
  void dispose() {
    _figuresController.close();
  }
}
