import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Guarda entradas (foto o PDF) únicamente en el almacenamiento local del
/// dispositivo, identificadas por un [id] arbitrario (el id de un concierto,
/// o el nombre de un festival). Nunca se sube al backend ni a Cloudinary:
/// así, aunque el servidor se vea comprometido, no hay ninguna entrada que
/// robar.
class TicketWalletService {
  Future<Directory> _ticketsDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/tickets');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Prefijo para entradas de festival, de forma que nunca choquen con un id
  /// de concierto (que son UUIDs) ni entre festivales con nombres parecidos.
  String festivalKey(String festivalName) => 'festival_${_sanitize(festivalName)}';

  String _sanitize(String raw) =>
      raw.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');

  /// Devuelve el archivo de la entrada guardada para este [id], o null si
  /// todavía no se ha añadido ninguna.
  Future<File?> getTicket(String id) async {
    final dir = await _ticketsDir();
    if (!await dir.exists()) return null;
    await for (final entity in dir.list()) {
      if (entity is File && _baseNameWithoutExtension(entity.path) == id) {
        return entity;
      }
    }
    return null;
  }

  /// Copia [source] al almacenamiento local de la app, reemplazando
  /// cualquier entrada anterior guardada con este [id].
  Future<File> saveTicket(String id, File source, String extension) async {
    await deleteTicket(id);
    final dir = await _ticketsDir();
    final destPath = '${dir.path}/$id.$extension';
    return source.copy(destPath);
  }

  Future<void> deleteTicket(String id) async {
    final existing = await getTicket(id);
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
