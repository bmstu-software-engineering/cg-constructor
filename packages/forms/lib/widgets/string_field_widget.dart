import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../src/fields/string_field.dart';
import 'form_field_widget.dart';

/// Виджет для строкового поля
class StringFieldWidget extends FormFieldWidget<String, StringField> {
  /// Создает виджет строкового поля
  ///
  /// [field] - строковое поле
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  const StringFieldWidget({
    super.key,
    required super.field,
    super.onChanged,
    super.decoration,
  });

  @override
  State<StringFieldWidget> createState() => _StringFieldWidgetState();
}

class _StringFieldWidgetState
    extends FormFieldWidgetState<String, StringField, StringFieldWidget> {
  late TextEditingController _controller;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<TextEditingController>('controller', _controller));
    properties.add(StringProperty('text', _controller.text));
    properties.add(IntProperty('minLength', widget.field.config.minLength));
    properties.add(IntProperty('maxLength', widget.field.config.maxLength));
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.field.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StringFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.field.value != oldWidget.field.value) {
    //   _controller.text = widget.field.value ?? '';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: getDecoration(
        labelText: widget.field.config.label,
        errorText: widget.field.error,
      ),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        widget.field.value = value;
        setState(() {});
        if (widget.onChanged != null) {
          widget.onChanged!(widget.field.value);
        }
      },
    );
  }
}
