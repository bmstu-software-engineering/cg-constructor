import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../models/figure_collection.dart';

// Условный импорт для dart:io, который не доступен на веб-платформе
// ignore: uri_does_not_exist
import 'dart:io' if (dart.library.js) 'dart:typed_data' as io;

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
  ///
  /// Примечание: этот метод не доступен на веб-платформе
  /// На веб-платформе используйте [readFromBytes] или [readFromString]
  Future<FigureCollection> readFromFile(io.File file) async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Метод readFromFile не поддерживается на веб-платформе',
      );
    }

    try {
      // Используем dynamic, чтобы обойти проблемы с типами при условном импорте
      final dynamic fileObj = file;

      // Проверяем, существует ли файл
      if (fileObj is io.File) {
        if (!await fileObj.exists()) {
          throw Exception('Файл не существует: ${fileObj.path}');
        }
      }

      final jsonString = await fileObj.readAsString();
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
