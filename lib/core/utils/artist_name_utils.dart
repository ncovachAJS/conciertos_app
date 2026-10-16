const _diacritics = {
  'á': 'a', 'à': 'a', 'ä': 'a', 'â': 'a', 'ã': 'a',
  'é': 'e', 'è': 'e', 'ë': 'e', 'ê': 'e',
  'í': 'i', 'ì': 'i', 'ï': 'i', 'î': 'i',
  'ó': 'o', 'ò': 'o', 'ö': 'o', 'ô': 'o', 'õ': 'o',
  'ú': 'u', 'ù': 'u', 'ü': 'u', 'û': 'u',
  'ñ': 'n', 'ç': 'c',
};

/// Nombre en minúsculas, sin acentos ni signos de puntuación ni espacios.
///
/// "AC/DC" → "acdc", "Héroes del Silencio" → "heroesdelsilencio".
String normalizeArtistName(String name) {
  final sb = StringBuffer();
  for (final ch in name.toLowerCase().split('')) {
    sb.write(_diacritics[ch] ?? ch);
  }
  return sb.toString().replaceAll(RegExp(r'[^\p{L}\p{N}]', unicode: true), '');
}

/// `true` si ambos nombres son el mismo artista según [normalizeArtistName].
/// Un nombre sin letras ni números nunca coincide con nada.
bool sameArtistName(String a, String b) {
  final na = normalizeArtistName(a);
  return na.isNotEmpty && na == normalizeArtistName(b);
}
