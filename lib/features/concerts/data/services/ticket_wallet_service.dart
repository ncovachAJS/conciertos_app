import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Guarda las entradas (foto o PDF) de cada concierto únicamente en el
/// almacenamiento local del dispositivo. Nunca se sube al backend ni a
/// Cloudinary: así, aunque el servidor se vea comprometido, no hay ninguna
/// entrada que robar.
class TicketWalletService {
  Future<Directory> _ticketsDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/tickets');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Devuelve el archivo de la entrada guardada para este concierto, o null
  /// si todavía no se ha añadido ninguna.
  Future<File?> getTicket(String concertId) async {
    final dir = await _ticketsDir();
    if (!await dir.exists()) return null;
    await for (final entity in dir.list()) {
      if (entity is File && _baseNameWithoutExtension(entity.path) == concertId) {
        return entity;
      }
    }
    return null;
  }

  /// Copia [source] al almacenamiento local de la app, reemplazando
  /// cualquier entrada anterior de este concierto.
  Future<File> saveTicket(String concertId, File source, String extension) async {
    await deleteTicket(concertId);
    final dir = await _ticketsDir();
    final destPath = '${dir.path}/$concertId.$extension';
    return source.copy(destPath);
  }

  Future<void> deleteTicket(String concertId) async {
    final existing = await getTicket(concertId);
    if (existing != null && await existing.exists()) {
      await existing.delete();
    }
  }

  String _baseNameWithoutExtension(String path) {
    final fileName = path.split('/').last;
    final dotIndex = fileName.lastIndexOf('.');
    return dotIndex == -1 ? fileName : fileName.substring(0, dotIndex);
  }
}
