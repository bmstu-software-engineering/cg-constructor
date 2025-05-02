import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:models_ns/models_ns.dart';
import '../src/fields/point_field.dart';
import 'form_field_widget.dart';
import 'number_field_widget.dart';

/// Список базовых цветов для выбора
const List<Map<String, dynamic>> _baseColors = [
  {'name': 'Черный', 'value': '#000000'},
  {'name': 'Белый', 'value': '#FFFFFF'},
  {'name': 'Красный', 'value': '#FF0000'},
  {'name': 'Зеленый', 'value': '#00FF00'},
  {'name': 'Синий', 'value': '#0000FF'},
  {'name': 'Желтый', 'value': '#FFFF00'},
  {'name': 'Голубой', 'value': '#00FFFF'},
  {'name': 'Пурпурный', 'value': '#FF00FF'},
  {'name': 'Другой', 'value': 'custom'},
];

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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('spacing', widget.spacing));
    properties.add(DiagnosticsProperty('xField', widget.field.xField));
    properties.add(DiagnosticsProperty('yField', widget.field.yField));
    if (widget.field.value != null) {
      properties.add(DoubleProperty('x', widget.field.value?.x));
      properties.add(DoubleProperty('y', widget.field.value?.y));
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: NumberFieldWidget(
                field: widget.field.xField,
                onChanged: (value) => _onChange(value),
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
                onChanged: (value) => _onChange(value),
                decoration: getDecoration(
                  labelText: widget.field.yField.config.label,
                  errorText: widget.field.yField.error,
                ),
              ),
            ),
          ],
        ),

        // Поле выбора цвета, если canSetColor = true
        if (widget.field.config.canSetColor)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildColorSelector(context),
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

  /// Текущий выбранный цвет (для отслеживания выбора "Другой")
  String _selectedColorValue = '';

  @override
  void initState() {
    super.initState();
    _selectedColorValue = widget.field.color;

    // Если текущий цвет не в списке базовых, выбираем "Другой"
    bool isCustomColor = true;
    for (var color in _baseColors) {
      if (color['value'] == _selectedColorValue) {
        isCustomColor = false;
        break;
      }
    }

    if (isCustomColor && _selectedColorValue != 'custom') {
      _selectedColorValue = 'custom';
    }
  }

  /// Создает виджет для выбора цвета
  Widget _buildColorSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Цвет',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4.0),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedColorValue,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                items: _baseColors.map((color) {
                  return DropdownMenuItem<String>(
                    value: color['value'],
                    child: Row(
                      children: [
                        if (color['value'] != 'custom')
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: _hexToColor(color['value']),
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          )
                        else
                          const Icon(Icons.color_lens, size: 16),
                        const SizedBox(width: 8.0),
                        Text(color['name']),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedColorValue = newValue;

                      // Если выбран не "Другой", устанавливаем цвет напрямую
                      if (newValue != 'custom') {
                        widget.field.color = newValue;
                      }
                    });
                    if (widget.onChanged != null && newValue != 'custom') {
                      widget.onChanged!(widget.field.value);
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 8.0),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedColorValue == 'custom'
                    ? _hexToColor(widget.field.color)
                    : _hexToColor(_selectedColorValue),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ],
        ),

        // Показываем поле для ввода HEX-кода только если выбран "Другой"
        if (_selectedColorValue == 'custom')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextFormField(
              initialValue: widget.field.color,
              decoration: InputDecoration(
                labelText: 'HEX код',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              onChanged: (String newValue) {
                if (newValue.startsWith('#') &&
                    (newValue.length == 7 || newValue.length == 9)) {
                  setState(() {
                    widget.field.color = newValue;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.field.value);
                  }
                }
              },
            ),
          ),
      ],
    );
  }

  /// Преобразует HEX-код цвета в объект Color
  Color _hexToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  void _onChange(_) {
    if (widget.onChanged != null) {
      widget.onChanged!(widget.field.value);
    }
    setState(() {
      widget.field.validate();
    });
  }
}
