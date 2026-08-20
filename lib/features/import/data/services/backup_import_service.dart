import 'dart:convert';

import '../../../concerts/data/models/concert_model.dart';

/// Parsea un JSON de copia de seguridad y devuelve los conciertos.
///
/// Acepta dos formatos:
///   1. `{"version":1, "concerts":[...]}` — exportado por esta app.
///   2. `[{...}, {...}]`  — lista plana (formato antiguo o CSV→JSON).
class BackupImportService {
  static const int _currentVersion = 1;

  /// Parsea el contenido de un archivo JSON y retorna los conciertos.
  /// Lanza [FormatException] si el formato no es reconocido.
  static List<ConcertModel> parse(String jsonContent) {
    final dynamic raw = jsonDecode(jsonContent);

    List<dynamic> list;

    if (raw is Map<String, dynamic>) {
      // Formato envuelto: { "version": 1, "concerts": [...] }
      if (raw['concerts'] is List) {
        list = raw['concerts'] as List<dynamic>;
      } else {
        throw const FormatException('El archivo no contiene una lista de conciertos');
      }
    } else if (raw is List) {
      // Lista plana (formato legacy)
      list = raw;
    } else {
      throw const FormatException('Formato de copia de seguridad no reconocido');
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map(ConcertModel.fromJson)
        .where((c) => c.artist.isNotEmpty)
        .toList();
  }

  /// Versión actual del formato de exportación.
  static int get currentVersion => _currentVersion;
}
