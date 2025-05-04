import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:models_ns/models_ns.dart';

// Импортируем dart:io только если не веб-платформа
import 'dart:io' as io show File;

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
  Future<FigureCollection> readFromFile(Object file) async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Метод readFromFile не поддерживается на веб-платформе',
      );
    }

    try {
      // Проверяем, что файл существует
      if (!kIsWeb) {
        final ioFile = file as io.File;
        if (!await ioFile.exists()) {
          throw Exception('Файл не существует: ${ioFile.path}');
        }

        final jsonString = await ioFile.readAsString();
        return readFromString(jsonString);
      } else {
        throw UnsupportedError(
          'Метод readFromFile не поддерживается на веб-платформе',
        );
      }
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
