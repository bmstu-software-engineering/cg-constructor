import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:models_ns/models_ns.dart';
import '../src/fields/polygon_field.dart';

import 'form_field_widget.dart';
import 'point_field_widget.dart';

/// Виджет для поля многоугольника
class PolygonFieldWidget extends FormFieldWidget<Polygon, PolygonField> {
  /// Создает виджет поля многоугольника
  ///
  /// [field] - поле многоугольника
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  /// [spacing] - расстояние между полями точек
  /// [addButtonLabel] - текст кнопки добавления точки
  /// [removeButtonTooltip] - подсказка кнопки удаления точки
  const PolygonFieldWidget({
    super.key,
    required PolygonField field,
    ValueChanged<Polygon?>? onChanged,
    InputDecoration? decoration,
    this.spacing = 16.0,
    this.addButtonLabel = 'Добавить точку',
    this.removeButtonTooltip = 'Удалить точку',
  }) : super(field: field, onChanged: onChanged, decoration: decoration);

  /// Расстояние между полями точек
  final double spacing;

  /// Текст кнопки добавления точки
  final String addButtonLabel;

  /// Подсказка кнопки удаления точки
  final String removeButtonTooltip;

  @override
  State<PolygonFieldWidget> createState() => _PolygonFieldWidgetState();
}

class _PolygonFieldWidgetState
    extends FormFieldWidgetState<Polygon, PolygonField, PolygonFieldWidget> {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('spacing', widget.spacing));
    properties.add(StringProperty('addButtonLabel', widget.addButtonLabel));
    properties
        .add(StringProperty('removeButtonTooltip', widget.removeButtonTooltip));
    properties
        .add(IntProperty('pointFieldsCount', widget.field.pointFields.length));
    properties.add(IntProperty('minPoints', widget.field.config.minPoints));
    properties
        .add(IntProperty('maxPoints', widget.field.config.maxPoints ?? -1));

    if (widget.field.value != null) {
      properties.add(
          IntProperty('pointsCount', widget.field.value?.points.length ?? 0));
      properties
          .add(DoubleProperty('perimeter', widget.field.value?.perimeter));
      properties.add(DoubleProperty('area', widget.field.value?.area));
      properties.add(DiagnosticsProperty('center', widget.field.value?.center));
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

        // Список точек
        ...List.generate(widget.field.pointFields.length, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        'Точка ${index + 1}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  // Кнопка удаления точки
                  if (widget.field.pointFields.length >
                      widget.field.config.minPoints)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      tooltip: widget.removeButtonTooltip,
                      onPressed: () {
                        setState(() {
                          widget.field.removePoint(index);
                          if (widget.onChanged != null) {
                            widget.onChanged!(widget.field.value);
                          }
                        });
                      },
                    ),
                ],
              ),
              PointFieldWidget(
                field: widget.field.pointFields[index],
                onChanged: (_) {
                  setState(() {});
                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.field.value);
                  }
                },
              ),
              if (index < widget.field.pointFields.length - 1)
                SizedBox(height: widget.spacing),
            ],
          );
        }),

        // Кнопка добавления точки
        if (widget.field.config.maxPoints == null ||
            widget.field.pointFields.length < widget.field.config.maxPoints!)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(widget.addButtonLabel),
              onPressed: () {
                setState(() {
                  widget.field.addPoint();
                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.field.value);
                  }
                });
              },
            ),
          ),

        if (widget.field.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
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
