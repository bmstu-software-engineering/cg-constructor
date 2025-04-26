// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('Figure IO Example App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FigureIOExampleApp());

    // Verify that the app title is displayed
    expect(find.text('Figure IO Example'), findsOneWidget);

    // Verify that the button for selecting a file is displayed
    expect(find.text('Выбрать JSON-файл с фигурами'), findsOneWidget);

    // Verify that no figures are loaded initially
    expect(find.text('Загруженные фигуры:'), findsNothing);
  });
}
