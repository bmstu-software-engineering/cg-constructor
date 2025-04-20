import 'package:flutter/material.dart';
import '../src/core/form_field.dart' as forms;

/// Базовый абстрактный класс для всех виджетов полей форм
abstract class FormFieldWidget<T, F extends forms.FormField<T>>
    extends StatefulWidget {
  /// Поле формы
  final F field;

  /// Обработчик изменения значения
  final ValueChanged<T?>? onChanged;

  /// Декорация поля ввода
  final InputDecoration? decoration;

  /// Создает виджет поля формы
  ///
  /// [field] - поле формы
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  const FormFieldWidget({
    super.key,
    required this.field,
    this.onChanged,
    this.decoration,
  });
}

/// Базовый класс состояния для всех виджетов полей форм
abstract class FormFieldWidgetState<
  T,
  F extends forms.FormField<T>,
  W extends FormFieldWidget<T, F>
>
    extends State<W> {
  /// Вызывается при изменении значения поля
  @protected
  void onChanged(T? value) {
    setState(() {
      widget.field.value = value;
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
    });
  }

  /// Возвращает декорацию поля ввода
  @protected
  InputDecoration getDecoration({
    String? labelText,
    String? errorText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? suffixText,
    String? prefixText,
  }) {
    return widget.decoration?.copyWith(
          labelText: labelText ?? widget.decoration?.labelText,
          errorText: errorText ?? widget.decoration?.errorText,
          hintText: hintText ?? widget.decoration?.hintText,
          prefixIcon: prefixIcon ?? widget.decoration?.prefixIcon,
          suffixIcon: suffixIcon ?? widget.decoration?.suffixIcon,
          suffixText: suffixText ?? widget.decoration?.suffixText,
          prefixText: prefixText ?? widget.decoration?.prefixText,
        ) ??
        InputDecoration(
          labelText: labelText,
          errorText: errorText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          suffixText: suffixText,
          prefixText: prefixText,
        );
  }
}
