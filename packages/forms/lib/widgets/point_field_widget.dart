import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';
import '../src/fields/point_field.dart';
import 'form_field_widget.dart';
import 'number_field_widget.dart';

/// Виджет для поля точки
class PointFieldWidget extends FormFieldWidget<Point, PointField> {
  /// Создает виджет поля точки
  ///
  /// [field] - поле точки
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  /// [spacing] - расстояние между полями X и Y
  const PointFieldWidget({
    super.key,
    required PointField field,
    ValueChanged<Point?>? onChanged,
    InputDecoration? decoration,
    this.spacing = 8.0,
  }) : super(field: field, onChanged: onChanged, decoration: decoration);

  /// Расстояние между полями X и Y
  final double spacing;

  @override
  State<PointFieldWidget> createState() => _PointFieldWidgetState();
}

class _PointFieldWidgetState
    extends FormFieldWidgetState<Point, PointField, PointFieldWidget> {
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
        Row(
          children: [
            Expanded(
              child: NumberFieldWidget(
                field: widget.field.xField,
                onChanged: (_) {
                  setState(() {});
                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.field.value);
                  }
                },
                decoration: getDecoration(
                  labelText: widget.field.xField.config.label,
                  errorText: widget.field.xField.error,
                ),
              ),
            ),
            SizedBox(width: widget.spacing),
            Expanded(
              child: NumberFieldWidget(
                field: widget.field.yField,
                onChanged: (_) {
                  setState(() {});
                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.field.value);
                  }
                },
                decoration: getDecoration(
                  labelText: widget.field.yField.config.label,
                  errorText: widget.field.yField.error,
                ),
              ),
            ),
          ],
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
