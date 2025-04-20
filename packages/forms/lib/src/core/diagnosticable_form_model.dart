import 'package:flutter/foundation.dart';
import 'form_model.dart';

/// Базовый класс для моделей форм с поддержкой диагностики
abstract class DiagnosticableFormModel
    with DiagnosticableTreeMixin
    implements FormModel {
  /// Возвращает строковое представление модели формы
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FormModel(isValid: ${isValid()})';
  }

  /// Заполняет свойства диагностики
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isValid', isValid()));
  }
}
