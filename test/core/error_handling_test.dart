import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Error Handling Tests', () {
    test('Exception throwing', () {
      expect(() => throw Exception('Test error'), throwsException);
    });

    test('Try-catch execution', () {
      String result = 'initial';
      try {
        throw Exception('Error');
      } catch (e) {
        result = 'caught';
      }
      expect(result, 'caught');
    });

    test('Null validation', () {
      String? value;
      expect(value == null, true);
      
      value = 'not null';
      expect(value != null, true);
    });

    test('Type checking', () {
      dynamic value = 'string';
      expect(value is String, true);
      expect(value is int, false);
    });
  });

  group('Async Tests', () {
    test('Future completion', () async {
      final future = Future.delayed(
        const Duration(milliseconds: 100),
        () => 'completed',
      );
      
      final result = await future;
      expect(result, 'completed');
    });

    test('Future error handling', () async {
      final future = Future.error('error');
      
      expect(future, throwsA(isA<String>()));
    });
  });

  group('Type Conversion Tests', () {
    test('String to int', () {
      final intValue = int.parse('123');
      expect(intValue, 123);
    });

    test('String to double', () {
      final doubleValue = double.parse('3.14');
      expect(doubleValue > 3.0, true);
    });

    test('Int to string', () {
      final stringValue = 42.toString();
      expect(stringValue, '42');
    });

    test('Object toString', () {
      final date = DateTime(2026, 7, 15);
      final str = date.toString();
      expect(str.contains('2026'), true);
    });
  });
}
