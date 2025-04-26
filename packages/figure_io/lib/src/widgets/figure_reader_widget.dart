import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/figure_collection.dart';
import '../services/figure_reader.dart';

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
    _figureReader.figuresStream.listen((figures) {
      setState(() {
        _loadedFigures = figures;
        _isLoading = false;
        _error = null;
      });
      widget.onFiguresLoaded?.call(figures);
    }, onError: (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
        print(error);
      });
    });
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
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true, // Всегда запрашиваем данные для веб-платформы
      );

      if (result != null) {
        final fileBytes = result.files.single.bytes;

        if (kIsWeb) {
          // На веб-платформе используем bytes
          if (fileBytes != null) {
            await _figureReader.readFromBytes(fileBytes);
          } else {
            throw Exception('Не удалось получить данные файла');
          }
        } else {
          final filePath = result.files.single.path;

          // На других платформах используем path
          if (filePath != null) {
            final file = File(filePath);
            await _figureReader.readFromFile(file);
          } else {
            // Если path равен null, пробуем использовать bytes
            if (fileBytes != null) {
              await _figureReader.readFromBytes(fileBytes);
            } else {
              throw Exception('Не удалось получить данные файла');
            }
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
        print(e);
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
              'Загружено: ${_loadedFigures!.allFigures.length} фигур',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
