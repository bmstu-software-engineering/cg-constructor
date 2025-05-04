import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:models_ns/models_ns.dart';
import '../services/figure_reader.dart';

// Импортируем dart:io только если не веб-платформа
import 'dart:io' as io show File;

/// Виджет для чтения фигур из JSON-файла
class FigureReaderWidget extends StatefulWidget {
  /// Callback, вызываемый при загрузке фигур
  final void Function(FigureCollection)? onFiguresLoaded;

  /// Текст кнопки выбора файла
  final String buttonText;

  /// Стиль кнопки
  final ButtonStyle? buttonStyle;

  /// Создает виджет для чтения фигур
  const FigureReaderWidget({
    super.key,
    this.onFiguresLoaded,
    this.buttonText = 'Выбрать JSON-файл',
    this.buttonStyle,
  });

  @override
  State<FigureReaderWidget> createState() => _FigureReaderWidgetState();
}

class _FigureReaderWidgetState extends State<FigureReaderWidget> {
  /// Сервис для чтения фигур
  final _figureReader = FigureReader();

  /// Загруженные фигуры
  FigureCollection? _loadedFigures;

  /// Флаг загрузки
  bool _isLoading = false;

  /// Сообщение об ошибке
  String? _error;

  @override
  void initState() {
    super.initState();
    // Подписка на Stream
    _figureReader.figuresStream.listen(
      (figures) {
        setState(() {
          _loadedFigures = figures;
          _isLoading = false;
          _error = null;
        });
        widget.onFiguresLoaded?.call(figures);
      },
      onError: (error) {
        setState(() {
          _error = error.toString();
          _isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _figureReader.dispose();
    super.dispose();
  }

  /// Метод для получения Stream с фигурами
  Stream<FigureCollection> get figuresStream => _figureReader.figuresStream;

  /// Метод для выбора и чтения файла
  Future<void> _pickAndReadFile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Используем FilePicker для выбора файла
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true, // Всегда запрашиваем данные для веб-платформы
      );

      if (result != null) {
        if (kIsWeb) {
          // На веб-платформе всегда используем bytes
          final fileBytes = result.files.single.bytes;
          if (fileBytes != null) {
            await _figureReader.readFromBytes(fileBytes);
          } else {
            throw Exception(
              'Не удалось получить данные файла на веб-платформе',
            );
          }
        } else {
          // На других платформах сначала пробуем использовать bytes, затем path
          final fileBytes = result.files.single.bytes;
          final filePath = result.files.single.path;

          if (fileBytes != null) {
            // Если есть байты, используем их (работает на всех платформах)
            await _figureReader.readFromBytes(fileBytes);
          } else if (filePath != null) {
            // Если нет байтов, но есть путь, используем его
            try {
              // Используем dart:io для создания File
              if (!kIsWeb) {
                final file = io.File(filePath);
                await _figureReader.readFromFile(file);
              } else {
                throw UnsupportedError(
                  'Метод readFromFile не поддерживается на веб-платформе',
                );
              }
            } catch (e) {
              // Если не удалось создать File, выбрасываем исключение
              throw Exception('Не удалось открыть файл: $e');
            }
          } else {
            throw Exception('Не удалось получить данные файла');
          }
        }
      } else {
        // Пользователь отменил выбор файла
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: _isLoading ? null : _pickAndReadFile,
          style: widget.buttonStyle,
          child: Text(widget.buttonText),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ошибка: $_error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        if (_loadedFigures != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Загружено: ${_loadedFigures!}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
