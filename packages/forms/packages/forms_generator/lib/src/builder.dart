import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'form_generator.dart';

/// Создает билдер для генерации типизированных форм
Builder formBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [FormGenerator()],
    'forms_generator',
  );
}
