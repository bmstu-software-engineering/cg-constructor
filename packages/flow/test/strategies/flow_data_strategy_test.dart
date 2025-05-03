import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/flow.dart';

// Создаем конкретную реализацию FlowDataStrategy для тестирования
class TestFlowDataStrategy implements FlowDataStrategy {
  final Widget Function() _buildWidgetCallback;
  final bool _isValid;

  TestFlowDataStrategy(this._buildWidgetCallback, {bool isValid = true})
    : _isValid = isValid;

  @override
  Widget buildWidget() => _buildWidgetCallback();

  @override
  bool get isValid => _isValid;
}

void main() {
  group('FlowDataStrategy', () {
    testWidgets('should build widget correctly', (WidgetTester tester) async {
      // Arrange
      final testWidget = Container(key: const Key('testDataWidget'));
      final dataStrategy = TestFlowDataStrategy(() => testWidget);

      // Act
      final widget = dataStrategy.buildWidget();

      // Assert
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      expect(find.byKey(const Key('testDataWidget')), findsOneWidget);
    });

    testWidgets('should handle widget updates', (WidgetTester tester) async {
      // Arrange
      bool isFirstBuild = true;
      final dataStrategy = TestFlowDataStrategy(() {
        if (isFirstBuild) {
          isFirstBuild = false;
          return Container(key: const Key('firstWidget'));
        } else {
          return Container(key: const Key('secondWidget'));
        }
      });

      // Act & Assert - First build
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: dataStrategy.buildWidget())),
      );
      expect(find.byKey(const Key('firstWidget')), findsOneWidget);
      expect(find.byKey(const Key('secondWidget')), findsNothing);

      // Act & Assert - Second build
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: dataStrategy.buildWidget())),
      );
      expect(find.byKey(const Key('firstWidget')), findsNothing);
      expect(find.byKey(const Key('secondWidget')), findsOneWidget);
    });

    test('should return isValid value', () {
      // Arrange
      final validStrategy = TestFlowDataStrategy(
        () => Container(),
        isValid: true,
      );
      final invalidStrategy = TestFlowDataStrategy(
        () => Container(),
        isValid: false,
      );

      // Assert
      expect(validStrategy.isValid, isTrue);
      expect(invalidStrategy.isValid, isFalse);
    });
  });
}
