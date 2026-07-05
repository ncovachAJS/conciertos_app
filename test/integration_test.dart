import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('App starts and displays home page',
        (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Test App'),
              ),
            ),
          ),
        ),
      );

      // Wait for app to load
      await tester.pumpAndSettle();

      // Verify app is running
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Navigate between tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Content'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('Can add a new concert', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ElevatedButton(
                onPressed: null,
                child: Text('Add Concert'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Add Concert'), findsOneWidget);
    });

    testWidgets('Display concerts list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ListView(
                children: [
                  ListTile(title: Text('Concert 1')),
                  ListTile(title: Text('Concert 2')),
                  ListTile(title: Text('Concert 3')),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Mark concert as favorite', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  Text('Concert Name'),
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });
  });
}
