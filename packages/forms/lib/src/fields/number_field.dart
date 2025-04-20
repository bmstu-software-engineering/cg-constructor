import '../config/number_config.dart';
import 'base_form_field.dart';

/// Поле формы для ввода числа
class NumberField extends BaseFormField<double> {
  /// Конфигурация поля
  final NumberFieldConfig config;

  /// Создает числовое поле формы
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  NumberField({required this.config, double? initialValue})
    : super(
        initialValue: initialValue,
        validator: _createValidator(config),
        isRequired: config.isRequired,
      );

  /// Создает валидатор на основе конфигурации
  static String? Function(double?)? _createValidator(NumberFieldConfig config) {
    return (double? value) {
      if (value == null) return null;

      if (config.min != null && value < config.min!) {
        final minStr =
            config.min == config.min!.toInt()
                ? config.min!.toInt()
                : config.min;
        return 'Значение должно быть не меньше $minStr';
      }

      if (config.max != null && value > config.max!) {
        final maxStr =
            config.max == config.max!.toInt()
                ? config.max!.toInt()
                : config.max;
        return 'Значение должно быть не больше $maxStr';
      }

      if (config.validator != null) {
        return config.validator!(value);
      }

      return null;
    };
  }

  /// Устанавливает значение из строки
  void setFromString(String? text) {
    if (text == null || text.isEmpty) {
      value = null;
      return;
    }

    try {
      value = double.parse(text);
    } catch (e) {
      value = null;
      // Устанавливаем ошибку напрямую
      setError('Неверный формат числа');
    }
  }

  /// Преобразует значение в строку для отображения
  String? getAsString() {
    return value?.toString();
  }
}
