/// Класс с базовыми валидаторами
class Validators {
  /// Валидатор для обязательного поля
  static String? required(dynamic value) {
    if (value == null) return 'Это поле обязательно';
    if (value is String && value.isEmpty) return 'Это поле обязательно';
    return null;
  }

  /// Валидатор для числового диапазона
  static String? Function(double?) range(double? min, double? max) {
    return (double? value) {
      if (value == null) return null;
      if (min != null && value < min) {
        final minStr = min == min.toInt() ? min.toInt() : min;
        return 'Значение должно быть не меньше $minStr';
      }
      if (max != null && value > max) {
        final maxStr = max == max.toInt() ? max.toInt() : max;
        return 'Значение должно быть не больше $maxStr';
      }
      return null;
    };
  }

  /// Валидатор для формата цвета
  static String? colorHex(String? value) {
    if (value == null) return null;
    if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(value)) {
      return 'Неверный формат цвета (должен быть #RRGGBB)';
    }
    return null;
  }
}
