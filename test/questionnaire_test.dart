import 'package:flutter/material.dart';
import 'package:flutter_app/pages/questionnaire.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('Questionnaire test', (WidgetTester tester) async {
    await tester.pumpWidget(const MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(home: Questionnaire(key: Key('questionnaire')))));

    final widgetFinder = find.byKey(const Key('questionnaire'));
    expect(widgetFinder, findsOneWidget);
    
    final textFinder = find.text('This is the questionnaire.');
    expect(textFinder, findsOneWidget);

    final appBarFinder = find.byType(AppBar);
    expect(appBarFinder, findsOneWidget);
  });
}
