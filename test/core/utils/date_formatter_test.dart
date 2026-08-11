import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter.short', () {
    test('formats a regular date correctly', () {
      expect(DateFormatter.short(DateTime(2024, 3, 5)), '05/03/2024');
    });

    test('pads day and month with leading zeros', () {
      expect(DateFormatter.short(DateTime(2023, 1, 1)), '01/01/2023');
    });

    test('handles last day of year', () {
      expect(DateFormatter.short(DateTime(2025, 12, 31)), '31/12/2025');
    });

    test('handles two-digit day and month without padding', () {
      expect(DateFormatter.short(DateTime(2022, 11, 15)), '15/11/2022');
    });
  });

  group('DateFormatter.hasTime', () {
    test('returns false for midnight (00:00)', () {
      expect(DateFormatter.hasTime(DateTime(2024, 6, 15, 0, 0)), isFalse);
    });

    test('returns true when hour is non-zero', () {
      expect(DateFormatter.hasTime(DateTime(2024, 6, 15, 20, 0)), isTrue);
    });

    test('returns true when minute is non-zero', () {
      expect(DateFormatter.hasTime(DateTime(2024, 6, 15, 0, 30)), isTrue);
    });

    test('returns true when both hour and minute are non-zero', () {
      expect(DateFormatter.hasTime(DateTime(2024, 6, 15, 21, 45)), isTrue);
    });

    test('returns true for 00:01', () {
      expect(DateFormatter.hasTime(DateTime(2024, 6, 15, 0, 1)), isTrue);
    });
  });

  group('DateFormatter.time', () {
    test('returns null for midnight', () {
      expect(DateFormatter.time(DateTime(2024, 6, 15, 0, 0)), isNull);
    });

    test('returns HH:MM formatted string when time is set', () {
      expect(DateFormatter.time(DateTime(2024, 6, 15, 20, 30)), '20:30');
    });

    test('pads single-digit hours and minutes', () {
      expect(DateFormatter.time(DateTime(2024, 6, 15, 9, 5)), '09:05');
    });

    test('handles midnight-plus-one-minute', () {
      expect(DateFormatter.time(DateTime(2024, 6, 15, 0, 1)), '00:01');
    });

    test('handles end of day (23:59)', () {
      expect(DateFormatter.time(DateTime(2024, 6, 15, 23, 59)), '23:59');
    });
  });
}
