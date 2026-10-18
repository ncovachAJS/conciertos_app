/// Normaliza el nombre de un artista para compararlo entre conciertos y discos.
///
/// Ignora mayúsculas, tildes, signos (apóstrofos rectos o tipográficos, puntos,
/// guiones...), el "The" inicial y el sufijo "(2)" con el que Discogs distingue
/// artistas homónimos. "Guns N' Roses" y "Guns N’ Roses" dan el mismo resultado.
String normalizeArtist(String name) {
  var t = name.toLowerCase().trim();
  t = t.replaceAll(RegExp(r'\s*\(\d+\)\s*$'), '');
  t = t.replaceAll('&', ' and ');

  const from = 'áàäâãåéèëêíìïîóòöôõøúùüûñçß';
  const to = 'aaaaaaeeeeiiiiooooouuuuncs';
  final buffer = StringBuffer();
  for (final ch in t.split('')) {
    final i = from.indexOf(ch);
    buffer.write(i >= 0 ? to[i] : ch);
  }
  t = buffer.toString();

  // Solo letras y números; todo lo demás es separador.
  // Los alfabetos no latinos (ruso, japonés...) se dejan intactos.
  t = t.replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), ' ').trim();
  if (t.startsWith('the ')) t = t.substring(4);
  return t;
}
