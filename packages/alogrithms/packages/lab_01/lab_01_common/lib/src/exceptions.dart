import 'package:algorithm_interface/algorithm_interface.dart';

/// Исключение, выбрасываемое при недостаточном количестве точек
class InsufficientPointsException extends AlgorithmException {
  InsufficientPointsException(String setName, int minRequired, int actual)
    : super(
        'Недостаточно точек в множестве "$setName": требуется минимум $minRequired, получено $actual',
      );
}

/// Исключение, выбрасываемое при отсутствии треугольников с тупыми углами
class NoObtuseAnglesException extends AlgorithmException {
  NoObtuseAnglesException(String setName)
    : super('В множестве "$setName" нет треугольников с тупыми углами');
}

/// Исключение, выбрасываемое при некорректных данных
class InvalidDataException extends AlgorithmException {
  InvalidDataException(super.message);
}

/// Исключение, выбрасываемое при ошибке вычислений
class CalculationException extends AlgorithmException {
  CalculationException(super.message);
}
