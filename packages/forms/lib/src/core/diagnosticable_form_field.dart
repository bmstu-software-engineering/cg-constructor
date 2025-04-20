import 'package:flutter/foundation.dart';
import 'form_field.dart';
import 'validatable.dart';

/// Базовый класс для полей форм с поддержкой диагностики
abstract class DiagnosticableFormField<T>
    with DiagnosticableTreeMixin
    implements FormField<T>, Validatable {
  /// Возвращает строковое представление поля формы
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FormField<$T>(value: $value, error: $error)';
  }

  /// Заполняет свойства диагностики
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('value', value));
    properties.add(StringProperty('error', error));
    properties.add(DiagnosticsProperty<bool>('isValid', isValid()));
    properties.add(DiagnosticsProperty<bool>('hasValue', value != null));
  }
}
