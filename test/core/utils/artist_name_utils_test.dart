import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/core/utils/artist_name_utils.dart';

void main() {
  group('normalizeArtistName', () {
    test('lowercases and strips spaces and punctuation', () {
      expect(normalizeArtistName('AC/DC'), 'acdc');
      expect(normalizeArtistName('  Guns N\' Roses '), 'gunsnroses');
    });

    test('strips Spanish diacritics', () {
      expect(normalizeArtistName('Héroes del Silencio'), 'heroesdelsilencio');
      expect(normalizeArtistName('Mägo de Oz'), 'magodeoz');
      expect(normalizeArtistName('Ñu'), 'nu');
    });

    test('keeps letters of non-Latin scripts', () {
      expect(normalizeArtistName('Король и Шут'), 'корольишут');
    });

    test('returns empty string when there is nothing to keep', () {
      expect(normalizeArtistName(''), '');
      expect(normalizeArtistName(' !?/ '), '');
    });
  });

  group('sameArtistName', () {
    test('matches ignoring case, accents and punctuation', () {
      expect(sameArtistName('metallica', 'Metallica'), isTrue);
      expect(sameArtistName('Heroes del Silencio', 'Héroes del Silencio'), isTrue);
      expect(sameArtistName('ACDC', 'AC/DC'), isTrue);
    });

    test('does not match similar but different artists', () {
      expect(sameArtistName('Fito', 'Fito Páez'), isFalse);
      expect(sameArtistName('Warning', 'The Warning'), isFalse);
    });

    test('never matches when a name has no letters or digits', () {
      expect(sameArtistName('', ''), isFalse);
      expect(sameArtistName('!!!', '???'), isFalse);
    });
  });
}
