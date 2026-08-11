class DateFormatter {
  DateFormatter._();

  static String short(DateTime date) {
    final day   = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year  = date.year;
    return '$day/$month/$year';
  }

  /// Devuelve "HH:MM" si el concierto tiene hora configurada (≠ medianoche).
  static String? time(DateTime date) {
    if (!hasTime(date)) return null;
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// True si la fecha tiene una hora distinta de medianoche (00:00).
  static bool hasTime(DateTime date) =>
      date.hour != 0 || date.minute != 0;
}
