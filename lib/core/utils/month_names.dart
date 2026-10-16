import '../../l10n/generated/app_localizations.dart';

/// Nombre localizado del mes (1 = enero … 12 = diciembre). Vacío si no es válido.
String monthName(AppLocalizations l, int month) => switch (month) {
      1 => l.monthJanuary,
      2 => l.monthFebruary,
      3 => l.monthMarch,
      4 => l.monthApril,
      5 => l.monthMay,
      6 => l.monthJune,
      7 => l.monthJuly,
      8 => l.monthAugust,
      9 => l.monthSeptember,
      10 => l.monthOctober,
      11 => l.monthNovember,
      12 => l.monthDecember,
      _ => '',
    };

/// Tres primeras letras del mes en mayúsculas ("ENE", "JAN").
String monthAbbr(AppLocalizations l, int month) {
  final name = monthName(l, month);
  return (name.length <= 3 ? name : name.substring(0, 3)).toUpperCase();
}
