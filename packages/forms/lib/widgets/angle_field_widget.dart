import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:models_ns/models_ns.dart';
import '../forms.dart';

/// Виджет для поля угла
class AngleFieldWidget extends FormFieldWidget<Angle, AngleField> {
  /// Создает виджет поля угла
  ///
  /// [field] - поле угла
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  /// [suffixText] - текст суффикса (по умолчанию '°')
  const AngleFieldWidget({
    super.key,
    required AngleField field,
    ValueChanged<Angle?>? onChanged,
    InputDecoration? decoration,
    this.suffixText = '°',
  }) : super(field: field, onChanged: onChanged, decoration: decoration);

  /// Текст суффикса
  final String suffixText;

  @override
  State<AngleFieldWidget> createState() => _AngleFieldWidgetState();
}

class _AngleFieldWidgetState
    extends FormFieldWidgetState<Angle, AngleField, AngleFieldWidget> {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('suffixText', widget.suffixText));
    properties.add(DiagnosticsProperty('valueField', widget.field.valueField));
    if (widget.field.value != null) {
      properties.add(DoubleProperty('angle', widget.field.value?.value));
      properties
          .add(DoubleProperty('radians', widget.field.value?.toRadians()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return NumberFieldWidget(
      field: widget.field.valueField,
      onChanged: (_) {
        setState(() {});
        if (widget.onChanged != null) {
          widget.onChanged!(widget.field.value);
        }
      },
      decoration: getDecoration(
        labelText: widget.decoration?.labelText ?? widget.field.config.label,
        errorText: widget.field.error,
        suffixText: widget.suffixText,
      ),
    );
  }
}
