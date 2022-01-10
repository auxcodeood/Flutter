import 'package:flutter/material.dart';
import 'package:flutter_app/pages/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('Dashboard test', (WidgetTester tester) async {
    await tester.pumpWidget(const MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(home: Dashboard(key: Key('dashboard')))));
    final widgetFinder = find.byKey(const Key('dashboard'));
    expect(widgetFinder, findsOneWidget);
  });
}
