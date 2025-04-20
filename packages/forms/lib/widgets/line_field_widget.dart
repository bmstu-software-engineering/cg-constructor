import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:models_ns/models_ns.dart';
import '../src/fields/line_field.dart';
import 'form_field_widget.dart';
import 'point_field_widget.dart';

/// Виджет для поля линии
class LineFieldWidget extends FormFieldWidget<Line, LineField> {
  /// Создает виджет поля линии
  ///
  /// [field] - поле линии
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  /// [spacing] - расстояние между полями начальной и конечной точек
  const LineFieldWidget({
    super.key,
    required LineField field,
    ValueChanged<Line?>? onChanged,
    InputDecoration? decoration,
    this.spacing = 16.0,
  }) : super(field: field, onChanged: onChanged, decoration: decoration);

  /// Расстояние между полями начальной и конечной точек
  final double spacing;

  @override
  State<LineFieldWidget> createState() => _LineFieldWidgetState();
}

class _LineFieldWidgetState
    extends FormFieldWidgetState<Line, LineField, LineFieldWidget> {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('spacing', widget.spacing));
    properties.add(DiagnosticsProperty('startField', widget.field.startField));
    properties.add(DiagnosticsProperty('endField', widget.field.endField));
    if (widget.field.value != null) {
      properties.add(DiagnosticsProperty<Line>('value', widget.field.value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.decoration?.labelText != null ||
            widget.field.config.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.decoration?.labelText ?? widget.field.config.label ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

        // Поле для начальной точки
        PointFieldWidget(
          field: widget.field.startField,
          onChanged: (_) {
            setState(() {});
            if (widget.onChanged != null) {
              widget.onChanged!(widget.field.value);
            }
          },
          decoration: getDecoration(
            labelText: widget.field.startField.config.label,
            errorText: widget.field.startField.error,
          ),
        ),

        SizedBox(height: widget.spacing),

        // Поле для конечной точки
        PointFieldWidget(
          field: widget.field.endField,
          onChanged: (_) {
            setState(() {});
            if (widget.onChanged != null) {
              widget.onChanged!(widget.field.value);
            }
          },
          decoration: getDecoration(
            labelText: widget.field.endField.config.label,
            errorText: widget.field.endField.error,
          ),
        ),

        if (widget.field.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              widget.field.error!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12.0,
              ),
            ),
          ),
      ],
    );
  }
}
