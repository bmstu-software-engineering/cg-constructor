import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../src/fields/number_field.dart';
import 'form_field_widget.dart';

/// Виджет для числового поля
class NumberFieldWidget extends FormFieldWidget<double, NumberField> {
  /// Создает виджет числового поля
  ///
  /// [field] - числовое поле
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  const NumberFieldWidget({
    super.key,
    required NumberField field,
    ValueChanged<double?>? onChanged,
    InputDecoration? decoration,
  }) : super(field: field, onChanged: onChanged, decoration: decoration);

  @override
  State<NumberFieldWidget> createState() => _NumberFieldWidgetState();
}

class _NumberFieldWidgetState
    extends FormFieldWidgetState<double, NumberField, NumberFieldWidget> {
  late TextEditingController _controller;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<TextEditingController>('controller', _controller));
    properties.add(StringProperty('text', _controller.text));
    properties.add(DoubleProperty('min', widget.field.config.min));
    properties.add(DoubleProperty('max', widget.field.config.max));
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.field.getAsString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NumberFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.field.value != oldWidget.field.value) {
      _controller.text = widget.field.getAsString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: getDecoration(
        labelText: widget.field.config.label,
        errorText: widget.field.error,
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        widget.field.setFromString(value);
        setState(() {});
        if (widget.onChanged != null) {
          widget.onChanged!(widget.field.value);
        }
      },
    );
  }
}
