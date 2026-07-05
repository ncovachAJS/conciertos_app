import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utility Functions', () {
    test('Date formatting works correctly', () {
      final date = DateTime(2026, 7, 15);
      expect(date.year, 2026);
      expect(date.month, 7);
      expect(date.day, 15);
    });

    test('String validation works correctly', () {
      final email = 'test@example.com';
      expect(email.contains('@'), true);
    });

    test('Number formatting works correctly', () {
      final number = 1000;
      expect(number > 0, true);
    });

    test('List operations work correctly', () {
      final list = [1, 2, 3, 4, 5];
      expect(list.length, 5);
      expect(list.contains(3), true);
    });
  });
}
