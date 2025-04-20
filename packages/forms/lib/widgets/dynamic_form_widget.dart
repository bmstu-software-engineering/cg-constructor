import 'package:flutter/material.dart';

import '../src/config/field_config_entry.dart';
import '../src/config/field_type.dart';
import '../src/fields/angle_field.dart';
import '../src/fields/list_field.dart';
import '../src/fields/number_field.dart';
import '../src/fields/point_field.dart';
import '../src/fields/polygon_field.dart';
import '../src/fields/rectangle_field.dart';
import '../src/fields/scale_field.dart';
import '../src/fields/triangle_field.dart';
import '../src/fields/vector_field.dart';
import '../src/models/dynamic_form_model.dart';
import 'angle_field_widget.dart';
import 'list_field_widget.dart';
import 'number_field_widget.dart';
import 'point_field_widget.dart';
import 'polygon_field_widget.dart';
import 'rectangle_field_widget.dart';
import 'scale_field_widget.dart';
import 'triangle_field_widget.dart';
import 'vector_field_widget.dart';

/// Виджет для отображения динамической формы
class DynamicFormWidget extends StatefulWidget {
  /// Модель формы
  final DynamicFormModel model;

  /// Обработчик отправки формы
  final void Function(Map<String, dynamic>)? onSubmit;

  /// Текст кнопки отправки
  final String submitButtonText;

  /// Отступы между полями
  final double fieldSpacing;

  /// Создает виджет динамической формы
  ///
  /// [model] - модель формы
  /// [onSubmit] - обработчик отправки формы
  /// [submitButtonText] - текст кнопки отправки
  /// [fieldSpacing] - отступы между полями
  const DynamicFormWidget({
    Key? key,
    required this.model,
    this.onSubmit,
    this.submitButtonText = 'Отправить',
    this.fieldSpacing = 16.0,
  }) : super(key: key);

  @override
  State<DynamicFormWidget> createState() => _DynamicFormWidgetState();
}

class _DynamicFormWidgetState extends State<DynamicFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок формы
        Text(
          widget.model.config.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: widget.fieldSpacing),

        // Поля формы
        ...widget.model.config.fields.map((fieldEntry) {
          final widget = _buildFieldWidget(fieldEntry);
          return Padding(
            padding: EdgeInsets.only(bottom: this.widget.fieldSpacing),
            child: widget,
          );
        }).toList(),

        // Кнопка отправки
        ElevatedButton(
          onPressed: () {
            if (widget.model.isValid()) {
              final values = widget.model.getValues();
              widget.onSubmit?.call(values);
            } else {
              widget.model.validate();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Пожалуйста, исправьте ошибки в форме'),
                ),
              );
            }
          },
          child: Text(widget.submitButtonText),
        ),
      ],
    );
  }

  /// Создает виджет для поля формы
  Widget _buildFieldWidget(FieldConfigEntry entry) {
    final field = widget.model.getField(entry.id);
    if (field == null) return const SizedBox();

    switch (entry.type) {
      case FieldType.number:
        return NumberFieldWidget(
          field: field as NumberField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.point:
        return PointFieldWidget(
          field: field as PointField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.angle:
        return AngleFieldWidget(
          field: field as AngleField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.vector:
        return VectorFieldWidget(
          field: field as VectorField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.scale:
        return ScaleFieldWidget(
          field: field as ScaleField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.polygon:
        return PolygonFieldWidget(
          field: field as PolygonField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.triangle:
        return TriangleFieldWidget(
          field: field as TriangleField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.rectangle:
        return RectangleFieldWidget(
          field: field as RectangleField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.list:
        // Упрощенная реализация для списка чисел
        return ListFieldWidget<double, NumberField>(
          field: field as ListField<double, NumberField>,
          onChanged: (_) => setState(() {}),
          itemBuilder: (context, itemField, onChanged) {
            return NumberFieldWidget(
              field: itemField,
              onChanged: onChanged,
            );
          },
        );
      default:
        return const SizedBox();
    }
  }
}
