import 'package:conciertos_app/features/records/domain/artist_match.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeArtist', () {
    test('apóstrofo recto y tipográfico coinciden', () {
      expect(normalizeArtist("Guns N' Roses"), normalizeArtist('Guns N’ Roses'));
    });

    test('ignora mayúsculas, espacios y "The" inicial', () {
      expect(normalizeArtist('  THE Beatles '), normalizeArtist('beatles'));
    });

    test('ignora tildes y signos', () {
      expect(normalizeArtist('Sigur Rós'), normalizeArtist('sigur ros'));
      expect(normalizeArtist('AC/DC'), normalizeArtist('AC DC'));
    });

    test('& equivale a and', () {
      expect(normalizeArtist('Simon & Garfunkel'),
          normalizeArtist('Simon and Garfunkel'));
    });

    test('quita el sufijo de homónimos de Discogs', () {
      expect(normalizeArtist('Nirvana (2)'), normalizeArtist('Nirvana'));
    });

    test('artistas distintos no coinciden', () {
      expect(normalizeArtist('Nirvana'), isNot(normalizeArtist('Nirvana Sound')));
    });

    test('alfabetos no latinos se conservan', () {
      expect(normalizeArtist('ЗВЕРИ'), 'звери');
    });
  });
}
