// Smoke test de widgets básicos — no requiere inicializar Firebase.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MaterialApp renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Text('OK')),
      ),
    );
    expect(find.text('OK'), findsOneWidget);
  });
}
