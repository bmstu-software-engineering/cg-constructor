import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../src/fields/nested_form_field.dart';
import 'form_field_widget.dart';
import 'dynamic_form_widget.dart';

/// Виджет для вложенной формы
class NestedFormFieldWidget extends FormFieldWidget<dynamic, NestedFormField> {
  /// Создает виджет вложенной формы
  ///
  /// [field] - поле вложенной формы
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  const NestedFormFieldWidget({
    super.key,
    required super.field,
    super.onChanged,
    super.decoration,
  });

  @override
  State<NestedFormFieldWidget> createState() => _NestedFormFieldWidgetState();
}

class _NestedFormFieldWidgetState extends FormFieldWidgetState<dynamic,
    NestedFormField, NestedFormFieldWidget> {
  // Контроллер для отслеживания изменений в форме
  late final _formChangeNotifier = ValueNotifier<int>(0);

  // Последнее известное значение формы для отслеживания изменений
  dynamic _lastKnownValue;

  @override
  void initState() {
    super.initState();
    // Сохраняем начальное значение
    _lastKnownValue = widget.field.value;

    // Настраиваем периодическую проверку изменений
    _setupChangeDetection();
  }

  @override
  void didUpdateWidget(NestedFormFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.field != widget.field) {
      _lastKnownValue = widget.field.value;
    }
  }

  @override
  void dispose() {
    _formChangeNotifier.dispose();
    super.dispose();
  }

  // Настраиваем обнаружение изменений в форме
  void _setupChangeDetection() {
    // Используем постфрейм-коллбэк для проверки изменений после каждого кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Проверяем, изменилось ли значение формы
      final currentValue = widget.field.value;
      if (_lastKnownValue != currentValue) {
        // Обновляем последнее известное значение
        _lastKnownValue = currentValue;

        // Увеличиваем счетчик изменений, чтобы вызвать перестроение
        _formChangeNotifier.value++;

        // Вызываем обработчик изменений родительской формы
        widget.onChanged?.call(currentValue);
      }

      // Планируем следующую проверку
      _setupChangeDetection();
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<dynamic>('value', widget.field.value));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок вложенной формы
        Text(
          widget.field.config.label ?? 'Вложенная форма',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),

        // Ошибка, если есть
        if (widget.field.error != null)
          Text(
            widget.field.error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),

        // Содержимое вложенной формы
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Используем ValueListenableBuilder для перестроения при изменении формы
            child: ValueListenableBuilder<int>(
              valueListenable: _formChangeNotifier,
              builder: (context, _, __) {
                return DynamicFormWidget(
                  model: widget.field.formModel.toDynamicFormModel(),
                  fieldSpacing: 8.0,
                  onSubmit:
                      null, // Не показываем кнопку отправки для вложенной формы
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
